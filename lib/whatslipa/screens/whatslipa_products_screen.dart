import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_product_images_field.dart';
class WhatsLipaProductsScreen extends StatefulWidget {
  const WhatsLipaProductsScreen({super.key});

  @override
  State<WhatsLipaProductsScreen> createState() => _WhatsLipaProductsScreenState();
}

class _WhatsLipaProductsScreenState extends State<WhatsLipaProductsScreen> {
  List<dynamic> _products = [];
  bool _loading = true;
  Map<String, String>? _imageHeaders;

  static const _units = ['kg', 'piece', 'liter', 'gram', 'bunch', 'pack', 'cylinder'];

  @override
  void initState() {
    super.initState();
    _loadImageHeaders();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  Future<void> _loadImageHeaders() async {
    final headers = await WhatsLipaApi.productImageHeaders();
    if (mounted) {
      setState(() => _imageHeaders = headers);
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _products = await WhatsLipaApi.productsList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
      _products = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  List<String> _urlsFromProduct(Map<String, dynamic> p) {
    final raw = p['image_urls'];
    if (raw is List) {
      return raw.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    }
    final single = p['image_url']?.toString();
    return single != null && single.isNotEmpty ? [single] : [];
  }

  Future<void> _openRegisterForm() async {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '0');
    String unit = _units.first;
    var saving = false;
    var newImageFiles = <XFile>[];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.neumorphicBase,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Register product',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.primaryColor),
                      ),
                      const SizedBox(height: 16),
                      NeuTextField(controller: nameCtrl, labelText: 'Product name *'),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: unit,
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          filled: true,
                          fillColor: AppColor.neumorphicSurface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: saving ? null : (v) => setModalState(() => unit = v ?? unit),
                      ),
                      const SizedBox(height: 12),
                      NeuTextField(
                        controller: priceCtrl,
                        labelText: 'Price (TZS) *',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 12),
                      NeuTextField(controller: descCtrl, labelText: 'Description'),
                      const SizedBox(height: 12),
                      WhatsLipaProductImagesField(
                        onChanged: (_, files) => newImageFiles = files,
                      ),
                      const SizedBox(height: 20),
                      NeuPrimaryButton(
                        label: 'Save to catalog',
                        loading: saving,
                        onPressed: saving
                            ? null
                            : () async {
                                final name = nameCtrl.text.trim();
                                final price = double.tryParse(priceCtrl.text.trim());
                                if (name.isEmpty) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(content: Text('Enter product name')),
                                  );
                                  return;
                                }
                                if (price == null || price < 0) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(content: Text('Enter a valid price')),
                                  );
                                  return;
                                }
                                setModalState(() => saving = true);
                                try {
                                  final result = await WhatsLipaApi.registerProduct(
                                    name: name,
                                    unit: unit,
                                    price: price,
                                    description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                                    quantity: double.tryParse(qtyCtrl.text.trim()),
                                    imageFiles: newImageFiles.isEmpty ? null : newImageFiles,
                                  );
                                  if (ctx.mounted) Navigator.pop(ctx);
                                  if (mounted) {
                                    ScaffoldMessenger.of(this.context).showSnackBar(
                                      SnackBar(
                                        content: Text(result.message),
                                        duration: const Duration(seconds: 6),
                                        backgroundColor: result.catalogSynced ? null : const Color(0xFFB45309),
                                      ),
                                    );
                                    _load();
                                  }
                                } catch (e) {
                                  setModalState(() => saving = false);
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(content: Text('$e'), duration: const Duration(seconds: 6)),
                                    );
                                  }
                                }
                              },
                      ),
                    ],
                  ),
              ),
            );
          },
        );
      },
    );

    nameCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    qtyCtrl.dispose();
  }

  Future<void> _openEditForm(Map<String, dynamic> p) async {
    final id = p['id'] as int;
    final nameCtrl = TextEditingController(text: p['name']?.toString() ?? '');
    final descCtrl = TextEditingController(text: p['description']?.toString() ?? '');
    final priceCtrl = TextEditingController(text: '${p['price'] ?? ''}');
    var saving = false;
    var keptUrls = _urlsFromProduct(p);
    var newImageFiles = <XFile>[];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.neumorphicBase,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Edit #${p['id']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    NeuTextField(controller: nameCtrl, labelText: 'Name'),
                    const SizedBox(height: 8),
                    NeuTextField(controller: priceCtrl, labelText: 'Price (TZS)', keyboardType: TextInputType.number),
                    const SizedBox(height: 8),
                    NeuTextField(controller: descCtrl, labelText: 'Description'),
                    const SizedBox(height: 12),
                    WhatsLipaProductImagesField(
                      existingUrls: keptUrls,
                      onChanged: (urls, files) {
                        keptUrls = urls;
                        newImageFiles = files;
                      },
                    ),
                    const SizedBox(height: 16),
                    NeuPrimaryButton(
                      label: 'Save & sync catalog',
                      loading: saving,
                      onPressed: saving
                          ? null
                          : () async {
                              final price = double.tryParse(priceCtrl.text.trim());
                              if (nameCtrl.text.trim().isEmpty || price == null) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(content: Text('Name and valid price required')),
                                );
                                return;
                              }
                              setModalState(() => saving = true);
                              try {
                                final result = await WhatsLipaApi.updateProduct(
                                  id,
                                  name: nameCtrl.text.trim(),
                                  price: price,
                                  description: descCtrl.text.trim(),
                                  imageFiles: newImageFiles.isEmpty ? null : newImageFiles,
                                  keepImageUrls: keptUrls,
                                );
                                if (ctx.mounted) Navigator.pop(ctx);
                                if (mounted) {
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    SnackBar(
                                      content: Text(result.message),
                                      duration: const Duration(seconds: 6),
                                    ),
                                  );
                                  _load();
                                }
                              } catch (e) {
                                setModalState(() => saving = false);
                                if (ctx.mounted) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    SnackBar(content: Text('$e'), duration: const Duration(seconds: 6)),
                                  );
                                }
                              }
                            },
                    ),
                    TextButton(
                      onPressed: saving
                          ? null
                          : () async {
                              setModalState(() => saving = true);
                              try {
                                final result = await WhatsLipaApi.syncProductCatalog(id);
                                if (!ctx.mounted) return;
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text(result.message),
                                    duration: const Duration(seconds: 6),
                                    backgroundColor: result.success ? null : Colors.red.shade700,
                                  ),
                                );
                                if (result.success && mounted) {
                                  _load();
                                }
                              } catch (e) {
                                if (ctx.mounted) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text('$e'),
                                      duration: const Duration(seconds: 6),
                                      backgroundColor: Colors.red.shade700,
                                    ),
                                  );
                                }
                              } finally {
                                if (ctx.mounted) {
                                  setModalState(() => saving = false);
                                }
                              }
                            },
                      child: saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sync to WhatsApp catalog only'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    nameCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neumorphicBase,
      appBar: WhatsLipaTheme.appBar(
        title: 'Products',
        actions: [IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _load)],
      ),
      floatingActionButton: Neumorphic(
        style: NeumorphicStyle(depth: 6, color: WhatsLipaTheme.primary, boxShape: const NeumorphicBoxShape.circle()),
        padding: const EdgeInsets.all(14),
        child: InkWell(
          onTap: _openRegisterForm,
          customBorder: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
      body: NeuScreenCanvas(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColor.primaryColor))
            : RefreshIndicator(
                color: AppColor.primaryColor,
                onRefresh: _load,
                child: _products.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 80),
                          Center(child: Text('No products yet.\nTap + to register one.')),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
                        itemCount: _products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final p = _products[i] as Map<String, dynamic>;
                          final thumb = _urlsFromProduct(p).isNotEmpty ? _urlsFromProduct(p).first : null;
                          return NeuPanel(
                            padding: const EdgeInsets.all(14),
                            child: ListTile(
                              onTap: () => _openEditForm(p),
                              leading: thumb != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        thumb,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        headers: _imageHeaders,
                                        errorBuilder: (_, __, ___) => _productIcon(),
                                      ),
                                    )
                                  : _productIcon(),
                              title: Text(
                                p['name']?.toString() ?? '',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text('${p['price'] ?? 0} TZS'),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }

  Widget _productIcon() {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 3,
        boxShape: const NeumorphicBoxShape.circle(),
        color: AppColor.primaryColor.withValues(alpha: 0.12),
      ),
      padding: const EdgeInsets.all(10),
      child: const Icon(Icons.inventory_2_rounded, color: AppColor.primaryColor),
    );
  }
}
