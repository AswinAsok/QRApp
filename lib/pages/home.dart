import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212023),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
              ],
            ),
          ),
          // You can add more content below the scanner here
        ],
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
