import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nemo/homepage.dart';

class VideoDataInput extends StatefulWidget {
  const VideoDataInput({Key? key}) : super(key: key);

  @override
  _VideoDataInputState createState() => _VideoDataInputState();
}

class _VideoDataInputState extends State<VideoDataInput> {
  @override
  void initState() {
    super.initState();
    _tempfn();
  }

  var _temp;
  void _tempfn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _temp = prefs.getString('folderlocation');
    });
  }

  void _saveaddress(String abc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var counter = prefs.getString('folderlocation');
    print('Pressed $counter times.');
    await prefs.setString('folderlocation', abc);
  }

  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 > 600
                  ? 600
                  : MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    hintText: "Current Folder : $_temp", //the actual variable
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: _saveaddress,
              ),
              color: Colors.white.withOpacity(0.16),
            ),
            // TextButton(
            //   child: Text("print the result"),
            //   onPressed: () async {
            //     SharedPreferences prefs = await SharedPreferences.getInstance();
            //     var counter = prefs.getString('folderlocation');
            //     print("$counter <= value");
            //     _tempfn();
            //     //_saveaddress();
            //     print("$_temp ghjdgjgf g");
            //   },
            // ),
            TextButton(
              child: Text("Done"),
              onPressed: () {
                //_saveaddress();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
