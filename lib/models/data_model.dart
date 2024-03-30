class StateModel {
  final String state;
  final List<String> cities;

  StateModel({required this.state, required this.cities});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      state: json['state'] as String,
      cities: List<String>.from(json['city'] as List),
    );
  }
}
