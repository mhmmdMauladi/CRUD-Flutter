import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> addDoctor(String name, String jabatan, String alamat) async {
  final response = await http.post(
    Uri.parse('http://192.168.229.30/api_project/tb_dokter/create.php'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: <String, String>{
      'nama': name,
      'jabatan': jabatan,
      'alamat': alamat,
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['message'] == 'created!') {
      print('Doctor added successfully');
    } else {
      print('Error: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Failed to add doctor');
  }
}
