import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location.freezed.dart';
part 'user_location.g.dart';

@freezed
abstract class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
    String? address,
  }) = _UserLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);
}
