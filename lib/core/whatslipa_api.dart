import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path_lib;
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/core/whatslipa_session.dart';

/// One host tried during [WhatsLipaApi.login].
class WhatsLipaLoginAttempt {
  const WhatsLipaLoginAttempt({
    required this.portalBase,
    required this.loginUrl,
    this.statusCode,
    this.error,
  });

  final String portalBase;
  final String loginUrl;
  final int? statusCode;
  final String? error;
}

class WhatsLipaApiException implements Exception {
  WhatsLipaApiException(
    this.statusCode,
    this.message, {
    this.attempts = const [],
  });

  final int statusCode;
  final String message;
  final List<WhatsLipaLoginAttempt> attempts;

  String get attemptsSummary {
    if (attempts.isEmpty) {
      return '';
    }
    final buf = StringBuffer('\n\nURLs tried:');
    for (final a in attempts) {
      buf.writeln();
      buf.write('• ${a.loginUrl}');
      if (a.statusCode != null || (a.error != null && a.error!.isNotEmpty)) {
        buf.write(' → ');
        if (a.statusCode != null) {
          buf.write('HTTP ${a.statusCode}');
        }
        if (a.error != null && a.error!.isNotEmpty) {
          if (a.statusCode != null) buf.write(': ');
          buf.write(a.error);
        }
      }
    }
    return buf.toString();
  }

  @override
  String toString() => message + attemptsSummary;
}

typedef WhatsLipaProgressCallback = void Function(String message);

/// Result from [WhatsLipaApi.registerProduct] / update with server message.
class CatalogSyncResult {
  CatalogSyncResult({
    required this.success,
    required this.message,
    this.detail,
  });

  final bool success;
  final String message;
  final Map<String, dynamic>? detail;

  factory CatalogSyncResult.fromResponse(Map<String, dynamic> body) {
    final data = body['data'];
    return CatalogSyncResult(
      success: body['success'] == true,
      message: body['message']?.toString() ??
          (body['success'] == true ? 'Catalog synced' : 'Catalog sync failed'),
      detail: data is Map ? Map<String, dynamic>.from(data) : null,
    );
  }
}

class ProductSaveResult {
  ProductSaveResult({
    required this.product,
    required this.message,
    this.catalogSync,
  });

  final Map<String, dynamic> product;
  final String message;
  final Map<String, dynamic>? catalogSync;

  factory ProductSaveResult.fromResponse(Map<String, dynamic> body) {
    final data = body['data'];
    final product = data is Map && data['product'] is Map
        ? Map<String, dynamic>.from(data['product'] as Map)
        : <String, dynamic>{};
    Map<String, dynamic>? catalogSync;
    if (data is Map && data['catalog_sync'] is Map) {
      catalogSync = Map<String, dynamic>.from(data['catalog_sync'] as Map);
    }
    return ProductSaveResult(
      product: product,
      message: body['message']?.toString() ?? 'Product saved.',
      catalogSync: catalogSync,
    );
  }

  bool get catalogSynced => catalogSync?['success'] == true;
}

class WhatsLipaApi {
  /// Populated on every [login] call (success or failure) for UI / debugging.
  static List<WhatsLipaLoginAttempt> lastLoginAttempts = [];

  static Future<String> _apiPrefix() async {
    await WhatsLipaConfig.ensurePortalLoaded();
    return WhatsLipaConfig.whatsliapaApiPrefix;
  }

  static Map<String, String> _jsonHeaders([String? token]) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  static Future<Map<String, String>> _authHeaders() async {
    final token = await WhatsLipaSession.token;
    final slug = await WhatsLipaSession.tenantSlug;
    return {
      ..._jsonHeaders(token),
      if (slug != null && slug.isNotEmpty) 'X-Tenant-Slug': slug,
    };
  }

  /// Tries portals from server .env (or saved portal if locked).
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
    String? tenantSlug,
    WhatsLipaProgressCallback? onProgress,
  }) async {
    final body = <String, dynamic>{
      'password': password,
      'phone': phone,
      if (tenantSlug != null && tenantSlug.isNotEmpty) 'tenant_slug': tenantSlug,
    };

    onProgress?.call('Preparing sign in…');
    final candidates = await WhatsLipaConfig.loginEndpointCandidates();
    lastLoginAttempts = [];
    WhatsLipaApiException? lastAuthError;
    var networkFailures = 0;

    for (var i = 0; i < candidates.length; i++) {
      final baseUrl = candidates[i];
      final apiPrefix = WhatsLipaConfig.whatsliapaApiPrefixFor(baseUrl);
      final loginUrl = '$apiPrefix/login';

      if (candidates.length > 1) {
        onProgress?.call('Trying server ${i + 1} of ${candidates.length}…');
      } else {
        onProgress?.call('Connecting…');
      }

      void recordAttempt({int? statusCode, String? error}) {
        lastLoginAttempts = [
          ...lastLoginAttempts,
          WhatsLipaLoginAttempt(
            portalBase: baseUrl,
            loginUrl: loginUrl,
            statusCode: statusCode,
            error: error,
          ),
        ];
      }

      try {
        onProgress?.call('Signing in…');
        final res = await http
            .post(
              Uri.parse(loginUrl),
              headers: _jsonHeaders(),
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 25));

        try {
          final parsed = await _parse(res);
          recordAttempt(statusCode: res.statusCode, error: 'OK');
          if (!WhatsLipaConfig.isUnreachableOnDevice(baseUrl)) {
            await WhatsLipaConfig.lockPortalAfterLogin(baseUrl);
          }
          return parsed;
        } on WhatsLipaApiException catch (e) {
          recordAttempt(statusCode: res.statusCode, error: e.message);
          if (_shouldTryNextPortal(e.statusCode, e.message)) {
            lastAuthError = WhatsLipaApiException(
              e.statusCode,
              e.message,
              attempts: List.from(lastLoginAttempts),
            );
            continue;
          }
          throw WhatsLipaApiException(e.statusCode, e.message, attempts: List.from(lastLoginAttempts));
        }
      } on WhatsLipaApiException catch (e) {
        if (kDebugMode) {
          debugPrint('WhatsLipa login $loginUrl: HTTP ${e.statusCode} — ${e.message}');
        }
        recordAttempt(statusCode: e.statusCode, error: e.message);
        if (_shouldTryNextPortal(e.statusCode, e.message)) {
          lastAuthError = WhatsLipaApiException(
            e.statusCode,
            e.message,
            attempts: List.from(lastLoginAttempts),
          );
          continue;
        }
        throw WhatsLipaApiException(e.statusCode, e.message, attempts: List.from(lastLoginAttempts));
      } on TimeoutException catch (e) {
        if (kDebugMode) {
          debugPrint('WhatsLipa login $loginUrl: timeout — $e');
        }
        recordAttempt(error: 'Timed out (25s)');
        networkFailures++;
        continue;
      } on SocketException catch (e) {
        if (kDebugMode) {
          debugPrint('WhatsLipa login $loginUrl: socket — $e');
        }
        recordAttempt(error: e.message);
        networkFailures++;
        continue;
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('WhatsLipa login $loginUrl: $e\n$st');
        }
        recordAttempt(error: e.toString());
        networkFailures++;
        continue;
      }
    }

    final attempts = List<WhatsLipaLoginAttempt>.from(lastLoginAttempts);

    if (lastAuthError != null) {
      throw WhatsLipaApiException(
        lastAuthError!.statusCode,
        lastAuthError!.message,
        attempts: attempts,
      );
    }
    if (networkFailures > 0) {
      throw WhatsLipaApiException(
        0,
        'Could not reach any portal. Check internet or server URL in settings.',
        attempts: attempts,
      );
    }
    throw WhatsLipaApiException(
      401,
      'These credentials do not match our records on any portal.',
      attempts: attempts,
    );
  }

  /// Retry on another host when the account is missing or portal rejected access.
  static bool _shouldTryNextPortal(int statusCode, String message) {
    if (statusCode == 401) return true;
    if (statusCode == 403) {
      final lower = message.toLowerCase();
      return lower.contains('whatslipa') ||
          lower.contains('access') ||
          lower.contains('inactive') ||
          lower.contains('role');
    }
    if (statusCode == 404 || statusCode >= 500) return true;
    return false;
  }

  static Future<Map<String, dynamic>> me() async => _get('/me');

  static Future<Map<String, dynamic>> selectOrganization(String tenantSlug) async {
    return _post('/select-organization', {'tenant_slug': tenantSlug});
  }

  static Future<Map<String, dynamic>> switchOrganization(String tenantSlug) async {
    final res = await selectOrganization(tenantSlug);
    final data = res['data'];
    if (data is Map) {
      await WhatsLipaSession.saveFromAuthPayload(Map<String, dynamic>.from(data));
    }
    return res;
  }

  static Future<Map<String, dynamic>> dashboard() async => _get('/dashboard');

  static Future<String> createBridgeUrl(String path) async {
    final data = await _post('/bridge', {'path': path});
    return data['data']['bridge_url'] as String;
  }

  // —— WhatsApp inbox ——
  static Future<List<dynamic>> chats({String? q}) async {
    final qParam = q != null && q.isNotEmpty ? '?q=${Uri.encodeQueryComponent(q)}' : '';
    final res = await _getRaw('/mobile/chats$qParam');
    final body = jsonDecode(res.body);
    return (body['chats'] as List<dynamic>? ?? []);
  }

  static Future<Map<String, dynamic>> thread(int customerId) async {
    final res = await _getRaw('/mobile/thread/$customerId');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<void> sendChatMessage(int customerId, String message) async {
    final prefix = await _apiPrefix();
    final res = await http.post(
      Uri.parse('$prefix/mobile/send'),
      headers: await _authHeaders(),
      body: jsonEncode({'customer_id': customerId, 'message': message}),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode < 200 || res.statusCode >= 300 || body['ok'] != true) {
      throw WhatsLipaApiException(res.statusCode, body['error']?.toString() ?? 'Send failed');
    }
  }

  static Future<void> openChatThread(int customerId) async {
    try {
      await _post('/mobile/thread/$customerId/open', {});
    } catch (_) {
      // Non-fatal if mark-read endpoint unavailable
    }
  }

  static Future<void> sendChatMedia(
    int customerId, {
    required String filePath,
    required String mediaType,
    String? caption,
  }) async {
    final prefix = await _apiPrefix();
    final token = await WhatsLipaSession.token;
    final req = http.MultipartRequest('POST', Uri.parse('$prefix/mobile/send-media'));
    req.headers['Accept'] = 'application/json';
    if (token != null && token.isNotEmpty) {
      req.headers['Authorization'] = 'Bearer $token';
    }
    req.fields['customer_id'] = '$customerId';
    req.fields['media_type'] = mediaType;
    if (caption != null && caption.isNotEmpty) req.fields['caption'] = caption;
    final filename = path_lib.basename(filePath);
    req.files.add(await http.MultipartFile.fromPath(
      'file',
      filePath,
      filename: filename,
      contentType: MediaType.parse(_mediaMimeForUpload(filePath, mediaType)),
    ));
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    Map<String, dynamic> body = {};
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}
    if (res.statusCode < 200 || res.statusCode >= 300 || body['ok'] != true) {
      final err = body['error']?.toString() ?? body['message']?.toString() ?? 'Media send failed';
      throw WhatsLipaApiException(res.statusCode, err);
    }
  }

  // —— Orders ——
  static Future<Map<String, dynamic>> ordersSummary({WhatsLipaProgressCallback? onProgress}) async {
    final d = await _get('/orders/summary', onProgress: onProgress, progressLabel: 'Loading orders…');
    return Map<String, dynamic>.from(d['data'] as Map);
  }

  static Future<Map<String, dynamic>> ordersList({String? status, String? queue, int page = 1}) async {
    final q = <String, String>{'page': '$page'};
    if (status != null) q['status'] = status;
    if (queue != null) q['queue'] = queue;
    return _get('/orders', query: q);
  }

  static Future<Map<String, dynamic>> orderDetail(int id) async {
    final d = await _get('/orders/$id');
    return Map<String, dynamic>.from(d['data']['order'] as Map);
  }

  static Future<void> updateOrderStatus(int id, String status) async {
    await _post('/orders/$id/status', {'status': status});
  }

  static Future<List<dynamic>> deliveryAgents() async {
    final d = await _get('/orders/delivery-agents');
    return List<dynamic>.from(d['data']['agents'] as List);
  }

  static Future<void> assignOrder(int orderId, int userId) async {
    await _post('/orders/$orderId/assign', {'assigned_to': userId});
  }

  // —— Delivery ——
  static Future<Map<String, dynamic>> deliveryMap() async {
    final d = await _get('/delivery/map');
    return Map<String, dynamic>.from(d['data'] as Map);
  }

  static Future<List<dynamic>> deliveryOrders() async {
    final d = await _get('/delivery/orders');
    return List<dynamic>.from(d['data']['orders'] as List);
  }

  static Future<void> postRiderLocation(double lat, double lng) async {
    await _post('/delivery/location', {'latitude': lat, 'longitude': lng});
  }

  static Future<void> startDelivery(int orderId) async {
    await _post('/delivery/orders/$orderId/start', {});
  }

  static Future<void> completeDelivery(int orderId) async {
    await _post('/delivery/orders/$orderId/complete', {});
  }

  static Future<void> cancelDelivery(int orderId) async {
    await _post('/delivery/orders/$orderId/cancel', {});
  }

  static Future<Map<String, dynamic>> customerProfile(int customerId) async {
    final d = await _get('/mobile/customers/$customerId');
    return Map<String, dynamic>.from(d['data']['customer'] as Map);
  }

  static Future<Map<String, dynamic>> campaignTemplates() async {
    final d = await _get('/campaigns/templates');
    return Map<String, dynamic>.from(d['data'] as Map);
  }

  static Future<Map<String, dynamic>> campaignQueueStatus() async {
    final d = await _get('/campaigns/queue-status');
    return Map<String, dynamic>.from(d['data'] as Map);
  }

  static Map<String, dynamic> _dataMap(Map<String, dynamic> body) {
    final data = body['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw WhatsLipaApiException(0, 'Invalid server response shape.');
  }

  static List<dynamic> _listFromData(Map<String, dynamic> body, String key) {
    final data = body['data'];
    if (data is! Map) return [];
    final value = data[key];
    if (value is List) return List<dynamic>.from(value);
    return [];
  }

  static Map<String, dynamic> _quantitiesMap(dynamic raw) {
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return {};
  }

  static Future<List<dynamic>> salesRecordPackages() async {
    final d = await _get('/reports/sales-records/form');
    return _listFromData(d, 'packages');
  }

  static Future<Map<String, dynamic>> salesRecordForDate(String date) async {
    final d = await _get('/reports/sales-records/date', query: {'sales_date': date});
    final data = _dataMap(d);
    return {
      ...data,
      'agent_quantities': _quantitiesMap(data['agent_quantities']),
      'customer_quantities': _quantitiesMap(data['customer_quantities']),
      'quantities': _quantitiesMap(data['quantities'] ?? data['customer_quantities']),
    };
  }

  static Future<void> submitSalesRecord({
    required String salesDate,
    Map<String, int>? agentQuantities,
    Map<String, int>? customerQuantities,
    Map<String, int>? quantities,
    String? comment,
  }) async {
    await _post('/reports/sales-records', {
      'sales_date': salesDate,
      'agent_quantities': agentQuantities ?? const {},
      'customer_quantities': customerQuantities ?? quantities ?? const {},
      if (comment != null) 'comment': comment,
    });
  }

  static Future<List<dynamic>> salesRecordHistory() async {
    final d = await _get('/reports/sales-records/history');
    return _listFromData(d, 'records');
  }

  static Future<Map<String, dynamic>> deliveryRoutePlan({
    required List<int> orderIds,
    double? originLat,
    double? originLng,
    int currentStopIndex = 0,
  }) async {
    final d = await _post('/delivery/route-plan', {
      'order_ids': orderIds,
      if (originLat != null) 'origin_latitude': originLat,
      if (originLng != null) 'origin_longitude': originLng,
      'current_stop_index': currentStopIndex,
    });
    return Map<String, dynamic>.from(d['data'] as Map);
  }

  static Future<Map<String, dynamic>> deliveryRouteActiveLeg({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    final d = await _post('/delivery/route-active-leg', {
      'origin_latitude': originLat,
      'origin_longitude': originLng,
      'destination_latitude': destLat,
      'destination_longitude': destLng,
    });
    return Map<String, dynamic>.from(d['data'] as Map);
  }

  // —— Campaign ——
  static Future<List<dynamic>> campaignsList() async {
    final d = await _get('/campaigns');
    return List<dynamic>.from(d['data']['campaigns'] as List);
  }

  static Future<List<dynamic>> campaignCustomers() async {
    final d = await _get('/campaigns/customers');
    return List<dynamic>.from(d['data']['customers'] as List);
  }

  static Future<void> createCampaign({
    required String channel,
    required String message,
    bool sendToAll = false,
    List<int>? customerIds,
  }) async {
    await _post('/campaigns', {
      'channel': channel,
      'message': message,
      'send_to_all': sendToAll,
      if (customerIds != null) 'customer_ids': customerIds,
    });
  }

  // —— Reports ——
  static Future<List<dynamic>> reportTypes() async {
    final d = await _get('/reports');
    return List<dynamic>.from(d['data']['types'] as List);
  }

  static Future<Map<String, dynamic>> reportSummary({
    required String type,
    String period = 'today',
  }) async {
    final d = await _get('/reports/summary', query: {'type': type, 'period': period});
    return Map<String, dynamic>.from(d['data'] as Map);
  }

  // —— Products (catalog) ——
  static Future<List<dynamic>> productsList({int page = 1}) async {
    final d = await _get('/products', query: {'page': '$page'});
    return List<dynamic>.from(d['data']['products'] as List);
  }

  static Future<Map<String, dynamic>> productDetail(int id) async {
    final d = await _get('/products/$id');
    return Map<String, dynamic>.from(d['data']['product'] as Map);
  }

  static Future<ProductSaveResult> updateProduct(
    int id, {
    String? name,
    String? unit,
    double? price,
    String? description,
    String? imageUrl,
    bool? isActive,
    bool syncCatalog = true,
    List<XFile>? imageFiles,
    List<String>? keepImageUrls,
  }) async {
    if (imageFiles != null && imageFiles.isNotEmpty || keepImageUrls != null) {
      final fields = <String, String>{
        '_method': 'PUT',
        'sync_catalog': syncCatalog ? '1' : '0',
      };
      if (name != null) fields['name'] = name;
      if (unit != null) fields['unit'] = unit;
      if (price != null) fields['price'] = '$price';
      if (description != null) fields['description'] = description;
      if (keepImageUrls != null) fields['keep_image_urls'] = jsonEncode(keepImageUrls);
      final d = await _multipartJson(
        'POST',
        '/products/$id',
        fields: fields,
        imageFiles: imageFiles ?? [],
      );
      return ProductSaveResult.fromResponse(d);
    }

    final body = <String, dynamic>{'sync_catalog': syncCatalog};
    if (name != null) body['name'] = name;
    if (unit != null) body['unit'] = unit;
    if (price != null) body['price'] = price;
    if (description != null) body['description'] = description;
    if (imageUrl != null) body['image_url'] = imageUrl;
    if (isActive != null) body['is_active'] = isActive;
    final d = await _put('/products/$id', body);
    return ProductSaveResult.fromResponse(d);
  }

  static Future<CatalogSyncResult> syncProductCatalog(int id) async {
    if (kDebugMode) {
      debugPrint('WhatsLipa sync catalog POST /products/$id/sync-catalog');
    }
    final body = await _post('/products/$id/sync-catalog', {}).timeout(const Duration(seconds: 90));
    return CatalogSyncResult.fromResponse(body);
  }

  /// Bearer token for [Image.network] when loading /api/whatslipa/media/... URLs.
  static Future<Map<String, String>?> productImageHeaders() async {
    final token = await WhatsLipaSession.token;
    if (token == null || token.isEmpty) {
      return null;
    }
    return {'Authorization': 'Bearer $token'};
  }

  static Future<Map<String, dynamic>> orderCatalogItems() async {
    final d = await _get('/orders/catalog/items');
    return Map<String, dynamic>.from(d['data'] as Map);
  }

  static Future<Map<String, dynamic>> addOrderItems(int orderId, List<Map<String, dynamic>> lines) async {
    final d = await _post('/orders/$orderId/items', {'lines': lines});
    return Map<String, dynamic>.from(d['data']['order'] as Map);
  }

  static Future<void> sendOrderConfirmation(int orderId) async {
    await _post('/orders/$orderId/send-confirmation', {});
  }

  static Future<ProductSaveResult> registerProduct({
    required String name,
    required String unit,
    required double price,
    String? description,
    String? imageUrl,
    double? quantity,
    String? nameSw,
    String? descriptionSw,
    List<XFile>? imageFiles,
  }) async {
    if (imageFiles != null && imageFiles.isNotEmpty) {
      final fields = <String, String>{
        'name': name,
        'unit': unit,
        'price': '$price',
        'sync_catalog': '1',
      };
      if (description != null && description.isNotEmpty) fields['description'] = description;
      if (quantity != null) fields['quantity'] = '$quantity';
      if (nameSw != null && nameSw.isNotEmpty) fields['name_sw'] = nameSw;
      if (descriptionSw != null && descriptionSw.isNotEmpty) fields['description_sw'] = descriptionSw;
      final d = await _multipartJson(
        'POST',
        '/products',
        fields: fields,
        imageFiles: imageFiles,
      );
      return ProductSaveResult.fromResponse(d);
    }

    final body = <String, dynamic>{
      'name': name,
      'unit': unit,
      'price': price,
      'sync_catalog': true,
    };
    if (description != null && description.isNotEmpty) body['description'] = description;
    if (imageUrl != null && imageUrl.isNotEmpty) body['image_url'] = imageUrl;
    if (quantity != null) body['quantity'] = quantity;
    if (nameSw != null && nameSw.isNotEmpty) body['name_sw'] = nameSw;
    if (descriptionSw != null && descriptionSw.isNotEmpty) body['description_sw'] = descriptionSw;
    final d = await _post('/products', body);
    return ProductSaveResult.fromResponse(d);
  }

  static Future<Map<String, dynamic>> _multipartJson(
    String method,
    String path, {
    required Map<String, String> fields,
    required List<XFile> imageFiles,
  }) async {
    final prefix = await _apiPrefix();
    final uri = Uri.parse('$prefix$path');
    if (kDebugMode) {
      debugPrint('WhatsLipa multipart $method $uri (${imageFiles.length} images)');
    }
    final req = http.MultipartRequest(method, uri);
    final authHeaders = await _authHeaders();
    req.headers.addAll(authHeaders);
    req.headers.remove('Content-Type');
    req.fields.addAll(fields);
    for (var i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      final bytes = await file.readAsBytes();
      var name = file.name;
      if (name.isEmpty) {
        name = 'image_$i.jpg';
      }
      final ext = path_lib.extension(name).toLowerCase();
      final mime = ext == '.png' ? 'image/png' : 'image/jpeg';
      req.files.add(http.MultipartFile.fromBytes(
        'images[]',
        bytes,
        filename: name,
        contentType: MediaType.parse(mime),
      ));
    }
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    if (kDebugMode && res.statusCode >= 400) {
      debugPrint('WhatsLipa multipart response ${res.statusCode}: ${res.body}');
    }
    return _parse(res);
  }

  static Future<void> logout() async {
    final prefix = await _apiPrefix();
    final token = await WhatsLipaSession.token;
    if (token != null) {
      try {
        await http.post(Uri.parse('$prefix/logout'), headers: await _authHeaders());
      } catch (_) {}
    }
    await WhatsLipaSession.clear();
    await WhatsLipaConfig.clearCachedState();
    lastLoginAttempts = [];
  }

  static Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String>? query,
    WhatsLipaProgressCallback? onProgress,
    String? progressLabel,
  }) async {
    onProgress?.call(progressLabel ?? 'Loading…');
    return _parse(await _getRaw(path, query: query));
  }

  static Future<http.Response> _getRaw(String path, {Map<String, String>? query}) async {
    final prefix = await _apiPrefix();
    var uri = Uri.parse('$prefix$path');
    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: query);
    }
    return http.get(uri, headers: await _authHeaders());
  }

  static Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    WhatsLipaProgressCallback? onProgress,
    String? progressLabel,
  }) async {
    onProgress?.call(progressLabel ?? 'Saving…');
    final prefix = await _apiPrefix();
    final res = await http
        .post(
          Uri.parse('$prefix$path'),
          headers: await _authHeaders(),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 90));
    if (kDebugMode && path.contains('sync-catalog')) {
      debugPrint('WhatsLipa sync-catalog response ${res.statusCode}: ${res.body}');
    }
    return _parse(res);
  }

  static Future<Map<String, dynamic>> _put(String path, Map<String, dynamic> body) async {
    final prefix = await _apiPrefix();
    return _parse(await http.put(
      Uri.parse('$prefix$path'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    ));
  }

  static String _mediaMimeForUpload(String path, String mediaType) {
    final ext = path_lib.extension(path).toLowerCase();
    if (mediaType == 'video') {
      return ext == '.mov' ? 'video/quicktime' : 'video/mp4';
    }
    if (mediaType == 'audio') {
      return ext == '.ogg' ? 'audio/ogg' : 'audio/mpeg';
    }
    return ext == '.png' ? 'image/png' : 'image/jpeg';
  }

  static Future<Map<String, dynamic>> _parse(http.Response res) async {
    Map<String, dynamic> body = {};
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      } else if (decoded is Map) {
        body = Map<String, dynamic>.from(decoded);
      }
    } catch (e) {
      if (kDebugMode) {
        final preview = res.body.length > 200 ? '${res.body.substring(0, 200)}…' : res.body;
        debugPrint('WhatsLipa JSON parse error (${res.statusCode}): $e — body: $preview');
      }
    }

    if (res.statusCode >= 200 && res.statusCode < 300 && body['success'] == true) {
      return body;
    }
    throw WhatsLipaApiException(res.statusCode, _formatApiError(body, res.statusCode, res.body));
  }

  static String _formatApiError(Map<String, dynamic> body, int statusCode, String rawBody) {
    final errors = body['errors'];
    if (errors is Map) {
      final lines = <String>[];
      errors.forEach((key, value) {
        if (value is List) {
          for (final item in value) {
            lines.add('$key: $item');
          }
        } else if (value != null) {
          lines.add('$key: $value');
        }
      });
      if (lines.isNotEmpty) {
        return lines.join('\n');
      }
    }
    final msg = body['message']?.toString();
    if (msg != null && msg.isNotEmpty) {
      return msg;
    }
    if (body.isEmpty && rawBody.isNotEmpty) {
      return 'Invalid server response ($statusCode)';
    }
    return 'Request failed ($statusCode)';
  }
}
