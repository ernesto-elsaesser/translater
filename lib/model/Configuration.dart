class Configuration {
  String from;
  String to;

  static Configuration fromDEtoEN = Configuration._private("de", "en");
  static Configuration fromENtoDE = Configuration._private("en", "de");

  Configuration._private(this.from, this.to);

  @override
  String toString() {
    return '${from.toUpperCase()} > ${to.toUpperCase()}';
  }
}
