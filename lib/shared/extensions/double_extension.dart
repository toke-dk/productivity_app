extension DoubleExtension on double {
  String get myDoubleToString => this.toStringAsFixed(this % 1 == 0 ? 0 : 1);
}
