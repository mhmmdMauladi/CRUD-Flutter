import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorModel {
  int id;
  String name;
  String jabatan;
  String alamat;
  String image;


  DoctorModel({
    required this.id,
    required this.name,
    required this.jabatan,
    required this.alamat,
    required this.image,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: int.tryParse(json['id_dokter']?.toString() ?? '0') ?? 0,
      name: json['nama'] ?? 'Unknown',
      jabatan: json['jabatan'] ?? 'Unknown',
      alamat: json['alamat'] ?? 'Unknown',
      image: "Dr. Stone.jpg",
    );
  }
}

Future<List<DoctorModel>> fetchDoctors() async {
  final response = await http.get(Uri.parse('http://192.168.229.30/api_project/tb_dokter/read.php'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => DoctorModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load doctors');
  }
}
