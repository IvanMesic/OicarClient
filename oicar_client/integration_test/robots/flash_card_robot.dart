import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class FlashCardRobot {
  final WidgetTester tester;

  FlashCardRobot(this.tester);

  Future<void> enterResponse(String response) async {
    final responseField = find.byKey(const Key('response_field'));
    await tester.enterText(responseField, response);
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
