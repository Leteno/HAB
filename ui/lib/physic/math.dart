class Math {
  static bool between(int a, int b, int test) {
    return test >= a && test <= b;
  }

  static bool isSameInMath(double a, double b) {
    double error = 0.000001;
    double gap = a - b;
    if (gap < 0) gap = -gap;
    return gap < error;
  }
}
