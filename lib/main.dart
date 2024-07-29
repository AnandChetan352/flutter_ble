import 'package:ble_scanner/ble_cotroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BluetoothDemo(),
    );
  }
}

class BluetoothDemo extends StatefulWidget {
  const BluetoothDemo({super.key});

  @override
  State<StatefulWidget> createState() => _BluetoothDemoState();
}

class _BluetoothDemoState extends State<BluetoothDemo> {
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text("BLE SCANNER"),),
        body: GetBuilder<BleController>(
          init: BleController(),
          builder: (BleController controller)
          {
            return Center(
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<List<ScanResult>>(
                      stream: controller.scanResults,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.data![index];
                                  return Card(
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text(data.device.name),
                                      subtitle: Text(data.device.id.id),
                                      trailing: Text(data.rssi.toString()),
                                      onTap: ()=> controller.connectToDevice(data.device),
                                    ),
                                  );
                                }),
                          );
                        }else{
                          return Center(child: Text("No Device Found"),);
                        }
                      }),
                   const SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()  async {
                    controller.scanDevices();
                    // await controller.disconnectDevice();
                  }, child: Text("SCAN")),

                ],
              ),
            );
          },
        )
    );
  }
}
