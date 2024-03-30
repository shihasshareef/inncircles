import 'package:flutter/cupertino.dart';
import 'package:inncircles/models/data_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  List<StateModel> _data = [];
  String? _state;
  String? _city;

  set setData(List<StateModel> value) {
    _data = value;
    notifyListeners();
  }

  get getData{
    return _data;
  }

  set setState(String? value) {
    _state = value;
    notifyListeners();
  }

  get getState{
    return _state;
  }

  set setCity(String? value) {
    _city = value;
    notifyListeners();
  }

  get getCity{
    return _city;
  }
}
