import 'package:flutter/material.dart';
import 'package:flutter_native_code/login.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_native_code/vstatic.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(
    child:
    MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    Future.delayed(Duration.zero,() async {
      var url = 'https://securebnk950.000webhostapp.com/prj/getaccc.php';
      try{
        http.Response response = await http.get(Uri.parse(url));
        String data = (response.body).toString();
        List acc;
        acc = data.split("#");
        int row = acc.length-1;
        int col = 5;
        int z =0;
        // ignore: deprecated_member_use
        Stat.login = List.generate(row, (i) => List(col), growable: false);
        // ignore: deprecated_member_use
        Stat.pas = List<String>(row);
        // ignore: deprecated_member_use
        Stat.balance = List<String>(row);
        setState(() {
          for(int i=0;i<acc.length-1;i++){
            Stat.login[i] = acc[i].split("  ");
            Stat.pas[i] = Stat.login[i][1].toString().trim();
            Stat.balance[i] = Stat.login[i][4].toString().trim();
          }
          print("await");
          print(Stat.update1);
        });
      }
      catch(e){
        Stat.update1 = true;
        print("Cauth");
        print(Stat.update1);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Secure Bank',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Login()
    );
  }
}



