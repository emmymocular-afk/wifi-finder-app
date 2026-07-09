import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wifi_provider.dart';

class CurrentConnectionInfo extends StatelessWidget {
  const CurrentConnectionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WiFiProvider>(
      builder: (context, wifiProvider, _) {
        final hasConnection = wifiProvider.currentSSID != null &&
            wifiProvider.currentSSID!.isNotEmpty;

        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: hasConnection ? Colors.blue[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasConnection ? Colors.blue[200]! : Colors.grey[300]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    hasConnection ? Icons.wifi : Icons.wifi_off,
                    color: hasConnection ? Colors.blue : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current Connection',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (hasConnection) ...
                [
                  _buildConnectionDetail('Network:', wifiProvider.currentSSID ?? 'N/A'),
                  _buildConnectionDetail('BSSID:', wifiProvider.currentBSSID ?? 'N/A'),
                  _buildConnectionDetail('IP Address:', wifiProvider.currentIPAddress ?? 'N/A'),
                ]
              else
                Text(
                  'No WiFi Connection',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectionDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
