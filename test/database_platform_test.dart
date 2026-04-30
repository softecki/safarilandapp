import 'package:flutter_test/flutter_test.dart';
import 'package:wicom/src/data/database_factory.dart';
import 'package:wicom/src/data/database_helper.dart';

void main() {
  group('Database Platform Tests', () {
    test('DatabaseFactory should create instance', () {
      final db = DatabaseFactory.instance;
      expect(db, isNotNull);
    });

    test('DatabaseHelper should be singleton', () {
      final db1 = DatabaseHelper.instance;
      final db2 = DatabaseHelper.instance;
      expect(db1, equals(db2));
    });

    test('Platform detection should work', () {
      final helper = DatabaseHelper.instance;
      // On test environment, it should detect as non-web
      expect(helper.isWeb || helper.isMobile, isTrue);
    });
  });
}
