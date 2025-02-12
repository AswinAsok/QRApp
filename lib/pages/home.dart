import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrapp/widgets/qr_scanner_corner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  Home({super.key});

  //reference our box
  final _myBox = Hive.box('qrBox');

  void writeData(String data) {
    _myBox.add(data);
  }

  void deleteData(int index) {
    _myBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScannerWidget(writeData: writeData),
                RecentScans(deleteData: deleteData)
              ],
            ),
            // You can add more content below the scanner here
          ],
        ),
      ),
    );
  }
}

class ScannerWidget extends StatefulWidget {
  final Function(String) writeData;

  const ScannerWidget({
    super.key,
    required this.writeData,
  });

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  bool isScanning = false;
  bool showInfoModal = false;
  String data = "";

  void showModal(String data) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scan Result',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showInfoModal = false;
                        this.data = "";
                      });
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    data,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: data));
                        Fluttertoast.showToast(
                          msg: "Copied to clipboard",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      icon: Icon(Icons.copy, color: Colors.white),
                      label:
                          Text("Copy", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () async {
                        final Uri uri = Uri.parse(data);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Could not launch URL",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      icon: Icon(Icons.open_in_browser, color: Colors.white),
                      label: Text("Open in Browser",
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () {
                        print("Share data");
                      },
                      icon: Icon(Icons.share, color: Colors.white),
                      label:
                          Text("Share", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showInfoModal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModal(data);
      });
    }

    return Container(
      width: double.infinity,
      height: 425,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: 40),
            child: Text(
              "Scan QR Codes",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                    width: 3,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isScanning = !isScanning;
                    });
                  },
                  child: Stack(
                    children: [
                      QRScannerCorner(),
                      Positioned(
                        right: 0,
                        child: Transform.rotate(
                          angle: Math.pi / 2,
                          child: QRScannerCorner(),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Transform.rotate(
                          angle: Math.pi,
                          child: QRScannerCorner(),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Transform.rotate(
                          angle: -Math.pi / 2,
                          child: QRScannerCorner(),
                        ),
                      ),
                      Center(
                        child: isScanning
                            ? SizedBox(
                                width: 175,
                                height: 175,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: MobileScanner(
                                    onDetect: (capture) {
                                      final List<Barcode> barcodes =
                                          capture.barcodes;
                                      if (barcodes.isNotEmpty) {
                                        setState(() {
                                          data = barcodes.first.rawValue ??
                                              "No data";
                                          Fluttertoast.showToast(
                                              msg: "Scanning Complete",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          isScanning = false;
                                          showInfoModal = true;
                                          widget.writeData(data);
                                        });
                                        // Close the scanner
                                      }
                                    },
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.touch_app,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    isScanning ? 'Scanning...' : 'Tap to scan',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "Place a QR code inside the frame to scan it",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentScans extends StatefulWidget {
  final Function(int) deleteData;

  const RecentScans({
    super.key,
    required this.deleteData,
  });

  @override
  _RecentScansState createState() => _RecentScansState();
}

class _RecentScansState extends State<RecentScans> {
  final _myBox = Hive.box('qrBox');

  void showModal(String data) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scan Result',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    data,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: data));
                        Fluttertoast.showToast(
                          msg: "Copied to clipboard",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      icon: Icon(Icons.copy, color: Colors.white),
                      label:
                          Text("Copy", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () async {
                        final Uri uri = Uri.parse(data);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Could not launch URL",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      icon: Icon(Icons.open_in_browser, color: Colors.white),
                      label: Text("Open in Browser",
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () {
                        print("Share data");
                      },
                      icon: Icon(Icons.share, color: Colors.white),
                      label:
                          Text("Share", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height - 425,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 40),
            child: Text(
              "Recent Scans (${_myBox.length})",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('qrBox').listenable(),
              builder: (context, Box box, _) {
                if (box.values.isEmpty) {
                  return Center(
                    child: Text(
                      "No recent scans",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final scan = box.getAt(index);
                      return GestureDetector(
                        onTap: () {
                          showModal(scan);
                        },
                        child: ListTile(
                          title: Text(
                            scan,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "Date: ${DateTime.now().toString().split(' ')[0]}",
                            style: TextStyle(color: Colors.white70),
                          ),
                          leading: Icon(Icons.qr_code, color: Colors.white),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              widget.deleteData(index);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class Math {
  static double pi = 3.1415926535897932;
}
