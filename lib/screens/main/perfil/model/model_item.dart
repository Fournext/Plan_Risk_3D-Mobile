class ModelItem {
  final int id;
  final String planFile;
  final String planImage;
  final String detectionsJson;
  final String glbModel;
  final int width;
  final int height;
  final String createdAt;
  final int usuario;

  ModelItem({
    required this.id,
    required this.planFile,
    required this.planImage,
    required this.detectionsJson,
    required this.glbModel,
    required this.width,
    required this.height,
    required this.createdAt,
    required this.usuario,
  });

  factory ModelItem.fromJson(Map<String, dynamic> j) => ModelItem(
        id: j['id'],
        planFile: j['plan_file'] ?? '',
        planImage: j['plan_image'] ?? '',
        detectionsJson: j['detections_json'] ?? '',
        glbModel: j['glb_model'] ?? '',
        width: j['width'] ?? 0,
        height: j['height'] ?? 0,
        createdAt: j['created_at'] ?? '',
        usuario: j['usuario'] ?? 0,
      );
}
