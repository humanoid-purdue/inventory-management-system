import 'package:flutter/material.dart';
import 'package:inventory_management_system/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 140.0,
            ),
            Container(
              child: Center(
                  child: Text(
                    "Inventory Management System",
                    style: TextStyle(
                        fontSize: 45, color: Color.fromRGBO(0, 0, 128, 10)),
                  )),
            ),
            Container(
              child: Image.asset(
                'lib/hrc.png',
                height: 300,
                width: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white60,
                  hintText: 'Enter your email',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white60,
                  hintText: 'Enter your password',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 42.0,
            ),
            InkWell(
              child: new Text("Admin Panel"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: "Register Page",
                      )),
                );
              },
            ),
            SizedBox(
              height: 42.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Material(
                color: Color.fromRGBO(255, 188, 33, 10),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    print('pressed');
                  },
                  minWidth: 330.0,
                  height: 42.0,
                  child: Text(
                    style: TextStyle(color: Color.fromRGBO(0, 0, 128, 10)),
                    'Log In',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
    );  }
}
