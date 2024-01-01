import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sofia_app/models/BLECharacteristics.dart';
import 'package:sofia_app/models/BLESample.dart';

abstract class IBle {
  static const carServiceGuid = "6c962546-6011-4e1b-9d8c-05027adb3a02";
  static const floorServiceGuid = "6c962546-6011-4e1b-9d8c-05027adb3a01";

  Stream<BLECharacteristics> get onCharacteristicUpdated;

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
    Duration timeout = const Duration(seconds: 10),
    bool autoConnect = false,
  });
  Future<void> disconnect({int timeout = 10});

  Stream<List<ScanResult>> get scanResults;
  Stream<BluetoothAdapterState> get adapterState;
  Future<List<BluetoothDevice>> get connectedSystemDevices;
  Future<BluetoothConnectionState> get connectionState;
  Future<List<BluetoothService>> get servicesStream;
  Stream<BluetoothDevice> get nearestDeviceStream;

  Future<List<BluetoothService>> discoverServices();
}
