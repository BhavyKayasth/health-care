class MedicineModel {
  final int id;
  final String name;
  final String category;
  final double price;
  final double mrp;
  final int discount;
  final bool prescription;
  final String manufacturer;
  final String description;
  final bool inStock;
  final double rating;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.mrp,
    required this.discount,
    required this.prescription,
    required this.manufacturer,
    required this.description,
    required this.inStock,
    required this.rating,
  });
}