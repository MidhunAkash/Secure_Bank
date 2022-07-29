import 'package:flutter/material.dart';
import 'package:flutter_native_code/vstatic.dart';

void main() => runApp(MaterialApp(
  home: Transaction(),
  debugShowCheckedModeBanner: false,
));

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}


class _TransactionState extends State<Transaction> {
  String name,acc,time,st;
  int rs;
  _status(int i){
    if(Stat.transac[i][4].toString().trim().compareTo("Received")==0){
      return Text("+ ${Stat.transac[i][3]}.00",
        style: TextStyle(
          color: Colors.green,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      );
    }
    else if(Stat.transac[i][4].toString().trim().compareTo("Sent")==0){
      return Text("- ${Stat.transac[i][3]}.00",
        style: TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
      );
    }
    else{
      return Text("${Stat.transac[i][3]}.00",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
      );
    }
  }
  _res(int i){
    if(Stat.transac[i][4].toString().trim().compareTo("Fail")==0){
      return Text("${Stat.transac[i][4]}ed",
        style: TextStyle(
          color: Colors.red,
          fontSize: 17,
        ),
      );
    }
    return Text("${Stat.transac[i][4]}",
      style: TextStyle(
        fontSize: 17,
      ),
    );
  }
  createCont(int i){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: Container(
        height: 95,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0,0),
                  blurRadius: 3.0)
            ],

        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${Stat.transac[i][0]}",
                        style: TextStyle(
                          fontSize: 24
                        ),
                      ),
                      Text("${Stat.transac[i][1]}")
                    ],
                  ),
                  _status(i),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${Stat.transac[i][2]}",
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                  _res(i)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("Transaction History",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        elevation: 5,
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 30,),
            for(int i=Stat.transac.length-1;i>=0;i--) createCont(i),
            SizedBox(height: 150,)
          ],
        ),
      ),
    );
  }
}
