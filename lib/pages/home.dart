import 'package:flutter/material.dart';

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
                Container(
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
                            child: Stack(
                              children: [
                                _buildCorner(),
                                Positioned(
                                  right: 0,
                                  child: Transform.rotate(
                                    angle: Math.pi / 2,
                                    child: _buildCorner(),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Transform.rotate(
                                    angle: Math.pi,
                                    child: _buildCorner(),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Transform.rotate(
                                    angle: -Math.pi / 2,
                                    child: _buildCorner(),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.touch_app,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Tap to scan',
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
                      )
                    ],
                  ),
                ),
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

  Widget _buildCorner() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          left: BorderSide(width: 3, color: Colors.black),
          top: BorderSide(width: 3, color: Colors.black),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
        ),
      ),
    );
  }
}

class Math {
  static double pi = 3.1415926535897932;
}
