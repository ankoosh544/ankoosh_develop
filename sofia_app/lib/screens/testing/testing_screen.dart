import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/configs/index.dart';
import 'package:sofia_app/providers/ble_provider.dart';

import '../home/device_connected.dart';
import '../home/find_device_screen.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    final bleProvider = Provider.of<BleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(tabTesting),
        actions: [
          ElevatedButton(
            onPressed: () {
              bleProvider.startScanning();
            },
            child: const Text('Scan Devices'),
          ),
          ElevatedButton(
            onPressed: () async {
              await bleProvider.ble.nearestScan;
            },
            child: const Text('Nearest Device'),
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isScanning = true;
                  context.read<BleProvider>().startScanning();
                });
              },
              child: Text('On')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isScanning = false;
                  context.read<BleProvider>().stopScan();
                });
              },
              child: Text('Off')),
          isScanning
              ? StreamBuilder<List<ScanResult>>(
                  stream: context.read<BleProvider>().ble.scanResults,
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final devices = snapshot.data ?? [];

                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(devices[index]
                              .device
                              .localName
                              .codeUnits
                              .toString()),
                          subtitle: Text(devices[index].rssi.toString()),
                        ),
                        itemCount: devices.length,
                      );
                    } else {
                      return const ConnectionInProgress();
                    }
                  },
                )
              : Text('Scanning....'),
          // const SizedBox(
          //   height: size_16,
          // ),
          // const FindDevicesScreen(),
          FutureBuilder(
            future: context.read<BleProvider>().ble.nearestScan,
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                print('Nearest Device: ${snapshot.data!.device.localName}');
                return ListTile(
                  title: Text(snapshot.data!.device.localName),
                );
              } else {
                return const Text('Loading Nearest device');
              }
            },
          )
        ],
      ),
    );
  }
}
