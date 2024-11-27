import 'package:online_tribes/features/shared/repositories/user/data/models/user_activity.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_information.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/user_registration/domain/entities/user_registration_step_enum.dart';

class UserUpdateBuilder {
  final Map<String, dynamic> _updateData = {};
  final Map<String, dynamic> _informationData = {};
  final Map<String, dynamic> _userActivityData = {};

  // Set username directly on UserModel
  UserUpdateBuilder setUsername(String? username) {
    if (username != null) {
      _updateData[UserModel.fieldUsername] = username;
    }
    return this;
  }

  // Set registration step index directly on UserModel
  UserUpdateBuilder setRegistrationStep({
    UserRegistrationStep? registrationStep,
  }) {
    if (registrationStep != null) {
      _updateData[UserModel.fieldLastRegistrationStepIndex] =
          registrationStep.index;
    }
    return this;
  }

  // Methods to set fields within UserInformation
  /// Merges the provided [information] into the existing [_informationData].
  /// Can be used in conjunction with individual setters without data overwrite.
  UserUpdateBuilder setInformation(UserInformation? information) {
    if (information != null) {
      _informationData.addAll(information.toJson());
    }
    return this;
  }

  UserUpdateBuilder setBio(String? bio) {
    if (bio != null) {
      _informationData[UserInformation.fieldBio] = bio;
    }
    return this;
  }

  UserUpdateBuilder setGender(String? gender) {
    if (gender != null) {
      _informationData[UserInformation.fieldGender] = gender;
    }
    return this;
  }

  UserUpdateBuilder setMyPlace(String? myPlace) {
    if (myPlace != null) {
      _informationData[UserInformation.fieldMyPlace] = myPlace;
    }
    return this;
  }

  UserUpdateBuilder setAge(double? age) {
    if (age != null) {
      _informationData[UserInformation.fieldAge] = age;
    }
    return this;
  }

  UserUpdateBuilder setLanguages(List<String>? languages) {
    if (languages != null) {
      _informationData[UserInformation.fieldLanguages] = languages;
    }
    return this;
  }

  UserUpdateBuilder setHobbies(List<String>? hobbies) {
    if (hobbies != null) {
      _informationData[UserInformation.fieldHobbies] = hobbies;
    }
    return this;
  }

  UserUpdateBuilder setProfilePictureUrl(String? profilePictureUrl) {
    if (profilePictureUrl != null) {
      _informationData[UserInformation.fieldProfilePictureUrl] =
          profilePictureUrl;
    }
    return this;
  }

  UserUpdateBuilder setNotifications(List<String>? notifications) {
    if (notifications != null) {
      _userActivityData[UserActivity.fieldNotifications] = notifications;
    }
    return this;
  }

  UserUpdateBuilder setLastTimeActive(DateTime? lastTimeActive) {
    if (lastTimeActive != null) {
      _userActivityData[UserActivity.fieldLastTimeActive] =
          lastTimeActive.toIso8601String();
    }
    return this;
  }

  UserUpdateBuilder setProfileCreatedAt(DateTime? profileCreatedAt) {
    if (profileCreatedAt != null) {
      _userActivityData[UserActivity.fieldProfileCreatedAt] =
          profileCreatedAt.toIso8601String();
    }
    return this;
  }

  // Build method to compile the update data
  Map<String, dynamic> build() {
    _addIfNotEmpty(_informationData, UserModel.fieldInformation);
    _addIfNotEmpty(_userActivityData, UserModel.fieldUserActivity);
    return _updateData;
  }

  void _addIfNotEmpty(Map<String, dynamic> data, String field) {
    if (data.isNotEmpty) {
      _updateData[field] = data;
    }
  }
}
