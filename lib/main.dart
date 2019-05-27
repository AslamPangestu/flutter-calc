import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Interest Calculator",
      theme: ThemeData(
          primaryColor: Colors.indigo,
          accentColor: Colors.indigoAccent,
          brightness: Brightness.dark),
      home: Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Interest Calculator"),
        ),
        body: CalcForm(),
      ),
    ));

class CalcForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalcFormState();
  }
}

class _CalcFormState extends State<CalcForm> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  var _currencies = ['Rupiah', 'Dollars', 'Pounds'];
  final _minPadding = 5.0;
  var _curCurrencies = '';
  var _resultDisplay = '';

  @override
  void initState() {
    super.initState();
    _curCurrencies = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(_minPadding * 5),
        children: <Widget>[
          getBannerAsset('images/banner.png'),
          inputText("Principal", "Enter principal 3.g 12000", textStyle,
              principalController),
          inputText("Rate Of Interest", "In Percent", textStyle, roiController),
          Row(
            children: <Widget>[
              Expanded(
                child:
                    inputText("Term", "In Percent", textStyle, termController),
              ),
              Expanded(
                child: dropdownList(_currencies, _curCurrencies),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: buttonAction(
                  "Submit",
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColorDark,
                ),
              ),
              Expanded(
                child: buttonAction("Reset", Theme.of(context).primaryColorDark,
                    Theme.of(context).primaryColorLight),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(_minPadding),
            child: Text(
              _resultDisplay,
              style: textStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget getBannerAsset(String source) {
    AssetImage assetImage = AssetImage(source);
    return Container(
      child: Image(
        image: assetImage,
        width: 125.0,
        height: 125.0,
      ),
      margin: EdgeInsets.all(_minPadding),
    );
  }

  Widget inputText(String type, String hint, TextStyle textStyle, controller) {
    return Container(
        margin: EdgeInsets.all(_minPadding),
        // height: 48.0,
        child: TextFormField(
          style: textStyle,
          controller: controller,
          validator: (String value) {
            return _validateNumber(value);
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: type,
              hintText: hint,
              errorStyle: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 15.0,
              ),
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        ));
  }

  Widget dropdownList(_items, _curItem) {
    return Container(
      margin: EdgeInsets.all(_minPadding),
      child: DropdownButton<String>(
        items: _items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            child: Text(value),
            value: value,
          );
        }).toList(),
        value: _curItem,
        onChanged: (String selectedValue) {
          _onSelectedDropdown(selectedValue);
        },
      ),
    );
  }

  Widget buttonAction(String type, butonColor, textColor) {
    return Container(
      margin: EdgeInsets.all(_minPadding),
      child: RaisedButton(
        color: butonColor,
        textColor: textColor,
        child: Text(type, textScaleFactor: 1.5),
        onPressed: () {
          if (type == "Submit") {
            if (_formKey.currentState.validate()) {
              _calculateResult();
            }
          } else {
            _resetCalculator();
          }
        },
      ),
    );
  }

  void _onSelectedDropdown(String newValue) {
    setState(() {
      this._curCurrencies = newValue;
    });
  }

  void _calculateResult() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double result = principal + (principal * roi * term) / 100;

    setState(() {
      this._resultDisplay =
          'After $term years, yours investment will be $result $_curCurrencies';
    });
  }

  String _validateNumber(String value) {
    if (value.isEmpty) {
      return 'Your input is empty';
    } else if (double.tryParse(value) == null) {
      return 'Your input is not number';
    } else {
      return null;
    }
  }

  void _resetCalculator() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    setState(() {
      this._resultDisplay = '';
      this._curCurrencies = 'Rupiah';
    });
  }
}
