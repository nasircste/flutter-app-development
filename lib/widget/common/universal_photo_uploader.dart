import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'universal_photo_uploader_ui.dart';
import '../../utils/responsive_utils.dart';

String convertStoragePathToUrl(String storagePath, {bool isEmulator = true}) {
  const String bucket = 'esteem-55225.appspot.com';

  final String decodedPath = Uri.decodeComponent(storagePath.replaceAll('+', ' '));

  final String encodedPath = Uri.encodeComponent(decodedPath);

  if (isEmulator) {
    return 'http://localhost:9199/v0/b/$bucket/o/$encodedPath?alt=media';
  } else {
    return 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encodedPath?alt=media';
  }
}

class PendingPhoto {
  final PlatformFile file;
  final Uint8List? bytes;
  final String? fileUrl; 
  bool isCover;

  PendingPhoto({
    required this.file,
    this.bytes,
    this.fileUrl,
    this.isCover = false,
  });
}


class BuildingPhotoUploader extends StatefulWidget {
  final List<PendingPhoto> photos;
  final Function(List<PendingPhoto>) onPhotosChanged;

  const BuildingPhotoUploader({
    super.key,
    required this.photos,
    required this.onPhotosChanged,
  });

  @override
  State<BuildingPhotoUploader> createState() => _BuildingPhotoUploaderState();
}

class _BuildingPhotoUploaderState extends State<BuildingPhotoUploader> {
  Future<void> _pickPhotos() async {
    print('🔍 _pickPhotos called - button tapped');
    try {
      print('📂 Opening FilePicker...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );
      print('📂 FilePicker result: ${result != null ? "${result.files.length} files" : "null (user canceled)"}');

      if (result == null || result.files.isEmpty) {
        print(' No files selected');
        return;
      }

      final hasExistingCover = widget.photos.any((photo) => photo.isCover);
      final newPhotos = result.files.map((f) {
        print('📷 Processing file: ${f.name}, size: ${f.size} bytes');
        return PendingPhoto(
          file: f,
          bytes: f.bytes,
        );
      }).toList();

      final updatedPhotos = [...widget.photos, ...newPhotos];

      // Ensure exactly one cover photo on the first upload.
      if (!hasExistingCover && updatedPhotos.isNotEmpty) {
        for (final photo in updatedPhotos) {
          photo.isCover = false;
        }
        updatedPhotos.first.isCover = true;
        print('Set ${updatedPhotos.first.file.name} as cover photo');
      }
      print(' Total photos now: ${updatedPhotos.length}');
      widget.onPhotosChanged(updatedPhotos);
    } catch (e, stackTrace) {
      print(' Error in _pickPhotos: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<PendingPhoto>.from(widget.photos);
    final removedWasCover = updatedPhotos[index].isCover;
    updatedPhotos.removeAt(index);

 
    if (removedWasCover && updatedPhotos.isNotEmpty) {
      updatedPhotos.first.isCover = true;
    }

    widget.onPhotosChanged(updatedPhotos);
  }

  void _toggleCover(int index) {
    final updatedPhotos = List<PendingPhoto>.from(widget.photos);

    // Remove cover from all photos
    for (var photo in updatedPhotos) {
      photo.isCover = false;
    }

    // Set selected photo as cover
    updatedPhotos[index].isCover = true;
    widget.onPhotosChanged(updatedPhotos);
  }

  @override
  Widget build(BuildContext context) {
    return UniversalPhotoUploaderUI<PendingPhoto>(
      photos: widget.photos,
      onAddPhoto: () {
        print('🖱️ Add Photo button tapped!');
        _pickPhotos();
      },
      onRemovePhoto: _removePhoto,
      onToggleCover: _toggleCover,
      isCoverPhoto: (photo) => photo.isCover,
      photoBuilder: (photo) {
        if (photo.bytes != null) {
          return Image.memory(
            photo.bytes!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );
        } else if (photo.fileUrl != null) {
          // Convert storage path to proper HTTP URL for emulator
          final String imageUrl = convertStoragePathToUrl(photo.fileUrl!, isEmulator: true);
          print('📷 Loading photo from URL: $imageUrl');
          return Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print(' Error loading image from $imageUrl: $error');
              print('Stack trace: $stackTrace');
              final iconSize = IntakeLayoutTokens.photoIconSize(context);
              final spacing = IntakeLayoutTokens.smallSpacing(context);
              final textSize =
                  ResponsiveUtils.scaleFont(context, 10, min: 8, max: 12);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: iconSize,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    'Failed to load',
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.red,
                    ),
                  ),
                ],
              );
            },
          );
        }
        return null;
      },
      emptyStateText: 'Click to upload building photo',
      addButtonText: 'Add Photo',
    );
  }
}
