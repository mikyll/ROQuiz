class FinalGradeCalculator {
  static double calculate({required double written, required double quiz}) {
    return ((written * 2) + quiz) / 3;
  }
}

