class ArabicNumbersUtils {
  static const arabicNums = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  static const englishNums = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

  static String englishToArabic(String number) {
    try {
      for (var i = 0; i < 10; i++) {
        number = number.replaceAll(RegExp(englishNums[i]), arabicNums[i]);
      }
      return number;
    } on Exception {
      throw FormatException();
    }
  }

  static int arabicToEnglish(String number) {
    try {
      for (var i = 0; i < 10; i++) {
        number = number.replaceAll(RegExp(arabicNums[i]), englishNums[i]);
      }
      return int.parse(number);
    } on Exception {
      throw FormatException();
    }
  }
}
