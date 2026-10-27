import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profildigital/main.dart';

Future<void> _pumpProfileApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Splash berpindah ke Profil setelah dua detik', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Kartu Profil Digital'), findsOneWidget);
    expect(find.text('putri nur syafia'), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('putri nur syafia'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.text('putri nur syafia'))).canPop(),
      isFalse,
    );
  });

  testWidgets('tombol Kembali membuka kembali halaman Profil', (
    WidgetTester tester,
  ) async {
    await _pumpProfileApp(tester);

    final projectTile = find.widgetWithText(
      ListTile,
      'Aplikasi Absensi Kampus',
    );
    await tester.ensureVisible(projectTile);
    await tester.tap(projectTile);
    await tester.pumpAndSettle();

    expect(find.text('Aplikasi Absensi Kampus'), findsNWidgets(2));
    await tester.tap(find.widgetWithText(FilledButton, 'Kembali'));
    await tester.pumpAndSettle();

    expect(find.text('Kartu Profil Digital'), findsOneWidget);
    expect(find.text('Aplikasi Absensi Kampus'), findsOneWidget);
  });

  testWidgets('Edit Profil menerima dan mengembalikan data lewat route', (
    WidgetTester tester,
  ) async {
    await _pumpProfileApp(tester);

    await tester.tap(find.byTooltip('Edit Profil'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Nama Baru');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Nama Baru'), findsOneWidget);
  });

  testWidgets('route dengan argumen tidak valid menampilkan halaman 404', (
    WidgetTester tester,
  ) async {
    await _pumpProfileApp(tester);

    final profileContext = tester.element(find.text('putri nur syafia'));
    unawaited(Navigator.of(profileContext).pushNamed<void>('/halaman-ngawur'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman tidak ditemukan'), findsOneWidget);
    expect(find.text('Ke Beranda'), findsOneWidget);
  });

  testWidgets('Keluar membersihkan stack lalu membuka Splash dan Profil', (
    WidgetTester tester,
  ) async {
    await _pumpProfileApp(tester);

    await tester.tap(find.byTooltip('Keluar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byTooltip('Edit Profil'), findsNothing);
    expect(find.text('putri nur syafia'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('putri nur syafia'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.text('putri nur syafia'))).canPop(),
      isFalse,
    );
  });

  testWidgets('tombol back AppBar otomatis membuka kembali halaman Profil', (
    WidgetTester tester,
  ) async {
    await _pumpProfileApp(tester);

    final projectTile = find.widgetWithText(
      ListTile,
      'Aplikasi Absensi Kampus',
    );
    await tester.ensureVisible(projectTile);
    await tester.tap(projectTile);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Kartu Profil Digital'), findsOneWidget);
    expect(find.text('Aplikasi Absensi Kampus'), findsOneWidget);
  });
}
