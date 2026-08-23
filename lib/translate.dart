import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

Future<String> translate(String text) async {
  try {
    final refererUrl = 'https://abadis.ir/translator/fa-ru/get';
    final url = Uri.parse('https://abadis.ir/ajaxcmd/inlinetranslate/');
    final res = await http.post(
      url,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': refererUrl,
        'Accept': '*/*',
        'Accept-Language': 'en-GB,en;q=0.9,fa;q=0.8',
        'Origin': 'https://abadis.ir',
      },
      body: {'ln': 'ru', 'exp': text},
    ).timeout(Duration(seconds: 10));
    final document = html_parser.parse(res.body);
    final div = document.querySelector('.boxMain');
    final translatedText = div!.text.trim();
    return translatedText;
  } catch (e) {
    return 'e';
  }
}
