import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:currency_converter/model/currencymodel.dart';
import 'package:currency_converter/service/api_service.dart';
import 'package:currency_converter/ui/components/all_currencylist_item.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiService apiService = ApiService();

  String _selectedCurrency = 'USD';

  Widget _dropDownItem(Country country) => Container(
        child: Row(
          children: [
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8,
            ),
            Text('${country.currencyName}')
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            'Base Currency',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CountryPickerDropdown(
                  initialValue: 'us',
                  itemBuilder: _dropDownItem,
                  onValuePicked: (Country? country) {
                    setState(() {
                      _selectedCurrency = country?.currencyCode ?? "";
                    });
                  },
                ),
              ),
            ),
          ),
          Text(
            'All Currency',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 8,
          ),
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<CurrencyModel> currencyModelList = snapshot.data ?? [];
                return Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    return AllCurrencyListItem(currencyModel: currencyModelList[index]);
                  },
                  itemCount: currencyModelList.length,
                ));
              }
              if(snapshot.hasError){
                return Center(child: Text(
                  "Error Occured",
                  style: TextStyle(color: Colors.white),
                ),);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            future: apiService.getLatest(_selectedCurrency),
          )
        ],
      ),
    );
  }
}
