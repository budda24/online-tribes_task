import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/tribe_registration/domain/entities/tribe_registration_step.dart';

class TribeUpdateBuilder {
  final Map<String, dynamic> _updateData = {};

  TribeUpdateBuilder setTribeName(String? name) {
    if (name != null) {
      _updateData[TribeModel.fieldName] = name;
    }
    return this;
  }

  TribeUpdateBuilder setLanguage(String? language) {
    if (language != null) {
      _updateData[TribeModel.fieldLanguage] = language;
    }
    return this;
  }

  TribeUpdateBuilder setDescription(String? description) {
    if (description != null) {
      _updateData[TribeModel.fieldDescription] = description;
    }
    return this;
  }

  TribeUpdateBuilder setType(String? type) {
    if (type != null) {
      _updateData[TribeModel.fieldType] = type;
    }
    return this;
  }

  TribeUpdateBuilder setThemes(List<String>? themes) {
    if (themes != null) {
      _updateData[TribeModel.fieldThemes] = themes;
    }
    return this;
  }

  TribeUpdateBuilder setOwnerId(String? ownerId) {
    if (ownerId != null) {
      _updateData[TribeModel.fieldOwnerId] = ownerId;
    }
    return this;
  }

  TribeUpdateBuilder setMembers(List<String>? members) {
    if (members != null) {
      _updateData[TribeModel.fieldMembers] = members;
    }
    return this;
  }

  TribeUpdateBuilder setPinnedPostsId(List<String>? pinnedPostsId) {
    if (pinnedPostsId != null) {
      _updateData[TribeModel.fieldPinnedPostsId] = pinnedPostsId;
    }
    return this;
  }

  TribeUpdateBuilder setMembershipCriteria(String? membershipCriteria) {
    if (membershipCriteria != null) {
      _updateData[TribeModel.fieldMembershipCriteria] = membershipCriteria;
    }
    return this;
  }

  TribeUpdateBuilder setCreatedAt(DateTime? createdAt) {
    if (createdAt != null) {
      _updateData[TribeModel.fieldCreatedAt] = createdAt;
    }
    return this;
  }

  TribeUpdateBuilder setRegistrationStep({
    required TribeRegistrationStep registrationStep,
  }) {
    _updateData[TribeModel.fieldLastRegistrationStepIndex] =
        registrationStep.index;
    return this;
  }

  TribeUpdateBuilder setSignUrl({
    required String signUrl,
  }) {
    _updateData[TribeModel.fieldSignUrl] = signUrl;
    return this;
  }

  Map<String, dynamic> build() => _updateData;
}
