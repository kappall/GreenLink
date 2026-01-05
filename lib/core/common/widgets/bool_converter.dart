import 'package:freezed_annotation/freezed_annotation.dart';

class BoolConverter implements JsonConverter<bool, dynamic> {
  const BoolConverter();

  @override
  bool fromJson(dynamic json) {
    if (json is int) return json == 1;
    if (json is bool) return json;
    if (json is String) return json == '1' || json.toLowerCase() == 'true';
    return false;
  }

  @override
  dynamic toJson(bool object) => object ? 1 : 0;
}
