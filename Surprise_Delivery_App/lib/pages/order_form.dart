import 'package:flutter/material.dart';
//import 'package:multi_select_flutter/multi_select_flutter.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({super.key});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Help Us Pick!",
            style: TextStyle(color: const Color.fromARGB(255, 155, 111, 8)),
          ),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent.withValues(alpha: 0.5),
        ),
        body: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.orange.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: Text("main")),
                Expanded(child: Text("side")),
                Expanded(child: Text("drink")),
                Expanded(child: Text("dessert"))
              ],
            )));
  }
}
