import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:beh_kbbi/util/constColor.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController search = TextEditingController();
  FlutterTts? flutterTts;

  Future<void> initializeTts(String param) async {
    flutterTts = FlutterTts();
    await flutterTts!.setLanguage('id-ID');
    await flutterTts!.setPitch(1.0);
    await flutterTts!.speak('$param');
  }

  var dataSearch;
  void sendRequest(String param) async {
    final url = Uri.parse('https://typoonline.com/api-kbbi/$param');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        dataSearch = response.body;
        print(dataSearch);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myPrimary,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100.h,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: myPrimary),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (search.text == '')
                      ? Text('')
                      : Text(
                          search.text,
                          style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                  (search.text == '')
                      ? SizedBox()
                      : GestureDetector(
                          onTap: () {
                            initializeTts(search.text);
                          },
                          child: const Icon(
                            Icons.volume_up_rounded,
                            size: 25,
                            color: Color(0xFFF7DC15),
                          ),
                        )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 50.h,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.grey),
              child: TextFormField(
                controller: search,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  suffixIconColor: Color(0xFF000000),
                  suffixIcon: Icon(Icons.search),
                ),
                cursorColor: Color(0xFF000000),
                onChanged: (value) {
                  sendRequest(search.text);
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r))),
              child: (search.text == '')
                  ? SizedBox()
                  : Html(
                      data: '$dataSearch',
                      style: {'h2': Style(color: myPrimary)},
                    ),
            )
          ],
        ),
      )),
    );
  }
}
