enum MediaType {
  text,
  image,
  video,
  audio,
}

extension MediaTypeExtension on MediaType {
  String get str {
    switch (this) {
      case MediaType.text:
        return "text";
      case MediaType.image:
        return 'image';
      case MediaType.video:
        return 'video';
      case MediaType.audio:
        return 'audio';
    }
  }
}
