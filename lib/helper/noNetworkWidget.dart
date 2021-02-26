import 'package:flutter/material.dart';


Widget noNetwork(BuildContext context){
  return new Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 2,
    child: new Center(child: new Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
      new Icon(Icons.signal_wifi_off,size: 50,),
        new Text('Please Connect to Network !',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),) 
    ],),),);
}


void noNetworkShowDialog(BuildContext context ,double width ,double height){
   showDialog(
      context: context,
      builder: (BuildContext context) => WillPopScope(
          onWillPop: ()  async => true,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(200),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: new SingleChildScrollView(
              child: new Container(
                width: width * .60,
                height: height * .30,
                child: new Card(child: noNetwork(context) ,),),
            ),
          )));
}