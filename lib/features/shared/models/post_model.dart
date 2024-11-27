import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.g.dart';
part 'post_model.freezed.dart';

@freezed
class PostModel with _$PostModel {
  factory PostModel({
    required String postId,
    required String authorId,
    required String content,
    required List<String> likedBy,
    required List<String> comments,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? imageUrl,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
