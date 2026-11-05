import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/launch.dart';
import '../models/rocket.dart';
import '../utils/json.dart';

// Erro com mensagem já pronta para mostrar ao usuário.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

// Uma página de lançamentos + o total que a API informa em "count".
class LaunchPage {
  final int count;
  final List<Launch> launches;
  LaunchPage(this.count, this.launches);
}

class _CacheEntry {
  final Future<dynamic> future;
  final DateTime time;
  _CacheEntry(this.future, this.time);
}

class SpaceService {
  // Para usar a versão de desenvolvimento (limite maior), troque "ll" por "lldev".
  static const _baseUrl = 'https://ll.thespacedevs.com/2.2.0';

  // A API gratuita limita a 15 requisições por hora, então guardamos as respostas.
  static const _cacheTtl = Duration(minutes: 10);
  static const _forceMinAge = Duration(minutes: 1);

  final http.Client _client = http.Client();
  final Map<String, _CacheEntry> _cache = {};

  // GET com cache. As telas que pedem o mesmo caminho ao mesmo tempo
  // compartilham a mesma requisição. "force" ignora o cache (puxar para atualizar).
  Future<dynamic> _get(String path, {bool force = false}) {
    final entry = _cache[path];
    final maxAge = force ? _forceMinAge : _cacheTtl;
    if (entry != null && DateTime.now().difference(entry.time) < maxAge) {
      return entry.future;
    }

    final future = _request(path);
    _cache[path] = _CacheEntry(future, DateTime.now());
    // Se falhar, não deixa o erro guardado no cache.
    future.catchError((_) {
      if (identical(_cache[path]?.future, future)) _cache.remove(path);
    });
    return future;
  }

  Future<dynamic> _request(String path) async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl$path'))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 429) {
        throw ApiException('Limite de requisições da API atingido. Aguarde alguns minutos.');
      }
      if (response.statusCode != 200) {
        throw ApiException('A API respondeu com erro ${response.statusCode}.');
      }
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiException('Sem conexão com a internet.');
    } on http.ClientException {
      throw ApiException('Sem conexão com a internet ou API fora do ar.');
    } on TimeoutException {
      throw ApiException('A requisição demorou demais. Tente novamente.');
    } on FormatException {
      throw ApiException('Resposta inesperada da API.');
    } on TypeError {
      throw ApiException('Os dados recebidos estão em formato inesperado.');
    }
  }

  Future<LaunchPage> _fetchLaunches(String path, bool force) async {
    final json = await _get(path, force: force) as Map<String, dynamic>;
    final results = (json['results'] as List?) ?? [];
    final launches = results.map((e) => Launch.fromJson(e as Map<String, dynamic>)).toList();
    return LaunchPage(asInt(json['count']), launches);
  }

  // GET /launch/upcoming -> próximos lançamentos (do mais próximo ao mais distante).
  Future<LaunchPage> fetchUpcoming({bool force = false}) =>
      _fetchLaunches('/launch/upcoming/?limit=30&mode=list', force);

  // GET /launch/previous -> lançamentos já realizados.
  Future<LaunchPage> fetchPrevious({bool force = false}) =>
      _fetchLaunches('/launch/previous/?limit=30&mode=list', force);

  // Junta próximos e anteriores numa lista só, do mais recente ao mais antigo.
  Future<List<Launch>> fetchAllLaunches({bool force = false}) async {
    final pages = await Future.wait<LaunchPage>([
      fetchUpcoming(force: force),
      fetchPrevious(force: force),
    ]);
    final all = [...pages[0].launches, ...pages[1].launches];
    all.sort((a, b) => b.date.compareTo(a.date));
    return all;
  }

  // GET /config/launcher -> os 12 foguetes com mais lançamentos.
  Future<List<Rocket>> fetchRockets({bool force = false}) async {
    final json = await _get('/config/launcher/?limit=100', force: force) as Map<String, dynamic>;
    final results = (json['results'] as List?) ?? [];
    final rockets = results.map((e) => Rocket.fromJson(e as Map<String, dynamic>)).toList();
    rockets.sort((a, b) => b.totalLaunches.compareTo(a.totalLaunches));
    return rockets.take(12).toList();
  }
}

final spaceService = SpaceService();
