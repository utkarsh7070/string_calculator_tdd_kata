class StringCalculator {
  int add(String numbers) {
    if (numbers.isEmpty) {
      return 0;
    }

    String delimiter = ',';
    String numbersToProcess = numbers;

    // Check for custom delimiter
    if (numbers.startsWith('//')) {
      final lines = numbers.split('\n');
      final delimiterLine = lines[0].substring(2); // Remove '//'

      if (delimiterLine.startsWith('[') && delimiterLine.endsWith(']')) {
        delimiter = delimiterLine.substring(1, delimiterLine.length - 1);
      } else {
        delimiter = delimiterLine;
      }

      numbersToProcess = lines.skip(1).join('\n');
    }

    // Replace newlines with delimiter for consistent processing
    numbersToProcess = numbersToProcess.replaceAll('\n', delimiter);

    // Split by delimiter and parse numbers
    final numberStrings = numbersToProcess.split(delimiter);
    final numbersList = <int>[];
    final negativeNumbers = <int>[];

    for (final numStr in numberStrings) {
      if (numStr.trim().isNotEmpty) {
        final num = int.tryParse(numStr.trim()) ?? 0;
        if (num < 0) {
          negativeNumbers.add(num);
        }
        numbersList.add(num);
      }
    }

    // Check for negative numbers
    if (negativeNumbers.isNotEmpty) {
      final negativeStr = negativeNumbers.join(', ');
      throw ArgumentError('negative numbers not allowed $negativeStr');
    }

    // Filter out numbers greater than 1000 (bonus requirement)
    final validNumbers = numbersList.where((num) => num <= 1000);

    return validNumbers.fold(0, (sum, num) => sum + num);
  }
}