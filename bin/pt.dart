import 'package:ptgb/ptgb.dart';
import 'package:pt/translate.dart';

void main() async {
  Bot bot = Bot();
  await for (Update update in bot.poll()) {
    final query = update.inlineQuery;
    if (query == null) continue;
    final text = query.query.trim();
    final trans = await autoTrans(text);
    final results = <InlineQueryResult>[
      InlineQueryResultArticle(
        '1',
        trans,
        InputTextMessageContent(trans),
        description: '',
      )
    ];
    await bot.answerInlineQuery(query.id, results, cacheTime: 0);
  }
}
