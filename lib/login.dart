import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_code/validation.dart';
import 'package:flutter_native_code/vstatic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MaterialApp(

  home: Login(),
  debugShowCheckedModeBanner: false,
));

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  _launchURL() async {
    const url = 'https://securebnk950.000webhostapp.com/prj/form.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchURL2() async {
    const url = 'https://securebnk950.000webhostapp.com/prj/download_app.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
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
            else {
              Stat.update1 = false;
              Phoenix.rebirth(context);
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
                else{
                  Stat.update1 = false;
                  Phoenix.rebirth(context);
                }
              });
            },
            width: 140,
          ),
        ]
    ).show();
  }
  TextEditingController inp1 = new TextEditingController();
  TextEditingController inp2 = new TextEditingController();
  TextEditingController inp3 = new TextEditingController();
  TextEditingController inp4 = new TextEditingController();
  String usr='',psw='';
  String user, pasword;
  bool _secure = true;

  check(String usrn,String pasw){
    bool flag = false;
    for(int i=0;i<Stat.pas.length;i++){
      user = Stat.login[i][0].toString();
      pasword = Stat.pas [i].toString();
      if(usrn.compareTo(user) == 0){
        if(pasw.compareTo(pasword) == 0){
          Stat.usd = i;
          flag = true;
          break;
        }
      }
    }
    if(flag){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Valid()));
    }
    else{
      showAlert();
    }

  }

  warnAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "Incorrect Username!",
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
  warnAlert2(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Security Update!",
        desc: "This is an important Security Update to app. Service will be continued after "
            "downloading the new app.",
        type: AlertType.warning,
        closeIcon: Icon(Icons.close),
        buttons: [
          DialogButton(
            child: Text("Download",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
              _launchURL2();
            },
            width: 140,
          ),
        ]
    ).show();
  }
  bool checkuser(){
    for(int i=0;i<Stat.login.length;i++){
      if(inp3.text.toString().compareTo(Stat.login[i][0])==0){
        Stat.usd = i;
        return true;
      }
    }
    return false;
  }

  newAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Username",
        desc: "To rest password you need to enter the username",
        content: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Container(
            height: 55,
            child: TextField(
              cursorHeight: 24,
              controller: inp3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8))
                ),
                labelText: 'Enter User-ID',
              ),
              autofocus: false,
              style: TextStyle(
                fontSize: 24,
              ),

            ),
          ),
        ),
        closeIcon: IconButton(icon: Icon(Icons.close),onPressed:(){
          Navigator.pop(context);
          setState(() {
            Stat.ramail="";
          });
        },),
        buttons: [
          DialogButton(
            child: Text("Confirm",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.blue[800],
            onPressed: () {
              icheck().then((intenet) {
                if ((intenet != null && intenet)!=true) {
                  internetAlert();
                }
                else{
                  setState(() {
                    if(checkuser()){
                      Navigator.pop(context);
                      Stat.ramail="rmail";
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Valid()));
                    }
                    else{
                      Stat.page="";
                      warnAlert();
                    }
                  });
                }
              });
            },
            width: 130,
          )
        ]
    ).show();
  }

  showAlert(){
    Alert(
      onWillPopActive: true,
      context: context,
      title: "Warning!",
      desc: "Invalid Username/password.",
      type: AlertType.warning,
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
            Phoenix.rebirth(context);
          },
          width: 140,
        ),
      ]
    ).show();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(70.0),
              bottomRight:  Radius.circular(70.0),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Login',
                    style: TextStyle(
                      fontSize: 25
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _launchURL();
                        SystemNavigator.pop();
                      });
                    },
                    child: Text("Sign-Up",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          backgroundColor: Colors.blue[900],
          elevation: 10.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 45.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  child: Image.asset('assets/banklogo.png',
                    height: 130,
                    width: 300,
                  ),

                ),
              ),
              SizedBox(height: 25,),
              Text(
                'Username:',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              SizedBox(height: 15.0,),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
                        width: 350,
                        height: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          cursorHeight: 25,
                          controller: inp1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            labelText: 'Enter User-ID',
                          ),
                          autofocus: false,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                    )
                  ]
              ),
              SizedBox(height: 20.0,),
              Text(
                'Password:',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              SizedBox(height: 15.0,),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
                        width: 350,
                        height: 50,
                        child: TextField(
                          obscureText: _secure,
                          cursorHeight: 25,
                          controller: inp2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            labelText: 'Enter password',
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
                            fontSize: 20,
                          ),
                          ),
                    ),
                  ]
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  setState(() {
                    Stat.page = "Reset";
                    inp3.text = "";
                    newAlert();
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.blue[900]
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Center(
                // ignore: deprecated_member_use
                child: RaisedButton(onPressed: () {
                  setState(() {
                    usr = inp1.text;
                    psw = inp2.text;
                    icheck().then((intenet) {
                      if ((intenet != null && intenet)!=true) {
                        internetAlert();
                      }
                      else{
                        if(Stat.update1){
                          warnAlert2();
                        }
                        else{
                          check(usr.toString(),psw.toString());
                        }
                      }
                    });
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
                        width: 100,
                        child: Text('Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24
                          ),
                        ),
                      ),
                    )
                ),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}