class Convert {
  static String encode(String data) => data.replaceAll(".", ":");
  static String decode(String data) => data.replaceAll(":", ".");
}