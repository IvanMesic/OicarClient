import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class FillBlankRobot {
  final WidgetTester tester;

  FillBlankRobot(this.tester);

  Future<void> enterSentence(String sentence) async {
    final sentenceField = find.byKey(const Key('sentence_field'));
    print(tester.any(sentenceField)); // Add this line
    await tester.enterText(sentenceField, sentence);
    await tester.pump();
  }

  Future<void> tapSubmitButton() async {
    final submitButton = find.byKey(const Key('submit_button'));
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
  }

  Future<void> verifyCorrectAnswer() async {
    expect(find.byKey(const Key('correct_answer_snackbar')), findsOneWidget);
  }

  Future<void> verifyIncorrectAnswer() async {
    expect(find.byKey(const Key('incorrect_answer_snackbar')), findsOneWidget);
  }

  Future<void> verifyError() async {
    expect(find.byKey(const Key('error_snackbar')), findsOneWidget);
  }
}
