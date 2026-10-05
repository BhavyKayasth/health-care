import '../model/medicine_model.dart';

const List<MedicineModel> medicines = [
  MedicineModel(
    id: 1,
    name: 'Paracetamol 500mg',
    category: 'Pain Relief',
    price: 15,
    mrp: 20,
    discount: 25,
    prescription: false,
    manufacturer: 'Cipla',
    description: 'Relief from fever and mild to moderate pain',
    inStock: true,
    rating: 4.5,
  ),

  MedicineModel(
    id: 2,
    name: 'Azithromycin 500mg',
    category: 'Antibiotics',
    price: 120,
    mrp: 150,
    discount: 20,
    prescription: true,
    manufacturer: 'Sun Pharma',
    description: 'Antibiotic for bacterial infections',
    inStock: true,
    rating: 4.7,
  ),

  MedicineModel(
    id: 3,
    name: 'Cetirizine 10mg',
    category: 'Allergy',
    price: 25,
    mrp: 35,
    discount: 29,
    prescription: false,
    manufacturer: "Dr. Reddy's",
    description: 'Relief from allergic symptoms',
    inStock: true,
    rating: 4.6,
  ),

  MedicineModel(
    id: 4,
    name: 'Omeprazole 20mg',
    category: 'Digestive',
    price: 45,
    mrp: 60,
    discount: 25,
    prescription: false,
    manufacturer: 'Lupin',
    description: 'Treats stomach acid and heartburn',
    inStock: true,
    rating: 4.4,
  ),

  MedicineModel(
    id: 5,
    name: 'Vitamin D3 60K',
    category: 'Vitamins',
    price: 80,
    mrp: 100,
    discount: 20,
    prescription: false,
    manufacturer: 'Mankind',
    description: 'Vitamin D supplement',
    inStock: true,
    rating: 4.8,
  ),

  MedicineModel(
    id: 6,
    name: 'Ibuprofen 400mg',
    category: 'Pain Relief',
    price: 30,
    mrp: 40,
    discount: 25,
    prescription: false,
    manufacturer: 'Abbott',
    description: 'Anti-inflammatory pain relief',
    inStock: true,
    rating: 4.5,
  ),
];

const List<String> medicineCategories = [
  'All',
  'Pain Relief',
  'Antibiotics',
  'Allergy',
  'Digestive',
  'Vitamins',
];

const List<Map<String, String>> medicinePartners = [
  {
    'name': 'PharmEasy',
    'commission': '12%',
  },
  {
    'name': '1mg',
    'commission': '10%',
  },
  {
    'name': 'Netmeds',
    'commission': '11%',
  },
  {
    'name': 'Apollo 24|7',
    'commission': '9%',
  },
];