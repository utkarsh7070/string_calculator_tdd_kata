// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator_tdd_kata/main.dart';
import 'package:string_calculator_tdd_kata/string_calculator.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });


  late StringCalculator calculator;

  setUp(() {
    calculator = StringCalculator();
  });

  group('String Calculator TDD Tests', () {

    // Step 1: Empty string test
    test('should return 0 for empty string', () {
      expect(calculator.add(''), equals(0));
    });

    // Step 2: Single number tests
    test('should return the number itself for single number', () {
      expect(calculator.add('1'), equals(1));
      expect(calculator.add('5'), equals(5));
    });

    // Step 3: Two numbers test
    test('should return sum for two comma-separated numbers', () {
      expect(calculator.add('1,5'), equals(6));
      expect(calculator.add('2,3'), equals(5));
    });

    // Step 4: Multiple numbers test
    test('should handle any amount of numbers', () {
      expect(calculator.add('1,2,3,4,5'), equals(15));
      expect(calculator.add('10,20,30'), equals(60));
      expect(calculator.add('1,2,3,4,5,6,7,8,9,10'), equals(55));
    });

    // Step 5: Newlines between numbers
    test('should handle newlines between numbers', () {
      expect(calculator.add('1\n2,3'), equals(6));
      expect(calculator.add('1,2\n3'), equals(6));
      expect(calculator.add('1\n2\n3'), equals(6));
    });

    // Step 6: Custom delimiters
    test('should support custom delimiters', () {
      expect(calculator.add('//;\n1;2'), equals(3));
      expect(calculator.add('//|\n1|2|3'), equals(6));
      expect(calculator.add('//*\n1*2*3*4'), equals(10));
    });

    test('should support custom delimiters with brackets', () {
      expect(calculator.add('//[;]\n1;2'), equals(3));
      expect(calculator.add('//[***]\n1***2***3'), equals(6));
    });

    // Step 7: Negative numbers exception
    test('should throw exception for negative numbers', () {
      expect(() => calculator.add('-1,2'),
          throwsA(isA<ArgumentError>().having(
                  (e) => e.message,
              'message',
              contains('negative numbers not allowed -1')
          )));
    });

    test('should show all negative numbers in exception', () {
      expect(() => calculator.add('-1,2,-3'),
          throwsA(isA<ArgumentError>().having(
                  (e) => e.message,
              'message',
              contains('negative numbers not allowed -1, -3')
          )));
    });

    test('should handle negative numbers with custom delimiters', () {
      expect(() => calculator.add('//;\n1;-2;3'),
          throwsA(isA<ArgumentError>().having(
                  (e) => e.message,
              'message',
              contains('negative numbers not allowed -2')
          )));
    });

    // Bonus: Numbers bigger than 1000 should be ignored
    test('should ignore numbers bigger than 1000', () {
      expect(calculator.add('2,1001'), equals(2));
      expect(calculator.add('1000,1001,2'), equals(1002));
    });

    // Edge cases
    test('should handle whitespace gracefully', () {
      expect(calculator.add(' 1 , 2 '), equals(3));
      expect(calculator.add('1,  ,2'), equals(3));
    });

    test('should handle empty segments', () {
      expect(calculator.add('1,,2'), equals(3));
      expect(calculator.add(',1,2,'), equals(3));
    });
  });
}
