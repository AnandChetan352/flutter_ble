import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController
{
  FlutterBlue ble = FlutterBlue.instance;

  Future scanDevices() async
  {
    if(await Permission.bluetoothScan.request().isGranted)
    {
      if(await Permission.bluetoothConnect.request().isGranted)
      {
        await ble.startScan(timeout: const Duration(seconds: 10));
        await ble.stopScan();
      }
    }
    
  }

  // This function will help user to connect to BLE devices.
 Future<void> connectToDevice(BluetoothDevice device)async {
    await device?.connect(timeout: Duration(seconds: 15));
    device?.state.listen((isConnected) {
      if(isConnected == BluetoothDeviceState.connecting){
        print("Device connecting to: ${device.name}");
      }else if(isConnected == BluetoothDeviceState.connected){
        print("Device connected: ${device.name}");
      }else{
        print("Device Disconnected");
      }
  
    });
 }
  Stream<List<ScanResult>> get scanResults => ble.scanResults;

}