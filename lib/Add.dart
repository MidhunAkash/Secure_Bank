import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_native_code/Account.dart';
import 'package:flutter_native_code/validation.dart';
import 'package:flutter_native_code/vstatic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';



void main() => runApp(MaterialApp(
  home: Addm(),
  debugShowCheckedModeBanner: false,
));

class Addm extends StatefulWidget {
  @override
  _AddmState createState() => _AddmState();
}

class _AddmState extends State<Addm> {

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
  warnAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "All fields are Mandatory!",
        desc: "Please fill form completely to get an verification code",
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
  var inp1 = new MaskedTextController(mask: '0000 0000 0000 0000');
  TextEditingController inp2 = new TextEditingController();
  var inp3 = new MaskedTextController(mask: '00/00');
  TextEditingController inp4 = new TextEditingController();
  bool check(String card,String name,String date,String cvv){
    if(card.length<19||card == ""||name==""||date==""||cvv==""||date.length<5||cvv.length<3){
      warnAlert();
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          brightness: Brightness.dark,
          titleSpacing: 1.0,
          shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60.0),
              bottomRight:  Radius.circular(60.0),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
                  });
                },
              ),
              Text("Debit/Credit/ATM Card",
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 50),
              child: Container(
                width: 500,
                height: 310,
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
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text("Card Number: ",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      SizedBox(height: 8,),
                      Container(
                        height: 50,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          textAlign: TextAlign.start,
                          controller: inp1,
                          keyboardType: TextInputType.number,
                          cursorHeight: 25,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(19),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            suffixIcon: Icon(Icons.credit_card_rounded),
                            hintText: "xxxx xxxx xxxx xxxx",
                          ),
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          autofocus: false,
                        ),
                      ),
                      SizedBox(height: 13,),
                      Text("Name on Card:",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 8,),
                      Container(
                        height: 50,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          textAlign: TextAlign.start,
                          controller: inp2,
                          cursorHeight: 25,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            hintText: "Enter Name on Card",
                          ),
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          autofocus: false,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Expiry Date:",
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                height: 50,
                                width: 150,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  textAlign: TextAlign.start,
                                  controller: inp3,
                                  keyboardType: TextInputType.number,
                                  cursorHeight: 25,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(5),
                                  ],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(10))
                                    ),
                                    hintText: "MM/YY",
                                  ),
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                  autofocus: false,

                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CVV:",
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                width: 130,
                                height: 50,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  textAlign: TextAlign.start,
                                  obscureText: true,
                                  controller: inp4,
                                  cursorHeight: 25,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(10))
                                    ),
                                    hintText: "CVV",
                                  ),
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                  autofocus: false,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              // ignore: deprecated_member_use
              child: RaisedButton(onPressed: () {
                icheck().then((intenet) {
                  if ((intenet != null && intenet)!=true) {
                    internetAlert();
                  }
                  else{
                    setState(() {
                      Stat.ramail = "amail";
                      if(check(inp1.text.toString(), inp2.text.toString(), inp3.text.toString(), inp4.text.toString())){
                        Stat.addname = inp2.text.toString();
                        Stat.addacc = inp1.text.toString().replaceAll(" ", "");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Valid()));
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
                      child: Text('Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24
                        ),
                      ),
                    ),
                  )
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}

