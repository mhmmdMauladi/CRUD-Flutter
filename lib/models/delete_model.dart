import 'package:http/http.dart' as http;
import 'dart:convert';

// URL endpoint API
const String apiUrl = 'http://192.168.229.30/api_project/tb_dokter/delete.php';

// Fungsi untuk menghapus dokter
Future<void> deleteDoctor(int doctorId) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'id_dokter': doctorId.toString(),
    },
  );

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if (responseBody['message'] == 'deleted!') {
      print('Doctor deleted successfully');
    } else {
      throw Exception('Failed to delete doctor');
    }
  } else {
    throw Exception('Failed to connect to the API');
  }
}
