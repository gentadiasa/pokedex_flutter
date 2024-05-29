extension IntExtension on int {
  String toNumberFormat() {
    return '#${toString().padLeft(3, '0')}';
  }

  String toWeightString() {
    if (this >= 10) {
      double weightInKg = this / 10.0;
      return '${weightInKg.toStringAsFixed(1).replaceAll('.', ',')} kg';
    } else {
      double weightInKg = this / 10.0;
      return '${weightInKg.toStringAsFixed(1).replaceAll('.', ',')} kg';
    }
  }

  String toHeightString() {
    if (this >= 10) {
      double heightM = this / 10.0;
      return '${heightM.toStringAsFixed(1).replaceAll('.', ',')} m';
    } else {
      double heightM = this / 10.0;
      return '${heightM.toStringAsFixed(1).replaceAll('.', ',')} m';
    }
  }
}
