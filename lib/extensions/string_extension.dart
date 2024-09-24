extension StringExtension on String {
  String capitalize() {
    List word = this.split(' ');
    if (word.length < 2) {
      return word.isEmpty ? '' : word.first.toString().capitalize();
    }

    return '${word[0].toString()[0].toUpperCase()}${word[0].toString().substring(1).toLowerCase()} ${word[1].toString()[0].toUpperCase()}${word[1].toString().substring(1).toLowerCase()}';
  }
}
