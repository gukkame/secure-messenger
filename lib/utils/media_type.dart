enum MediaType {
  image,
  video,
  audio,
}

extension MediaTypeExtension on MediaType {
  String get str {
    switch (this) {
      case MediaType.image:
        return 'image';
      case MediaType.video:
        return 'video';
      case MediaType.audio:
        return 'audio';
    }
  }
}
