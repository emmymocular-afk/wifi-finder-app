# WiFi Finder App

A Flutter mobile application for discovering, analyzing, and managing WiFi networks on iOS and Android.

## Features

✨ **Network Scanning**
- Scan for available WiFi networks in your area
- Real-time network detection
- Automatic sorting and filtering

📊 **Signal Strength Analysis**
- Display signal strength as percentage (0-100%)
- Signal categories: Excellent, Good, Fair, Weak, Very Weak
- Signal level in dBm
- Visual signal indicators

🔐 **Network Details**
- SSID and BSSID information
- Security type detection (WPA3, WPA2, WPA, WEP, Open)
- Frequency information (2.4 GHz, 5 GHz, 6 GHz)
- Network capabilities and specifications

💾 **Favorite Networks**
- Save favorite networks locally
- Quick access to your preferred WiFi networks
- Persistent storage using SharedPreferences

📱 **Current Connection**
- View currently connected WiFi network
- Display connection IP address
- Show BSSID of current connection

## Technology Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **WiFi Functionality**: network_info_plus, connectivity_plus
- **UI**: Material Design 3

## Dependencies

```yaml
network_info_plus: ^4.0.0  # WiFi information
connectivity_plus: ^5.0.0  # Connectivity monitoring
shared_preferences: ^2.2.0 # Local storage
provider: ^6.0.0          # State management
```

## Installation

### Prerequisites
- Flutter SDK 3.0 or higher
- Android SDK (for Android development)
- Xcode 12+ (for iOS development)

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/emmymocular-afk/wifi-finder-app.git
cd wifi-finder-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**

**On Android:**
```bash
flutter run
```

**On iOS:**
```bash
flutter run -d ios
```

## Permissions

### Android
The app requires the following permissions:
- `ACCESS_FINE_LOCATION` - Required for WiFi scanning
- `ACCESS_COARSE_LOCATION` - Required for WiFi scanning
- `ACCESS_NETWORK_STATE` - To check current network state
- `CHANGE_NETWORK_STATE` - To manage network connections
- `ACCESS_WIFI_STATE` - To access WiFi state
- `CHANGE_WIFI_STATE` - To change WiFi state

### iOS
The app requires the following privacy keys:
- `NSLocalNetworkUsageDescription` - For local network access
- `NSBonjourServices` - For Bonjour service discovery

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── wifi_network.dart       # WiFiNetwork model
├── providers/
│   └── wifi_provider.dart      # WiFi state management
├── screens/
│   └── home_screen.dart        # Main UI
└── widgets/
    ├── wifi_network_card.dart  # Network display card
    └── current_connection_info.dart # Current WiFi info
```

## Usage

1. **Scan Networks**: Tap the floating action button to scan for available WiFi networks
2. **View Details**: Tap on any network card to expand and see full details
3. **Save Favorites**: Tap the heart icon to save a network as favorite
4. **Switch Tabs**: Use the tabs to view all networks or just your favorites
5. **Current Connection**: View your current WiFi connection info at the top

## Features in Detail

### WiFiNetwork Model
Core model containing all WiFi network information with utility methods:
- `getSignalStrength()` - Convert dBm to percentage
- `getSignalCategory()` - Categorize signal strength
- `getSecurityType()` - Parse security from capabilities
- `getFrequencyBand()` - Identify frequency band

### WiFiProvider
State management using Provider pattern:
- Network scanning and caching
- Favorite management with persistence
- Current connection tracking
- Error handling and user feedback

## Future Enhancements

- [ ] Real WiFi network connection capability
- [ ] WiFi password saving and auto-connect
- [ ] Network history and statistics
- [ ] Channel analysis and interference detection
- [ ] Speed test integration
- [ ] Network sharing QR codes
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Network notifications

## License

MIT License - Feel free to use this project for personal and commercial purposes.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.

## Authors

- **Emmy Mocular** - Initial work

---

**Note**: This app uses mock data for WiFi scanning. For production use, you'll need to integrate with native WiFi APIs or use actual network scanning libraries.
