import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> updateDoctor(
    int id, String name, String jabatan, String alamat) async {
  final response = await http.post(
    Uri.parse('http://192.168.229.30/api_project/tb_dokter/edit.php'),
    body: {
      'id_dokter': id.toString(),
      'nama': name,
      'jabatan': jabatan,
      'alamat': alamat,
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['message'] == 'updated!') {
      print('Doctor updated successfully');
    } else {
      throw Exception('Failed to update doctor');
    }
  } else {
    throw Exception('Failed to update doctor');
  }
}
