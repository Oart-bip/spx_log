const _meses = [
  'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
  'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
];

String _dois(int n) => n.toString().padLeft(2, '0');

String formatDate(DateTime d) {
  final u = d.toUtc();
  return '${_dois(u.day)} ${_meses[u.month - 1]} ${u.year}';
}

String formatTime(DateTime d) {
  final u = d.toUtc();
  return '${_dois(u.hour)}:${_dois(u.minute)} UTC';
}

String formatDayMonth(DateTime d) {
  final u = d.toUtc();
  return '${_dois(u.day)} ${_meses[u.month - 1]}';
}

// 17000 -> 17.000
String formatInt(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

// 70.0 -> 70 | 3.66 -> 3,7
String formatDecimal(double v) {
  final texto = v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
  return texto.replaceAll('.', ',');
}

String formatUsd(int v) {
  if (v >= 1000000000) return 'US\$ ${formatDecimal(v / 1e9)} bi';
  if (v >= 1000000) return 'US\$ ${formatDecimal(v / 1e6)} mi';
  return 'US\$ ${formatInt(v)}';
}
