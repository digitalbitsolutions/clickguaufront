import 'package:bubbly/utils/const_res.dart';

class UrlRes {
  ///RegisterUser
  static final String registerUser = ConstRes.baseUrl + 'User/Registration';
  static final String checkUsername = ConstRes.baseUrl + 'User/checkUsername';
  static final String deviceToken = 'device_token';
  static final String userEmail = 'user_email';
  static final String fullName = 'full_name';
  static final String loginType = 'login_type';
  static final String userName = 'user_name';
  static final String identity = 'identity';
  static final String platform = 'platform';

  ///getUserVideos getUserLikesVideos
  static final String getUserVideos = ConstRes.baseUrl + 'Post/getUserVideos';
  static final String getUserLikesVideos =
      ConstRes.baseUrl + 'Post/getUserLikesVideos';
  static final String start = 'start';
  static final String limit = 'limit';
  static final String userId = 'user_id';
  static final String myUserId = 'my_user_id';

  /// getPostList
  ///type following and related
  static final String getPostList = ConstRes.baseUrl + 'Post/getPostList';
  static final String type = 'type';
  static final String following = 'following';
  static final String trending = 'trending';
  static final String related = 'related';

  ///LikeUnlikeVideo
  static final String likeUnlikePost = ConstRes.baseUrl + 'Post/LikeUnlikePost';
  static final String postId = 'post_id';

  ///CommentListByPostId
  static final String getCommentByPostId =
      ConstRes.baseUrl + 'Post/getCommentByPostId';

  ///addComment
  static final String addComment = ConstRes.baseUrl + 'Post/addComment';
  static final String comment = 'comment';

  ///deleteComment
  static final String deleteComment = ConstRes.baseUrl + 'Post/deleteComment';
  static final String commentId = 'comments_id';

  ///getVideoByHashTag
  static final String videosByHashTag =
      ConstRes.baseUrl + 'Post/getSingleHashTagPostList';
  static final String hashTag = 'hash_tag';

  ///getVideoBySoundId
  static final String getPostBySoundId =
      ConstRes.baseUrl + 'Post/getPostBySoundId';
  static final String soundId = 'sound_id';
  static final String soundIds = 'sound_ids';

  ///sendCoin
  static final String sendCoin = ConstRes.baseUrl + 'Wallet/sendCoin';
  static final String coin = 'coin';
  static final String toUserId = 'to_user_id';

  ///getExploreHashTag
  static final String getExploreHashTag =
      ConstRes.baseUrl + 'Post/getExploreHashTagPostList';

  ///getUserSearchPostList
  static final String getUserSearchPostList =
      ConstRes.baseUrl + 'Post/getUserSearchPostList';
  static final String keyWord = 'keyword';

  ///getSearchPostList
  static final String getSearchPostList =
      ConstRes.baseUrl + 'Post/getSearchPostList';

  ///getNotificationList
  static final String getNotificationList =
      ConstRes.baseUrl + 'User/getNotificationList';

  ///setNotificationSettings
  static final String setNotificationSettings =
      ConstRes.baseUrl + 'User/setNotificationSettings';

  ///getCoinRateList
  static final String getCoinRateList =
      ConstRes.baseUrl + 'Wallet/getCoinRateList';

  ///getRewardingActionList
  static final String getRewardingActionList =
      ConstRes.baseUrl + 'Wallet/getRewardingActionList';

  ///getMyWalletCoin
  static final String getMyWalletCoin =
      ConstRes.baseUrl + 'Wallet/getMyWalletCoin';

  ///redeemRequest
  static final String redeemRequest = ConstRes.baseUrl + 'Wallet/redeemRequest';
  static final String amount = 'amount';
  static final String redeemRequestType = 'redeem_request_type';
  static final String account = 'account';

  ///verifyRequest
  static final String verifyRequest = ConstRes.baseUrl + 'User/verifyRequest';
  static final String idNumber = 'id_number';
  static final String name = 'name';
  static final String address = 'address';
  static final String photoIdImage = 'photo_id_image';
  static final String photoWithIdImage = 'photo_with_id_image';

  ///getProfile
  static final String getProfile = ConstRes.baseUrl + 'User/getProfile';

  ///getProfileCategoryList
  static final String getProfileCategoryList =
      ConstRes.baseUrl + 'User/getProfileCategoryList';

  ///updateProfile
  static final String updateProfile = ConstRes.baseUrl + 'User/updateProfile';
  static final String bio = 'bio';
  static final String fbUrl = 'fb_url';
  static final String instaUrl = 'insta_url';
  static final String youtubeUrl = 'youtube_url';
  static final String userProfile = 'user_profile';
  static final String profileCategory = 'profile_category';
  static final String isNotification = 'is_notification';

  ///FollowUnFollowPost
  static final String followUnFollowPost =
      ConstRes.baseUrl + 'Post/FollowUnfollowPost';

  ///getFollowerList
  static final String getFollowerList =
      ConstRes.baseUrl + 'Post/getFollowerList';

  ///getFollowingList
  static final String getFollowingList =
      ConstRes.baseUrl + 'Post/getFollowingList';

  ///getSoundList
  static final String getSoundList = ConstRes.baseUrl + 'Post/getSoundList';

  ///getFavouriteSoundList
  static final String getFavouriteSoundList =
      ConstRes.baseUrl + 'Post/getFavouriteSoundList';

  ///getSearchSoundList
  static final String getSearchSoundList =
      ConstRes.baseUrl + 'Post/getSearchSoundList';

  ///generateAgoraToken
  static final String generateAgoraToken =
      ConstRes.baseUrl + 'User/generateAgoraToken';
  static final String channelName = 'channelName';

  ///addPost
  static final String addPost = ConstRes.baseUrl + 'Post/addPost';
  static final String postDescription = 'post_description';
  static final String postHashTag = 'post_hash_tag';
  static final String postVideo = 'post_video';
  static final String postImage = 'post_image';
  static final String isOriginalSound = 'is_orignal_sound';
  static final String postSound = 'post_sound';
  static final String soundTitle = 'sound_title';
  static final String duration = 'duration';
  static final String singer = 'singer';
  static final String soundImage = 'sound_image';

  ///Logout
  static final String logoutUser = ConstRes.baseUrl + 'User/Logout';

  ///DeleteAccount
  static final String deleteAccount = ConstRes.baseUrl + 'User/deleteMyAccount';

  ///DeletePost
  static final String deletePost = ConstRes.baseUrl + 'Post/deletePost';

  ///ReportPost
  static final String reportPostOrUser = ConstRes.baseUrl + 'Post/ReportPost';
  static final String reportType = 'report_type';
  static final String reason = 'reason';
  static final String description = 'description';
  static final String contactInfo = 'contact_info';

  ///BlockUser
  static final String blockUser = ConstRes.baseUrl + 'User/blockUser';

  ///getPostListById
  static final String getPostListById =
      ConstRes.baseUrl + 'Post/getPostListById';

  ///getCoinPlanList
  static final String getCoinPlanList =
      ConstRes.baseUrl + 'Wallet/getCoinPlanList';

  ///addCoin
  static final String addCoin = ConstRes.baseUrl + 'Wallet/addCoin';
  static final String rewardingActionId = 'rewarding_action_id';

  ///purchaseCoin
  static final String purchaseCoin = ConstRes.baseUrl + 'Wallet/purchaseCoin';

  ///IncreasePostViewCount
  static final String increasePostViewCount =
      ConstRes.baseUrl + 'Post/IncreasePostViewCount';

  ///fetchSettingsData
  static final String fetchSettingsData =
      ConstRes.baseUrl + 'fetchSettingsData';

  /// uploadFileGivenPath
  static final String fileGivenPath = ConstRes.baseUrl + 'uploadFileGivePath';

  /// Notification Api
  static final String notificationUrl =
      ConstRes.baseUrl + 'User/pushNotificationToSingleUser';

  /// privacy & term
  static final String termAndCondition = ConstRes.base + 'termsOfUse';
  static final String privacyPolicy = ConstRes.base + 'privacypolicy';

  static final String agoraLiveStreamingCheck =
      'https://api.agora.io/dev/v1/channel/user/';

  static final String checkVideoModeration =
      'https://api.sightengine.com/1.0/video/check-workflow-sync.json';

  static final String checkVideoModerationMoreThenOneMinutes =
      'https://api.sightengine.com/1.0/video/check.json';

  static final String uniqueKey = 'unique-key';
  static final String authorization = 'Authorization';
  static final String favourite = 'favourite';

  static final String isLogin = 'is_login';

  static final String camera = '';

  static final String isAccepted = 'is_accepted';
}
