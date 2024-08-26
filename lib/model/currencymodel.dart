class CurrencyModel {
  String? code;
  double? value;

  CurrencyModel({this.code, this.value});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    value = double.parse(json['value'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['value'] = this.value;
    return data;
  }
}