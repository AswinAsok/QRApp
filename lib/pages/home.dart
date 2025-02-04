import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrapp/widgets/qr_scanner_corner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                ScannerWidget(),
                Container(
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
                          "Recent Scans",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                "Scan $index",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Date: 2021-10-10",
                                style: TextStyle(color: Colors.white70),
                              ),
                              leading: Icon(Icons.qr_code, color: Colors.white),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 16),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
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
  const ScannerWidget({
    super.key,
  });

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  bool isScanning = false;
  bool showInfoModal = false;
  String data = "";

  @override
  Widget build(BuildContext context) {
    if (showInfoModal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
                      Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 24,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                ],
              ),
            );
          },
        );
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

class Math {
  static double pi = 3.1415926535897932;
}
