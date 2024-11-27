/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@Freezed(copyWith: false)
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String userId,
    required String email,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  factory AuthUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return AuthUser(
      userId: doc.id,
      email: data['email'] as String,
    );
  }
}
 */
