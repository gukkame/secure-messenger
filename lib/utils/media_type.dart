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
        return "image";
      case MediaType.video:
        return "video";
      case MediaType.audio:
        return "audio";
    }
  }
}

class MediaTypeUtils {
  static MediaType from(String str) {
    switch (str.toLowerCase()) {
      case "text":
      case "texts":
        return MediaType.text;
      case "image":
      case "images":
        return MediaType.image;
      case "audio":
      case "audios":
        return MediaType.audio;
      case "video":
      case "videos":
        return MediaType.video;
      default:
        throw UnimplementedError("No media type assigned to $str");
    }
  }
}
