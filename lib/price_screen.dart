import 'dart:convert';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/crypto_json.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

const apiKey = '12FF15BA-F3A4-469E-8498-B5B8FC4DD718';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  List<String> exchangeRate = ['?', '?', '?'];
  String currencySelected =
      currenciesList[currenciesList.length - 2]; //To display USD as default

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  void asyncInitState() async {
    await getCryptoCurrencyExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: drawCryptoCards(),
      ),
      bottomNavigationBar: Container(
        height: 150.0,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
        // child: dropDownMenu(),
        child: Platform.isIOS ? cupertinoPicker() : dropDownMenu(),
      ),
    );
  }

  Widget cupertinoPicker() {
    return Center(
      child: CupertinoPicker.builder(
        itemExtent: 25.0,
        onSelectedItemChanged: (index) {
          setState(
            () {
              currencySelected = currenciesList[index];
            },
          );
          getCryptoCurrencyExchangeRate();
        },
        childCount: currenciesList.length,
        itemBuilder: (context, index) {
          return Text(currenciesList[index]);
        },
      ),
    );
  }

  Widget dropDownMenu() {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final currency in currenciesList) {
      menuItems.add(
        DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        ),
      );
    }
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: menuItems,
          value: currencySelected,
          onChanged: (currency) => setState(
            () {
              if (currency != null) {
                currencySelected = currency;
              }
              getCryptoCurrencyExchangeRate();
            },
          ),
        ),
      ),
    );
  }

  List<Widget> drawCryptoCards() {
    final List<Widget> cards = <Widget>[];

    for (final cryto in cryptoList) {
      final card = Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $cryto = ${exchangeRate[cryptoList.indexOf(cryto)]} $currencySelected',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
      cards.add(card);
    }
    return cards;
  }

  Future<void> getCryptoCurrencyExchangeRate() async {
    final client = http.Client();
    try {
      for (final cryto in cryptoList) {
        final url = Uri.parse(
            'https://rest.coinapi.io/v1/exchangerate/$cryto/$currencySelected');

        final response = await client.get(
          url,
          headers: {'X-CoinAPI-Key': apiKey},
        );
        if (response.statusCode == 200) {
          final cryptoModel = CryptoModel.fromJson(jsonDecode(response.body));
          exchangeRate[cryptoList.indexOf(cryto)] =
              cryptoModel.rate.toStringAsFixed(2);
        }
      }
    } catch (ex) {
      print(ex.toString());
    } finally {
      client.close();
    }

    setState(() {});
  }
}
