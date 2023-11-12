import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primaryColor: Color(0xFFA374DB),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAdminChecked = false;
  bool isOtherChecked = true; // Set this to true to make "Other" the default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Remove the top bar
        child: AppBar(
          backgroundColor: Color(0xFFe7e5f1),
          elevation: 0,
        ),
      ),
      backgroundColor: Color(0xFFe7e5f1), // Set the background color to mauve
      body: Center(
        // Center everything vertically and horizontally
        child: Container(
          width: 400, // Set the width of the login box
          decoration: BoxDecoration(
            color: Color(0xFFe7e5f1), // Mauve background color for the login box
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center the login box vertically
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Login', // Add the word "Login" at the top
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF8f89b7), // White text color
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, // White login box
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Center the login box vertically
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the checkboxes horizontally
                      children: <Widget>[
                        Checkbox(
                          value: isAdminChecked,
                          onChanged: (value) {
                            setState(() {
                              isAdminChecked = value ?? false;
                              if (isAdminChecked) {
                                isOtherChecked = false;
                              }
                            });
                          },
                          activeColor: Color(0xFF8f89b7), // Mauve background color
                        ),
                        Text('Admin'),
                        SizedBox(width: 20), // Add some horizontal spacing
                        Checkbox(
                          value: isOtherChecked,
                          onChanged: (value) {
                            setState(() {
                              isOtherChecked = value ?? false;
                              if (isOtherChecked) {
                                isAdminChecked = false;
                              }
                            });
                          },
                          activeColor: Color(0xFF8f89b7), // Mauve background color
                        ),
                        Text('Other'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Grey box for ID
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'ID',
                          labelStyle: TextStyle(color: Color(0xFF8f89b7)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF8f89b7),
                          ),
                          border: InputBorder.none, // Remove border
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Grey box for Password
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Color(0xFF8f89b7)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF8f89b7),
                          ),
                          border: InputBorder.none, // Remove border
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add your login logic here
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF8f89b7), // Mauve background color
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
