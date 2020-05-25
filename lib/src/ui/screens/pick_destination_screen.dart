import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';

class PickDestinationScreen extends StatelessWidget {
  static const routeNamed = "/pick-destination-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pilih Destinasi')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight / 2, left: 40, right: 40),
              child: TextFormFieldCustom(
                onSaved: (value) => '',
                disableOutlineBorder: false,
                prefixIcon: Icon(FontAwesomeIcons.searchLocation),
                hintText: "Cari Destinasi ...",
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('data'),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              color: colorPallete.white,
              boxShadow: [
                BoxShadow(color: Colors.black87, blurRadius: 3),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Destinasimu',
                  style:
                      appTheme.headline6(context).copyWith(fontFamily: "Righteous", fontSize: 18),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          )
        ],
      ),
    );
  }
}
