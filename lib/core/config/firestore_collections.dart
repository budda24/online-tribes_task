class FirestoreCollections {
  static const String users = 'users';
  static const String loginAttempts = 'login-attempts';
  static const String posts = 'posts';
  static const String comments = 'comments';
  static const String tribes = 'tribes';
  static const String tribeNames = 'tribe-search-tribe-names';
  static const String userHome = 'user-home';
  static const String userNames = 'tribe-search-user-names';
  static const String typeAhead = 'typeahead-data';
  static const String typeAheadGenderDoc = 'genders';
  static const String typeAheadPlacesDoc = 'places';
  static const String typeAheadLanguagesDoc = 'languages';
  static const String typeAheadHobbiesDoc = 'hobbies';
  static const String typeAheadTypesDoc = 'tribe-search-tribe-types';
  static const String config = 'config';
  static const String tribeRulesConfig = 'tribe-rules';
  static const String tribeMembershipTickets = 'tribe-membership-tickets';

  // Subcollections
  static String userPosts(String userId) => 'users/$userId/posts';
  static String userComments(String userId, String postId) =>
      'users/$userId/posts/$postId/comments';

  static String sanitizeDocName(String username) {
    // Replace or remove any special characters that Firestore might not accept
    return username.replaceAll(RegExp(r'[\/#?\[\]]'), '');
  }
}
