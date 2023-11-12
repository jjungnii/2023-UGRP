import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  final List<String> _titles = [
    'Menu',
    'My Page',
    'Schedule',
    'Notification',
  ];
  String _currentTitle = 'Menu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(_currentTitle),
        backgroundColor: Color(0xFF8f89b7),
        centerTitle: true,
        toolbarHeight: 80.0, // Increase the size of the top bar
      ),
      body: Stack(
        children: [
          _buildOffstageNavigator(0, HomeScreen(updateTitle: updateTitle)),
          _buildOffstageNavigator(1, MyPage()),
          _buildOffstageNavigator(2, ScheduleScreen()), // Schedule screen now includes a calendar function
          _buildOffstageNavigator(3, Text('Notification')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedFontSize: 18, // Increase size for bottom bar items
        unselectedFontSize: 16,
        iconSize: 12.0,
        selectedItemColor: Color(0xFF8f89b7),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/menu.png', height: 52, width: 52),//Icon(Icons.menu),
            label: 'Menu',       
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png',height: 52, width: 52),
            label: 'My Page',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/calendar.png', height: 52, width: 52),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/notification.png', height: 52, width: 52),
            label: 'Notification',
          ),
        ],
      ),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _currentIndex != index,
      
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => child,
          );
        },
      ),
    );
  }

  void onTabTapped(int index) {
    if (index == 0) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    }
    setState(() {
      _currentIndex = index;
      _currentTitle = _titles[index];
    });
  }
  void updateTitle(String title) {
  setState(() {
    _currentTitle = title;
  });
}

}//navigation


class HomeScreen extends StatelessWidget {
  final Function(String) updateTitle;
  HomeScreen({required this.updateTitle});
  @override
  Widget build(BuildContext context) {
    return Container(
       alignment: Alignment.topCenter,
      color: Color(0xFFe7e5f1),
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0), // Set top padding
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          createGridItem('RC Introduction', context,'assets/images/office.png'),
          createGridItem('Notice', context,'assets/images/megaphone.png'),
          createGridItem('Report/Proposal', context,'assets/images/alarm.png'),
          createGridItem('Manage Warehouses', context,'assets/images/boxes.png'),
          createGridItem('Order Delivery', context,'assets/images/fast-delivery.png'),
          createGridItem('Apply for Programs', context,'assets/images/stage.png'),
          createGridItem('Check Retirement', context,'assets/images/moving-truck.png'),
          createGridItem('Clean-up', context,'assets/images/cleaning.png'),
          createGridItem('Link Popo', context,'assets/images/POPO.png'),
        ],
      ),
    ),
    );
  }
  

  Widget createGridItem(String title, BuildContext context,String imagePath) {
    return GestureDetector(
      onTap: () {
        updateTitle(title);
        if (title == 'Manage Warehouses') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WarehouseManagementScreen(),
        ));
      }
       else  if (title == 'Link Popo') {
        // If the title is 'Manage Warehouses', then launch the URL
        _launchURL();
      }
       else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailScreen(title: title),
        ));
      }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        //child: Center(
          child: Column(
    mainAxisSize: MainAxisSize.min, // Use min to fit content size
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0), // Add some padding around the text
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
      fontWeight: FontWeight.bold, // Make the text bold
      color: Color(0xFF8f89b7),    // Set the text color
      fontSize: 16.0,              // Set the font size
      // You can add more styling properties as needed
    ),
        ),
      ),
    ],
  ),
      ),
    );
  }

void _launchURL() async {
  const url = 'https://popo.poapper.club/';
  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // You can show an error message here
      print('Could not launch $url');
    }
  } catch (e) {
    // You can show an error message here
    print('Could not launch $url: $e');
  }
}
}

class WarehouseManagementScreen extends StatefulWidget {
  @override
  _WarehouseManagementScreenState createState() => _WarehouseManagementScreenState();
}

class _WarehouseManagementScreenState extends State<WarehouseManagementScreen> {
  List<Widget> packageTiles = [];

  @override
  void initState() {
    super.initState();
    // Initialize your list with one package info or more if needed
    packageTiles.add(_buildBoxedTile(
      image: AssetImage('assets/images/box-linear.png'),
      title: 'Package Info',
      subtitle: '2023.06.10 - Package R-9',
      color: Color(0xFF8f89b7),
      titleColor: Colors.white,
      subtitleColor: Colors.white,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(height: 10), // Some space at the top
              _buildBoxedTile(
                image: AssetImage('assets/images/notification.png'),
                title: 'Your Notification Title',
                subtitle: '2023.06.08 ~ 2023.06.10',
                color: Color(0xFF8f89b7),
                titleColor: Colors.white,
                subtitleColor: Colors.white,
              ),
              SizedBox(height: 10),
              _buildBoxedTile(
                image: AssetImage('assets/images/notification.png'),
                title: 'Another Notification Title',
                subtitle: 'Your message here!',
                color: Color(0xFF8f89b7),
                titleColor: Colors.white,
                subtitleColor: Colors.white,
                
              ),
              SizedBox(height: 40), // Space before the warehouse title
              Text('Warehouse', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8f89b7))),
              SizedBox(height: 10),
              _buildBoxedTile(
                image: AssetImage('assets/images/refrigerator.png'),
                title: 'Warehouse Info',
                subtitle: '2023.06.10 - Warehouse 128',
                color: Color(0xFF8f89b7),
                titleColor: Colors.white,
                subtitleColor: Colors.white,

              ),
              SizedBox(height: 10),
              ...packageTiles, // This will display the list of tiles on the screen
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addNewPackageInfo, // Add package info when this button is pressed
                child: Text('+ Add New Item'),
                style: ElevatedButton.styleFrom(primary: Color(0xFF8f89b7)),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _addNewPackageInfo() {
  setState(() {
    // Add a new package info tile to the list with some margin
    packageTiles.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0), // This adds space between the tiles
        child: _buildBoxedTile(
          image: AssetImage('assets/images/box-linear.png'), // Make sure to have this image in your assets
          title: 'New Package Info',
          subtitle: 'Timestamp - Package XYZ',
          color: Color(0xFF8f89b7),
          titleColor: Colors.white,
          subtitleColor: Colors.white,
        ),
      ),
    );
  });
}

  Widget _buildBoxedTile({
    required ImageProvider image,
    required String title,
    required String subtitle,
    required Color color,
    Color titleColor = Colors.black,
    Color subtitleColor = Colors.black54,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ListTile(
        leading: Image(
          image: image,
          width: 40,
          height: 40,
          color: Colors.white,
        ),
        title: Text(title, style: TextStyle(color: titleColor)),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
      ),
    );
  }
}




class DetailScreen extends StatelessWidget {
  final String title;

  DetailScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('You are now in $title screen'),
      ),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
          },
          child: Text('Pick a date'),
        ),
      ),
    );
  }
}


//mypage
class MyPage extends StatelessWidget {
  // Define variables for the text content
  final String name = "임지훈";
  final String department = "컴퓨터공학과";
  final String room = "Room 123";
  final String roommates = "김정윤";
  final program = ["카네이션 만들기","RC 잔치","베이킹 둥지"];
  final program_list = ["층프로그램","전체행사","둥지"];
  final prgram_info = ["2023.10.22 19:00/층홀","2023.10.22 19:00/층홀","2023.10.22 19:00/층홀"];
  final String quantity = "10";
  final String storageLocation = "Warehouse A";
  final String storageDate = "2023-10-10";
  final String Ra = "박지원";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe7e5f1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Remove the top bar
        child: AppBar(
          backgroundColor: Color(0xFF8f89b7), // Similar color theme
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
            ),
            _buildPersonInfo(),
            SizedBox(height: 10),
            Text(
              'program',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8f89b7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
            ),
            _buildProgramInfo(0),
            SizedBox(height: 10), // Add some space between program boxes
            _buildProgramInfo(1),
            SizedBox(height: 10), // Add some space between program boxes
            _buildProgramInfo(2),
            SizedBox(height: 20),
            Text(
              'cotain',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8f89b7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
            ),
            _buildContainerInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonInfo() {
    return Container(
      padding: EdgeInsets.all(6), // Reduce horizontal size
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF8f89b7)),
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFFFFFFF),
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/notification.png', // Replace with your image path
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
              Text('Ra: ,$Ra'), // Not sure what this line should display
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgramInfo(int pindx) {
    String program_ = program[pindx];
    String program_list_ = program_list[pindx];
    String prgram_info_ = prgram_info[pindx];
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0), // Add bottom margin
      child: Container(
        height: 60,
        width: 450,
        padding: EdgeInsets.all(10), // Reduce horizontal size
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF8f89b7)),
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$program_list_: $program_',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8f89b7),
              )
              ),

            Text('$prgram_info_',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8f89b7),
              )
            ),
            
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
        border: Border.all(color: Color(0xFF8f89b7)),
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFFFFFFF),
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/boxes.png', // Replace with your image path
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
