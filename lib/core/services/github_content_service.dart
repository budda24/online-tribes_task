import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/github_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/github_error_reason.dart';
import 'package:online_tribes/core/models/github_resources_paths.dart';

class GithubContentService {
  final Dio _dio;

  GithubContentService(this._dio);

  // Fetch file content from a private GitHub repository
  Future<Either<BaseApiError<GithubErrorReason>, List<Map<String, dynamic>>>>
      fetchFileContentJson({
    required GithubContentPath githubResourcesPaths,
  }) async {
    try {
      final apiKey = dotenv.env['GITHUB_API_KEY'];

      final response = await _dio.get<dynamic>(
        'https://api.github.com/repos/${githubResourcesPaths.owner}/${githubResourcesPaths.repo}/contents/${githubResourcesPaths.path}?ref=${githubResourcesPaths.branch}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey', // GitHub Personal Access Token
            'Accept': 'application/vnd.github.raw+json',
            'X-GitHub-Api-Version': '2022-11-28',
          },
        ),
      );

      if (response.statusCode == 200) {
        final content = (response.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        return Right(content);
      } else {
        return Left(
          BaseApiError(
            reason: mapGithubErrorReason(response.statusCode),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        BaseApiError(
          reason: mapGithubErrorReason(e.response?.statusCode),
        ),
      );
    }
  }

  Future<Either<BaseApiError<GithubErrorReason>, String>> fetchMarkdownFile({
    required GithubContentPath githubResourcesPaths,
  }) async {
    try {
      final apiKey = dotenv.env['GITHUB_API_KEY'];

      final response = await _dio.get<dynamic>(
        'https://api.github.com/repos/${githubResourcesPaths.owner}/${githubResourcesPaths.repo}/contents/${githubResourcesPaths.path}?ref=${githubResourcesPaths.branch}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey', // GitHub Personal Access Token
            'Accept': 'application/vnd.github.v3.raw', // Fetch raw content
          },
        ),
      );

      if (response.statusCode == 200) {
        final content = response.data as String; // Raw markdown content
        return Right(content);
      } else {
        return Left(
          BaseApiError(
            reason: mapGithubErrorReason(response.statusCode),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        BaseApiError(
          reason: mapGithubErrorReason(e.response?.statusCode),
        ),
      );
    }
  }
}
