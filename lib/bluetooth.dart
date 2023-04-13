// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Bluetooth Demo',
//       home: MyHomePage(title: 'Flutter Bluetooth Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   BluetoothDevice? _connectedDevice;
//
//   void _startScan() {
//     flutterBlue.scan().listen((scanResult) {
//       print('Device found: ${scanResult.device.name}');
//     }, onDone: () => print('Scan complete.'), onError: (e) => print(e));
//   }
//
//   void _stopScan() {
//     flutterBlue.stopScan();
//   }
//
//   void _connectToDevice(BluetoothDevice device) async {
//     try {
//       await device.connect();
//       setState(() {
//         _connectedDevice = device;
//       });
//       print('Device connected: ${device.name}');
//       _discoverServices(device);
//     } catch (e) {
//       print('Error connecting to device: $e');
//     }
//   }
//
//   void _disconnectFromDevice() async {
//     if (_connectedDevice != null) {
//       await _connectedDevice!.disconnect();
//       setState(() {
//         _connectedDevice = null;
//       });
//       print('Device disconnected.');
//     }
//   }
//
//   void _discoverServices(BluetoothDevice device) async {
//     try {
//       List<BluetoothService> services = await device.discoverServices();
//       services.forEach((service) async {
//         List<BluetoothCharacteristic> characteristics = await service.characteristics;
//         characteristics.forEach((characteristic) async {
//           await characteristic.read().then((value) {
//             print('Value: $value');
//             // Do something with the characteristic value
//           });
//         });
//       });
//     } catch (e) {
//       print('Error discovering services: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _startScan,
//               child: Text('Start Scan'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _stopScan,
//               child: Text('Stop Scan'),
//             ),
//             SizedBox(height: 16),
//             if (_connectedDevice == null)
//               Text('No device connected.')
//             else
//               Text('Connected to device: ${_connectedDevice!.name}'),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => _connectToDevice(_connectedDevice!),
//               child: Text('Discover Services'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _disconnectFromDevice,
//               child: Text('Disconnect'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }