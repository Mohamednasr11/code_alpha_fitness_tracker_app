import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Display AppBar Title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AppBarWidget()));
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Profile'),
    );
  }
}
