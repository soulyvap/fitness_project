export "int_extension.dart";

extension IntExtension on int {
  String secondsToTimeString() {
    final int seconds = this;
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }

  String toOrdinal() {
    final int number = this;
    if (number == 11 || number == 12 || number == 13) {
      return '${number}th';
    }

    if (number < 6) {
      switch (number) {
        case 1:
          return 'first';
        case 2:
          return 'second';
        case 3:
          return 'third';
        default:
          return 'fourth';
      }
    }

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
}
