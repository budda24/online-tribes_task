class StoragePaths {
  // Define the static folder paths
  static const String profilePicturesFolder = 'profile_pictures';
  static const String users = 'users';
  static const String tribes = 'tribes';

  static String userProfilePicturePath(String userId) {
    return '$users/$userId/$profilePicturesFolder/profile_picture.jpg';
  }

  static String tribalSignPicturePath(String tribeId) {
    return '$tribes/$tribeId/$profilePicturesFolder/sign_picture.jpg';
  }

  // Generic method for any path
  static String genericPath(
    String basePath,
    String identifier,
    String fileName,
  ) =>
      '$basePath/$identifier/$fileName';
}
