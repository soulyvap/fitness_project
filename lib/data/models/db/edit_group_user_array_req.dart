class EditGroupUserArrayReq {
  String groupId;
  String userId;
  GroupUserArray groupUserArray;
  GroupArrayAction groupArrayAction;

  EditGroupUserArrayReq(
      {required this.groupId,
      required this.userId,
      required this.groupUserArray,
      required this.groupArrayAction});
}

enum GroupUserArray {
  members,
  admins,
  allowedUsers,
  ;

  String get name {
    return toString().split('.').last;
  }
}

enum GroupArrayAction {
  add,
  remove,
  ;
}
