class Model3D {
  final String id;
  final String name;
  final String glbUrl;

  const Model3D({required this.id, required this.name, required this.glbUrl});

  factory Model3D.fromJson(Map<String, dynamic> j)
    => Model3D(id: j['id'], name: j['name'], glbUrl: j['glbUrl']);
}
