import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/company.dart';
import '../models/launch.dart';
import '../models/rocket.dart';

// Erro com mensagem já pronta para mostrar ao usuário.
class SpaceXException implements Exception {
  final String message;
  SpaceXException(this.message);

  @override
  String toString() => message;
}

class SpaceXService {
  static const _baseUrl = 'https://api.spacexdata.com/v4';

  final http.Client _client = http.Client();

  // Faz o GET, valida o status e devolve o JSON decodificado.
  Future<dynamic> _get(String path) async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl$path'))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        throw SpaceXException('A API respondeu com erro ${response.statusCode}.');
      }
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on SpaceXException {
      rethrow;
    } on SocketException {
      throw SpaceXException('Sem conexão com a internet.');
    } on http.ClientException {
      throw SpaceXException('Sem conexão com a internet ou API fora do ar.');
    } on TimeoutException {
      throw SpaceXException('A requisição demorou demais. Tente novamente.');
    } on FormatException {
      throw SpaceXException('Resposta inesperada da API.');
    } on TypeError {
      throw SpaceXException('Os dados recebidos estão em formato inesperado.');
    }
  }

  // GET /launches -> todos os lançamentos, do mais recente ao mais antigo.
  Future<List<Launch>> fetchLaunches() async {
    final json = await _get('/launches') as List;
    final launches = json.map((e) => Launch.fromJson(e as Map<String, dynamic>)).toList();
    launches.sort((a, b) => b.date.compareTo(a.date));
    return launches;
  }

  // GET /launches/latest -> último lançamento registrado.
  Future<Launch> fetchLatestLaunch() async {
    final json = await _get('/launches/latest') as Map<String, dynamic>;
    return Launch.fromJson(json);
  }

  // GET /rockets
  Future<List<Rocket>> fetchRockets() async {
    final json = await _get('/rockets') as List;
    return json.map((e) => Rocket.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Mapa id -> nome, para mostrar o foguete de cada lançamento.
  Future<Map<String, String>> fetchRocketNames() async {
    final rockets = await fetchRockets();
    return {for (final r in rockets) r.id: r.name};
  }

  // GET /company
  Future<Company> fetchCompany() async {
    final json = await _get('/company') as Map<String, dynamic>;
    return Company.fromJson(json);
  }
}

final spaceX = SpaceXService();
