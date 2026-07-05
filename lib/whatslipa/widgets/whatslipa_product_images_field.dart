import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';

/// Pick multiple product photos (gallery/camera) and manage existing URLs.
class WhatsLipaProductImagesField extends StatefulWidget {
  const WhatsLipaProductImagesField({
    super.key,
    this.existingUrls = const [],
    this.maxImages = 8,
    this.onChanged,
  });

  final List<String> existingUrls;
  final int maxImages;
  final void Function(List<String> keptUrls, List<XFile> newFiles)? onChanged;

  @override
  State<WhatsLipaProductImagesField> createState() => _WhatsLipaProductImagesFieldState();
}

class _WhatsLipaProductImagesFieldState extends State<WhatsLipaProductImagesField> {
  final _picker = ImagePicker();
  late List<String> _keptUrls;
  final List<XFile> _newFiles = [];
  Map<String, String>? _imageHeaders;

  @override
  void initState() {
    super.initState();
    _keptUrls = List<String>.from(widget.existingUrls);
    _loadImageHeaders();
  }

  Future<void> _loadImageHeaders() async {
    final headers = await WhatsLipaApi.productImageHeaders();
    if (mounted) {
      setState(() => _imageHeaders = headers);
    }
  }

  void _notify() {
    widget.onChanged?.call(_keptUrls, List<XFile>.from(_newFiles));
  }

  int get _total => _keptUrls.length + _newFiles.length;

  Future<void> _pickFromGallery() async {
    if (_total >= widget.maxImages) {
      _snack('Maximum ${widget.maxImages} images');
      return;
    }
    final files = await _picker.pickMultiImage(imageQuality: 75, maxWidth: 1600);
    if (files.isEmpty) return;
    setState(() {
      for (final f in files) {
        if (_total >= widget.maxImages) break;
        _newFiles.add(f);
      }
      _notify();
    });
  }

  Future<void> _takePhoto() async {
    if (_total >= widget.maxImages) {
      _snack('Maximum ${widget.maxImages} images');
      return;
    }
    final file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 75, maxWidth: 1600);
    if (file == null) return;
    setState(() {
      _newFiles.add(file);
      _notify();
    });
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showAddMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: WhatsLipaTheme.primary),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickFromGallery();
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: Icon(Icons.camera_alt, color: WhatsLipaTheme.primary),
                title: const Text('Take photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  _takePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Product photos', style: TextStyle(fontWeight: FontWeight.w600, color: primary)),
            const Spacer(),
            Text('$_total / ${widget.maxImages}', style: const TextStyle(fontSize: 12, color: AppColor.textSecondary)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'First photo is used on WhatsApp catalog. Add up to ${widget.maxImages} images.',
          style: const TextStyle(fontSize: 12, color: AppColor.textSecondary),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._keptUrls.asMap().entries.map((e) => _thumb(
                    key: ValueKey('url_${e.key}'),
                    child: Image.network(
                      e.value,
                      fit: BoxFit.cover,
                      headers: _imageHeaders,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                    onRemove: () {
                      setState(() {
                        _keptUrls.removeAt(e.key);
                        _notify();
                      });
                    },
                  )),
              ..._newFiles.asMap().entries.map((e) => _thumb(
                    key: ValueKey('file_${e.key}'),
                    child: _NewImagePreview(file: e.value),
                    onRemove: () {
                      setState(() {
                        _newFiles.removeAt(e.key);
                        _notify();
                      });
                    },
                  )),
              if (_total < widget.maxImages)
                GestureDetector(
                  onTap: _showAddMenu,
                  child: Container(
                    width: 88,
                    height: 88,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColor.neumorphicSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primary.withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: primary),
                        const SizedBox(height: 4),
                        Text('Add', style: TextStyle(fontSize: 11, color: primary)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thumb({required Key key, required Widget child, required VoidCallback onRemove}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(width: 88, height: 88, child: child),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewImagePreview extends StatelessWidget {
  const _NewImagePreview({required this.file});

  final XFile file;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(),
      builder: (context, snap) {
        if (snap.hasData) {
          return Image.memory(snap.data!, fit: BoxFit.cover);
        }
        if (snap.hasError) {
          return const Icon(Icons.broken_image);
        }
        return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
      },
    );
  }
}
