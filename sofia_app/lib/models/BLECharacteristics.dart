class BLECharacteristics {
  String? serviceGuid;
  String? characteristicGuid;
  List<int>? value;

  BLECharacteristics({this.serviceGuid, this.characteristicGuid, this.value});

  Map<String, dynamic> toJson() {
    return {
      'serviceGuid': serviceGuid,
      'characteristicGuid': characteristicGuid,
      'value': value,
    };
  }
}
