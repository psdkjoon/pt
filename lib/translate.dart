import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

final http.Client _client = http.Client();
final String _ucid = _generateUcid();
int _requestId = 0;

const _userAgent =
    'ru.yandex.translate/22.11.8.22364114 (samsung SM-A505GM; Android 12)';

String _generateUcid() {
  final rnd = Random.secure();
  final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

String _nextSid() {
  final sid = '$_ucid-$_requestId-0';
  _requestId++;
  return sid;
}

void main() async {
  print(await translate('Hello'));
  _client.close();
}

Future<String> autoTrans(String text) async {
  if (text.codeUnits.any((i) => i >= 1550 && i <= 1750)) {
    return translate(text, 'fa');
  }
  return translate(text);
}

Future<String> translate(
  String text, [
  String from = 'en',
  String to = 'ru',
]) async {
  try {
    final url = Uri.parse(
      'https://translate.yandex.net/api/v1/tr.json/translate',
    ).replace(queryParameters: {
      'sid': _nextSid(),
      'srv': 'android',
      'format': 'text',
    });

    final res = await _client.post(
      url,
      headers: {'User-Agent': _userAgent},
      body: {'text': text, 'lang': '$from-$to'},
    ).timeout(const Duration(seconds: 30));

    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    if (decoded['code'] != 200) {
      return 'Error code: ${decoded['code']}';
    }
    return (decoded['text'] as List).first as String;
  } catch (e) {
    return e.toString();
  }
}
