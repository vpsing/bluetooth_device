import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bluetooth Scan Demo',
      home: BluetoothScanScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
//   FlutterBluePlus _flutterBluePlus = FlutterBluePlus.instance;
//   StreamSubscription? _scanSubscription;
//
//   void _startScan() {
//     _scanSubscription = _flutterBluePlus
//         .scan(
//       timeout: const Duration(seconds: 5),
//       withServices: [],
//     )
//         .listen((scanResult) {
//       if (!devicesList.contains(scanResult.device)) {
//         setState(() {
//           devicesList.add(scanResult.device);
//         });
//       }
//     });
//   }
//
//   void _stopScan() {
//     _scanSubscription?.cancel();
//     setState(() {
//       _scanSubscription = null;
//     });
//   }
//
//   void _clearList() {
//     setState(() {
//       devicesList.clear();
//     });
//   }
//
//   ListView _buildListViewOfDevices() {
//     List<Container> containers = <Container>[];
//     for (BluetoothDevice device in devicesList) {
//       containers.add(
//         Container(
//           height: 50,
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: Column(
//                   children: <Widget>[
//                     Text(device.name == '' ? '(unknown device)' : device.name),
//                     Text(device.id.toString()),
//                   ],
//                 ),
//               ),
//               TextButton(
//                 style: TextButton.styleFrom(
//                   primary: Colors.white,
//                   backgroundColor: Colors.blue,
//                 ),
//                 child: const Text('Connect'),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return ListView.separated(
//       itemCount: containers.length,
//       itemBuilder: (BuildContext context, int index) {
//         return containers[index];
//       },
//       separatorBuilder: (BuildContext context, int index) => const Divider(),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _startScan();
//   }
//
//   @override
//   void dispose() {
//     _stopScan();
//     super.dispose();
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
//           children: <Widget>[
//             ElevatedButton(
//               child: Text('Clear List'),
//               onPressed: _startScan,
//             ),
//             Expanded(child: _buildListViewOfDevices()),
//           ],
//         ),
//       ),
//     );
//   }
// }




// class BluetoothScanScreen extends StatefulWidget {
//   @override
//   _BluetoothScanScreenState createState() => _BluetoothScanScreenState();
// }
//
// class _BluetoothScanScreenState extends State<BluetoothScanScreen> {
//   FlutterBluePlus _flutterBluePlus = FlutterBluePlus.instance;
//   StreamSubscription<ScanResult>? _scanSubscription;
//   List<ScanResult> _scanResults = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//     _flutterBluePlus.stopScan();
//   }
//
//
//
//
//   void _startScan() {
//     if (_scanSubscription != null) {
//       _scanSubscription!.cancel();
//       _scanSubscription = null;
//     }
//     setState(() {
//       _scanResults.clear();
//     });
//     _scanSubscription = _flutterBluePlus.scan().listen((result) {
//       setState(() {
//         if (!_scanResults.contains(result)) {
//           _scanResults.add(result);
//         }
//       });
//     });
//   }
//
//   void _stopScan() {
//     _scanSubscription?.cancel();
//     _scanSubscription = null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Scan'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _startScan,
//               child: Text('Scan'),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _scanResults.length,
//                 itemBuilder: (context, index) {
//                   final result = _scanResults[index];
//                   return ListTile(
//                     title: Text(result.device.name ?? 'Unknown Device'),
//                     subtitle: Text(result.device.id.toString()),
//                     trailing: Text('${result.rssi} dBm'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BluetoothScanScreen extends StatefulWidget {
  @override
  _BluetoothScanScreenState createState() => _BluetoothScanScreenState();
}

class _BluetoothScanScreenState extends State<BluetoothScanScreen> {
  FlutterBluePlus _flutterBluePlus = FlutterBluePlus.instance;
  StreamSubscription<ScanResult>? _scanSubscription;
  List<ScanResult> _scanResults = [];

  BluetoothDevice? _connectedDevice;

  void _startScan() {
    if (_scanSubscription != null) {
      _scanSubscription!.cancel();
      _scanSubscription = null;
    }
    setState(() {
      _scanResults.clear();
    });
    _scanSubscription = _flutterBluePlus.scan().listen((result) {
      setState(() {
        if (!_scanResults.contains(result)) {
          _scanResults.add(result);
        }
      });
    });
  }

  void _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        _connectedDevice = device;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Device connected successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to device.')),
      );
    }
  }

  void _disconnectFromDevice() {
    _connectedDevice?.disconnect();
    setState(() {
      _connectedDevice = null;
    });
  }

  @override
  void dispose() {
    _stopScan();
    _connectedDevice?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startScan,
              child: Text('Scan'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _scanResults.length,
                itemBuilder: (context, index) {
                  final result = _scanResults[index];
                  return ListTile(
                    title: Text(result.device.name ?? 'Unknown Device'),
                    subtitle: Text(result.device.id.toString()),
                    trailing: Text('${result.rssi} dBm'),
                    onTap: () {
                      _connectToDevice(result.device);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            if (_connectedDevice != null)
              Text('Connected to device: ${_connectedDevice!.name}'),
            ElevatedButton(
              onPressed: _disconnectFromDevice,
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
