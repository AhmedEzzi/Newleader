class TimestampService {
  static const int cacheDurationInDays = 2;

  bool isCacheValid(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inDays < cacheDurationInDays;
  }

  DateTime getCurrentTimestamp() {
    return DateTime.now();
  }
}