import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/providers/ble_provider.dart';

import '../../configs/index.dart';
import '../../widgets/index.dart';
import 'bluetooth_off_screen.dart';
import 'device_screen.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BluetoothAdapterState>(
        stream: context.read<BleProvider>().bluetoothStateStream,
        initialData: context.read<BleProvider>().bluetoothState,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothAdapterState.on) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      scannedDevices,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.lightBlue,
                    ),
                    StreamBuilder<List<BluetoothDevice>>(
                        stream:
                            FlutterBluePlus.connectedSystemDevices.asStream(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                snapshot.hasData ? snapshot.data!.length : 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: StreamBuilder<int>(
                                  stream: context
                                      .read<BleProvider>()
                                      .rssiStream(snapshot.data![index]),
                                  builder: (context, snapshot) {
                                    return Text(
                                        snapshot.hasData
                                            ? '${snapshot.data}dBm'
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall);
                                  },
                                ),
                                title: Text(
                                  '${snapshot.data![index].remoteId.str}: ${snapshot.data![index].localName}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            },
                          );
                        }),
                    // StreamBuilder<List<ScanResult>>(
                    //   stream: context.read<BleProvider>().scanResult,
                    //   initialData: const [],
                    //   builder: (c, snapshot) {
                    //     return snapshot.hasData && snapshot.data!.isNotEmpty
                    //         ? Column(
                    //             children: snapshot.data!.map(
                    //               (result) {
                    //                 log('Sofia : ${result.toString()}');
                    //                 return ScanResultTile(
                    //                   result: result,
                    //                   onTap: () => Navigator.of(context).push(
                    //                     MaterialPageRoute(
                    //                       builder: (context) {
                    //                         result.device.connect();
                    //                         return DeviceScreen(
                    //                             device: result.device);
                    //                       },
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //             ).toList(),
                    //           )
                    //         : Column(
                    //             children: [
                    //               SizedBox(
                    //                 height: MediaQuery.of(context).size.height *
                    //                     .26,
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text(
                    //                   'Please start scanning the devices',
                    //                   style: Theme.of(context)
                    //                       .textTheme
                    //                       .headlineSmall,
                    //                 ),
                    //               ),
                    //             ],
                    //           );
                    //   },
                    // ),
                  ],
                ),
              ),
            );
          }
          return BluetoothOffScreen(state: state);
        },
      ),
    );
  }
}
