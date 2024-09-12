import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Weather App',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              _buildInfoBubble('JUNLIN YANG', 'junlin.yang@ue-germany.de'),
              SizedBox(height: 16),
              _buildInfoBubble('Zhijian Mao', 'zhijian.mao@ue-germany.de'),
              SizedBox(height: 16),
              _buildInfoBubble('Zeyu Xue', 'zeyu.xue@ue-germany.de'),
              SizedBox(height: 16),
              _buildInfoBubble('Jong Woo Park', 'jong.park@ue-germany.de'),
              SizedBox(height: 16),
              _buildInfoBubble('Yiheng Wu', 'yiheng.wu@ue-germany.de'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBubble(String name, String email) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.lightBlueAccent, width: 2),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
