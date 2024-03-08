import 'package:crypto/coin_list_screen.dart';
import 'package:crypto/data/model/crypto.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
 getdata();
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/logo.png')),
            SpinKitWave(
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  void getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => CoinListScreen(
                  cryptoList: cryptoList,
                )));
  }
}
