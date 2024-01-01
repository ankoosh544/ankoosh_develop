import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sofia_app/interfaces/i_ble.dart';
import 'package:sofia_app/models/BLECharacteristics.dart';
import 'package:sofia_app/models/BLESample.dart';

class BleService implements IBle {
  final _nearestDeviceController = StreamController<BluetoothDevice>();

  @override
  Stream<BluetoothDevice> get nearestDeviceStream =>
      _nearestDeviceController.stream;

  final _characteristicUpdatedController =
      StreamController<BLECharacteristics>.broadcast();

  @override
  Stream<BLECharacteristics> get onCharacteristicUpdated =>
      _characteristicUpdatedController.stream;

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect(autoConnect: true);
  }

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
    final device = (await nearestScan).device;
    _nearestDeviceController.add(device);
    return (await nearestScan).device;
  }

  @override
  Future<ScanResult> get nearestScan async => (await scanResults.first)
      .reduce((current, next) => current.rssi > next.rssi ? current : next);

  @override
  Future<void> connect({
    Duration timeout = const Duration(seconds: 15),
    bool autoConnect = false,
  }) async =>
      (await nearestDevice).connect(timeout: timeout, autoConnect: autoConnect);

  @override
  Future<void> disconnect({int timeout = 15}) async =>
      (await nearestDevice).disconnect(timeout: timeout);

  @override
  Future<List<BluetoothService>> get servicesStream async =>
      (await nearestDevice).servicesStream.first;

  @override
  Future<List<BluetoothService>> discoverServices() async =>
      (await nearestDevice).discoverServices();
}
