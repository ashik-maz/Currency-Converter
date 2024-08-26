import 'package:currency_converter/model/currencymodel.dart';
import 'package:flutter/material.dart';

class AllCurrencyListItem extends StatelessWidget {
  final CurrencyModel currencyModel;
  const AllCurrencyListItem({super.key, required this.currencyModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.blue.withAlpha(88),borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Text(
                currencyModel.code.toString(),
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              Text(
                currencyModel.value?.toStringAsFixed(2).toString() ??"",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
                
            ],
          ),
        ),
      ),
    );
  }
}
