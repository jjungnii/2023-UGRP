import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const AppleHomePage());
}

class AppleHomePage extends StatelessWidget {
  const AppleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apple Homepage',
      theme: ThemeData(
        primaryColor: const Color(0xFFA374DB),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  color: const Color(0xFFA374DB),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: const Center(
                    child: Text(
                      'Apple',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 800,
                        ),
                        child: buildBody(context),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xFFA374DB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildFooterBox(context, Icons.headset, 'Audio',
                          Colors.white, const AudioPage()),
                      buildFooterBox(context, Icons.tv, 'TV', Colors.white,
                          const TVPage()),
                      buildFooterBox(context, Icons.calendar_today, 'Calendar',
                          Colors.white, const CalendarPage()),
                      buildFooterBox(context, Icons.print, 'Print',
                          Colors.white, const PrintPage()),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        IconData icon;
        String title;
        Color color;
        Color textColor = Colors.white;

        switch (index) {
          case 0:
            icon = Icons.phone_iphone;
            title = 'iPhone';
            color = const Color(0xFFD399F0);
            break;
          case 1:
            icon = Icons.watch;
            title = 'Watch';
            color = const Color(0xFF9F9CE9);
            break;
          case 2:
            icon = Icons.computer;
            title = 'Mac';
            color = const Color(0xFF7CD7CB);
            break;
          case 3:
            icon = Icons.tablet_mac;
            title = 'iPad';
            color = const Color(0xFFF6C373);
            break;
          case 4:
            icon = Icons.headphones;
            title = 'Audio';
            color = const Color(0xFFFF8E98);
            break;
          case 5:
            icon = Icons.tv;
            title = 'TV';
            color = const Color(0xFFB4E080);
            break;
          case 6:
            icon = Icons.home;
            title = 'HomePod';
            color = const Color(0xFFD98EE3);
            break;
          case 7:
            icon = Icons.camera_alt;
            title = 'Camera';
            color = const Color(0xFFE8CCE5);
            break;
          case 8:
            icon = Icons.print;
            title = 'Print';
            color = const Color(0xFFB5D9C9);
            break;
          default:
            icon = Icons.help;
            title = 'Other';
            color = const Color(0xFFDDDDDD);
            break;
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailPage(title: title)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFooterBox(BuildContext context, IconData icon, String title,
      Color color, Widget? nextPage) {
    return GestureDetector(
      onTap: () {
        if (nextPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        }
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 40,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;

  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('This is the $title page'),
      ),
    );
  }
}

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio'),
      ),
      body: const Center(
        child: Text('This is the Audio page'),
      ),
    );
  }
}

class TVPage extends StatelessWidget {
  const TVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV'),
      ),
      body: const Center(
        child: Text('This is the TV page'),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Appointments for ${_selectedDay?.toString() ?? 'Select a day'}:',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Appointment 1: ...',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Appointment 2: ...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrintPage extends StatelessWidget {
  const PrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print'),
      ),
      body: const Center(
        child: Text('This is the Print page'),
      ),
    );
  }
}
