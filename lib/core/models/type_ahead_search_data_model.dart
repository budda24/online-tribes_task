class TypeAheadSearchDataResponseModel {
  final List<TypeAheadSearchDataModel> values;

  TypeAheadSearchDataResponseModel(this.values);

  factory TypeAheadSearchDataResponseModel.fromDocData(
    Map<String, dynamic>? docData,
  ) {
    final data = docData?['values'] as List<dynamic>?;

    final values = data
            ?.map(
              (element) => TypeAheadSearchDataModel.fromMap(
                element as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [];

    return TypeAheadSearchDataResponseModel(values);
  }
}

class TypeAheadSearchDataModel {
  final String key;
  final List<String> tribeIds;

  TypeAheadSearchDataModel({
    required this.key,
    required this.tribeIds,
  });

  factory TypeAheadSearchDataModel.fromMap(Map<String, dynamic> map) {
    return TypeAheadSearchDataModel(
      key: map.keys.first,
      tribeIds: (map.values.first as List).cast<String>(),
    );
  }
}
