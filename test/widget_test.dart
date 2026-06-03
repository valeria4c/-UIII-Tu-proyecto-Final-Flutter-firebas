import 'package:flutter_test/flutter_test.dart';
import 'package:studiomochi22px/main.dart';

void main() {
  testWidgets('Studio Mochi 22px App initial loading test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudioMochiApp());

    // Verify that our start screen loads and displays the studio title.
    expect(find.text('STUDIO MOCHI'), findsOneWidget);
    expect(find.text('22PX'), findsOneWidget);
    expect(find.text('INGRESAR'), findsOneWidget);
  });
}
