import 'package:flutter/material.dart';
import '../models/wifi_network.dart';

class WiFiNetworkCard extends StatefulWidget {
  final WiFiNetwork network;
  final VoidCallback onFavoriteTap;

  const WiFiNetworkCard({
    Key? key,
    required this.network,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  State<WiFiNetworkCard> createState() => _WiFiNetworkCardState();
}

class _WiFiNetworkCardState extends State<WiFiNetworkCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final network = widget.network;
    final signalStrength = network.getSignalStrength();
    final signalCategory = network.getSignalCategory();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          ListTile(
            leading: _buildSignalIcon(signalStrength),
            title: Text(
              network.ssid.isEmpty ? '(Hidden)' : network.ssid,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${signalCategory} • ${network.getFrequencyBand()}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      widget.network.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.network.isFavorite ? Colors.red : null,
                    ),
                    onPressed: widget.onFavoriteTap,
                  ),
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) _buildExpandedDetails(network),
        ],
      ),
    );
  }

  Widget _buildSignalIcon(int strength) {
    IconData icon;
    Color color;

    if (strength >= 80) {
      icon = Icons.signal_cellular_4_bar;
      color = Colors.green;
    } else if (strength >= 60) {
      icon = Icons.signal_cellular_3_bar;
      color = Colors.lightGreen;
    } else if (strength >= 40) {
      icon = Icons.signal_cellular_2_bar;
      color = Colors.orange;
    } else {
      icon = Icons.signal_cellular_1_bar;
      color = Colors.red;
    }

    return Icon(icon, color: color);
  }

  Widget _buildExpandedDetails(WiFiNetwork network) {
    return Container(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('SSID:', network.ssid.isEmpty ? '(Hidden)' : network.ssid),
            _buildDetailRow('BSSID:', network.bssid),
            _buildDetailRow('Security:', network.getSecurityType()),
            _buildDetailRow('Frequency:', '${network.frequency} MHz'),
            _buildDetailRow('Frequency Band:', network.getFrequencyBand()),
            _buildDetailRow('Signal Strength:', '${network.getSignalStrength()}%'),
            _buildDetailRow('Signal Level:', '${network.level} dBm'),
            _buildDetailRow('Signal Category:', network.getSignalCategory()),
            if (network.capabilities != null)
              _buildDetailRow('Capabilities:', network.capabilities ?? 'N/A'),
            if (network.isConnected ?? false)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Currently Connected',
                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
