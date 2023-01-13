import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'OtpForm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CodeNotifier(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: CodeVerificationScreen(),
      ),
    );
  }
}

class CodeVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CodeNotifier(),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text("Enter 7 digit code"),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) {
                  return Container(
                    height: 55,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) {
                          Provider.of<CodeNotifier>(context, listen: false).updateCode(value,index);
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.length == 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        showCursor: false,
                        readOnly: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counter: Offstage(),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.black12),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.purple),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Text("Code is: ${Provider.of<CodeNotifier>(context).code}"),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OtpForm()),
                  );
                },
                child: Text("Second"))
          ],
        ),
      ),
    );

  }
}

class CodeNotifier extends ChangeNotifier {
  List<String> _code = List.filled(7, "");

  List<String> get code => _code;

  void updateCode(String value, int index) {
    _code[index] = value;
    notifyListeners();
  }
}
