// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:sofia_app/interfaces/i_ble.dart';
// import 'package:sofia_app/providers/ble_provider.dart';

// class MockFlutterBluePlus extends Mock implements FlutterBluePlus {}

// class MockScanResultStream extends Mock implements Stream<List<ScanResult>> {}

// class MockConnectedDeviceStream extends Mock
//     implements Stream<List<BluetoothDevice>> {}

// class MockBluetoothAdapterStateStream extends Mock
//     implements Stream<BluetoothAdapterState> {}

// //class BleTestingImpl extends Mock implements Ble {}

// class BleTestingImpl extends IBle {
//   @override
//   Stream<BluetoothAdapterState> get adapterState =>
//       Stream.value(BluetoothAdapterState.on);

//   @override
//   Future<void> connect(
//       {Duration timeout = const Duration(seconds: 15),
//       bool autoConnect = false}) async {
//     log('In Connect method');
//   }

//   @override
//   Future<List<BluetoothDevice>> get connectedSystemDevices async =>
//       sampleScanResult.map((e) => e.device).toList();

//   @override
//   Future<BluetoothConnectionState> get connectionState async =>
//       Future(() => BluetoothConnectionState.connected);

//   @override
//   Future<void> disconnect({int timeout = 15}) async {
//     log('Disconnect');
//   }

//   @override
//   Future<List<BluetoothService>> discoverServices() async => [];

//   @override
//   bool get isScanningNow => false;

//   @override
//   Future<BluetoothDevice> get nearestDevice async {
//     return (await nearestScan).device;
//   }

//   @override
//   Future<ScanResult> get nearestScan async => (await scanResults.first)
//       .reduce((current, next) => current.rssi > next.rssi ? current : next);

//   @override
//   Stream<List<ScanResult>> get scanResults => Stream.value(sampleScanResult);

//   @override
//   Future<List<BluetoothService>> get servicesStream async => [];

//   @override
//   Future<void> startScan(
//       {ScanMode scanMode = ScanMode.lowLatency,
//       List<Guid> withServices = const [],
//       List<String> macAddresses = const [],
//       Duration? timeout,
//       bool allowDuplicates = false,
//       bool androidUsesFineLocation = false}) async {
//     log('startScan');
//   }

//   @override
//   Future<void> stopScan() async {
//     log('stopScan');
//   }
// }

// List<ScanResult> sampleScanResult = [
//   ScanResult(
//     device: BluetoothDevice(
//       remoteId: const DeviceIdentifier('24:4C:AB:09:3F:82'),
//       localName: 'Piano 1',
//       type: BluetoothDeviceType.unknown,
//     ),
//     advertisementData: AdvertisementData(
//       localName: 'P1',
//       txPowerLevel: 1,
//       connectable: true,
//       manufacturerData: {},
//       serviceData: {},
//       serviceUuids: [],
//     ),
//     rssi: -60,
//     timeStamp: DateTime.now(),
//   ),
//   ScanResult(
//     device: BluetoothDevice(
//       remoteId: const DeviceIdentifier('24:4C:AB:09:CB:AE'),
//       localName: 'Piano 2',
//       type: BluetoothDeviceType.unknown,
//     ),
//     advertisementData: AdvertisementData(
//       localName: 'P2',
//       txPowerLevel: 2,
//       connectable: true,
//       manufacturerData: {},
//       serviceData: {},
//       serviceUuids: [],
//     ),
//     rssi: -50,
//     timeStamp: DateTime.now(),
//   ),
// ];

// void main() {
//   late IBle mockBle;
//   late BleProvider bleProvider;
//   late MockFlutterBluePlus mockFlutterBluePlus;
//   late MockScanResultStream mockScanResultStream;
//   late MockConnectedDeviceStream mockConnectedDeviceStream;
//   late MockBluetoothAdapterStateStream mockBluetoothAdapterStateStream;

//   setUp(() {
//     mockBle = BleTestingImpl();
//     bleProvider = BleProvider(mockBle);
//     mockFlutterBluePlus = MockFlutterBluePlus();
//     mockScanResultStream = MockScanResultStream();
//     mockConnectedDeviceStream = MockConnectedDeviceStream();
//     mockBluetoothAdapterStateStream = MockBluetoothAdapterStateStream();
//     //final d = ble.scanResults;

//     // Mocking streams
//     // when(mockFlutterBluePlus.scanResults)
//     //     .thenAnswer((_) => mockScanResultStream);
//     // when(mockFlutterBluePlus.connectedSystemDevices)
//     //     .thenAnswer((_) => mockConnectedDeviceStream);
//     // when(mockFlutterBluePlus.adapterState)
//     //     .thenAnswer((_) => mockBluetoothAdapterStateStream);
//   });

//   // test('Start scanning should call FlutterBluePlus.startScan', () async {
//   //   when(mockFlutterBluePlus.isScanningNow).thenReturn(false);
//   //
//   //   bleProvider.startScanning();
//   //
//   //   verify(mockFlutterBluePlus.startScan(
//   //     withServices: anyNamed('withServices'),
//   //     timeout: anyNamed('timeout'),
//   //     androidUsesFineLocation: anyNamed('androidUsesFineLocation'),
//   //   )).called(1);
//   // });

//   // test('Stop scanning should call FlutterBluePlus.stopScan', () async {
//   //   when(mockFlutterBluePlus.isScanningNow).thenReturn(true);
//   //
//   //   bleProvider.stopScan();
//   //
//   //   verify(mockFlutterBluePlus.stopScan()).called(1);
//   // });

//   // Write similar tests for other methods, such as readCharacteristic, clearConnectedDevice, etc.

//   test('Set connected device updates the stream', () async {
//     final nearestDevice = BluetoothDevice(
//       remoteId: const DeviceIdentifier('mock_id'),
//       localName: 'Mock Device',
//       type: BluetoothDeviceType.unknown,
//     );

//     bleProvider.setConnectedDevice(nearestDevice);

//     final connectedDevices = await bleProvider.connectedDeviceStream.first;
//     expect(nearestDevice, connectedDevices.first);
//   });

//   test('Scanned Devices', () async {
//     //when(mockBle.scanResults).thenAnswer((_) => Stream.value(sampleScanResult));

//     final scannedResult = await mockBle.scanResults.first;
//     expect(sampleScanResult, scannedResult);
//     //expect(true, true);

//     // final testSubject = StreamController<List<ScanResult>>();
//     //
//     // testSubject.add(sampleScanResult);
//     //
//     // expect((await testSubject.stream.first), sampleScanResult);
//   });

//   test('Find Nearest Device', () async {
//     final scannedResult = await mockBle.scanResults.first;
//     expect(sampleScanResult, scannedResult);
//     final device = await mockBle.nearestDevice;
//     expect(sampleScanResult.last.device, device);
//   });

//   test('Find Nearest Device and connect', () async {
//     final scannedResult = await mockBle.scanResults.first;
//     expect(sampleScanResult, scannedResult);
//     final device = await mockBle.nearestDevice;
//     expect(sampleScanResult.last.device, device);
//     mockBle.connect();
//     expect(BluetoothConnectionState.connected, await (mockBle.connectionState));
//   });

//   // test("Listening device", () async {
//   //   ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
//   //       'flutter_blue_plus/methods',
//   //       StandardMethodCodec()
//   //           .encodeMethodCall(MethodCall('getAdapterState', '{"result":true}')),
//   //       (ByteData data) {});
//   // });

//   // test("Is Scanning Asynchronously", () async {
//   //   expect(bleProvider.isScanningStream, false);
//   // });
//   //
//   // test('isScanningStream should emit the initial value', () {
//   //   expect(bleProvider.isScanningStream, emitsInOrder([false]));
//   // });
//   // test('isScanning value should be updated when BehaviorSubject is updated',
//   //     () {
//   //   bleProvider
//   //       .changeScanningStatus(true); // Call the method that updates _isScanning
//   //
//   //   expect(bleProvider.isScanning, true);
//   // });

//   // Write more tests for showing devices, connecting, disconnecting, and other functionalities
// }
