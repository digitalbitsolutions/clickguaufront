import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:bubbly/modal/agora/agora.dart';
import 'package:bubbly/modal/agora/agora_token.dart';
import 'package:bubbly/modal/comment/comment.dart';
import 'package:bubbly/modal/explore/explore_hash_tag.dart';
import 'package:bubbly/modal/file_path/file_path.dart';
import 'package:bubbly/modal/followers/follower_following_data.dart';
import 'package:bubbly/modal/notification/notification.dart';
import 'package:bubbly/modal/nudity/nudity_checker.dart';
import 'package:bubbly/modal/nudity/nudity_media_id.dart';
import 'package:bubbly/modal/plan/coin_plans.dart';
import 'package:bubbly/modal/profileCategory/profile_category.dart';
import 'package:bubbly/modal/rest/rest_response.dart';
import 'package:bubbly/modal/search/search_user.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/modal/single/single_post.dart';
import 'package:bubbly/modal/sound/fav/favourite_music.dart';
import 'package:bubbly/modal/sound/sound.dart';
import 'package:bubbly/modal/status.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/modal/wallet/my_wallet.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:firebase_auth/firebase_auth.dart' as FireBaseAuth1;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class ApiService {
  var client = http.Client();

  Future<User> registerUser(HashMap<String, String?> params) async {
    final response = await client.post(
      Uri.parse(UrlRes.registerUser),
      body: params,
      headers: {UrlRes.uniqueKey: ConstRes.apiKey},
    );
    final responseJson = jsonDecode(response.body);
    SessionManager sessionManager = SessionManager();
    await sessionManager.initPref();
    sessionManager.saveUser(
      jsonEncode(User.fromJson(responseJson)),
    );
    // print(response.body);
    return User.fromJson(responseJson);
  }

  Future<UserVideo> getUserVideos(
      String star, String limit, String? userId, int type) async {
    Map map = {};
    map[UrlRes.start] = star;
    map[UrlRes.limit] = limit;
    map[UrlRes.userId] = '$userId';
    map[UrlRes.myUserId] = '${SessionManager.userId}';

    final response = await client.post(
      Uri.parse(type == 0 ? UrlRes.getUserVideos : UrlRes.getUserLikesVideos),
      body: map,
      headers: {UrlRes.uniqueKey: ConstRes.apiKey},
    );
    final responseJson = jsonDecode(response.body);

    return UserVideo.fromJson(responseJson);
  }

  Future<UserVideo> getPostList(
      String limit, String userId, String type) async {
    final response = await client.post(
      Uri.parse(UrlRes.getPostList),
      body: {
        UrlRes.limit: limit,
        UrlRes.userId: userId,
        UrlRes.type: type,
      },
      headers: {UrlRes.uniqueKey: ConstRes.apiKey},
    );
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }

  Future<RestResponse> likeUnlikePost(String postId) async {
    // print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(UrlRes.likeUnlikePost),
      body: {
        UrlRes.postId: postId,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<Comment> getCommentByPostId(
      String start, String limit, String postId) async {
    final response = await client.post(
      Uri.parse(UrlRes.getCommentByPostId),
      body: {
        UrlRes.postId: postId,
        UrlRes.start: start,
        UrlRes.limit: limit,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
      },
    );

    final responseJson = jsonDecode(response.body);
    return Comment.fromJson(responseJson);
  }

  Future<RestResponse> addComment(String comment, String postId) async {
    final response = await client.post(
      Uri.parse(UrlRes.addComment),
      body: {
        UrlRes.postId: postId,
        UrlRes.comment: comment,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> deleteComment(String commentID) async {
    final response = await client.post(
      Uri.parse(UrlRes.deleteComment),
      body: {
        UrlRes.commentId: commentID,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<UserVideo> getPostByHashTag(
      String start, String limit, String? hashTag) async {
    // print(hashTag);
    final response = await client.post(
      Uri.parse(UrlRes.videosByHashTag),
      body: {
        UrlRes.start: start,
        UrlRes.limit: limit,
        UrlRes.userId: SessionManager.userId.toString(),
        UrlRes.hashTag: hashTag,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
      },
    );
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }

  Future<UserVideo> getPostBySoundId(
      String start, String limit, String? soundId) async {
    final response = await client.post(
      Uri.parse(UrlRes.getPostBySoundId),
      body: {
        UrlRes.start: start,
        UrlRes.limit: limit,
        UrlRes.userId: SessionManager.userId.toString(),
        UrlRes.soundId: soundId,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
      },
    );
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }

  Future<RestResponse> sendCoin(String coin, String toUserId) async {
    final response = await client.post(
      Uri.parse(UrlRes.sendCoin),
      body: {
        UrlRes.coin: coin,
        UrlRes.toUserId: toUserId,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }

  Future<ExploreHashTag> getExploreHashTag(String start, String limit) async {
    final response = await client.post(
      Uri.parse(UrlRes.getExploreHashTag),
      body: {
        UrlRes.start: start,
        UrlRes.limit: limit,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return ExploreHashTag.fromJson(responseJson);
  }

  Future<SearchUser> getSearchUser(
      String start, String limit, String keyWord) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(UrlRes.getUserSearchPostList),
      body: {
        UrlRes.start: start,
        UrlRes.limit: limit,
        UrlRes.keyWord: keyWord,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return SearchUser.fromJson(responseJson);
  }

  Future<UserVideo> getSearchPostList(
      String start, String limit, String? userId, String? keyWord) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(UrlRes.getSearchPostList),
      body: {
        UrlRes.start: start,
        UrlRes.limit: limit,
        UrlRes.userId: userId,
        UrlRes.keyWord: keyWord,
      },
      headers: {UrlRes.uniqueKey: ConstRes.apiKey},
    );
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }

  Future<UserNotifications> getNotificationList(
      String start, String limit) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(UrlRes.getNotificationList),
      body: {
        UrlRes.start: start,
        UrlRes.limit: limit,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );
    // print(response.statusCode);
    final responseJson = jsonDecode(response.body);
    return UserNotifications.fromJson(responseJson);
  }

  Future<RestResponse> setNotificationSettings(String? deviceToken) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(UrlRes.setNotificationSettings),
      body: {
        UrlRes.deviceToken: deviceToken,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<MyWallet> getMyWalletCoin() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(UrlRes.getMyWalletCoin),
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );
    final responseJson = jsonDecode(response.body);
    return MyWallet.fromJson(responseJson);
  }

  Future<RestResponse> redeemRequest(String amount, String redeemRequestType,
      String account, String coin) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(UrlRes.redeemRequest),
      body: {
        UrlRes.amount: amount,
        UrlRes.redeemRequestType: redeemRequestType,
        UrlRes.account: account,
        UrlRes.coin: coin,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> verifyRequest(String idNumber, String name,
      String address, File? photoIdImage, File? photoWithIdImage) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(UrlRes.verifyRequest),
    );
    request.headers[UrlRes.uniqueKey] = ConstRes.apiKey;
    request.headers[UrlRes.authorization] = SessionManager.accessToken;
    request.fields[UrlRes.idNumber] = idNumber;
    request.fields[UrlRes.name] = name;
    request.fields[UrlRes.address] = address;
    if (photoIdImage != null) {
      request.files.add(
        http.MultipartFile(UrlRes.photoIdImage,
            photoIdImage.readAsBytes().asStream(), photoIdImage.lengthSync(),
            filename: photoIdImage.path.split("/").last),
      );
    }
    if (photoWithIdImage != null) {
      request.files.add(
        http.MultipartFile(
            UrlRes.photoWithIdImage,
            photoWithIdImage.readAsBytes().asStream(),
            photoWithIdImage.lengthSync(),
            filename: photoWithIdImage.path.split("/").last),
      );
    }
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(jsonDecode(respStr));
  }

  Future<User> getProfile(String? userId) async {
    Map<String, dynamic> map = {};
    if (SessionManager.userId != -1) {
      map[UrlRes.myUserId] = SessionManager.userId.toString();
    }
    map[UrlRes.userId] = userId;
    final response = await client.post(
      Uri.parse(UrlRes.getProfile),
      body: map,
      headers: {UrlRes.uniqueKey: ConstRes.apiKey},
    );
    final responseJson = jsonDecode(response.body);
    if (userId == SessionManager.userId.toString()) {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      User user = User.fromJson(responseJson);
      if (SessionManager.accessToken.isNotEmpty) {
        user.data?.setToken(SessionManager.accessToken);
      }
      sessionManager.saveUser(jsonEncode(user));
    }
    return User.fromJson(responseJson);
  }

  Future<ProfileCategory> getProfileCategoryList() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(UrlRes.getProfileCategoryList),
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    return ProfileCategory.fromJson(responseJson);
  }

  Future<User> updateProfile(
      {String? fullName,
      String? userName,
      String? bio,
      String? fbUrl,
      String? instagramUrl,
      String? youtubeUrl,
      String? profileCategory,
      File? profileImage,
      String? isNotification}) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(UrlRes.updateProfile),
    );
    request.headers[UrlRes.uniqueKey] = ConstRes.apiKey;
    request.headers[UrlRes.authorization] = SessionManager.accessToken;

    if (fullName != null && fullName.isNotEmpty) {
      request.fields[UrlRes.fullName] = fullName;
    }
    if (userName != null && userName.isNotEmpty) {
      request.fields[UrlRes.userName] = userName;
    }
    if (bio != null && bio.isNotEmpty) {
      request.fields[UrlRes.bio] = bio;
    }
    if (isNotification != null && isNotification.isNotEmpty) {
      request.fields[UrlRes.isNotification] = isNotification;
    }
    if (fbUrl != null && fbUrl.isNotEmpty) {
      request.fields[UrlRes.fbUrl] = fbUrl;
    }
    if (instagramUrl != null && instagramUrl.isNotEmpty) {
      request.fields[UrlRes.instaUrl] = instagramUrl;
    }
    if (youtubeUrl != null && youtubeUrl.isNotEmpty)
      request.fields[UrlRes.youtubeUrl] = youtubeUrl;
    if (profileCategory != null && profileCategory.isNotEmpty) {
      request.fields[UrlRes.profileCategory] = profileCategory;
    }
    if (profileImage != null) {
      request.files.add(
        http.MultipartFile(UrlRes.userProfile,
            profileImage.readAsBytes().asStream(), profileImage.lengthSync(),
            filename: profileImage.path.split("/").last),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();

    User user = User.fromJson(jsonDecode(respStr));
    if (user.data?.userId.toString() == SessionManager.userId.toString()) {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      if (SessionManager.accessToken.isNotEmpty) {
        user.data?.setToken(SessionManager.accessToken);
      }
      sessionManager.saveUser(jsonEncode(user));
    }
    return User.fromJson(jsonDecode(respStr));
  }

  Future<RestResponse> followUnFollowUser(String toUserId) async {
    final response = await client.post(
      Uri.parse(UrlRes.followUnFollowPost),
      body: {UrlRes.toUserId: toUserId},
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<FollowerFollowingData> getFollowersList(
      String userId, String start, String count, int type) async {
    final response = await client.post(
      Uri.parse(type == 0 ? UrlRes.getFollowerList : UrlRes.getFollowingList),
      body: {
        UrlRes.userId: userId,
        UrlRes.start: start,
        UrlRes.limit: count,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    return FollowerFollowingData.fromJson(responseJson);
  }

  Future<Sound> getSoundList() async {
    final response = await client.get(
      Uri.parse(UrlRes.getSoundList),
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken
      },
    );

    final responseJson = jsonDecode(response.body);
    return Sound.fromJson(responseJson);
  }

  Future<FavouriteMusic> getFavouriteSoundList() async {
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(UrlRes.getFavouriteSoundList),
      body: jsonEncode(<String, List<String>>{
        UrlRes.soundIds: sessionManager.getFavouriteMusic(),
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    return FavouriteMusic.fromJson(responseJson);
  }

  Future<RestResponse> addPost({
    required String postDescription,
    String? postHashTag,
    required String isOriginalSound,
    String? soundTitle,
    String? duration,
    String? singer,
    String? soundId,
    File? postVideo,
    File? thumbnail,
    File? postSound,
    File? soundImage,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(UrlRes.addPost),
    );
    request.headers[UrlRes.uniqueKey] = ConstRes.apiKey;
    request.headers[UrlRes.authorization] = SessionManager.accessToken;
    if (postDescription.isNotEmpty) {
      request.fields[UrlRes.postDescription] = postDescription;
    }
    if (postHashTag != null || postHashTag!.isNotEmpty) {
      request.fields[UrlRes.postHashTag] =
          postHashTag.isEmpty ? '' : postHashTag;
    }
    request.fields[UrlRes.isOriginalSound] = isOriginalSound;
    if (isOriginalSound == '1') {
      request.fields[UrlRes.soundTitle] = soundTitle!;
      request.fields[UrlRes.duration] = duration!;
      request.fields[UrlRes.singer] = singer!;
      if (postSound != null) {
        request.files.add(
          http.MultipartFile(UrlRes.postSound,
              postSound.readAsBytes().asStream(), postSound.lengthSync(),
              filename: postSound.path.split("/").last),
        );
      }
      if (soundImage != null) {
        request.files.add(
          http.MultipartFile(UrlRes.soundImage,
              soundImage.readAsBytes().asStream(), soundImage.lengthSync(),
              filename: soundImage.path.split("/").last),
        );
      }
    } else {
      request.fields[UrlRes.soundId] = soundId!;
    }
    if (postVideo != null) {
      request.files.add(
        http.MultipartFile(UrlRes.postVideo, postVideo.readAsBytes().asStream(),
            postVideo.lengthSync(),
            filename: postVideo.path.split("/").last),
      );
    }
    if (thumbnail != null) {
      request.files.add(
        http.MultipartFile(UrlRes.postImage, thumbnail.readAsBytes().asStream(),
            thumbnail.lengthSync(),
            filename: thumbnail.path.split("/").last),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    final responseJson = jsonDecode(respStr);
    // print(request.fields);
    // print(UrlRes.addPost);
    // print(responseJson);
    addCoin();
    return RestResponse.fromJson(responseJson);
  }

  Future<FavouriteMusic> getSearchSoundList(String keyword) async {
    client = http.Client();
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(UrlRes.getSearchSoundList),
      body: {
        UrlRes.keyWord: keyword,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return FavouriteMusic.fromJson(responseJson);
  }

  Future<UserVideo> getPostsByType({
    required int? pageDataType,
    required String start,
    required String limit,
    String? userId,
    String? soundId,
    String? hashTag,
    String? keyWord,
  }) {
    ///PagedDataType
    ///1 = UserVideo
    ///2 = UserLikesVideo
    ///3 = PostsBySound
    ///4 = PostsByHashTag
    ///5 = PostsBySearch
    switch (pageDataType) {
      case 1:
        return getUserVideos(start, limit, userId, 0);
      case 2:
        return getUserVideos(start, limit, userId, 1);
      case 3:
        return getPostBySoundId(start, limit, soundId);
      case 4:
        return getPostByHashTag(start, limit, hashTag!.replaceAll('#', ''));
      case 5:
        return getSearchPostList(start, limit, userId, keyWord);
    }
    return getPostByHashTag(start, limit, hashTag);
  }

  Future<RestResponse> logoutUser() async {
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(UrlRes.logoutUser),
      body: {
        UrlRes.userId: SessionManager.userId.toString(),
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    sessionManager.clean();
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> deleteAccount() async {
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    await FireBaseAuth1.FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    // print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(UrlRes.deleteAccount),
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    sessionManager.clean();
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> deletePost(String postId) async {
    final response = await client.post(
      Uri.parse(UrlRes.deletePost),
      body: {
        UrlRes.postId: postId,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> reportUserOrPost({
    required String reportType,
    String? postIdOrUserId,
    String? reason,
    required String description,
    required String contactInfo,
  }) async {
    final response = await client.post(
      Uri.parse(UrlRes.reportPostOrUser),
      body: {
        UrlRes.reportType: reportType,
        reportType == '1' ? UrlRes.userId : UrlRes.postId: postIdOrUserId,
        UrlRes.reason: reason,
        UrlRes.description: description,
        UrlRes.contactInfo: contactInfo,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> blockUser(String? userId) async {
    final response = await client.post(
      Uri.parse(UrlRes.blockUser),
      body: {
        UrlRes.userId: userId,
      },
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );
    // print(response.body);
    return RestResponse.fromJson(jsonDecode(response.body));
  }

  Future<SinglePost> getPostByPostId(String postId) async {
    final response = await client.post(
      Uri.parse(UrlRes.getPostListById),
      body: {UrlRes.postId: postId},
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
      },
    );
    // print(' ${response.body}');
    return SinglePost.fromJson(jsonDecode(response.body));
  }

  Future<CoinPlans> getCoinPlanList() async {
    final response = await client.get(
      Uri.parse(UrlRes.getCoinPlanList),
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return CoinPlans.fromJson(responseJson);
  }

  Future<CoinPlans> addCoin() async {
    final response = await client.post(
      Uri.parse(UrlRes.addCoin),
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
      body: {UrlRes.rewardingActionId: '3'},
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return CoinPlans.fromJson(responseJson);
  }

  Future<RestResponse> purchaseCoin(int coin) async {
    // print(SessionManager.accessToken + coin);
    final response = await client.post(
      Uri.parse(UrlRes.purchaseCoin),
      body: {UrlRes.coin: '$coin'},
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> increasePostViewCount(String postId) async {
    final response = await client.post(
      Uri.parse(UrlRes.increasePostViewCount),
      body: {UrlRes.postId: postId},
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  static HttpClient getHttpClient() {
    HttpClient httpClient = new HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    return httpClient;
  }

  Future<FilePath> filePath({File? filePath}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(UrlRes.fileGivenPath),
    );
    request.headers.addAll({
      UrlRes.uniqueKey: ConstRes.apiKey,
      UrlRes.authorization: SessionManager.accessToken
    });
    if (filePath != null) {
      request.files.add(
        http.MultipartFile(
            'file', filePath.readAsBytes().asStream(), filePath.lengthSync(),
            filename: filePath.path.split("/").last),
      );
    }
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    final responseJson = jsonDecode(respStr);
    FilePath path = FilePath.fromJson(responseJson);
    return path;
  }

  Future pushNotification(
      {required String title,
      required String body,
      required String token,
      required Map<String, dynamic> data}) async {
    await http.post(
      Uri.parse(UrlRes.notificationUrl),
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
        UrlRes.authorization: SessionManager.accessToken,
        'content-type': 'application/json'
      },
      body: json.encode({
        'message': {
          'notification': {
            'title': title,
            'body': body,
          },
          'token': token,
          'data': data
        },
      }),
    );
  }

  Future<Setting> fetchSettingsData() async {
    final response = await client.post(
      Uri.parse(UrlRes.fetchSettingsData),
      headers: {
        UrlRes.uniqueKey: ConstRes.apiKey,
      },
    );
    SessionManager sessionManager = SessionManager();
    await sessionManager.initPref();
    sessionManager.saveSetting(response.body);
    return Setting.fromJson(jsonDecode(response.body));
  }

  Future<AgoraToken> generateAgoraToken(String? channelName) async {
    final response =
        await client.post(Uri.parse(UrlRes.generateAgoraToken), headers: {
      UrlRes.authorization: SessionManager.accessToken,
      UrlRes.uniqueKey: ConstRes.apiKey,
    }, body: {
      UrlRes.channelName: channelName
    });
    // print(response.body);
    return AgoraToken.fromJson(jsonDecode(response.body));
  }

  Future<Agora> agoraListStreamingCheck(
      String channelName, String authToken, String agoraAppId) async {
    http.Response response = await http.get(
        Uri.parse('${UrlRes.agoraLiveStreamingCheck}$agoraAppId/$channelName'),
        headers: {UrlRes.authorization: 'Basic $authToken'});
    return Agora.fromJson(jsonDecode(response.body));
  }

  Future<Status> checkUsername({required String userName}) async {
    http.Response response =
        await http.post(Uri.parse(UrlRes.checkUsername), headers: {
      UrlRes.authorization: SessionManager.accessToken,
      UrlRes.uniqueKey: ConstRes.apiKey,
    }, body: {
      UrlRes.userName: userName
    });
    // print(response.body);
    return Status.fromJson(jsonDecode(response.body));
  }

  Future<NudityMediaId> checkVideoModerationApiMoreThenOneMinutes(
      {required File? file,
      required String apiUser,
      required String apiSecret}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(UrlRes.checkVideoModerationMoreThenOneMinutes),
    );
    request.fields['models'] = nudityModels;
    request.fields['api_user'] = apiUser;
    request.fields['api_secret'] = apiSecret;

    print(request.fields);

    if (file != null) {
      request.files.add(
        http.MultipartFile(
            'media', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split("/").last),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    NudityMediaId nudityStatus = NudityMediaId.fromJson(jsonDecode(respStr));
    return nudityStatus;
  }

  Future<NudityChecker> getOnGoingVideoJob(
      {required String mediaId,
      required String apiUser,
      required String apiSecret}) async {
    http.Response response = await http.get(Uri.parse(
      'https://api.sightengine.com/1.0/video/byid.json?id=${mediaId}&api_user=${apiUser}&api_secret=${apiSecret}',
    )
        // 'https://api.sightengine.com/1.0/video/byid.json?id=med_fN29aqHUajuGaR9TPH8G9&api_user=1762220856&api_secret=ivYtsGAKF9dpoxRLe83aZLgiDaBYswkH'),
        );

    print('${mediaId} //// $apiUser //// $apiSecret');

    NudityChecker nudityChecker =
        NudityChecker.fromJson(jsonDecode(response.body));
    print(response.body);
    // print('Nudity Checker ${nudityChecker.toJson()}');
    return nudityChecker;
  }
}
