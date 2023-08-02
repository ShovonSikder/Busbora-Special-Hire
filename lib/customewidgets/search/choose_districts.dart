import 'package:appscwl_specialhire/models/all_districts_model.dart';
import 'package:appscwl_specialhire/providers/districts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';

class ChooseDistricts extends StatefulWidget {
  static String routeName = '/search_districts';
  const ChooseDistricts({Key? key}) : super(key: key);

  @override
  State<ChooseDistricts> createState() => _ChooseDistrictsState();
}

class _ChooseDistrictsState extends State<ChooseDistricts> {
  final _searchController = TextEditingController();
  List<Districts>? districts = [];
  List<Districts>? tempDistricts = [];
  String? label;
  Districts? selectedDistricts;
  @override
  void initState() {
    districts = Provider.of<DistrictsProvider>(context, listen: false)
        .allDistrictsModel!
        .districts;
    tempDistricts = [...districts!];

    super.initState();
  }

  @override
  void didChangeDependencies() {
    label = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)!.select} $label'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildSearchTextField(context),
            buildItemListExpanded(),
          ],
        ),
      ),
    );
  }

  Expanded buildItemListExpanded() {
    return Expanded(
      child: tempDistricts!.isNotEmpty
          ? ListView.builder(
              itemCount: tempDistricts!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Transform.translate(
                          offset: const Offset(-15, 0),
                          child: Text(tempDistricts![index].distTitle ?? '')),
                      leading: const Icon(Icons.location_city_sharp),
                      onTap: () {
                        Navigator.pop(context, tempDistricts![index]);
                      },
                    ),
                    const Divider(
                      height: 0,
                      thickness: .5,
                    ),
                  ],
                );
              },
            )
          : Center(child: Text(AppLocalizations.of(context)!.no_data_found)),
    );
  }

  TextField buildSearchTextField(BuildContext context) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.search,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 12),
        // prefixIcon: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context, null);
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        suffixIcon: const Icon(Icons.search_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onChanged: (value) {
        _filterList(value);
      },
    );
  }

  void _filterList(String value) {
    if (value.isNotEmpty) {
      tempDistricts = [];
      for (var dist in districts!) {
        if (dist.distTitle!.toLowerCase().contains(value.toLowerCase())) {
          tempDistricts!.add(dist);
        }
      }
    } else {
      tempDistricts = [...districts!];
    }
    setState(() {});
  }
}
