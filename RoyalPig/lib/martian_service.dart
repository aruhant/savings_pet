import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:goals/secrets.dart';

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
}
