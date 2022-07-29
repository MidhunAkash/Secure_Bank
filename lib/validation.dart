import 'dart:async';
import 'package:flutter_native_code/password.dart';
import 'package:password_strength/password_strength.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_code/Account.dart';
import 'package:flutter_native_code/vstatic.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';


void main() => runApp(MaterialApp(
  home: Valid(),
  debugShowCheckedModeBanner: false,
));

class Valid extends StatefulWidget {
  @override
  _ValidState createState() => _ValidState();
}

class _ValidState extends State<Valid> {

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

  String date = Jiffy().format('MMM do, yyyy, h:mm a');
  addmail() async{
    String username = 'do.not.reply.securebnk@gmail.com';
    String password = 'midhun@123';
    Random random = new Random();
    int rnum = random.nextInt(900)+100;
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);
    final message1 = Message()
      ..from = Address(username, 'Secure Bank')
      ..recipients.add('${Stat.login[Stat.usd][3]}')
      ..subject = '${Stat.ttemp[3]} is Added [#eID$rnum]'
      ..html = "<!DOCTYPE html>"
          "<html><body style='background-color: white;'>"
          "<div><center>"
          "<img src='https://tse1.mm.bing.net/th/id/OIP.K-BgnJVlPg85l_pQzDtJKwHaDt?w=312&h=175&c=7&o=5&dpr=1.4&pid=1.7' alt='Secure Bank'/><br>"
          "</center><h2>Hi ${Stat.login[Stat.usd][2]},</h2><br>"
          "<p>Hi, there this is to inform you that</p><br>"
          "<h3>${Stat.ttemp[3]} has been added successfully on ${Stat.ttemp[2]}</h3>"
          "<p>From,<br>Card Holder Name: ${Stat.ttemp[0]}.</p><br>"
          "<p>If you have any other questions, feel free to reach out."
          " We will be glad to help in any way we can!<br>"
          "<br>Thanks for being a part of the Secure Bank!</p>"
          "<p>Best Regards,<br>"
          "Secure Bank</p></div></body></html>";
    try {
      final sendReport = await send(message1, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future setall() async{
    var url = 'https://securebnk950.000webhostapp.com/prj/setall.php';
    await http.post(Uri.parse(url),body: {
      'user': Stat.login[Stat.usd][0],
      'bal': Stat.balance[Stat.usd].toString().trim(),
      'tname': Stat.ttemp[0],
      'acno': Stat.ttemp[1],
      'time': Stat.ttemp[2],
      'rs': Stat.ttemp[3],
      'status': Stat.ttemp[4],
    });
  }

  String ematter(){
    if(Stat.ramail.compareTo("rmail")==0){
      return "A password reset requires a further verification because we need to ensure whether "
          "it is you are not. To complete the process enter "
          "the verification code in your device.";
    }
    else if(Stat.ramail.compareTo("amail")==0){
      return "To Add Money it requires a further verification because we need to ensure whether "
          "it is you are not. To complete the process enter "
          "the verification code in your device.";
    }
    else if(Stat.ramail.compareTo("vmail")==0){
      return "To change the email address it requires a further verification because we need to ensure whether "
          "it is you are not. To complete the process enter "
          "the verification code in your device.";
    }
    return "A sign in attempt requires further verification as a part of "
        "two-step verification for ensuring that it's you. To complete the sign in, "
        "enter the verification code in your device.";
  }
  sendmail() async {
    String username = 'do.not.reply.securebnk@gmail.com';
    String password = 'midhun@123';
    Random random = new Random();
    Stat.rnum = random.nextInt(90000) + 10000;
    int rnum = random.nextInt(900)+100;
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);
    final message1 = Message()
      ..from = Address(username, 'Secure Bank')
      ..recipients.add('${Stat.login[Stat.usd][3]}')
      ..subject = 'Verification Code [#eID$rnum]'
      ..html = "<!DOCTYPE html>"
          "<html><head><style type='text/css' data-hse-inline-css='true'>.card{width: auto;height: auto;display: inline-block;box-shadow: 2px 2px 20px rgba(83, 83, 83, 0.664);"
          "border-radius: 15px; margin: 1%;padding-left: 3%;padding-right: 3%;} </style></head>"
          "<body style='background-color: white;'>"
          "<div class='back'><center>"
          "<img src='https://tse1.mm.bing.net/th/id/OIP.K-BgnJVlPg85l_pQzDtJKwHaDt?w=312&h=175&c=7&o=5&dpr=1.4&pid=1.7' alt='Secure Bank'/><br>"
          "</center><h2>Hi ${Stat.login[Stat.usd][2]},</h2><br>"
          "<p>${ematter()}</p>"
          "<center><div style='width: auto;height: auto;display: inline-block;box-shadow: 2px 2px 20px rgba(83, 83, 83, 0.664);border-radius: 15px; margin: 1%;padding-left: 3%;padding-right: 3%;'><h1>${Stat.rnum}</h1></div></center>"
          "<p>If you have any other questions, feel free to reach out."
          " We will be glad to help in any way we can!<br>"
          "<br>Thanks for being a part of the Secure Bank!</p>"
          "<p>Best Regards,<br>"
          "Secure Bank</p></div></body></html>";
    try {
      final sendReport = await send(message1, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  Timer _timer;
  int _start = 25;
  int _expire = 59;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          print(_timer);
        } else {
          setState(() {
            _start--;
          });
        }

      },
    );
  }
  void startTimer2() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_expire == 0) {
          setState(() {
            timer.cancel();
            if(Stat.ramail.compareTo("vmail")==0){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
              Stat.ramail="";
            }
            else{
              Random random = new Random();
              Stat.rnum = random.nextInt(90000) + 10000;
            }
          });
          print(_timer);
        } else {
          setState(() {
            _expire--;
          });
        }

      },
    );
  }
  @override
  void initState(){
    Future.delayed(Duration.zero,() async {
      String username = 'do.not.reply.securebnk@gmail.com';
      String password = 'midhun@123';
      Random random = new Random();
      Stat.rnum = random.nextInt(90000) + 10000;
      int rnum = random.nextInt(900)+100;
      // ignore: deprecated_member_use
      final smtpServer = gmail(username, password);
      final message1 = Message()
        ..from = Address(username, 'Secure Bank')
        ..recipients.add('${Stat.login[Stat.usd][3]}')
        ..subject = 'Verification Code [#eID$rnum]'
        ..html = "<!DOCTYPE html>"
            "<html><head><style type='text/css' data-hse-inline-css='true'>.card{width: auto;height: auto;display: inline-block;box-shadow: 2px 2px 20px rgba(83, 83, 83, 0.664);"
            "border-radius: 15px; margin: 1%;padding-left: 3%;padding-right: 3%;} </style></head>"
            "<body style='background-color: white;'>"
            "<div class='back'><center>"
            "<img src='https://tse1.mm.bing.net/th/id/OIP.K-BgnJVlPg85l_pQzDtJKwHaDt?w=312&h=175&c=7&o=5&dpr=1.4&pid=1.7' alt='Secure Bank'/><br>"
            "</center><h2>Hi ${Stat.login[Stat.usd][2]},</h2><br>"
            "<p>${ematter()}</p>"
            "<center><div style='width: auto;height: auto;display: inline-block;box-shadow: 2px 2px 20px rgba(83, 83, 83, 0.664);border-radius: 15px; margin: 1%;padding-left: 3%;padding-right: 3%;'><h1>${Stat.rnum}</h1></div></center>"
            "<p>If you have any other questions, feel free to reach out."
            " We will be glad to help in any way we can!<br>"
            "<br>Thanks for being a part of the Secure Bank!</p>"
            "<p>Best Regards,<br>"
            "Secure Bank</p></div></body></html>";
      try {
        final sendReport = await send(message1, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      var url = 'https://securebnk950.000webhostapp.com/prj/createtrans.php';
      await http.post(Uri.parse(url),body: {
        'tname': Stat.login[Stat.usd][0],
        'time': date
      });
      var url2 = 'https://securebnk950.000webhostapp.com/prj/getran.php';
      http.Response response = await http.post(Uri.parse(url2),body: {
        'tname': Stat.login[Stat.usd][0]
      });
      String data = (response.body).toString();
      List acc;
      acc = data.split("#");
      int row = acc.length-1;
      int col = 5;
      // ignore: deprecated_member_use
      Stat.transac = List.generate(row, (i) => List(col));
      for(int i=0;i<acc.length-1;i++){
        Stat.transac[i] = acc[i].split("  ");
        for(int j =0;j<5;j++) {
          Stat.transac[i][j].trim();
        }
      }
    });
    super.initState();
    startTimer();
    startTimer2();
  }
  disptime(){
    if(_start!=0){
      return Text("  in $_start sec",
        style: TextStyle(
          fontSize: 17,
        ),
      );
    }
    else{
      return Text("");
    }
  }

  _passcheker() {
    double pstrength = estimatePasswordStrength(Stat.pas[Stat.usd]);
    print(pstrength);
    if(pstrength <0.88){
      Alert(
          onWillPopActive: true,
          context: context,
          title: "Week Password!",
          desc: "${Stat.login[Stat.usd][2]} your password is week. Would you like to change password?",
          type: AlertType.warning,
          closeIcon: Icon(Icons.ac_unit,size: 0.1,),
          buttons: [
            DialogButton(
              child: Text("Later",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              color: Colors.red[800],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
              },
              width: 60,
              highlightColor: Colors.red,
              splashColor: Colors.red,
            ),
            DialogButton(
              child: Text("Now",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              color: Colors.green[800],
              onPressed: () {
                Stat.page = "Change";
                newAlert2(context);
              },
              width: 80,
              splashColor: Colors.green[700],
              highlightColor: Colors.green[700],
            )
          ]
      ).show();
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
    }
  }
  Future<void> newAlert2(BuildContext context) async {
    bool _secure = true;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  scrollable: true,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                  title: Center(child: Text("Change Password")),
                  content: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Column(
                      children: [
                        Text("To change password you need to Enter the current password.",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        SizedBox(height: 8,),
                        Container(
                          height: 55,
                          child: TextField(
                            obscureText: _secure,
                            cursorHeight: 24,
                            controller: inp4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))
                              ),
                              labelText: 'Enter Current Password',
                              suffixIcon: IconButton(icon: Icon(
                                  _secure ? Icons.visibility_off_rounded : Icons
                                      .visibility_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _secure = !_secure;
                                    });
                                  }
                              ),
                            ),
                            autofocus: false,
                            style: TextStyle(
                              fontSize: 24,
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Center(
                        child: DialogButton(
                          child: Text("Confirm",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          color: Colors.blue[800],
                          onPressed: () {
                            setState(() {
                              if ((inp4.text.toString()).compareTo(
                                  Stat.pas[Stat.usd]) == 0) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Pasword()));
                              }
                              else {
                                warnAlert2();
                              }
                            });
                          },
                          width: 130,
                        )
                    ),

                  ],
                );
              }
          );
        });
  }
  warnAlert2(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "Incorrect Password!",
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

  TextEditingController inp1 = new TextEditingController();
  TextEditingController inp4 = new TextEditingController();

  Future<bool> _onWillPop() {
    return Alert(
        onWillPopActive: true,
        context: context,
        title: "Are you sure ?",
        desc: "Do you really want to stop the verification Process?",
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
              if(Stat.ramail.compareTo("amail")==0){
                Stat.ramail = "";
                Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
              }
              if(Stat.ramail.compareTo("vmail")==0){
                Stat.ramail = "";
                Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
              }
              else{
                Phoenix.rebirth(context);
              }
            },
            width: 80,
          )
        ]
    ).show();
  }

  resendColr(){
    if(_start != 0){
      return TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          color: Colors.grey[500]
      );
    }
    else{
      return TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          color: Colors.blue[900]
      );
    }
  }
  susAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Amount Added!",
        desc: "${Stat.addrs} is added to your account Successfully.",
        closeIcon: Icon(Icons.ac_unit,size: 0.1,),
        type: AlertType.success,
        buttons: [
          DialogButton(
            child: Text("ok",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.blue[800],
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
            },
            width: 80,
          )
        ]
    ).show();
  }
  warnAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Verification Failed!",
        desc: "Incorrect verification code you are not allowed to access this account.\nPress the log-out to login again.",
        type: AlertType.error,
        closeIcon: Icon(Icons.ac_unit,size: 0.1,),
        buttons: [
          DialogButton(
            child: Text("Log Out",
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
  susAlert2(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Verified!",
        desc: "Your authentication is verified.\nPress next to continue.",
        type: AlertType.success,
        closeIcon: Icon(Icons.ac_unit,size: 0.1,),
        buttons: [
          DialogButton(
            child: Text("Next",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
              if(Stat.page.compareTo("Reset") == 0){
                Stat.page="Reset";
                Navigator.push(context, MaterialPageRoute(builder: (context) => Pasword()));
              }
              else{
                _passcheker();
              }
            },
            width: 140,
          ),
        ]
    ).show();
  }

  String exdata(){
    if(_expire==0){
      return "expired.";
    }
    return "expires in $_expire sec.";
  }
  @override
  Widget build(BuildContext context) {
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
                Text("Authentication",
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
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Container(
                  height: 135,
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 290.0,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child:Text("• Please check your e-mail.\n ${Stat.login[Stat.usd][3].toString().replaceRange(2, 11,"*********")}."),
                            )
                        ),
                        Container(
                            width: 300.0,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child:Text("• If you din't received any email."),
                            )
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    if(_start==0){
                                      _start = 25;
                                      _expire = 59;
                                      startTimer();
                                      startTimer2();
                                      sendmail();
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Resend Notification",
                                      style: resendColr(),
                                    ),
                                    disptime(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Verification code ${exdata()}",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 60,),
                Text("Verification Code: ",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                      width: 150,
                      height: 50,
                      child: TextField(
                        cursorHeight: 30,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: inp1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                        ],
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 30,
                          letterSpacing: 10,
                        ),
                        autofocus: false,
                      )
                  ),
                ),
                SizedBox(height: 40,),
                Center(
                  // ignore: deprecated_member_use
                  child: RaisedButton(onPressed: () {
                    icheck().then((intenet) {
                      if ((intenet != null && intenet)!=true) {
                        internetAlert();
                      }
                      else{
                        setState(() {
                          if(inp1.text.toString().compareTo(Stat.rnum.toString())==0){
                            _timer.cancel();
                            if(Stat.ramail.compareTo("amail")==0){
                              Stat.ramail = "";
                              Stat.balance[Stat.usd] = (int.parse(Stat.balance[Stat.usd])+Stat.addamt).toString();
                              Stat.ttemp.clear();
                              Stat.ttemp.add(Stat.addname);
                              Stat.ttemp.add(Stat.addacc);
                              Stat.ttemp.add(date);
                              Stat.ttemp.add(Stat.addrs);
                              Stat.ttemp.add("Received");
                              Stat.transac.add([]);
                              Stat.transac[Stat.transac.length-1].add(Stat.addname);
                              Stat.transac[Stat.transac.length-1].add(Stat.addacc);
                              Stat.transac[Stat.transac.length-1].add(date);
                              Stat.transac[Stat.transac.length-1].add(Stat.addrs);
                              Stat.transac[Stat.transac.length-1].add("Received");
                              setall();
                              addmail();
                              susAlert();
                            }
                            else if(Stat.ramail.compareTo("vmail")==0){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
                            }
                            else{
                              Stat.ramail="";
                              susAlert2();
                            }
                          }
                          else{
                            _timer.cancel();
                            warnAlert();
                          }
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
                          width: 100,
                          child: Text('Verify',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24
                            ),
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        )
      ),
    );
  }
}

