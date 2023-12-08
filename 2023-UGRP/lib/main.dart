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
        if (title == 'Order Delivery') {
        // Navigate to the Order Delivery page
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OrderDeliveryScreen(),
        ));
      } else if (title == 'Manage Warehouses') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WarehouseManagementScreen(),
        ));
      }
       else  if (title == 'Link Popo') {
        // If the title is 'Manage Warehouses', then launch the URL
        _launchURL_popo();

      
      } else if(title == 'RC Introduction'){
        // Show dialog with options for RC 소개 and RA 소개
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Choose an option'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to RCIntroductionScreen
                      _launchURL_RC();
                    },
                    child: Text('RC 소개'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Show RA 조직도 content (You need to implement RAIntroductionScreen)
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RAIntroductionScreen(),
                      ));
                    },
                    child: Text('RA 소개'),
                  ),
                ],
              ),
            );
          },
        );
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
void _launchURL_RC() async {
  const url = 'https://freshman.postech.ac.kr/residentialcollege/aboutrc/';
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
void _launchURL_popo() async {
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

//=========================RA 소개
class RAIntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RA 소개'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // RA 조직도 사진 추가
          Image.asset('assets/images/ra_intro_image.png', height: 100, width: 100),
          Text('RA 소개 화면'),
        ],
      ),
    );
  }
}


//=========================Delivery
class DeliveryBoxTile extends StatefulWidget {
  final ImageProvider image;
  final String title;
  final String subtitle;
  final Color color;
  final Color titleColor;
  final Color subtitleColor;
  final String status;
  final String orderLink; // Add this new field for the order link

  DeliveryBoxTile({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
    this.titleColor = Colors.white,
    this.subtitleColor = Colors.white,
    required this.status,
    required this.orderLink, // Initialize the orderLink in the constructor
  });

  @override
  _DeliveryBoxTileState createState() => _DeliveryBoxTileState();
}

class _DeliveryBoxTileState extends State<DeliveryBoxTile> {
  int participants = 0; // Counter for participants

void _joinDelivery() async {
    if (await canLaunch(widget.orderLink)) {
      await launch(widget.orderLink);
    } else {
      // Handle the error or show a message in case the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch the delivery link'),
        ),
      );
    }

    // Increment the count of participants
    setState(() {
      participants++; // Increment the count
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image(
              image: widget.image,
              width: 40,
              height: 40,
              color: Colors.white,
            ),
            title: Text(widget.title, style: TextStyle(color: widget.titleColor)),
            subtitle: Text(widget.subtitle, style: TextStyle(color: widget.subtitleColor)),
            trailing: _buildDeliveryStatusBox(widget.status),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Participants: $participants',
               style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      )),
            ElevatedButton(
  onPressed: _joinDelivery, // Update this call
  child: Text('Join Delivery'),
  style: ElevatedButton.styleFrom(
    primary: Colors.blueAccent,
    onPrimary: Colors.white,
  ),
),
            ],
          ),
        ],
      ),
    );
  }
Widget _buildDeliveryStatusBox(String status) {
  Color statusColor;
  switch (status) {
    case 'Pending':
      statusColor = Colors.orange;
      break;
    case 'In Transit':
      statusColor = Colors.blue;
      break;
    case 'Delivered':
      statusColor = Colors.green;
      break;
    default:
      statusColor = Colors.grey; // Default color for unknown status
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: statusColor,
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
}
class OrderDeliveryScreen extends StatefulWidget {
  @override
  _OrderDeliveryScreenState createState() => _OrderDeliveryScreenState();
}

class _OrderDeliveryScreenState extends State<OrderDeliveryScreen> {
  @override
  List<Widget> packageTiles = [];

  @override
  void initState() {
    super.initState();
    // Initialize your list with one package info or more if needed
    // 초기 주문 상태 적으면 돤다!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10), // Space before the warehouse title
              Text('Order Delivery', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8f89b7))),
              SizedBox(height: 10),
 ElevatedButton(
  onPressed: _showAddDeliveryDialog, // This calls the dialog function
  child: Text('+ Add New Delivery'),
  style: ElevatedButton.styleFrom(primary: Color(0xFF8f89b7)),
),
              
              SizedBox(height: 10),
              ...packageTiles, // This will display the list of tiles on the screen
              SizedBox(height: 20),
              
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
          status: 'In Transit',
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
    required String status, // Add a rating parameter
    Color titleColor = Colors.white,
    Color subtitleColor = Colors.white,
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
      child: Column(
        children: [
          ListTile(
            leading: Image(
              image: image,
              width: 40,
              height: 40,
              color: Colors.white,
            ),
            title: Text(title, style: TextStyle(color: titleColor)),
            subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
            trailing: _buildDeliveryStatusBox(status), // Call to the new method
          ),
          // If you want to add more content inside the box, add more widgets here
        ],
      ),
    );
  }
  Widget _buildDeliveryStatusBox(String status) {
  Color statusColor;
  switch (status) {
    case 'Pending':
      statusColor = Colors.orange;
      break;
    case 'In Transit':
      statusColor = Colors.blue;
      break;
    case 'Delivered':
      statusColor = Colors.green;
      break;
    default:
      statusColor = Colors.grey; // Default color for unknown status
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: statusColor,
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
Future<void> _showAddDeliveryDialog() async {
  String restaurantName = '';
  String orderTime = '';
  String orderLink = '';
  
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button to dismiss dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add New Delivery'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter restaurant name',
                ),
                onChanged: (value) {
                  restaurantName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter order completion time',
                ),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  orderTime = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter order Link',
                ),
                //keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  orderLink = value;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              // Call a method to add a new delivery info box
              _addNewDeliveryInfo(restaurantName, orderTime,orderLink);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
void _addNewDeliveryInfo(String restaurantName, String orderTime, String orderLink) {
  setState(() {
    Widget newTile = DeliveryBoxTile(
      image: AssetImage('assets/images/fast-delivery.png'),
      title: restaurantName,
      subtitle: 'Order Time: $orderTime',
      color: Color(0xFF8f89b7),
      titleColor: Colors.white,
      subtitleColor: Colors.white,
      status: 'Pending',
      orderLink: orderLink, // Pass the order link here
    );
    packageTiles.add(newTile);
  });
}

}
//=========================Delivery



//=========================Warehouse
class WarehouseManagementScreen extends StatefulWidget {
  @override
  _WarehouseManagementScreenState createState() => _WarehouseManagementScreenState();
}

class _WarehouseManagementScreenState extends State<WarehouseManagementScreen> {
  List<Map<String, dynamic>> packageData = [];
  int counter = 0; // A counter to assign unique IDs
  String category = 'Box'; // Move this to the state level

  @override
  void initState() {
    super.initState();
    // Initialize your list with default package info or more if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... existing Scaffold code ...
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ... existing widgets ...
              Text('WarehouseManage', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8f89b7))),
              SizedBox(height: 10),
              ...packageData.map((data) => _buildBoxedTile(
                id: data['id'],
                image: data['image'],
                title: data['title'],
                subtitle: data['subtitle'],
                color: data['color'],
              )).toList(),
              ElevatedButton(
                onPressed: _showAddPackageDialog,
                child: Text('+ Add New Item'),
                style: ElevatedButton.styleFrom(primary: Color(0xFF8f89b7)),
              ),
              // ... existing widgets ...
            ],
          ),
        ),
      ),
    );
  }

    void _showAddPackageDialog() {
    String location = '';
    String date = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder( // Use StatefulBuilder to update the dialog's state
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add New Package'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(hintText: 'Enter location'),
                      onChanged: (value) => location = value,
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'Enter date'),
                      onChanged: (value) => date = value,
                    ),
                    DropdownButton<String>(
                      value: category,
                      onChanged: (String? newValue) {
                        setState(() { // Update the dialog's state
                          category = newValue!;
                        });
                      },
                      items: <String>['Box', 'Refrigerator']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                      print('Adding Package: $location, $date, $category');
                    _addNewPackageInfo(location, date, category);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

 void _addNewPackageInfo(String location, String date, String category) {
    setState(() {
      packageData.add({
        'id': counter,
        'image': (category == 'Box') ? AssetImage('assets/images/box-linear.png') : AssetImage('assets/images/refrigerator.png'),
        'title': 'Location: $location',
        'subtitle': 'Date: $date - Category: $category',
        'color': Color(0xFF8f89b7),
      });
      counter++;
    });
  }
  void _removePackageInfo(int id) {
    setState(() {
      packageData.removeWhere((element) => element['id'] == id);
    });
  }

Widget _buildBoxedTile({
    required int id,
    required ImageProvider image,
    required String title,
    required String subtitle,
    required Color color,
    Color titleColor = Colors.white,
    Color subtitleColor = Colors.white,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
      child: Column(
        children: [
          ListTile(
            leading: Image(
              image: image,
              width: 40,
              height: 40,
              color: Colors.white,
            ),
            title: Text(
              title,
              style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: subtitleColor),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _removePackageInfo(id),
              child: Text('Remove', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(padding: EdgeInsets.all(8)),
            ),
          ),
        ],
      ),
    );
  }
}
//
 
//

// ware house=============================



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
