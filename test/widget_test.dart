import 'package:flutter_test/flutter_test.dart';

import 'package:edit_doc_flutter/main.dart';

void main() {
  testWidgets('exibe a tela de login', (tester) async {
    await tester.pumpWidget(EditDocApp());
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Não tem uma conta? Cadastre-se'), findsOneWidget);
  });
}
