int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r"\s+")).length;
  final readindTime = wordCount / 100;
  return readindTime.ceil();
}
