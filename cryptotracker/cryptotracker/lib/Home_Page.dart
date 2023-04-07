import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tcontroller = TextEditingController();
  String price = '';
  late String coin = 'bitcoin';
  Future<void> getBitcoinPrice(String coin) async {
    final url = Uri.parse('https://api.coingecko.com/api/v3/coins/${coin}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        price = data['market_data']['current_price']['usd'].toString();
      });
    } else {
      throw Exception('Failed to load Bitcoin price');
    }
  }

  @override
  void initState() {
    super.initState();
    getBitcoinPrice(coin);
    Timer.periodic(Duration(minutes: 5), (timer) => getBitcoinPrice(coin));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tcontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(179, 179, 179, 1))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(214, 104, 58, 183))),
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          filled: true,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(179, 179, 179, 1)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => getBitcoinPrice(tcontroller.text),
                      child: Container(
                        child: Center(
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                          ),
                        ),
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(214, 104, 58, 183),
                        ),
                        width: 60,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.network(
                        'https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Text(
                      '\$ $price',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
