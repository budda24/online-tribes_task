import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

enum GithubErrorReason {
  notFound, // 404
  unauthorized, // 401
  forbidden, // 403
  rateLimitExceeded, // 429
  serverError, // 500
  badRequest, // 400
  conflict, // 409
  unknownError, // Catch-all for other errors
}

extension GithubErrorReasonErrorMessage on GithubErrorReason {
  String localizedMessage(BuildContext context) {
    final localizations = context.localizations;

    switch (this) {
      case GithubErrorReason.notFound:
        return localizations.githubErrorNotFound;
      case GithubErrorReason.unauthorized:
        return localizations.githubErrorUnauthorized;
      case GithubErrorReason.forbidden:
        return localizations.githubErrorForbidden;
      case GithubErrorReason.rateLimitExceeded:
        return localizations.githubErrorRateLimitExceeded;
      case GithubErrorReason.serverError:
        return localizations.githubErrorServerError;
      case GithubErrorReason.badRequest:
        return localizations.githubErrorBadRequest;
      case GithubErrorReason.conflict:
        return localizations.githubErrorConflict;
      case GithubErrorReason.unknownError:
        return localizations.githubErrorUnknown;
    }
  }
}
