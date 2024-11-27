import 'package:online_tribes/core/error/reasons/github_error_reason.dart';

GithubErrorReason mapGithubErrorReason(int? statusCode) {
  switch (statusCode) {
    case 400:
      return GithubErrorReason.badRequest;
    case 401:
      return GithubErrorReason.unauthorized;
    case 403:
      return GithubErrorReason.forbidden;
    case 404:
      return GithubErrorReason.notFound;
    case 409:
      return GithubErrorReason.conflict;
    case 429:
      return GithubErrorReason.rateLimitExceeded;
    case 500:
    default:
      return GithubErrorReason.serverError;
  }
}
