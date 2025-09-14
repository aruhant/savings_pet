import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:goals/secrets.dart';
import 'package:goals/shopping_items.dart';

class MartianService {
  static Future<Map<String, dynamic>> processSMS(String sms) async {
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "Extract the amount, merchant, and category from the following SMS message:\n\n$sms\n\nRespond in JSON format with keys: amount, merchant, category. Category should be one of: Food, Transport, Shopping, Other. Do not include any other text.",
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );
    OpenAI.apiKey = MartianSecrets['apiKey']!;
    OpenAI.baseUrl = 'https://api.withmartian.com';
    // Start using!
    final completion = await OpenAI.instance.chat.create(
      model: "meta-llama/llama-3.1-8b-instruct:cheap",
      messages: [userMessage],
    );
    print(completion);
    String text = completion.choices.first.message.content?.first.text ?? '';

    // Use regex to clean up the string and extract JSON
    final jsonRegex = RegExp(r'\{.*\}', dotAll: true);
    final match = jsonRegex.firstMatch(text);
    if (match != null) {
      String jsonString = match.group(0)!;
      // Clean up any extra whitespace or newlines
      jsonString = jsonString.replaceAll(RegExp(r'\s+'), ' ').trim();
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('No JSON found in response');
    }
  }

  static Future<List<ShoppingItem>> getItems(String goal) async {
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "a user has a goal of '$goal' with a budget of about 10000\$. Generate a detailed itemized list of expenses that the user will incurr. Break it down into as many items as possible. For example, for a 'Europe Trip' include Museum tickets, bus tickets, breakfast, coffee etc. The output should be in the following JSON format. " +
              "Here are the keys and their descriptions: " +
              "title: A brief, descriptive name for the expense.\n"
                  "subtitle: A more detailed description or context for the expense.\n" +
              "priority: An integer between 1 and 3, representing the importance of the expense. 1 being heightest priority.\n" +
              "place: The location where the expense will be occurred.\n" +
              "date: The specific date on which the expense will be incurred. \n" +
              "price: The cost of the expense in \$. Example:" +
              '''
{
  "expenses": [
    {
      "title": "Breakfast",
      "subtitle": "Last breakfast in Amsterdam before departure.",
      "place": "Amsterdam",
      "date": "Jul 14, 2029",
      "price": 8.00,
      "priority": 3
    },
    {
      "title": "Museum Entry",
      "subtitle": "Entry ticket to the Rijksmuseum.",
      "place": "Amsterdam",
      "date": "Jul 14, 2029",
      "price": 20.00,
      "priority": 2
    }
  ]
}
 

''',
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );
    OpenAI.apiKey = MartianSecrets['apiKey']!;
    OpenAI.baseUrl = 'https://api.withmartian.com';
    // Start using!
    final completion = await OpenAI.instance.chat.create(
      model: "google/gemini-2.5-flash:cheapest",
      messages: [userMessage],
    );
    print(completion);
    String text = completion.choices.first.message.content?.first.text ?? '';

    // Use regex to clean up the string and extract JSON
    final jsonRegex = RegExp(r'\{.*\}', dotAll: true);
    final match = jsonRegex.firstMatch(text);
    if (match != null) {
      String jsonString = match.group(0)!;
      // Clean up any extra whitespace or newlines
      jsonString = jsonString.replaceAll(RegExp(r'\s+'), ' ').trim();
      try {
        Map<String, dynamic> json = jsonDecode(jsonString);
        List<dynamic> expenses = json['expenses'] ?? [];
        List<ShoppingItem> items = expenses
            .map(
              (e) => ShoppingItem(
                title: e['title'] ?? '',
                subtitle: e['subtitle'] ?? '',
                place: e['place'] ?? '',
                date: e['date'] ?? '',
                portfolio: 'balanced',
                price: (e['price'] is num) ? e['price'].toDouble() : 0.0,
                imageUrl: '', // Default image URL since not provided in JSON
              ),
            )
            .toList();
        return items;
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('No JSON found in response');
    }
  }
}
