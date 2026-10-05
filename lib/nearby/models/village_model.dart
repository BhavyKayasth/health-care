class VillageModel {
  final String id;
  final String areaId;
  final String name;

  const VillageModel({
    required this.id,
    required this.areaId,
    required this.name,
  });

  VillageModel copyWith({
    String? id,
    String? areaId,
    String? name,
  }) {
    return VillageModel(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      name: name ?? this.name,
    );
  }
}