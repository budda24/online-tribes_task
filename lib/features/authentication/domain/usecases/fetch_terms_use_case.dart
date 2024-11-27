import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/reasons/github_error_reason.dart';
import 'package:online_tribes/core/models/github_resources_paths.dart';
import 'package:online_tribes/core/services/github_content_service.dart';

class FetchTermsUseCase {
  final GithubContentService _githubContentService;

  FetchTermsUseCase(this._githubContentService);

  Future<Either<BaseApiError<GithubErrorReason>, String>> execute({
    required String languageCode,
  }) async {
    // Define the GitHub path for terms based on language
    final githubResourcesPaths = GithubContentPath(
      owner: 'budda24',
      repo: 'terms_condition_online_trribes',
      path: 'terms_$languageCode.md',
      branch: 'main',
    );

    // Fetch the content from GitHub
    final result = await _githubContentService.fetchMarkdownFile(
      githubResourcesPaths: githubResourcesPaths,
    );

    // Map the result to return a string or an error
    return result.fold(
      Left.new,
      (contentList) {
        // Assuming the file content is a single string, you can handle it here
        if (contentList.isNotEmpty) {
          return Right(contentList);
        } else {
          return const Left(BaseApiError(reason: GithubErrorReason.notFound));
        }
      },
    );
  }
}
