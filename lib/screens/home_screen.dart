import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/data_model.dart';
import '../providers/home_screen_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<StateModel>> _statesFuture;
  late HomeScreenProvider homeScreenProvider;

  @override
  void initState() {
    super.initState();
    homeScreenProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    _statesFuture = loadStates();
  }

  Future<List<StateModel>> loadStates() async {
    String jsonData = await rootBundle.loadString('assets/json/data.json');
    List<dynamic> jsonList = json.decode(jsonData)['data'];
    List<StateModel> states =
        jsonList.map((json) => StateModel.fromJson(json)).toList();
    return states;
  }

  @override
  Widget build(BuildContext context) {
    homeScreenProvider = Provider.of<HomeScreenProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select State & City'),
      ),
      body: Center(
        child: FutureBuilder<List<StateModel>>(
          future: _statesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<StateModel> states = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text('Select State'),
                      value: homeScreenProvider.getState,
                      onChanged: (String? newValue) {
                        setState(() {
                          homeScreenProvider.setState = newValue!;
                          homeScreenProvider.setCity = null;
                        });
                      },
                      items: states.map<DropdownMenuItem<String>>(
                          (StateModel stateData) {
                        return DropdownMenuItem<String>(
                          value: stateData.state,
                          child: Text(stateData.state),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text('Select City'),
                      value: homeScreenProvider.getCity,
                      onChanged: (String? newValue) {
                        setState(() {
                          homeScreenProvider.setCity = newValue;
                        });
                      },
                      items: homeScreenProvider.getState != null
                          ? states
                              .firstWhere((state) =>
                                  state.state == homeScreenProvider.getState)
                              .cities
                              .map<DropdownMenuItem<String>>((city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList()
                          : null,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
