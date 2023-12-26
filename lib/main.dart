import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'api/api.dart';
import 'model/order.dart';
import 'model/item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  String _currentTitle = '메뉴';
  final PageController _pageController = PageController();
  final List<String> _titles = ['메뉴', '마이페이지', '알맹이'];
  void updateTitle(String title) {
    setState(() {
      _currentTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]), // AppBar 제목 설정
        backgroundColor: const Color(0xFF8f89b7),
        centerTitle: true,
        toolbarHeight: 80.0, // Increase the size of the top bar
      ),
      body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            HomeScreen(updateTitle: updateTitle), // updateTitle 함수를 전달합니다.
            MyPage(),
            const ScheduleScreen(),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF8f89b7),
        unselectedItemColor: const Color(0xFF8f89b7),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index); // 애니메이션 없이 페이지 변경
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '메뉴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이 페이지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '알맹이',
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
  const HomeScreen({super.key, required this.updateTitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xFFe7e5f1),
      child: Padding(
        padding: const EdgeInsets.only(top: 110), // Set top padding
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            createGridItem('RC & RA 소개', context, 'assets/images/office.png'),
            createGridItem('공지사항', context, 'assets/images/megaphone.png'),
            createGridItem('신고/건의', context, 'assets/images/alarm.png'),
            createGridItem('창고 사용', context, 'assets/images/boxes.png'),
            createGridItem(
                '배달 함께 주문', context, 'assets/images/fast-delivery.png'),
            createGridItem('프로그램 신청', context, 'assets/images/stage.png'),
            createGridItem('퇴사 점검', context, 'assets/images/moving-truck.png'),
            createGridItem('청소 점검', context, 'assets/images/cleaning.png'),
            createGridItem('POPO', context, 'assets/images/POPO.png'),
          ],
        ),
      ),
    );
  }

  Widget createGridItem(String title, BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        updateTitle(title);
        if (title == '배달 함께 주문') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const OrderDeliveryScreen(),
          ));
        } else if (title == '신고/건의') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ReportProposalScreen(),
          ));
        } else if (title == '창고 사용') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WarehouseManagementScreen(),
          ));
        } else if (title == '퇴사 점검') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const checkretirmentScreen(),
          ));
        } else if (title == '청소 점검') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const checkcleaningScreen(),
          ));
        } else if(title == '프로그램 신청'){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProgramRegisterScreen(),
          ));
            
        } else if (title == 'POPO') {
          // If the title is 'Manage Warehouses', then launch the URL
          _launchURL_popo();
        } else if (title == 'RC & RA 소개') {
          // Show dialog with options for RC 소개 and RA 소개
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'RC & RA 소개',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8f89b7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8f89b7),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to RCIntroductionScreen
                          _launchURL_RC();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .transparent, // Set button color to transparent
                          elevation: 0, // Remove button shadow
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'RC 소개',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8f89b7),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Show RA 조직도 content (You need to implement RAIntroductionScreen)
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RAIntroductionScreen(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .transparent, // Set button color to transparent
                          elevation: 0, // Remove button shadow
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
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
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        //child: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min, // Use min to fit content size
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 16.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    scale: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.all(8.0), // Add some padding around the text
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold, // Make the text bold
                  color: Color(0xFF8f89b7), // Set the text color
                  fontSize: 16.0, // Set the font size
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

//=========================// Program register


class ProgramRegisterScreen extends StatefulWidget {
  const ProgramRegisterScreen({super.key});

  @override
  _ProgramRegisterScreenState createState() => _ProgramRegisterScreenState();
}

class _ProgramRegisterScreenState extends State<ProgramRegisterScreen> {
  List<Map<String, dynamic>> packageData = [];
  int counter = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로그램 신청'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8f89b7),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              ...packageData.map((data) => _buildBoxedTile(data)).toList(),
              ElevatedButton(
                onPressed: _showAddPackageDialog,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8f89b7)),
                child: const Text('+ 프로그램 추가'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPackageDialog() {
    String title = '';
    String content = '';
    String capacity = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('프로그램 추가'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: '프로그램 제목'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: '프로그램 설명'),
                  onChanged: (value) => content = value,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: '정원'),
                  onChanged: (value) => capacity = value,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('추가'),
              onPressed: () {
                _addNewItem(title, content, int.tryParse(capacity) ?? 0);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewItem(String title, String content, int capacity) {
    setState(() {
      packageData.add({
        'id': counter,
        'title': title,
        'content': content,
        'capacity': capacity,
        'appliedCount': 0,
        'image': 'assets/images/stage.png', // Image path
        'color': const Color(0xFF8f89b7),
      });
      counter++;
    });
  }

  Widget _buildBoxedTile(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: data['color'],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ListTile(
        leading: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.white, // The color to apply
          BlendMode.srcIn, // Blend mode
        ),
        child: Image.asset(data['image']),
      ),
        title: Text(
          data['title'],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '신청인원: ${data['appliedCount']} / 정원: ${data['capacity']}',
          style: const TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () => _removeItem(data['id']),
        ),
        onTap: () => _showPackageDetails(data),
      ),
    );
  }

 void _showPackageDetails(Map<String, dynamic> data) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('프로그램 설명'),
        content: SingleChildScrollView(
          child: Text(data['content']),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('신청'),
            onPressed: () {
              _applyForProgram(data['id'], data['capacity']);
              Navigator.of(context).pop(); // Close the dialog here
            },
          ),
          TextButton(
            child: const Text('닫기'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

bool _applyForProgram(int id, int capacity) {
  bool appliedSuccessfully = false;
  setState(() {
    if (packageData.any((element) => element['id'] == id && element['appliedCount'] < capacity)) {
      packageData.firstWhere((element) => element['id'] == id)['appliedCount']++;
      appliedSuccessfully = true;
      _showSnackBar('신청 되었습니다',Color(0xFF8f89b7));
    } else {
      _showSnackBar('모집이 마감되었습니다', Color(0xFF8f89b7));
    }
  });
  return appliedSuccessfully;
}

  void _removeItem(int id) {
    setState(() {
      packageData.removeWhere((element) => element['id'] == id);
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color, // Set the background color to purple
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
//========================//program register

//=========================// Report
class ReportProposalScreen extends StatefulWidget {
  const ReportProposalScreen({super.key});

  @override
  _ReportProposalScreenState createState() => _ReportProposalScreenState();
}

class _ReportProposalScreenState extends State<ReportProposalScreen> {
  List<Map<String, dynamic>> packageData = [];
  int counter = 0; // A counter to assign unique IDs

  @override
  void initState() {
    super.initState();
    // Initialize your list with default package info or more if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('신고 / 건의'),
          centerTitle: true,
          backgroundColor: const Color(0xFF8f89b7)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text('Report/Proposal',
              //     style: TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.bold,
              //         color: Color(0xFF8f89b7))),
              const SizedBox(height: 10),
              ...packageData
                  .map((data) => _buildBoxedTile(
                        id: data['id'],
                        title: data['title'],
                        content: data['content'],
                        color: data['color'],
                      ))
                  .toList(),
              ElevatedButton(
                onPressed: _showAddPackageDialog,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8f89b7)),
                child: const Text('+ 글 작성'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPackageDialog() {
    String title = '';
    String content = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter title'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter content'),
                  onChanged: (value) => content = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _addNewItem(title, content);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewItem(String title, String content) {
    setState(() {
      packageData.add({
        'id': counter,
        'title': title,
        'content': content,
        'color': const Color(0xFF8f89b7),
      });
      counter++;
    });
  }

  Widget _buildBoxedTile({
    required int id,
    required String title,
    required String content,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _showPackageDetails(content),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _removeItem(id),
          ),
        ),
      ),
    );
  }

  void _showPackageDetails(String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Item Details'),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(int id) {
    setState(() {
      packageData.removeWhere((element) => element['id'] == id);
    });
  }
}

// Report=============================

//=========================RA 소개
class RAIntroductionScreen extends StatelessWidget {
  const RAIntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5f1),
      appBar: AppBar(
        title: const Text('RA 소개'),
        backgroundColor: const Color(0xFF8f89b7), // 연보라색으로 변경
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // RA 조직도 사진 추가
          Image.network(
            'https://i.ibb.co/b5VjvYq/Untitled.png',
            height: 600,
            width: 1000,
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

  const DeliveryBoxTile({
    super.key,
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
        const SnackBar(
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
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 2),
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
                color: const Color(0xFF8f89b7),
              ),
              // title: Text(widget.title,
              //     style: TextStyle(color: widget.titleColor)),
              subtitle: Row(
                children: [
                  Text("${widget.title}\n${widget.subtitle}",
                      style: TextStyle(color: widget.subtitleColor)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _joinDelivery,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF8f89b7),
                    ), // Update this call
                    child: const Text(
                      "주문 참여",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )

              // trailing: _buildDeliveryStatusBox(widget.status),
              ),
          // Text('Participants: $participants',
          //     style: const TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     )),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// 메뉴에서 선택하면 열리는 screen
class OrderDeliveryScreen extends StatefulWidget {
  const OrderDeliveryScreen({super.key});

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
    getOrders();
  }

  // DB에서 order 불러옴
  getOrders() async {
    packageTiles = [];

    try {
      var response = await http.get(Uri.parse(API.getOrders));

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: "Server Connected for Getting")
        var resGetOrders = jsonDecode(response.body);
        // Fluttertoast.showToast(msg: resGetOrders);

        for (int i = 1; i <= resGetOrders.length; i++) {
          _addNewDeliveryInfo(
              resGetOrders[resGetOrders.length - i]['restaurantName'],
              resGetOrders[resGetOrders.length - i]['orderTime'],
              resGetOrders[resGetOrders.length - i]['orderLink']);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
    }
  }

  // DB에 order 추가
  addOrder(String restaurantName, String orderTime, String orderLink) async {
    Order orderModel = Order(1, restaurantName, orderTime, orderLink);
    // Fluttertoast.showToast(msg: "add runned");
    try {
      var res =
          await http.post(Uri.parse(API.addOrder), body: orderModel.toJson());

      if (res.statusCode == 200) {
        // Fluttertoast.showToast(msg: "added successfully");
        var resAddOrder = jsonDecode(res.body);

        if (resAddOrder['success'] == true) {
          print('order added successfully!');
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5f1),
      appBar: AppBar(
        title: const Text('배달 함께 주문'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8f89b7),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10), // Space before the warehouse title
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _showAddDeliveryDialog,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFF8f89b7)), // This calls the dialog function
                child: const Text('+ 함께 주문 추가'),
              ),

              const SizedBox(height: 10),
              ...packageTiles, // This will display the list of tiles on the screen
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
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
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 2),
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
                color: const Color(0xFF8f89b7)),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        status,
        style: const TextStyle(
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
          title: const Text('함께 주문 추가'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    hintText: '가게 이름  ex)베라보',
                  ),
                  onChanged: (value) {
                    restaurantName = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '주문 예정 일시  ex)1월 1일 00:00',
                  ),
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) {
                    orderTime = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '오픈채팅방 링크',
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
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('추가'),
              onPressed: () {
                // Call a method to add a new delivery info box
                addOrder(restaurantName, orderTime, orderLink);
                // _addNewDeliveryInfo(restaurantName, orderTime, orderLink);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewDeliveryInfo(
      String restaurantName, String orderTime, String orderLink) {
    setState(() {
      Widget newTile = DeliveryBoxTile(
        image: const AssetImage('assets/images/fast-delivery.png'),
        title: restaurantName,
        subtitle: '주문 예정 일시 | $orderTime',
        color: Colors.white,
        titleColor: const Color(0xFF8f89b7),
        subtitleColor: const Color(0xFF8f89b7),
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
  const WarehouseManagementScreen({super.key});

  @override
  _WarehouseManagementScreenState createState() =>
      _WarehouseManagementScreenState();
}

class _WarehouseManagementScreenState extends State<WarehouseManagementScreen> {
  List<Map<String, dynamic>> packageData = [];
  String category = 'Box'; // Move this to the state level

  @override
  void initState() {
    super.initState();
    // Initialize your list with default package info or more if needed
    getItems();
  }

  // DB에서 item 불러옴
  getItems() async {
    packageData = [];

    try {
      var response = await http.get(Uri.parse(API.getItems));

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: "Server Connected for Getting");

        var resGetItems = jsonDecode(response.body);
        // Fluttertoast.showToast(msg: resGetItems[0]['itemCategory'].toString());

        for (int i = 0; i < resGetItems.length; i++) {
          _addNewPackageInfo(
              int.parse(resGetItems[i]['itemId']),
              int.parse(resGetItems[i]['studentId']),
              resGetItems[i]['itemLocation'],
              resGetItems[i]['itemDate'],
              resGetItems[i]['itemCategory']);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      print(e.toString());
    }
  }

  // DB에 item 추가
  addItem(int studentId, String itemLocation, String itemDate,
      String itemCategory) async {
    Item itemModel = Item(1, studentId, itemLocation, itemDate, itemCategory);
    // Fluttertoast.showToast(msg: "add runned");
    try {
      var res =
          await http.post(Uri.parse(API.addItem), body: itemModel.toJson());

      if (res.statusCode == 200) {
        // Fluttertoast.showToast(msg: "added successfully");
        var resAddItem = jsonDecode(res.body);

        if (resAddItem['success'] == true) {
          print('item added successfully!');
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5f1),
      appBar: AppBar(
        title: const Text('창고 사용'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8f89b7),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ... existing widgets ...
              // const Text('보관 물품 목록',
              //     textAlign: TextAlign.left,
              //     style: TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.bold,
              //         color: Color(0xFF8f89b7))),
              ElevatedButton(
                onPressed: _showAddPackageDialog,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8f89b7)),
                child: const Text('+ 보관 물품 추가'),
              ),
              const SizedBox(height: 10),
              ...packageData
                  .map((data) => _buildBoxedTile(
                        id: data['itemId'],
                        image: data['image'],
                        title: data['title'],
                        subtitle: data['subtitle'],
                        color: data['color'],
                      ))
                  .toList(),
              const SizedBox(height: 150),
              // ... existing widgets ...
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPackageDialog() {
    int studentId = 20200968;
    String location = '';
    String date = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to update the dialog's state
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('보관 물품 추가'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      decoration:
                          const InputDecoration(hintText: '보관 위치  ex)127'),
                      onChanged: (value) => location = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          hintText: '보관 날짜  ex)2023-01-01'),
                      onChanged: (value) => date = value,
                    ),
                    DropdownButton<String>(
                      value: category,
                      onChanged: (String? newValue) {
                        setState(() {
                          // Update the dialog's state
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
                  child: const Text('취소'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('추가'),
                  onPressed: () {
                    print('Adding Package: $location, $date, $category');
                    // _addNewPackageInfo(1, studentId, location, date, category);
                    addItem(studentId, location, date, category);
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

  void _addNewPackageInfo(int itemId, int studentId, String location,
      String date, String category) {
    // Fluttertoast.showToast(msg: "add runned");
    setState(() {
      packageData.add({
        'itemId': itemId,
        'studentId': studentId,
        'image': (category == 'Box')
            ? const AssetImage('assets/images/box-linear.png')
            : const AssetImage('assets/images/refrigerator.png'),
        'title': '보관 위치 | $location',
        'subtitle': '보관 날짜 | $date',
        'color': Colors.white,
      });
    });
  }

  void _removePackageInfo(int id) {
    setState(() {
      packageData.removeWhere((element) => element['itemId'] == id);
    });
  }

  Widget _buildBoxedTile({
    required int id,
    required ImageProvider image,
    required String title,
    required String subtitle,
    required Color color,
    Color titleColor = const Color(0xFF8f89b7),
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
              leading: Image(
                image: image,
                width: 50,
                height: 50,
                color: const Color(0xFF8f89b7),
              ),
              // title: Text(
              //   "$title\n$subtitle",
              //   style: TextStyle(color: titleColor),
              // ),
              subtitle: Row(
                children: [
                  Text(
                    "$title\n$subtitle",
                    style: TextStyle(
                      color: titleColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _removePackageInfo(id),
                    style:
                        TextButton.styleFrom(padding: const EdgeInsets.all(8)),
                    child: const Text('물품 찾기',
                        style: TextStyle(
                          color: Color(0xFF8f89b7),
                          decoration: TextDecoration.underline,
                        )),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
// ware house=============================

class DetailScreen extends StatelessWidget {
  final String title;

  const DetailScreen({super.key, required this.title});

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
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFe7e5f1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime(2000),
            //       lastDate: DateTime(2101),
            //     );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xFF8f89b7), // 연보라색
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 24.0, vertical: 16.0), // 크기 조절
            //   ),
            //   // child: const Text('Pick a date'),
            // ),
            const SizedBox(height: 8.0), // 버튼과 이미지 사이 여백 조절
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
  final String profile = "박OO 조OO";

  final List<String> programType = ["전체 행사", "둥지"];
  final List<String> programTitles = ["RC 잔치", "베이킹 둥지"];
  final List<String> programDetails = [
    "2023.10.22 19:00 | RC 1층",
    "2023.10.22 19:00 | 휴게실4"
  ];

  final int quantity = 1;
  final String storageLocation = "R11";
  final String storageDate = "2023-12-25";

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5f1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Remove the top bar
        child: AppBar(
          backgroundColor: const Color(0xFF8f89b7), // Similar color theme
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
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: <Widget>[
          Image.network(
            'https://i.ibb.co/RB8dzVk/2023-12-20-210902.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('이름 | $name', style: const TextStyle(fontSize: 16)),
                const Text('학과 | 산업경영공학과',
                    style: TextStyle(fontSize: 16)), // 이미지에 따라 학과명 추가
                Text('호수 | $room', style: const TextStyle(fontSize: 16)),
                const Text('룸메이트 | 박정은',
                    style: TextStyle(fontSize: 16)), // 이미지에 따라 룸메이트 이름 추가
                Text('담당 RA | $profile', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // 박스 배경 흰색
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            programType[index],
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 6),
          Text(
            programTitles[index],
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 2),
          Text(
            programDetails[index],
            style: const TextStyle(
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Image(
            image: AssetImage('assets/images/refrigerator.png'),
            width: 60,
            height: 60,
            color: Color(0xFF8f89b7),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text('수량 | $quantity', style: const TextStyle(fontSize: 16)),
                Text('보관 위치 | $storageLocation',
                    style: const TextStyle(fontSize: 16)),
                Text('보관 날짜 | $storageDate',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//퇴사점검========================
class checkretirmentScreen extends StatefulWidget {
  const checkretirmentScreen({super.key});

  @override
  _checkretirmentScreenState createState() => _checkretirmentScreenState();
}

class _checkretirmentScreenState extends State<checkretirmentScreen> {
  List<Map<String, dynamic>> packageData = [];
  int counter = 0; // A counter to assign unique IDs

  @override
  void initState() {
    super.initState();
    // Initialize your list with default package info or more if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퇴사 점검'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8f89b7),
      ),
      backgroundColor: const Color(0xFFe7e5f1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text(
              //   '퇴사점검',
              //   style: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xFF8f89b7)),
              // ),
              Container(
                margin: const EdgeInsets.all(60.0), // 주변 여백 설정
                padding: const EdgeInsets.all(36.0), // 카드 내부 여백 설정
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton(context, '퇴사 점검 예약', _reservecheckout),
                    const SizedBox(height: 16),
                    _buildButton(context, '퇴사 점검표 작성', _writecheckouttable),
                    const SizedBox(height: 16),
                    _buildButton(context, '퇴사 점검 현황', _checkingcurrentstate),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, // 버튼 너비를 최대로 설정
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF8f89b7), // 버튼 텍스트 색상
          elevation: 0, // 그림자 효과 제거
          shape: RoundedRectangleBorder(
            // 모서리 둥글게 설정
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0), // 버튼 내부 패딩 설정
        ),
        child: Text(text),
      ),
    );
  }

  void _reservecheckout() {
    String title = '';
    String content = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('희망점검시간'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'Enter date ex) 2023-12-22 (금)'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter time ex) 9:00am'),
                  onChanged: (value) => content = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('add'),
              onPressed: () {
                _addNewItem1(title, content);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewItem1(String title, String content) {
    setState(() {
      packageData.add({
        'id': counter,
        'title': title,
        'content': content,
        'color': const Color(0xFF8f89b7),
      });
      counter++;
    });
  }

  void _writecheckouttable() {
    String title = '';
    String content = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('퇴사점검표'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'checklist 확인완료'),
                  onChanged: (value) => title = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('add'),
              onPressed: () {
                _addNewItem2(title, content);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewItem2(String title, String content) {
    setState(() {
      packageData.add({
        'id': counter,
        'title': title,
        'content': content,
        'color': const Color(0xFF8f89b7),
      });
      counter++;
    });
  }

  void _checkingcurrentstate() {
    String title = '';
    String content = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예정점검시간'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration:
                      const InputDecoration(hintText: '2023-12-22 (금) 9:00 am'),
                  onChanged: (value) => title = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

// 퇴사점검=============================

//대청소점검========================
class checkcleaningScreen extends StatefulWidget {
  const checkcleaningScreen({super.key});

  @override
  _checkcleaningScreenState createState() => _checkcleaningScreenState();
}

class _checkcleaningScreenState extends State<checkcleaningScreen> {
  List<Map<String, dynamic>> packageData = [];
  int counter = 0; // A counter to assign unique IDs

  @override
  void initState() {
    super.initState();
    // Initialize your list with default package info or more if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('청소 점검'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8f89b7),
      ),
      backgroundColor: const Color(0xFFe7e5f1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text(
              //   '청소 점검',
              //   style: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xFF8f89b7)),
              // ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(60.0), // 주변 여백 설정
                padding: const EdgeInsets.all(36.0), // 카드 내부 여백 설정
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton(context, '청소 점검 예약', _reservecheckout),
                    const SizedBox(height: 16),
                    _buildButton(context, '청소 점검표 작성', _writecheckouttable),
                    const SizedBox(height: 16),
                    _buildButton(context, '청소 점검 현황', _checkingcurrentstate),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, // 버튼 너비를 최대로 설정
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF8f89b7), // 버튼 텍스트 색상
          elevation: 0, // 그림자 효과 제거
          shape: RoundedRectangleBorder(
            // 모서리 둥글게 설정
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0), // 버튼 내부 패딩 설정
        ),
        child: Text(text),
      ),
    );
  }

  void _reservecheckout() {
    String title = '';
    String content = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('희망점검시간'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter time ex) 9:00am'),
                  onChanged: (value) => content = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('add'),
              onPressed: () {
                _addNewItem1(title, content);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewItem1(String title, String content) {
    setState(() {
      packageData.add({
        'id': counter,
        'title': title,
        'content': content,
        'color': const Color(0xFF8f89b7),
      });
      counter++;
    });
  }

  void _writecheckouttable() {
    String title = '';
    String content = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('청소점검표'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'checklist 확인완료'),
                  onChanged: (value) => title = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('add'),
              onPressed: () {
                _addNewItem2(title, content);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewItem2(String title, String content) {
    setState(() {
      packageData.add({
        'id': counter,
        'title': title,
        'content': content,
        'color': const Color(0xFF8f89b7),
      });
      counter++;
    });
  }

  void _checkingcurrentstate() {
    String title = '';
    String content = '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예정점검시간'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: '9:00 am'),
                  onChanged: (value) => title = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

// 대청소점검=============================
