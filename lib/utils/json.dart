// Leitura tolerante do JSON: campos podem vir nulos, como texto ou como número.

double? asDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

int asInt(dynamic v) => asDouble(v)?.toInt() ?? 0;

String? asText(dynamic v) {
  final texto = v?.toString().trim();
  return (texto == null || texto.isEmpty) ? null : texto;
}

// Dependendo da versão da API, a imagem vem como texto ou como objeto.
String? asImageUrl(dynamic v) {
  if (v is String && v.isNotEmpty) return v;
  if (v is Map) return asText(v['image_url']);
  return null;
}
