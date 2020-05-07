import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TableAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              IconButton(
                icon: Icon(FontAwesomeIcons.angleLeft),
                onPressed: () {},
              ),
              Text(
                globalF.formatYearMonth(DateTime.now(), type: 3),
                style: appTheme.subtitle1(context),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.angleRight),
                onPressed: () {},
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
        SizedBox(height: 20),
        Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                color: Colors.amber,
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                  style: appTheme.button(context),
                  child: Row(
                    children: [
                      Flexible(child: Text('Tanggal'), fit: FlexFit.tight, flex: 2),
                      Flexible(child: Text('Datang'), fit: FlexFit.tight),
                      Flexible(child: Text('Pulang'), fit: FlexFit.tight),
                      Flexible(child: Text('Durasi'), fit: FlexFit.tight),
                    ],
                  ),
                ),
              ),
              Container(
                child: ListView.builder(
                  itemCount: 15,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, left: 4.0),
                      child: DefaultTextStyle(
                        style: appTheme.caption(context).copyWith(fontWeight: FontWeight.bold),
                        child: Row(
                          children: [
                            Flexible(child: Text('Tanggal'), fit: FlexFit.tight, flex: 2),
                            Flexible(child: Text('Datang'), fit: FlexFit.tight),
                            Flexible(child: Text('Pulang'), fit: FlexFit.tight),
                            Flexible(child: Text('Durasi'), fit: FlexFit.tight),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
