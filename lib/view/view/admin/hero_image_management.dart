import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:smart_city/view/viewmodel/heroimage/hero_image_view_model.dart';
import 'package:smart_city/view/authentication/test/model/heroimagemodel/hero_image_model.dart';

class HeroImageManagement extends StatefulWidget {
  const HeroImageManagement({super.key});

  @override
  State<HeroImageManagement> createState() => _HeroImageManagementState();
}

class _HeroImageManagementState extends State<HeroImageManagement> {
  @override
  void initState() {
    super.initState();
    // Load hero images when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HeroImageViewModel>(context, listen: false).fetchHeroImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final heroImageViewModel = Provider.of<HeroImageViewModel>(context, listen: false);
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hero Resimler',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ana sayfa hero bölümü resimlerini yönetin',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showHeroImageUploadDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Yeni Resim Ekle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Loading State
              if (heroImageViewModel.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (heroImageViewModel.error != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Color(0xFFDC2626)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(heroImageViewModel.error!)),
                    ],
                  ),
                )
              else if (!heroImageViewModel.hasImages)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Henüz resim yüklenmemiş',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'İlk resmi yüklemek için "Yeni Resim Ekle" butonuna tıklayın',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              else
                // HeroImage Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75, // Daha dikdörtgen kartlar - resimler daha iyi görünür
                    ),
                    itemCount: heroImageViewModel.heroImageList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final image = heroImageViewModel.heroImageList![index];
                      return _buildHeroImageCard(image, heroImageViewModel);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroImageCard(HeroImageModel image, HeroImageViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4), spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Preview
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    // Background Image
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        'https://localhost:7276${image.imageUrl}',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Yükleniyor...', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  Text('Resim yüklenemedi', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Overlay - Palandöken mavi tonu
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          color: const Color(0xFF1E40AF).withOpacity(0.4), // Palandöken mavi tonu
                        ),
                      ),
                    ),
                    // Actions
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: IconButton(
                              onPressed: () => _showHeroImageUploadDialog(context, image),
                              icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: IconButton(
                              onPressed: () => _showDeleteConfirmation(context, image, viewModel),
                              icon: const Icon(Icons.delete, color: Colors.white, size: 16),
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resim #${image.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'Yüklenme: ${_formatDate(image.createdAt!)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
                const SizedBox(height: 2),
                FutureBuilder<String>(
                  future: _getImageSize(image.imageUrl!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text('Boyut: ${snapshot.data}', style: TextStyle(color: Colors.grey[600], fontSize: 11));
                    }
                    return Text('Boyut hesaplanıyor...', style: TextStyle(color: Colors.grey[600], fontSize: 11));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<String> _getImageSize(String imageUrl) async {
    try {
      final fullUrl = 'https://localhost:7276$imageUrl';
      final response = await http.head(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        final contentLength = response.headers['content-length'];
        if (contentLength != null) {
          final sizeInBytes = int.parse(contentLength);
          if (sizeInBytes < 1024) {
            return '$sizeInBytes B';
          } else if (sizeInBytes < 1024 * 1024) {
            return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
          } else {
            return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
          }
        }
      }
      return 'Bilinmiyor';
    } catch (e) {
      return 'Bilinmiyor';
    }
  }

  void _showHeroImageUploadDialog(BuildContext context, [HeroImageModel? image]) {
    showDialog(
      context: context,
      builder: (context) => _HeroImageUploadDialog(image: image),
    );
  }

  void _showDeleteConfirmation(BuildContext context, HeroImageModel image, HeroImageViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resmi Sil'),
        content: const Text('Bu resmi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await viewModel.deleteHeroImage(image.id!);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resim başarıyla silindi')));
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Resim silinirken hata oluştu')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

// HeroImage Upload Dialog
class _HeroImageUploadDialog extends StatefulWidget {
  final HeroImageModel? image;
  const _HeroImageUploadDialog({this.image});

  @override
  State<_HeroImageUploadDialog> createState() => _HeroImageUploadDialogState();
}

class _HeroImageUploadDialogState extends State<_HeroImageUploadDialog> {
  dynamic _selectedFile; // Can be File (mobile) or Uint8List (web)
  String? _fileName;
  bool _isUploading = false;
  String? _errorMessage;

  // Title and description controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.image != null ? 'Resim Düzenle' : 'Yeni Resim Yükle'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // File selection area
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _selectedFile != null
                  ? Stack(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(8), child: _buildImagePreview()),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: IconButton(
                              onPressed: () => setState(() {
                                _selectedFile = null;
                                _fileName = null;
                              }),
                              icon: const Icon(Icons.close, color: Colors.white, size: 16),
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                            ),
                          ),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: _pickImage,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text('Resim seçmek için tıklayın', style: TextStyle(color: Colors.grey.shade600)),
                          const SizedBox(height: 4),
                          Text('JPG, PNG, GIF (Max 10MB)', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // Error message
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Color(0xFFDC2626), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12)),
                    ),
                  ],
                ),
              ),

            if (_errorMessage != null) const SizedBox(height: 16),

            // File info
            if (_selectedFile != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dosya: $_fileName', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    FutureBuilder<int>(
                      future: _getFileSize(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final sizeInBytes = snapshot.data!;
                          final sizeInMB = (sizeInBytes / (1024 * 1024)).toStringAsFixed(2);
                          return Text('Boyut: $sizeInMB MB');
                        }
                        return const Text('Boyut hesaplanıyor...');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Title and Description fields
            if (_selectedFile != null) ...[
              // Title field
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                  hintText: 'Örn: ARAÇ FİLOSU',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Description field
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  hintText:
                      'Örn: Ulaşım ve diğer hizmetlerimizde kullanılmak üzere filomuzu 1200 araç ve iş makineleriyle güçlendirdik.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                maxLines: 3,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _isUploading ? null : () => Navigator.pop(context), child: const Text('İptal')),
        ElevatedButton(
          onPressed: _isUploading || _selectedFile == null ? null : _uploadImage,
          child: _isUploading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Yükle'),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _selectedFile is Uint8List) {
      return Image.memory(_selectedFile as Uint8List, width: double.infinity, height: 120, fit: BoxFit.cover);
    } else if (!kIsWeb && _selectedFile is File) {
      return Image.file(_selectedFile as File, width: double.infinity, height: 120, fit: BoxFit.cover);
    }
    return Container(
      width: double.infinity,
      height: 120,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image, size: 48, color: Colors.grey),
    );
  }

  Future<int> _getFileSize() async {
    if (kIsWeb && _selectedFile is Uint8List) {
      return (_selectedFile as Uint8List).length;
    } else if (!kIsWeb && _selectedFile is File) {
      return await (_selectedFile as File).length();
    }
    return 0;
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (kIsWeb) {
          // Web platform - use bytes
          if (file.bytes != null) {
            final fileSize = file.bytes!.length;
            final maxSize = 10 * 1024 * 1024; // 10MB in bytes

            if (fileSize > maxSize) {
              setState(() {
                _errorMessage =
                    'Dosya boyutu 10MB\'dan büyük olamaz. Seçilen dosya: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB';
              });
              return;
            }

            setState(() {
              _selectedFile = file.bytes;
              _fileName = file.name;
              _errorMessage = null;
            });
          }
        } else {
          // Mobile platform - use path
          if (file.path != null) {
            final fileObj = File(file.path!);
            final fileSize = await fileObj.length();
            final maxSize = 10 * 1024 * 1024; // 10MB in bytes

            if (fileSize > maxSize) {
              setState(() {
                _errorMessage =
                    'Dosya boyutu 10MB\'dan büyük olamaz. Seçilen dosya: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB';
              });
              return;
            }

            setState(() {
              _selectedFile = fileObj;
              _fileName = file.name;
              _errorMessage = null;
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Dosya seçilirken hata oluştu: $e';
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedFile == null) return;

    // Validate title and description
    if (_titleController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Başlık alanı zorunludur';
      });
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Açıklama alanı zorunludur';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final viewModel = Provider.of<HeroImageViewModel>(context, listen: false);
      final success = await viewModel.uploadImage(
        _selectedFile,
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );

      if (success) {
        // Close dialog and show success message
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resim başarıyla yüklendi')));
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Resim yüklenirken hata oluştu';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Resim yüklenirken hata oluştu: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
}
