import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/wifi_network.dart';

class WiFiProvider extends ChangeNotifier {
  final NetworkInfo _networkInfo = NetworkInfo();
  late SharedPreferences _prefs;

  List<WiFiNetwork> _networks = [];
  bool _isScanning = false;
  String? _currentSSID;
  String? _currentBSSID;
  String? _currentIPAddress;
  String? _errorMessage;

  List<WiFiNetwork> get networks => _networks;
  bool get isScanning => _isScanning;
  String? get currentSSID => _currentSSID;
  String? get currentBSSID => _currentBSSID;
  String? get currentIPAddress => _currentIPAddress;
  String? get errorMessage => _errorMessage;
  List<WiFiNetwork> get favoriteNetworks => _networks.where((n) => n.isFavorite).toList();

  WiFiProvider() {
    _initializePrefs();
    _loadCurrentWiFi();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFavorites();
  }

  /// Load current WiFi connection details
  Future<void> _loadCurrentWiFi() async {
    try {
      _currentSSID = await _networkInfo.getWifiName();
      _currentBSSID = await _networkInfo.getWifiBSSID();
      _currentIPAddress = await _networkInfo.getWifiIP();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load current WiFi: $e';
      notifyListeners();
    }
  }

  /// Scan for available WiFi networks
  Future<void> scanNetworks() async {
    try {
      _isScanning = true;
      _errorMessage = null;
      notifyListeners();

      // In a real app, you would use:
      // final networks = await _networkInfo.getWifiResults() ?? [];
      // For now, we'll use mock data for demonstration
      
      await Future.delayed(const Duration(seconds: 2));
      _networks = _generateMockNetworks();

      // Update favorite status
      await _loadFavorites();

      _isScanning = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isScanning = false;
      _errorMessage = 'Failed to scan networks: $e';
      notifyListeners();
    }
  }

  /// Toggle favorite status for a network
  Future<void> toggleFavorite(WiFiNetwork network) async {
    network.isFavorite = !network.isFavorite;
    await _saveFavorites();
    notifyListeners();
  }

  /// Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final favorites = favoriteNetworks
          .map((n) => jsonEncode(n.toJson()))
          .toList();
      await _prefs.setStringList('favorite_networks', favorites);
    } catch (e) {
      _errorMessage = 'Failed to save favorites: $e';
      notifyListeners();
    }
  }

  /// Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final favorites = _prefs.getStringList('favorite_networks') ?? [];
      final favoriteSSIDs = favorites
          .map((f) => jsonDecode(f) as Map<String, dynamic>)
          .map((json) => json['ssid'] as String)
          .toSet();

      for (var network in _networks) {
        network.isFavorite = favoriteSSIDs.contains(network.ssid);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load favorites: $e';
      notifyListeners();
    }
  }

  /// Sort networks by signal strength
  void sortBySignalStrength() {
    _networks.sort((a, b) => b.getSignalStrength().compareTo(a.getSignalStrength()));
    notifyListeners();
  }

  /// Sort networks by name
  void sortByName() {
    _networks.sort((a, b) => a.ssid.compareTo(b.ssid));
    notifyListeners();
  }

  /// Filter networks by security type
  List<WiFiNetwork> filterBySecurityType(String securityType) {
    if (securityType == 'All') return _networks;
    return _networks.where((n) => n.getSecurityType() == securityType).toList();
  }

  /// Generate mock WiFi networks for testing
  List<WiFiNetwork> _generateMockNetworks() {
    return [
      WiFiNetwork(
        ssid: 'HomeNetwork',
        bssid: '00:1A:2B:3C:4D:5E',
        level: -50,
        frequency: 2437,
        capabilities: '[WPA2-PSK-CCMP][ESS][WPS]',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        isConnected: true,
      ),
      WiFiNetwork(
        ssid: 'GuestWiFi',
        bssid: '00:1A:2B:3C:4D:5F',
        level: -65,
        frequency: 5180,
        capabilities: '[WPA3-PSK-CCMP][ESS]',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      WiFiNetwork(
        ssid: 'OpenNetwork',
        bssid: '00:1A:2B:3C:4D:60',
        level: -75,
        frequency: 2452,
        capabilities: '[ESS]',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      WiFiNetwork(
        ssid: 'NeighborWiFi',
        bssid: '00:1A:2B:3C:4D:61',
        level: -85,
        frequency: 5220,
        capabilities: '[WPA2-PSK-CCMP][ESS]',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      WiFiNetwork(
        ssid: 'CafeNetwork',
        bssid: '00:1A:2B:3C:4D:62',
        level: -70,
        frequency: 2462,
        capabilities: '[WPA-PSK-CCMP][ESS]',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    ];
  }
}
