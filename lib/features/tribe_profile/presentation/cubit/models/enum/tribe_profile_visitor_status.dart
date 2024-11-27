enum TribeProfileVisitorStatus {
  hasRequestPending,
  joinRequestSent,
  isMember,
  isNotMember,
  isOwner,
}

extension TribeProfileVisitorStatusExtension on TribeProfileVisitorStatus {
  bool get isMember => this == TribeProfileVisitorStatus.isMember;
  bool get isNotMember => this == TribeProfileVisitorStatus.isNotMember;
  bool get isOwner => this == TribeProfileVisitorStatus.isOwner;
  bool get hasRequestPending =>
      this == TribeProfileVisitorStatus.hasRequestPending;
  bool get joinRequestSent => this == TribeProfileVisitorStatus.joinRequestSent;
}
