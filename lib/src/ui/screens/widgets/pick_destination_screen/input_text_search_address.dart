import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../providers/maps_provider.dart';

class InputTextSearchAddress extends StatelessWidget {
  const InputTextSearchAddress({
    @required this.searchLocationController,
    @required this.iconTimesSize,
    @required this.completer,
  });

  final TextEditingController searchLocationController;
  final Completer<GoogleMapController> completer;
  final double iconTimesSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight, right: 40, left: 40),
      child: Material(
        elevation: 10.0,
        child: TypeAheadFormField<Placemark>(
          hideOnError: true,
          errorBuilder: (context, error) => Center(child: Text(error.toString())),
          textFieldConfiguration: TextFieldConfiguration(
            controller: searchLocationController,
            decoration: InputDecoration(
              hintStyle: appTheme.caption(context),
              hintText: 'Cari Lokasi Absen',
              filled: true,
              fillColor: colorPallete.white,
              border: InputBorder.none,
              prefixIcon: const Icon(FontAwesomeIcons.searchLocation, size: 18),
              suffixIcon: Selector<GlobalProvider, bool>(
                selector: (_, provider) => provider.isShowClearTextField,
                builder: (_, showClearTextField, __) {
                  return showClearTextField
                      ? IconButton(
                          icon: const Icon(FontAwesomeIcons.times),
                          onPressed: () => _clearSearchLocation(context),
                          iconSize: iconTimesSize,
                          color: colorPallete.weekEnd,
                        )
                      : const SizedBox();
                },
              ),
            ),
          ),
          suggestionsCallback: (pattern) async {
            final globalProvider = context.read<GlobalProvider>();
            final mapsProvider = context.read<MapsProvider>();
            if (pattern.isEmpty) {
              Future.delayed(const Duration(milliseconds: 500),
                  () => globalProvider.setShowClearTextField(false));
              return [];
            } else {
              Future.delayed(const Duration(milliseconds: 500),
                  () => globalProvider.setShowClearTextField(true));
              return await mapsProvider.getAutocompleteAddress(query: pattern);
            }
          },
          onSuggestionSelected: (suggestion) async {
            await _moveCameraByAddress(
              suggestion.position.latitude,
              suggestion.position.longitude,
              completer,
            );
          },
          itemBuilder: (context, itemData) {
            return ListTile(
              title: Text(
                  '${itemData.name},${itemData.subLocality},${itemData.locality},${itemData.subAdministrativeArea},${itemData.administrativeArea},${itemData.country}'),
              trailing: CircleAvatar(
                backgroundColor: colorPallete.primaryColor,
                child: FittedBox(
                  child: Text(itemData.isoCountryCode),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _moveCameraByAddress(
      double latitude, double longitude, Completer<GoogleMapController> completerController) async {
    try {
      final List<Placemark> placemarkLatLng =
          await Geolocator().placemarkFromCoordinates(latitude, longitude);
      if (placemarkLatLng != null) {
        final GoogleMapController controller = await completerController.future;
        for (final item in placemarkLatLng) {
          await controller.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(item.position.latitude, item.position.longitude), 18),
          );
        }
      } else {
        throw 'Destinasi Tidak Ditemukan';
      }
    } on PlatformException catch (err) {
      if (err.code == 'ERROR_GEOCODNG_ADDRESSNOTFOUND') {
        await globalF.showToast(
            message: 'Destinasi Tidak Ditemukan', isError: true, isLongDuration: true);
      } else {
        await globalF.showToast(message: err.code, isError: true, isLongDuration: true);
      }
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
    }
  }

  void _clearSearchLocation(BuildContext context) {
    searchLocationController.clear();
    context.read<GlobalProvider>().setShowClearTextField(false);
  }
}
