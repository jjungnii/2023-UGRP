import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Page',
      theme: ThemeData(
        primaryColor: Color(0xFFA374DB), // Similar color theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  // Define variables for the text content
  final String name = "John Doe";
  final String department = "Engineering";
  final String room = "Room 123";
  final String roommates = "Alice, Bob";
  final String program = "Computer Science";
  final String quantity = "10";
  final String storageLocation = "Warehouse A";
  final String storageDate = "2023-10-10";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Remove the top bar
        child: AppBar(
          backgroundColor: Color(0xFFA374DB), // Similar color theme
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'my_page',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildPersonInfo(),
            SizedBox(height: 20),
            Text(
              'program',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildProgramInfo(),
            SizedBox(height: 10), // Add some space between program boxes
            _buildProgramInfo(),
            SizedBox(height: 10), // Add some space between program boxes
            _buildProgramInfo(),
            SizedBox(height: 20),
            Text(
              'cotain',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildContainerInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonInfo() {
    return Container(
      padding: EdgeInsets.all(10), // Reduce horizontal size
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/person_image.png', // Replace with your image path
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Name: $name'),
              Text('Department: $department'),
              Text('Room: $room'),
              Text('Roommates: $roommates'),
              Text('La: la'), // Not sure what this line should display
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgramInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Add bottom margin
      child: Container(
        padding: EdgeInsets.all(10), // Reduce horizontal size
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Program: $program'),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerInfo() {
    return Container(
      padding: EdgeInsets.all(10), // Reduce horizontal size
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/box_image.png', // Replace with your image path
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Quantity: $quantity'),
              Text('Storage Location: $storageLocation'),
              Text('Storage Date: $storageDate'),
            ],
          ),
        ],
      ),
    );
  }
}
