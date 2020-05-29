import 'package:tuple/tuple.dart';
import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './widgets/pick_destination_screen/picked_destination.dart';
import './widgets/pick_destination_screen/list_destination.dart';

import '../../providers/absen_provider.dart';
import '../../providers/user_provider.dart';

class PickDestinationScreen extends StatelessWidget {
  static const routeNamed = "/pick-destination-screen";
  @override
  Widget build(BuildContext context) {
    final TextEditingController _filterController = TextEditingController();
    print('Rebuild Pick Destination Screen');
    final absenProvider = Provider.of<AbsenProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Destinasi')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: kToolbarHeight / 2, left: 20, right: 20, bottom: 20),
              child: TextFormFieldCustom(
                onSaved: (value) => '',
                disableOutlineBorder: false,
                prefixIcon: Icon(FontAwesomeIcons.searchLocation),
                hintText: "Cari Destinasi ...",
                controller: _filterController,
                onChanged: (query) => context.read<AbsenProvider>().filterListDestination(query),
                suffixIcon: IconButton(
                  icon: Icon(FontAwesomeIcons.times),
                  onPressed: () {
                    _filterController.clear();
                    context.read<AbsenProvider>().resetFilterListDestination();
                  },
                  iconSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: absenProvider.fetchDestinationUser(userProvider.user.idUser),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return LoadingFutureBuilder();
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.hasData) {
                  return Selector3<AbsenProvider, AbsenProvider, GlobalProvider,
                      Tuple3<List<DestinasiModel>, List<DestinasiModel>, bool>>(
                    selector: (_, fullList, filteredList, isLoading) => Tuple3(
                      fullList.listDestinasi,
                      filteredList.filteredListDestinasi,
                      isLoading.isLoading,
                    ),
                    builder: (_, value, __) {
                      print("Rebuild Selector Pick Destination Screen");
                      final resultList =
                          (value.item2.length != 0 || _filterController.text.isNotEmpty)
                              ? value.item2
                              : value.item1.where((element) => element.status != "t").toList();
                      return (value.item3)
                          ? LoadingFutureBuilder(isLinearProgressIndicator: false)
                          : ListView.builder(
                              itemCount: resultList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final result = resultList[index];
                                return ListDestination(result: result);
                              },
                            );
                    },
                  );
                }
                return Center(child: Text('No Data'));
              },
            ),
          ),
          PickedDestination()
        ],
      ),
    );
  }
}
