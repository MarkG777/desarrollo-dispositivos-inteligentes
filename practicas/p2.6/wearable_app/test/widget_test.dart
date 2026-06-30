import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_app/main.dart';

void main() {
  testWidgets('WearableApp renders bpm display', (WidgetTester tester) async {
    await tester.pumpWidget(const WearableApp());
    expect(find.text('bpm'), findsOneWidget);
    expect(find.text('Iniciar'), findsOneWidget);
  });
}
