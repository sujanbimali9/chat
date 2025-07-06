class IdGenerator {
  static String getConversionId(String fromid, String toid) {
    return fromid.hashCode <= toid.hashCode
        ? '${fromid}_$toid'
        : '${toid}_$fromid';
  }
}
