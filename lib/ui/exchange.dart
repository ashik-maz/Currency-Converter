import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

import '../service/api_service.dart';

class Exchange extends StatefulWidget {
  const Exchange({super.key});

  @override
  State<Exchange> createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  ApiService apiService = ApiService();

  String _selectedBaseCurrency = 'USD';
  String _selectedTargetCurrency = 'BDT';
  String _totalValue = "";

  final _textcontroller = TextEditingController();

  Widget _dropDownItem(Country country) => Row(
        children: [
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8),
          Text('${country.currencyName}'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Exchange'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 8),
            Text(
              'Base Currency',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CountryPickerDropdown(
                    initialValue: 'us',
                    itemBuilder: _dropDownItem,
                    onValuePicked: (Country? country) {
                      setState(() {
                        _selectedBaseCurrency = country?.currencyCode ?? "";
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _textcontroller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Target Currency',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CountryPickerDropdown(
                    initialValue: 'bd',
                    itemBuilder: _dropDownItem,
                    onValuePicked: (Country? country) {
                      setState(() {
                        _selectedTargetCurrency = country?.currencyCode ?? "";
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                if (_textcontroller.text.isNotEmpty) {
                  try {
                    print("Fetching exchange rate for $_selectedBaseCurrency to $_selectedTargetCurrency");
                    var result = await apiService.getExchange(_selectedBaseCurrency, _selectedTargetCurrency);
                    print("API Result: $result");

                    if (result != null && result.isNotEmpty) {
                      double value = double.parse(_textcontroller.text);
                      double exchangeRate = double.parse(result[0].value.toString());
                      double total = value * exchangeRate;

                      _totalValue = total.toStringAsFixed(2);
                      print("Calculated Total Value: $_totalValue");

                      setState(() {});
                    } else {
                      print("Error: API returned empty result.");
                    }
                  } catch (e) {
                    print("Error occurred: $e");
                  }
                }
              },
              child: Text('Exchange', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 45),
            Text(
              _totalValue + " " + _selectedTargetCurrency,
              style: TextStyle(fontSize: 60, color: Colors.greenAccent),
            ),
          ],
        ),
      ),
    );
  }
}
