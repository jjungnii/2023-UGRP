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
  String _currentTitle = 'Menu';
  final PageController _pageController = PageController();
  final List<String> _titles = ['Menu','My Page', 'Calendar'];
  void updateTitle(String title) {
    setState(() {
      _currentTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _pages 리스트를 여기서 초기화합니다.
    final List<Widget> _pages = [
      HomeScreen(updateTitle: updateTitle), // updateTitle 함수를 전달합니다.
      MyPage(),
      ScheduleScreen(),
      NotificationScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]), // AppBar 제목 설정
        backgroundColor: Color(0xFF8f89b7),
        centerTitle: true,
        toolbarHeight: 80.0, // Increase the size of the top bar
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF8f89b7),
        unselectedItemColor: Color(0xFF8f89b7),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index); // 애니메이션 없이 페이지 변경
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calander',
          ),
          // 여기에 추가 BottomNavigationBarItem들을 정의합니다.
        ],
        // BottomNavigationBarItem 설정...
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

 

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
            title: Text('Choose an option', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF8f89b7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to RCIntroductionScreen
                      _launchURL_RC();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Set button color to transparent
                      elevation: 0, // Remove button shadow
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'RC 소개',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF8f89b7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Show RA 조직도 content (You need to implement RAIntroductionScreen)
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RAIntroductionScreen(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Set button color to transparent
                      elevation: 0, // Remove button shadow
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'RA 소개',
                        style: TextStyle(color: Colors.white),
                  ),
                  ),
                ),
              ),
            ],
          ),
         );
      },
     );

      } else {
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
        backgroundColor: Color(0xFF8f89b7), // 연보라색으로 변경

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // RA 조직도 사진 추가
          Image.network(
            'https://i.ibb.co/b5VjvYq/Untitled.png',
            height:600,
            width:1000,
          ),
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

///달력=============================================
class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF8f89b7), // 연보라색
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // 크기 조절
              ),
              child: Text('Pick a date'),
            ),
            SizedBox(height: 8.0), // 버튼과 이미지 사이 여백 조절
            Image.network(
              'https://i.ibb.co/17C0r9Q/2023-12-20-211943.png', // 이미지 URL로 수정
              
              height: 300,
              width: 400,
            ),
          ],
        ),
      ),
    );
  }
}

//mypage =====================================================
class MyPage extends StatelessWidget {
  // Define variables for the text content
  final String name = "박지원";
  final String studentId = "20200000";
  final String room = "1022호";
  final String profile = "유현아 이승은";

  final List<String> programType = ["층 프로그램","전체 행사", "둥지"];
  final List<String> programTitles = ["카네이션 만들기", "RC 잔치", "베이킹 둥지"];
  final List<String> programDetails = [
    "2023.10.22 19:00 / 층홀",
    "2023.10.22 19:00 / RC 1층",
    "2023.10.22 19:00 / 휴게실4"
  ];

  final int quantity = 1;
  final String storageLocation = "129";
  final String storageDate = "2023.10.22";
 
   
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPersonInfo(),
            _buildProgramSection(),
            _buildStorageSection()
          ],
        ),
      ),
    );
  }

  Widget _buildPersonInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical:22.0, horizontal : 16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: <Widget>[
          Image.network(
              'https://i.ibb.co/RB8dzVk/2023-12-20-210902.png',
              width:100,
              height:100,
              fit: BoxFit.cover,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name: $name', style: TextStyle(fontSize: 16)),
                Text('Department: 산업경영공학과', style: TextStyle(fontSize: 16)), // 이미지에 따라 학과명 추가
                Text('Room: $room', style: TextStyle(fontSize: 16)),
                Text('Roommates: 박정은', style: TextStyle(fontSize: 16)), // 이미지에 따라 룸메이트 이름 추가
                Text('Ra: $profile', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '프로그램 신청 내역',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8f89b7),
            ),
          ),
          ...List.generate(programTitles.length, (index) {
            return _buildProgramInfo(index);
          }),
        ],
      ),
    );
  }

  Widget _buildProgramInfo(int index) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // 박스 배경 흰색
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            programType[index],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
          SizedBox(height: 6),
          Text(
            programTitles[index],
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          ),
          SizedBox(height: 2),
          Text(
            programDetails[index],
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '물품 보관 내역',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8f89b7),
            ),
          ),
         _buildStorageInfo(),
        ],
      ),
    );
  }

  Widget _buildStorageInfo() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
            Image.network(
                'https://i.ibb.co/9NYPHc4/2023-12-20-213703.png',
                width: 100,
                height: 100,
                fit:BoxFit.cover,
            ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('수량: $quantity', style: TextStyle(fontSize: 16)),
                Text('보관위치: $storageLocation', style: TextStyle(fontSize: 16)),
                Text('보관일: $storageDate', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//알림=============================================
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF8f89b7), // 연보라색
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // 크기 조절
              ),
              child: Text('Pick a date'),
            ),
            SizedBox(height: 8.0), // 버튼과 이미지 사이 여백 조절
          ],
        ),
      ),
    );
  }
}