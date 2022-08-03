class SimpleData {
  late double gridSize;

  SimpleData() {
    gridSize = 30;
  }

  static final SimpleData _instance = SimpleData();
  static SimpleData getInstance() {
    return _instance;
  }
}
