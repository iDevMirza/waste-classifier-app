class WasteClasses {
  WasteClasses._();

  static const List<String> values = [
    'cardboard',
    'glass',
    'metal',
    'paper',
    'plastic',
    'trash',
  ];

  static String displayName(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() + value.substring(1);
  }
}
