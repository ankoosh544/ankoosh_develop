import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:rxdart/rxdart.dart';
import 'package:sofia_app/enums/direction.dart';
import 'package:sofia_app/enums/operation_mode.dart';
import 'package:sofia_app/enums/type_mission_status.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sofia_app/notifications/notificaiton_service.dart';
import '../configs/index.dart';
import 'package:sofia_app/screens/no_device_found_screen.dart';

abstract class Ble {
  Future<void> startScan({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Guid> withServices = const [],
    List<String> macAddresses = const [],
    Duration? timeout,
    bool allowDuplicates = false,
    bool androidUsesFineLocation = false,
  });
  Future<void> stopScan();

  bool get isScanningNow;
  Future<ScanResult> get nearestScan;
  Future<BluetoothDevice> get nearestDevice;
  Future<void> connect({
    Duration timeout = const Duration(seconds: 35),
    bool autoConnect = false,
  });
  Future<void> disconnect({int timeout = 35});

  Stream<List<ScanResult>> get scanResults;
  Stream<BluetoothAdapterState> get adapterState;
  Future<List<BluetoothDevice>> get connectedSystemDevices;
  Future<BluetoothConnectionState> get connectionState;
  Future<List<BluetoothService>> get servicesStream;

  Future<List<BluetoothService>> discoverServices();
}

class BleImpl extends Ble {
  @override
  Future<void> startScan({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Guid> withServices = const [],
    List<String> macAddresses = const [],
    Duration? timeout,
    bool allowDuplicates = false,
    bool androidUsesFineLocation = false,
  }) async =>
      FlutterBluePlus.startScan(
        withServices: withServices,
        timeout: timeout,
        androidUsesFineLocation: androidUsesFineLocation,
      );
  //FlutterBluePlus.startScan(oneByOne: true);

  @override
  Future<void> stopScan() async => FlutterBluePlus.stopScan();

  @override
  Stream<BluetoothAdapterState> get adapterState =>
      FlutterBluePlus.adapterState;

  @override
  Future<List<BluetoothDevice>> get connectedSystemDevices =>
      FlutterBluePlus.connectedSystemDevices;

  @override
  Future<BluetoothConnectionState> get connectionState async =>
      (await nearestDevice).connectionState.first;

  @override
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  @override
  bool get isScanningNow => FlutterBluePlus.isScanningNow;

  @override
  Future<BluetoothDevice> get nearestDevice async {
    return (await nearestScan).device;
  }

  @override
  Future<ScanResult> get nearestScan async => (await scanResults.first)
      .where(
          (e) => e.advertisementData.serviceUuids.contains(FLOOR_SERVICE_GUID))
      .reduce((current, next) => current.rssi > next.rssi ? current : next);

  @override
  Future<void> connect({
    Duration timeout = const Duration(seconds: 35),
    bool autoConnect = false,
  }) async =>
      (await nearestDevice).connect(timeout: timeout, autoConnect: autoConnect);

  @override
  Future<void> disconnect({int timeout = 35}) async =>
      (await nearestDevice).disconnect(timeout: timeout);

  @override
  Future<List<BluetoothService>> get servicesStream async =>
      (await nearestDevice).servicesStream.first;

  @override
  Future<List<BluetoothService>> discoverServices() async =>
      (await nearestDevice).discoverServices();
}

class BleProvider extends ChangeNotifier {
  final Ble ble;
  final _connectedDevice = BehaviorSubject<List<BluetoothDevice>>.seeded([]);
  Stream<List<BluetoothDevice>> get connectedDeviceStream =>
      _connectedDevice.stream;
  final _myScanResults = BehaviorSubject<List<ScanResult>>.seeded([]);
  Stream<List<ScanResult>> get myScanResults => _myScanResults.stream;

  final _bluetoothState = BehaviorSubject<BluetoothAdapterState>.seeded(
      BluetoothAdapterState.unknown);
  Stream<BluetoothAdapterState> get bluetoothStateStream =>
      _bluetoothState.stream;
  BluetoothAdapterState get bluetoothState => _bluetoothState.value;

  bool outOfService = false;
  bool presenceOfLight = false;
  //String carFloor = "--";
  String carFloor = "999";
  Direction carDirection = Direction.stopped;
  TypeMissionStatus missionStatus = TypeMissionStatus.missionNoInit;
  int eta = -1;
  late OperationMode operationMode;
  bool _showNotification = false;

  BleProvider(this.ble) {
    // if your terminal doesn't support color you'll see annoying logs like `\x1B[1;35m`
    //FlutterBluePlus.setLogLevel(LogLevel.verbose, color: false);
    // Initialize local notifications

    _getBluetoothState();
    ble.scanResults.listen((results) async {
      final device = await ble.nearestDevice;
      final l = await ble.connectionState;
      final d = (await ble.nearestScan).advertisementData.connectable;
      final f = isFloor(await ble.nearestScan);
      log('NearestDevice ${device.localName.codeUnits.toString()} --->>  ${device.remoteId.str}, $l, $d, $f');
      if (await ble.connectionState != BluetoothConnectionState.connected &&
          (await ble.nearestScan).advertisementData.connectable) {
        if (isFloor(await ble.nearestScan)) {
          await ble.connect();
          final d = BluetoothDevice.fromId(
            device.remoteId.str,
            localName: device.localName.codeUnits.toString(),
            type: device.type,
          );
          if (_showNotification == false) {
            print(_showNotification);
            print(
                "===================================================================================================================================");
            NotificationService service = NotificationService();
            service.initNotification();
            service.sendNotification(
              notificationId: 0,
              title: 'Sofia App is Near to ElevatorTest',
              body: 'Sofia is Connected to ElevatorTest',
            );
            _showNotification = true;
          }

          setConnectedDevice(d);
          log('Device connected ${device.localName.codeUnits.toString()} ----------->>  ${device.remoteId.str}');
          await removedAllConnectedDevice();
          final connectedDevices = await ble.connectedSystemDevices;
          log('Connected Device List ${connectedDevices.length}');
          // await _showNotification(
          //     'BLE Device Connected', 'Your BLE device is now connected.');
          // await writeCharacteristic(d.localName);
          await readCharacteristic();
        }
      } else {
        final d = BluetoothDevice.fromId(
          device.remoteId.str,
          localName: device.localName.codeUnits.toString(),
          type: device.type,
        );
        setConnectedDevice1(d);
        await readCharacteristic();
      }
    }, onError: (error) {});
  }

//get elevator to connected floor

  // Future<void> getPianoCabina() async {
  //   try {
  //     carFloor = "999";
  //     if (await ble.nearestScan.re.toString() != "") {
  //       try {
  //         await bleService.getValueFromCharacteristicGuid(
  //             IBLEService.floorServiceGuid, floorChangeCharacteristicGuid);
  //       } catch (e) {
  //         return;
  //         //await App.current.mainPage.displayAlert("Alert", e.toString());
  //       }
  //       if (bleService.valueFromCharacteristic != null) {
  //         try {
  //           carFloor =
  //               (bleService.valueFromCharacteristic[0] & 0x3F).toString();
  //         } catch (e) {
  //           if (Preferences.get("DevOptions", false) == true) {
  //             carFloor = "*****";
  //             //debugPrint("***** Caratteristica non trovata ******");
  //           }
  //         }
  //       } else {
  //         carFloor = "999";
  //       }
  //     }
  //   } catch (ex) {
  //     print(ex);
  //   }
  // }
  // void navigateToNoDeviceFoundScreen(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => NoDeviceFoundScreen()),
  //   );
  // }

  bool isFloor(ScanResult scanResult) =>
      scanResult.advertisementData.serviceUuids.contains(FLOOR_SERVICE_GUID);

  bool isCar(ScanResult scanResult) =>
      scanResult.advertisementData.serviceUuids.contains(CAR_SERVICE_GUID);

  void _getBluetoothState() => ble.adapterState.listen((event) {
        if (event == BluetoothAdapterState.on) {
          startScanning();
        } else {
          stopScan();
        }
        _bluetoothState.add(event);
      });

  void startScanning() async {
    if (ble.isScanningNow == false) {
      await ble.startScan(
        withServices: isServiceGuid ? serviceGuids : [],
        timeout: const Duration(days: timeoutDuration),
        androidUsesFineLocation: false,
      );
    }
  }

  void stopScan() async {
    await ble.stopScan();
    _refresh();
    await removedAllConnectedDevice();
  }

  void _refresh() {
    _myScanResults.add([]);
    _connectedDevice.add([]);
  }

  Future<void> readCharacteristic() async {
    try {
      final state = await (await ble.nearestDevice).connectionState.first;
      if (state == BluetoothConnectionState.connected) {
        final services = await (await ble.nearestDevice).discoverServices();
        final characteristic = services
            .firstWhere((element) =>
                element.serviceUuid.toString() == FLOOR_SERVICE_GUID)
            .characteristics;

        final floorChange = characteristic.firstWhere((ch) =>
            ch.characteristicUuid.toString() == floorChangeCharacteristicGuid);

        await floorChange.read();
        await getFloorChangeRequest(floorChange);

        final outOfService = characteristic.firstWhere((ch) =>
            ch.characteristicUuid.toString() == outOfServiceCharacteristicGuid);

        await outOfService.read();
        await getOutOfService(outOfService);
      }
    } catch (e) {
      print("===================================================NNNNNNNNN{$e}");
      log(e.toString());
    }
  }

  Future<void> writeCharacteristic(String floor) async {
    try {
      if (floor.isNotEmpty) {
        print(
            "==========writecharacteristic==========================================={$floor}");
        final state = await (await ble.nearestDevice).connectionState.first;
        if (state == BluetoothConnectionState.connected) {
          final services = await (await ble.nearestDevice).discoverServices();
          final characteristic = services
              .firstWhere((element) =>
                  element.serviceUuid.toString() == FLOOR_SERVICE_GUID)
              .characteristics;

          final floorrequest = characteristic.firstWhere((ch) =>
              ch.characteristicUuid.toString() ==
              floorRequestCharacteristicGuid);

          await floorrequest.write(floor.codeUnits);
          print(
              '*******Data written****** : ${String.fromCharCodes(floor.codeUnits)}');
          await connectToCarDevice();

          // for (var service in services) {
          //   var characteristics = service.characteristics;
          //   for (BluetoothCharacteristic c in characteristics) {
          //     if (c.properties.write) {
          //       if (c.characteristicUuid.toString() ==
          //           floorRequestCharacteristicGuid) {
          //         await c.write(floor.codeUnits);
          //         print(
          //             'Data written : ${String.fromCharCodes(floor.codeUnits)}');
          //         await connectToCarDevice();
          //       }
          //     }
          //   }
          // }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> connectToCarDevice() async {
    try {
      final scanResult = (await ble.scanResults.first).singleWhere(
          (e) => e.advertisementData.serviceUuids.contains(CAR_SERVICE_GUID));
      await scanResult.device.connect();
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> bleServiceOnCharacteristicUpdated1(
  //     BluetoothCharacteristic e) async {
  //   try {
  //     switch (e.characteristicUuid.toString()) {
  //       // case floorChangeCharacteristicGuid:
  //       //   print("*******Case 1 Floor Change CharacteristicGuid***********");
  //       //   try {
  //       //     await getFloorChangeRequest(e);
  //       //   } catch (ex) {
  //       //     print("$ex");
  //       //   }
  //       //   break;
  //       case missionStatusCharacteristicGuid:
  //         print("********Case 2 MissionStatus*********");
  //         try {
  //           await getMissionStatus(e);
  //         } catch (ex) {
  //           print("$ex");
  //         }
  //         break;
  //
  //       case outOfServiceCharacteristicGuid:
  //         print("*********Case 3 Out-ofService**********");
  //         try {
  //           await getOutOfService(e);
  //         } catch (ex) {
  //           print(ex);
  //         }
  //         break;
  //
  //       case movementDirectionCar:
  //         print("*******Case 4 Car Direction******+");
  //         try {
  //           await getMovementDirectionCar(e);
  //         } catch (ex) {
  //           print(ex);
  //         }
  //         break;
  //       default:
  //         print("**************Default******+**********}");
  //         break;
  //     }
  //   } catch (ex) {
  //     print(ex);
  //   }
  //   notifyListeners();
  // }

  Future removedAllConnectedDevice() async {
    final state = await (await ble.nearestDevice).connectionState.first;

    final connectedDevices = await ble.connectedSystemDevices;
    for (var device in connectedDevices) {
      if (state == BluetoothConnectionState.connected &&
          (await ble.nearestDevice).remoteId.str != device.remoteId.str) {
        await device.disconnect();
      }
    }
  }

  void setConnectedDevice(BluetoothDevice device) {
    _connectedDevice.value.clear();
    _connectedDevice.add([device]);
  }

  void setConnectedDevice1(BluetoothDevice device) {
    _connectedDevice.add([device]);
  }

  void clearConnectedDevice() {
    _connectedDevice.value.clear();
  }

  Stream<int> rssiStream(BluetoothDevice device) async* {
    var isConnected = true;
    final subscription = device.connectionState.listen((state) {
      isConnected = state == BluetoothConnectionState.connected;
    });
    while (isConnected) {
      yield await device.readRssi();
      await Future.delayed(const Duration(seconds: 1));
    }
    subscription.cancel();
    // Device disconnected, stopping RSSI stream
  }

  int getFloorNumber(String inputString) {
    final RegExp regex = RegExp(r'\d+');
    final Match? match = regex.firstMatch(inputString);
    if (match != null) {
      final String numberAsString = match.group(0)!;
      return int.parse(numberAsString);
    }

    return 0;
  }

  Future<void> getFloorChangeRequest(BluetoothCharacteristic c) async {
    await c.setNotifyValue(true);
    c.onValueReceived.listen((value) {
      carFloor = (value[0] & 0x3F).toString();
      print("***********ITS WORKING $carFloor");
      if ((value[0] & 0x40) == 0x40) {
        presenceOfLight = true;
        print("presenceofLight is true");
      } else {
        presenceOfLight = false;
        print("presenceofLight is false");
      }

      if ((value[1] & 0x1) == 0x1) {
        if ((value[1] & 0x02) == 0x02) {
          carDirection = Direction.up;
        } else {
          carDirection = Direction.down;
        }
      } else {
        carDirection = Direction.stopped;
      }
      notifyListeners();
    });
  }

  Future<void> getMissionStatus(BluetoothCharacteristic c) async {
    await c.setNotifyValue(true);
    c.onValueReceived.listen((value) {
      if (value.length > 2) {
        missionStatus = TypeMissionStatus.values[value[0]];
        print("***MissionStatus*********$missionStatus");
        eta = value[1] * 256 + value[2];
        print("********************eta time*******$eta");
      }
      notifyListeners();
    });
  }

  Future<void> getOutOfService(BluetoothCharacteristic e) async {
    print("coming to outofservice");
    await e.setNotifyValue(true);
    e.onValueReceived.listen((value) {
      if (value[0] == 0) {
        outOfService = false;
      } else {
        outOfService = true;
      }
      print("******outofservice*****$outOfService**************");
      notifyListeners();
    });
  }

  Future<void> getMovementDirectionCar(BluetoothCharacteristic e) async {
    await e.setNotifyValue(true);
    e.onValueReceived.listen((value) {
      if ((value[0] & 0x1) == 0x1) {
        if ((value[0] & 0x02) == 0x02) {
          carDirection = Direction.up;
        } else {
          carDirection = Direction.down;
        }
      } else {
        carDirection = Direction.stopped;
      }
      notifyListeners();
    });
  }
}
