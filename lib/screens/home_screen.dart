import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wifi_provider.dart';
import '../widgets/wifi_network_card.dart';
import '../widgets/current_connection_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WiFiProvider>().scanNetworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WiFi Finder'),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Networks'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: Consumer<WiFiProvider>(
          builder: (context, wifiProvider, _) {
            return TabBarView(
              children: [
                // All Networks Tab
                _buildNetworksTab(context, wifiProvider, wifiProvider.networks),
                // Favorites Tab
                _buildNetworksTab(context, wifiProvider, wifiProvider.favoriteNetworks),
              ],
            );
          },
        ),
        floatingActionButton: Consumer<WiFiProvider>(
          builder: (context, wifiProvider, _) {
            return FloatingActionButton(
              onPressed: wifiProvider.isScanning
                  ? null
                  : () => context.read<WiFiProvider>().scanNetworks(),
              tooltip: 'Scan Networks',
              child: wifiProvider.isScanning
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.refresh),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNetworksTab(
    BuildContext context,
    WiFiProvider wifiProvider,
    List<dynamic> networks,
  ) {
    return Column(
      children: [
        const CurrentConnectionInfo(),
        Expanded(
          child: networks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        wifiProvider.isScanning
                            ? 'Scanning for networks...'
                            : 'No networks found',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: networks.length,
                  itemBuilder: (context, index) {
                    return WiFiNetworkCard(
                      network: networks[index],
                      onFavoriteTap: () {
                        context.read<WiFiProvider>().toggleFavorite(networks[index]);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
