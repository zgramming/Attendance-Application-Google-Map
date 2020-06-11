import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../providers/absen_provider.dart';
import '../../providers/user_provider.dart';
import './shimmer/shimmer_pick_location.dart';
import './widgets/pick_destination_screen/list_destination.dart';
import './widgets/pick_destination_screen/picked_destination.dart';

class PickDestinationScreen extends StatefulWidget {
  static const routeNamed = '/pick-destination-screen';

  @override
  _PickDestinationScreenState createState() => _PickDestinationScreenState();
}

class _PickDestinationScreenState extends State<PickDestinationScreen> {
  final TextEditingController _searchLocationController = TextEditingController();

  @override
  void dispose() {
    _searchLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<AbsenProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi')),
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
                prefixIcon: const Icon(FontAwesomeIcons.searchLocation),
                hintText: 'Cari Lokasi Absen...',
                controller: _searchLocationController,
                onChanged: _onChangedSearcLocation,
                suffixIcon: Selector<GlobalProvider, bool>(
                  selector: (_, provider) => provider.isShowClearTextField,
                  builder: (_, isShowClearTextField, __) {
                    return isShowClearTextField
                        ? IconButton(
                            icon: const Icon(FontAwesomeIcons.times),
                            onPressed: _clearSearchLocation,
                            iconSize: 18,
                            color: colorPallete.weekEnd,
                          )
                        : const SizedBox();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: absenProvider.fetchDestinationUser(userProvider.user.idUser),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return ShimmerPickLocatation();
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Selector3<AbsenProvider, AbsenProvider, GlobalProvider,
                      Tuple3<List<DestinasiModel>, List<DestinasiModel>, bool>>(
                    selector: (_, fullList, filteredList, isLoading) => Tuple3(
                      fullList.listDestinasi,
                      filteredList.filteredListDestinasi,
                      isLoading.isLoading,
                    ),
                    builder: (_, value, __) {
                      final resultList =
                          (value.item2.isNotEmpty || _searchLocationController.text.isNotEmpty)
                              ? value.item2
                              : value.item1.where((element) => element.status != 't').toList();
                      return (value.item3)
                          ? const LoadingFutureBuilder(isLinearProgressIndicator: false)
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
              },
            ),
          ),
          const PickedDestination()
        ],
      ),
    );
  }

  void _clearSearchLocation() {
    _searchLocationController.clear();
    context.read<GlobalProvider>().setShowClearTextField(false);
    context.read<AbsenProvider>().resetFilterListDestination();
  }

  void _onChangedSearcLocation(String value) {
    final globalProvider = context.read<GlobalProvider>();
    final absenProvider = context.read<AbsenProvider>();
    absenProvider.filterListDestination(value);
    if (value.isEmpty) {
      globalProvider.setShowClearTextField(false);
    } else {
      globalProvider.setShowClearTextField(true);
    }
  }
}
