import 'dart:math';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_code/vstatic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

void main() => runApp(MaterialApp(
  home: Send(),

  debugShowCheckedModeBanner: false,
));

class Send extends StatefulWidget {

  @override
  _SendState createState() => _SendState();
}


class _SendState extends State<Send> {

  Future setacc() async{
    var url2 = 'https://securebnk950.000webhostapp.com/prj/getaccc.php';
    http.Response response2 = await http.get(Uri.parse(url2));
    String data2 = (response2.body).toString();
    List acc2;
    acc2 = data2.split("#");
    int row2 = acc2.length-1;
    int col2 = 5;
    // ignore: deprecated_member_use
    Stat.login = List.generate(row2, (i) => List(col2), growable: false);
    // ignore: deprecated_member_use
    Stat.pas = List<String>(row2);
    // ignore: deprecated_member_use
    Stat.balance = List<String>(row2);
    setState(() {
      for(int i=0;i<acc2.length-1;i++){
        Stat.login[i] = acc2[i].split("  ");
        Stat.pas[i] = Stat.login[i][1].toString().trim();
        Stat.balance[i] = Stat.login[i][4].toString().trim();
      }
    });
    var url = 'https://securebnk950.000webhostapp.com/prj/getran.php';
    http.Response response = await http.post(Uri.parse(url),body: {
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
            else{
              setacc();
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
                  setacc();
                }
              });
            },
            width: 140,
          ),
        ]
    ).show();
  }

  sendmail(int i) async{
    String username = 'do.not.reply.securebnk@gmail.com';
    String password = 'midhun@123';
    Random random = new Random();
    int rnum = random.nextInt(900)+100;
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);
    final message1 = Message()
      ..from = Address(username, 'wHospital')
      ..recipients.add('${Stat.login[i][3]}')
      ..subject = '${Stat.ttemp[3]} is  [#eID$rnum]'
      ..html = "<!DOCTYPE html>"
          "<html><body style='background-color: white;'>"
          "<div><center>"
          "<img src='https://tse1.mm.bing.net/th/id/OIP.K-BgnJVlPg85l_pQzDtJKwHaDt?w=312&h=175&c=7&o=5&dpr=1.4&pid=1.7' alt='Secure Bank'/><br>"
          "</center><h2>Hi ${Stat.login[i][2]},</h2><br>"
          "<p>This is to inform you that,</p><br>"
          "<h3>${Stat.ttemp[3]} has been  on ${Stat.ttemp[2]}</h3>"
          "<p>Amount has been .</p><br>"
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
  Future setreceiver(int i) async{
    var url = 'https://securebnk950.000webhostapp.com/prj/setreceiver.php';
    await http.post(Uri.parse(url),body: {
      'user': Stat.login[i][0],
      'tname': Stat.ttemp[0],
      'acno': Stat.ttemp[1],
      'time': Stat.ttemp[2],
      'rs': Stat.ttemp[3],
    });
  }
  Future setbal(int i) async{
    var url = 'https://securebnk950.000webhostapp.com/prj/setrbal.php';
    await http.post(Uri.parse(url),body: {
      'user': Stat.login[i][0],
      'bal': Stat.balance[i]
    });
  }

  bool flag = false;
  String date = Jiffy().format('MMM do, yyyy, h:mm a');
  String _apiKey ='';
  String name = Stat.login[Stat.usd][2].toString();
  int amount = int.parse(Stat.balance[Stat.usd]);
  TextEditingController inp1 = new TextEditingController();
  TextEditingController inp2 = new TextEditingController();
  var inp3 = new MaskedTextController(mask:'SECBNK000000');
  var inp4 = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: ',',leftSymbol: '₹',precision: 0);
  String n="",num="",ifs="",wdrl = "";
  String famount;
  String s,str1;
  int withdrwl;
  _getData(int wrdl){
    int amt = int.parse(Stat.balance[Stat.usd].toString().trim());
    print(amt);
    print(wrdl);
    _apiKey = (amt-wrdl).toString();
    print(_apiKey);
    showalerts();
    setState(() {
    });
  }
  fecthAll(){
    if(n==""||num==""||ifs==""||wdrl=="0"){
      warnAlert();
    }
    else{
      int withdral = int.parse(wdrl);
      withdrwl = withdral;
      _getData(withdral);
    }
  }
  showalerts(){
    int tbal = int.parse(_apiKey);
    if(tbal >= 0) {
      if (num.compareTo(Stat.login[Stat.usd][0]) == 0) {
        warnAlert2("Sender and Receiver account number can't be same.\n$num");
      }
      else {
        flag = false;
        for (int i = 0; i < Stat.login.length; i++) {
          if (num.compareTo(Stat.login[i][0]) == 0) {
            if((Stat.login[i][0].toString().compareTo("1234567890")==0) != true) {
              Stat.ttemp.clear();
              Stat.ttemp.add(Stat.login[Stat.usd][2]);
              Stat.ttemp.add(Stat.login[Stat.usd][0]);
              Stat.ttemp.add(date);
              Stat.ttemp.add(famount);
              Stat.ttemp.add("Received");
              setreceiver(i);
              Stat.balance[i] =
                  (int.parse(Stat.balance[i]) + withdrwl).toString();
              setbal(i);
              sendmail(i);
              flag = true;
              break;
            }
            else{
              warnAlert2("This account number is restricted Please Try again.");
            }
          }
        }
        if(flag) {
          Stat.ttemp.clear();
          Stat.ttemp.add(n);
          Stat.ttemp.add(num);
          Stat.ttemp.add(date);
          Stat.ttemp.add(famount);
          Stat.ttemp.add("Sent");
          Stat.transac.add([]);
          Stat.transac[Stat.transac.length - 1].add(n);
          Stat.transac[Stat.transac.length - 1].add(num);
          Stat.transac[Stat.transac.length - 1].add(date);
          Stat.transac[Stat.transac.length - 1].add(famount);
          Stat.transac[Stat.transac.length - 1].add("Sent");
          int tbal = int.parse(_apiKey);
          Stat.balance[Stat.usd] = tbal.toString();
          setall();
          sendmail(Stat.usd);
          scusAlert();
        }
        else{
          warnAlert2("This account number is not registered with the bank.");
        }
      }
    }
    else{
      Stat.ttemp.clear();
      Stat.ttemp.add(n);
      Stat.ttemp.add(num);
      Stat.ttemp.add(date);
      Stat.ttemp.add(famount);
      Stat.ttemp.add("Fail");
      Stat.transac.add([]);
      Stat.transac[Stat.transac.length-1].add(Stat.login[Stat.usd][2]);
      Stat.transac[Stat.transac.length-1].add(Stat.login[Stat.usd][0]);
      Stat.transac[Stat.transac.length-1].add(date);
      Stat.transac[Stat.transac.length-1].add(famount);
      Stat.transac[Stat.transac.length-1].add("Fail");
      setall();
      failAlert();
    }
  }
  warnAlert2(String data){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Invalid Account Number!",
        desc: "$data",
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
            color: Colors.blue[800],
            onPressed: () {
              Navigator.pop(context);
            },
            width: 140,
          )
        ]
    ).show();
  }
  warnAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "All fields are Mandatory\nPlease check!",
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
            color: Colors.blue[800],
            onPressed: () {
              Navigator.pop(context);
            },
            width: 140,
          )
        ]
    ).show();
  }
  failAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Failed!",
        desc: "$famount \nFund Transferring to $n got Failed.\n Warning: Insufficient Fund!",
        type: AlertType.error,
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
            color: Colors.blue[800],
            onPressed: () {
              Navigator.pop(context);
            },
            width: 140,
          )
        ]
    ).show();
  }
  scusAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Successful!",
        desc: "$famount \nFund Transferred to $n Successfully. ",
        type: AlertType.success,
        closeIcon: Icon(Icons.close),
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
            width: 80,
          )
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
          shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60.0),
              bottomRight:  Radius.circular(60.0),
            ),
          ),
          title: Text("Send Money",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          elevation: 5,
          backgroundColor: Colors.blue[900],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Name:",
                style: TextStyle(
                  fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              Container(
                  width: 370,
                  height: 50,
                  child: TextField(
                    controller: inp1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Enter Account Holder's Name",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: false,
                  )
              ),
              SizedBox(height: 20,),
              Text("Account Number:",
                style: TextStyle(
                    fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              Container(
                  width: 370,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: inp2,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Enter Account Number",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: false,
                  )
              ),
              SizedBox(height: 20,),
              Text("IFSC:",
                style: TextStyle(
                    fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              Container(
                  width: 370,
                  height: 50,
                  child: TextField(
                    controller: inp3,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Enter IFSC Code",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: false,
                  )
              ),
              SizedBox(height: 20,),
              Text("Amount:",
                style: TextStyle(
                    fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              Container(
                  width: 370,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: inp4,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(14),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Enter Amount to pay",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: false,
                  )
              ),
              SizedBox(height: 35,),
              Center(
                // ignore: deprecated_member_use
                child: RaisedButton(onPressed: () {
                  icheck().then((intenet) {
                    if ((intenet != null && intenet)!=true) {
                      internetAlert();
                    }
                    else{
                      setState(() {
                        n = inp1.text.toString();
                        num = inp2.text.toString();
                        ifs = inp3.text.toString();
                        famount = inp4.text.toString();
                        s =inp4.text.toString().replaceAll('₹', '');
                        wdrl = s.replaceAll(',', '');
                        fecthAll();
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
                        width: 110,
                        child: Text('Send',
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
