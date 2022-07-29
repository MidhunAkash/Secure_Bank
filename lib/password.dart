import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_code/Account.dart';
import 'package:flutter_native_code/vstatic.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

void main() => runApp(MaterialApp(
  home: Pasword(),
  debugShowCheckedModeBanner: false,
));


class Pasword extends StatefulWidget {
  @override
  _PaswordState createState() => _PaswordState();
}

class _PaswordState extends State<Pasword> {

  Future<bool> icheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  internetAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "NO INTERNET",
        desc: "Please check your network connection.",
        type: AlertType.info,
        closeIcon: IconButton(icon: Icon(Icons.close),onPressed:(){
          Navigator.pop(context);
          icheck().then((intenet) {
            if ((intenet != null && intenet) != true) {
              internetAlert();
            }
          });
        },),
        buttons: [
          DialogButton(
            child: Text("Try again",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
              icheck().then((intenet) {
                if ((intenet != null && intenet)!=true) {
                  internetAlert();
                }
              });
            },
            width: 140,
          ),
        ]
    ).show();
  }
  Future setpas() async{
    var url = 'https://securebnk950.000webhostapp.com/prj/setpas.php';
    await http.post(Uri.parse(url),body: {
      'user': Stat.login[Stat.usd][0],
      'pass': Stat.pas[Stat.usd]
    });
  }

  bool _secure = true;
  bool _csecure = true;
  TextEditingController pas = new TextEditingController();
  TextEditingController inp1 = new TextEditingController();
  String _pass;
  double stval;

  Future<bool> _onWillPop() {
    return Alert(
        onWillPopActive: true,
        context: context,
        title: "Are you sure ?",
        desc: "Do you really want to go back?",
        type: AlertType.none,
        closeIcon: Icon(Icons.close),
        buttons: [
          DialogButton(
            child: Text("No",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.blue[800],
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            width: 60,
          ),
          DialogButton(
            child: Text("Yes",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.blue[800],
            onPressed: () {
              if(Stat.page.compareTo("Change")==0){
                Stat.ramail = "";
                Stat.page = "";
                Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
              }
              else{
                Stat.ramail = "";
                Stat.page = "";
                Phoenix.rebirth(context);
              }
            },
            width: 80,
          )
        ]
    ).show();
  }

  _mypstrength() {
    print("Called");
    if(_pass != null) {
      print("brfore Current Password s: $stval");
      if (_pass.length < 8) {
        return Text("Too short",
          style: TextStyle(
              color: Colors.red,
            fontSize: 17
          ),
        );
      }
      else if (stval >= 0.88) {
        print("Current Password s: $stval");
        return Text("Strong",
          style: TextStyle(
              color: Colors.green,
              fontSize: 17
          ),
        );
      }
      else {
        return Text("week",
          style: TextStyle(
              color: Colors.red,
              fontSize: 17
          ),
        );
      }
    }
    else{
      return Text("");
    }

  }
  @override
  Widget build(BuildContext context) {
    showAlert(){
      Alert(
          onWillPopActive: true,
          context: context,
          title: "Warning!",
          desc: "Current password is not matched with new password.",
          type: AlertType.warning,
          closeIcon: Icon(Icons.close),
          buttons: [
            DialogButton(
              child: Text("Try again",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
              width: 140,
            ),
          ]

      ).show();
    }
    showAlert2(){
      Alert(
          onWillPopActive: true,
          context: context,
          title: "Warning!",
          desc: "You New Password is week.\n Please check!",
          type: AlertType.warning,
          closeIcon: Icon(Icons.close),
          buttons: [
            DialogButton(
              child: Text("Try again",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
              width: 140,
            ),
          ]

      ).show();
    }
    showAlert3(){
      Alert(
          onWillPopActive: true,
          context: context,
          title: "Password Changed!",
          desc: "Yor password changed successfully.\n Press the button to login with new password",
          closeIcon: Icon(Icons.ac_unit,size: 0.1,),
          type: AlertType.success,
          buttons: [
            DialogButton(
              child: Text("Go to Login Page",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              color: Colors.blue,
              onPressed: () {

                Phoenix.rebirth(context);
              },
              width: 200,
            ),
          ]

      ).show();
    }
    check(String nps,String cps){
      if (stval >= 0.88) {
        if (nps.compareTo(cps) == 0) {
          Stat.pas[Stat.usd] = _pass;
          setpas();
          Stat.ramail = "";
          showAlert3();
        }
        else {
          showAlert();
        }
      }
      else{
        showAlert2();
      }
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            brightness: Brightness.dark,
            titleSpacing: 1.0,
            automaticallyImplyLeading: false,
            shape: ContinuousRectangleBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60.0),
                bottomRight:  Radius.circular(60.0),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                        _onWillPop();
                    });
                  },
                ),
                Text("${Stat.page} Password",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            elevation: 5,
            backgroundColor: Colors.blue[900],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0,0),
                          blurRadius: 2.0)
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text("Password Instructions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                    Container(
                      width: 350.0,
                      child: FittedBox(
                      fit: BoxFit.contain,
                      child:Text("1. Password must contain 8-16 characters."),
                    )
                  ),
                      Container(
                          width: 350.0,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child:Text("2. Password should contain Special characters."),
                          )
                      ),
                      SizedBox(height: 10,),
                      Text("Hint: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                          Container(
                              width: 350,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child:Text("You can always check the password in the strength bar."),
                              )
                          ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text("New Password:",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 55,
                  child: TextField(
                    obscureText: _secure,
                    cursorHeight: 25,
                    controller: pas,
                    onChanged: (pas)=>setState((){_pass=pas;
                    }),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(16),
                    ],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        labelText: 'Enter New password',
                        suffixIcon: IconButton(icon: Icon(
                            _secure ? Icons.visibility_off_rounded:Icons.visibility_rounded),
                            onPressed: () {
                              setState(() {
                                _secure = !_secure;
                              });
                            }
                        )
                    ),
                    autofocus: false,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Password Stength :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 5,),
                    _mypstrength(),
                  ],
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 15),
                  child: FlutterPasswordStrength(
                      password: _pass,
                      height: 10,
                      radius: 10,
                      backgroundColor: Colors.grey[350],
                      strengthCallback: (strength){
                        debugPrint(strength.toString());
                        stval = strength;
                      }
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  height: 55,
                  child: TextField(
                    obscureText: _csecure,
                    cursorHeight: 25,
                    controller: inp1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(16),
                    ],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        labelText: 'Confirm password',
                        suffixIcon: IconButton(icon: Icon(
                            _csecure ? Icons.visibility_off_rounded:Icons.visibility_rounded),
                            onPressed: () {
                              setState(() {
                                _csecure = !_csecure;
                              });
                            }
                        )
                    ),
                    autofocus: false,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Center(
                  // ignore: deprecated_member_use
                  child: RaisedButton(onPressed: () {
                    icheck().then((intenet) {
                      if ((intenet != null && intenet)!=true) {
                        internetAlert();
                      }
                      else{
                        setState(() {
                          check(pas.text.toString(),inp1.text.toString());
                        });
                      }
                    });
                  },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.grey[600]),
                      ),
                      color: Colors.blue[600],
                      elevation: 10.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: 230,
                          child: Text('${Stat.page} Password',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24
                            ),
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(height: 25,),
              ],
            ),
          ),
        ),

      ),
    );
  }
}