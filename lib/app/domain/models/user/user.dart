// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String username,

    ///
    @JsonKey(
      name: 'avatar',
      fromJson: avatarPathFromJson,
    )
    String? avatarPath,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  // TODO: implement avatarPath
  String? get avatarPath => throw UnimplementedError();

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement username
  String get username => throw UnimplementedError();
}

String? avatarPathFromJson(Map<String, dynamic> json) {
  return json['tmdb']?['avatar_path'] as String?;
}
