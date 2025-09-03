class ModelInfo {
  final String title;
  final String dateText;
  final String glbUrl;
  final String? thumbnailAsset;

  ModelInfo({
    required this.title,
    required this.dateText,
    required this.glbUrl,
    this.thumbnailAsset,
  });
}
