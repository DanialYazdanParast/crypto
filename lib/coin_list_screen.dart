import 'package:crypto/data/constans/constans.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto/data/model/crypto.dart';

class CoinListScreen extends StatefulWidget {
  List<Crypto>? cryptoList;
  CoinListScreen({super.key, this.cryptoList});

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? cryptoList;
  bool isSearchLoadin = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blackColor,
        appBar: AppBar(
          title: Text(
            'کریپتو بازار',
            style: TextStyle(fontFamily: 'morabee'),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: blackColor,
        ),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) {
                    _filterList(value);
                  },
                  decoration: InputDecoration(
                      hintText: 'اسم رمز ارز  را سرچ کنید',
                      hintStyle:
                          TextStyle(fontFamily: 'morabee', color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(width: 0, style: BorderStyle.none)),
                      filled: true,
                      fillColor: Colors.indigo),
                ),
              ),
            ),
            Visibility(
                visible: isSearchLoadin,
                child: Text(
                  '...درحال آپدیت  اطلاعات رمز ارزها',
                  style: TextStyle(color: greyColor, fontFamily: 'morabee'),
                )),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: Colors.indigo,
                color: Colors.grey,
                onRefresh: () async {
                  List<Crypto> fereshData = await _getdata();
                  setState(() {
                    cryptoList = fereshData;
                  });
                },
                child: ListView.builder(
                  itemCount: cryptoList!.length,
                  itemBuilder: (context, index) {
                    return _getListTileItem(cryptoList![index]);
                  },
                ),
              ),
            ),
          ],
        )));
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: greenColor,
          );
  }

  Color _getColorehangeTest(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
        title: Text(
          crypto.name,
          style: TextStyle(color: Colors.indigo),
        ),
        subtitle: Text(
          crypto.symbol,
          style: TextStyle(color: greyColor),
        ),
        leading: SizedBox(
          width: 30,
          child: Center(
            child: Text(
              crypto.rank.toString(),
              style: TextStyle(color: greyColor),
            ),
          ),
        ),
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    crypto.priceUsd.toStringAsFixed(2),
                    style: TextStyle(color: greyColor, fontSize: 18),
                  ),
                  Text(
                    crypto.changePercent24hr.toStringAsFixed(2),
                    style: TextStyle(
                        color: _getColorehangeTest(crypto.changePercent24hr)),
                  ),
                ],
              ),
              SizedBox(
                  width: 50,
                  child: Center(
                      child: _getIconChangePercent(crypto.changePercent24hr))),
            ],
          ),
        ));
  }

  Future<List<Crypto>> _getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  Future<void> _filterList(String enteredKeyword) async {
    List<Crypto> cryptoResultList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearchLoadin = true;
      });
      var result = await _getdata();
      setState(() {
        cryptoList = result;
        isSearchLoadin = false;
      });
      return;
    }
    cryptoResultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();
    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
