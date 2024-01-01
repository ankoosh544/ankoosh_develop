import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/configs/index.dart';
import 'package:sofia_app/custom/light_warning_message.dart';
import 'package:sofia_app/custom/out_of_service_message.dart';
import 'package:sofia_app/notifications/notificaiton_service.dart';
import 'package:sofia_app/providers/index.dart';
import 'package:sofia_app/screens/car_status/car_status_screen.dart';

import 'device_screen.dart';

class DeviceConnected extends StatelessWidget {
  const DeviceConnected({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(tabHome),
        notificationPredicate: (notification) => notification.depth == 1,
        scrolledUnderElevation: 4.0,
        shadowColor: Theme.of(context).shadowColor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(size_16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ElevatedButton(
              //     onPressed: () {
              //       NotificationService service = NotificationService();
              //       service.initNotification();
              //       service.sendNotification(
              //         notificationId: 0,
              //         title: 'Sample Notification',
              //         body: 'Notification details',
              //       );
              //     },
              //     child: const Text('Notify')),
              Text(
                '$welcomeMessage ${context.watch<ProfileProvider>().username}'
                    .trim(),
                style: TextStyle(color: Colors.blueGrey, fontSize: 28),
              ),
              const SizedBox(
                height: size_16,
              ),
              const Text(
                greetingMessage,
                style: TextStyle(color: Colors.blueGrey, fontSize: 20),
              ),
              const SizedBox(
                height: size_16,
              ),
              const Text(
                sourceFrom,
                style: TextStyle(
                  fontSize: 20, // Example font size
                  fontWeight: FontWeight.bold, // Example font weight
                  color: Colors.blueGrey, // Example text color
                ),
              ),
              const SizedBox(
                height: size_16,
              ),
              StreamBuilder<List<BluetoothDevice>>(
                stream: context.read<BleProvider>().connectedDeviceStream,
                initialData: const [],
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final device = snapshot.data!.first;

                    return StreamBuilder<BluetoothConnectionState>(
                      stream: device.connectionState,
                      initialData: BluetoothConnectionState.disconnected,
                      builder: (c, connectionSnapshot) {
                        if (connectionSnapshot.data ==
                            BluetoothConnectionState.connected) {
                          return Container(
                            width: MediaQuery.of(context).size.height * .09,
                            height: MediaQuery.of(context).size.height * .09,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.green),
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Animate(
                                  effects: const [FadeEffect(), ScaleEffect()],
                                  child: Text(
                                    context
                                        .read<BleProvider>()
                                        .getFloorNumber(device.localName)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 38,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          context.read<BleProvider>().clearConnectedDevice();
                          return const ConnectionInProgress();
                        }
                      },
                    );
                  } else {
                    return const ConnectionInProgress();
                  }
                },
              ),
              const SizedBox(
                height: size_16,
              ),
              const Text(
                sourceTo,
                style: TextStyle(
                  fontSize: 20, // Example font size
                  fontWeight: FontWeight.bold, // Example font weight
                  color: Colors.blueGrey, // Example text color
                ),
              ),
              const SizedBox(
                height: size_16,
              ),
              StreamBuilder<List<BluetoothDevice>>(
                stream: context.read<BleProvider>().connectedDeviceStream,
                initialData: const [],
                builder: (context, snapshot) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 100),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: hintDestination,
                        hintStyle:
                            TextStyle(fontSize: 20, color: Colors.blueGrey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      style:
                          const TextStyle(fontSize: 30, color: Colors.blueGrey),
                      onFieldSubmitted: (value) async {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final device = snapshot.data!.first;

                          // Background writeCharacteristic operations
                          Future.microtask(() async {
                            String nearestDeviceFloor = context
                                .read<BleProvider>()
                                .getFloorNumber(device.localName)
                                .toString();
                            await context
                                .read<BleProvider>()
                                .writeCharacteristic(nearestDeviceFloor);
                            await context
                                .read<BleProvider>()
                                .writeCharacteristic(value);
                          });

                          // Navigate to CarStatusScreen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CarStatusScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: size_20,
              ),
              if (!context.watch<BleProvider>().presenceOfLight)
                LightWarningMessage(message: warningAttentionforLight),
              const SizedBox(
                height: size_20,
              ),
              if (context.watch<BleProvider>().outOfService)
                OutOfServiceMessage(message: warningAttentionForOutOfService),
              if (isTestingMode)
                StreamBuilder<List<BluetoothDevice>>(
                  stream: context.read<BleProvider>().connectedDeviceStream,
                  initialData: const [],
                  builder: (c, snapshot) {
                    return Column(
                      children: snapshot.data!.map((device) {
                        //log('Psk : ${device.toString()}');
                        int floorNumber = context
                            .read<BleProvider>()
                            .getFloorNumber(device.localName);
                        return ListTile(
                          title: Text(floorNumber.toString()),
                          subtitle: Text(device.remoteId.toString()),
                          trailing: StreamBuilder<BluetoothConnectionState>(
                            stream: device.connectionState,
                            initialData: BluetoothConnectionState.disconnected,
                            builder: (c, snapshot) {
                              if (snapshot.data ==
                                  BluetoothConnectionState.connected) {
                                return ElevatedButton(
                                  child: const Text('OPEN'),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeviceScreen(device: device),
                                    ),
                                  ),
                                );
                              }
                              return Text(snapshot.data.toString());
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectionInProgress extends StatelessWidget {
  const ConnectionInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(), ScaleEffect()],
      child: const Text(
        waitingForConnection,
        style: TextStyle(
          fontSize: 18, // Example font size

          color: Colors.blueGrey, // Example text color
        ),
      ),
    );
  }
}
