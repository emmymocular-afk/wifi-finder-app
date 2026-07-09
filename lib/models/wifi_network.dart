class WiFiNetwork {
  final String ssid;
  final String bssid;
  final int level;
  final int frequency;
  final String? capabilities;
  final int timestamp;
  bool isFavorite;
  bool? isConnected;

  WiFiNetwork({
    required this.ssid,
    required this.bssid,
    required this.level,
    required this.frequency,
    this.capabilities,
    required this.timestamp,
    this.isFavorite = false,
    this.isConnected,
  });

  /// Calculate signal strength as percentage (0-100)
  int getSignalStrength() {
    return ((level + 100) / 2).toInt().clamp(0, 100);
  }

  /// Get signal strength category
  String getSignalCategory() {
    final strength = getSignalStrength();
    if (strength >= 80) return 'Excellent';
    if (strength >= 60) return 'Good';
    if (strength >= 40) return 'Fair';
    if (strength >= 20) return 'Weak';
    return 'Very Weak';
  }

  /// Parse security type from capabilities
  String getSecurityType() {
    if (capabilities == null || capabilities!.isEmpty) {
      return 'Open';
    }
    final cap = capabilities!.toUpperCase();
    if (cap.contains('WPA3')) return 'WPA3';
    if (cap.contains('WPA2')) return 'WPA2';
    if (cap.contains('WPA')) return 'WPA';
    if (cap.contains('WEP')) return 'WEP';
    return 'Other';
  }

  /// Get frequency band
  String getFrequencyBand() {
    if (frequency >= 2400 && frequency <= 2500) {
      return '2.4 GHz';
    } else if (frequency >= 5000 && frequency <= 6000) {
      return '5 GHz';
    } else if (frequency >= 6000 && frequency <= 7000) {
      return '6 GHz';
    }
    return 'Unknown';
  }

  Map<String, dynamic> toJson() => {
    'ssid': ssid,
    'bssid': bssid,
    'level': level,
    'frequency': frequency,
    'capabilities': capabilities,
    'timestamp': timestamp,
    'isFavorite': isFavorite,
  };

  factory WiFiNetwork.fromJson(Map<String, dynamic> json) => WiFiNetwork(
    ssid: json['ssid'] as String,
    bssid: json['bssid'] as String,
    level: json['level'] as int,
    frequency: json['frequency'] as int,
    capabilities: json['capabilities'] as String?,
    timestamp: json['timestamp'] as int,
    isFavorite: json['isFavorite'] as bool? ?? false,
  );
}
