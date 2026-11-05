import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porichoy/main.dart';
import 'package:porichoy/core/constants/bd_constants.dart';

void main() {
  testWidgets('Porichoy app launches and displays title smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PorichoyApp(),
      ),
    );
    await tester.pump();

    // Verify app brand is present
    expect(find.text(BDConstants.appName), findsOneWidget);
  });
}
