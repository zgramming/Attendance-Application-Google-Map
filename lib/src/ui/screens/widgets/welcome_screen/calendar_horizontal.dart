import 'package:flutter/material.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import './card_calendar.dart';

import '../../../../providers/user_provider.dart';

class CalendarHorizontal extends StatefulWidget {
  @override
  _CalendarHorizontalState createState() => _CalendarHorizontalState();
}

class _CalendarHorizontalState extends State<CalendarHorizontal> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Future<List<AbsensiStatusModel>> getStatusAbsensi(DateTime now) async {
    final result = absensiAPI.getStatusAbsenMonthly(
      idUser: context.read<UserProvider>().user.idUser,
      dateTime: now,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild Calendar Horizontal");
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Selector<GlobalProvider, DateTime>(
                  selector: (_, provider) => provider.dateAddSubstract,
                  builder: (_, dateTime, __) => Text(
                    globalF.formatYearMonth(dateTime),
                    style: appTheme.headline6(context),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Selector<GlobalProvider, DateTime>(
                selector: (_, provider) => provider.dateAddSubstract,
                builder: (_, dateTime, __) => FutureBuilder(
                  future: getStatusAbsensi(dateTime),
                  builder:
                      (BuildContext context, AsyncSnapshot<List<AbsensiStatusModel>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return LoadingFutureBuilder(isLinearProgressIndicator: true);
                    }
                    if (snapshot.hasError) {
                      return InkWell(
                        onTap: _refreshMenu,
                        child: Text(
                          "${snapshot.error.toString()} , Tap Untuk Refresh Data",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      return Container(
                        height: sizes.height(context) / 8,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ScrollablePositionedList.builder(
                          initialScrollIndex: dateTime.day,
                          initialAlignment: .6,
                          itemCount: globalF.totalDaysOfMonth(
                            dateTime.year,
                            dateTime.month,
                          ),
                          itemScrollController: itemScrollController,
                          itemPositionsListener: itemPositionsListener,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return CardCalendar(
                              now: dateTime,
                              index: index,
                              list: snapshot.data,
                            );
                          },
                        ),
                      );
                    }
                    return Text('No Data');
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
        Positioned(
          child: Row(
            children: [
              InkWell(
                child: const Icon(FontAwesomeIcons.angleLeft, size: 18),
                onTap: () => context.read<GlobalProvider>().substractMonthCalendar(),
              ),
              const SizedBox(width: 20),
              InkWell(
                child: const Icon(FontAwesomeIcons.angleRight, size: 18),
                onTap: () => context.read<GlobalProvider>().addMonthCalendar(),
              ),
              const SizedBox(width: 20),
              Selector<GlobalProvider, DateTime>(
                selector: (_, provider) => provider.dateAddSubstract,
                builder: (_, dateTime, __) => InkWell(
                  child: const Icon(FontAwesomeIcons.calendar, size: 18),
                  onTap: () => itemScrollController.scrollTo(
                    index: dateTime.day,
                    alignment: .6,
                    duration: Duration(seconds: 2),
                  ),
                ),
              ),
            ],
          ),
          top: 10,
          right: 30,
        )
      ],
    );
  }

  void _refreshMenu() {
    setState(() {});
  }
}
