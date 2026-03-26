import 'package:bubbly/main.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyLoading extends ChangeNotifier {
  bool _isForYouSelected = true;

  bool get isForYou {
    return _isForYouSelected;
  }

  setIsForYouSelected(bool isForYou) {
    _isForYouSelected = isForYou;
    notifyListeners();
  }

  bool _isBigProfile = false;

  bool get isBigProfile {
    return _isBigProfile;
  }

  setIsBigProfile(bool isBig) {
    _isBigProfile = isBig;
    notifyListeners();
  }

  int _selectedItem = 0;

  int get getSelectedItem {
    return _selectedItem;
  }

  setSelectedItem(int selectedItem) {
    this._selectedItem = selectedItem;
    notifyListeners();
  }

  int _profilePageIndex = 0;

  int get getProfilePageIndex => _profilePageIndex;

  setProfilePageIndex(int profilePageIndex) {
    this._profilePageIndex = profilePageIndex;
    notifyListeners();
  }

  int _notificationPageIndex = 0;

  int get getNotificationPageIndex {
    return _notificationPageIndex;
  }

  setNotificationPageIndex(int notificationPageIndex) {
    this._notificationPageIndex = notificationPageIndex;
    notifyListeners();
  }

  int _searchPageIndex = 0;

  int get getSearchPageIndex {
    return _searchPageIndex;
  }

  setSearchPageIndex(int searchPageIndex) {
    this._searchPageIndex = searchPageIndex;
    notifyListeners();
  }

  int _followerPageIndex = 0;

  int get getFollowerPageIndex {
    return _followerPageIndex;
  }

  setFollowerPageIndex(int searchPageIndex) {
    this._followerPageIndex = searchPageIndex;
    notifyListeners();
  }

  int _musicPageIndex = 0;

  int get getMusicPageIndex {
    return _musicPageIndex;
  }

  setMusicPageIndex(int searchPageIndex) {
    this._musicPageIndex = searchPageIndex;
    notifyListeners();
  }

  User? _user;

  User? get getUser {
    return _user;
  }

  setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  bool isScrollProfileVideo = false;

  bool get scrollProfileVideo {
    return isScrollProfileVideo;
  }

  setScrollProfileVideo(bool isScrollProfileVideo) {
    this.isScrollProfileVideo = isScrollProfileVideo;
    notifyListeners();
  }

  String searchText = '';

  String get getSearchText {
    return searchText;
  }

  setSearchText(String searchText) {
    this.searchText = searchText;
    notifyListeners();
  }

  String musicSearchText = '';

  String get getMusicSearchText {
    return musicSearchText;
  }

  setMusicSearchText(String musicSearchText) {
    this.musicSearchText = musicSearchText;
    notifyListeners();
  }

  bool isSearchMusic = false;

  bool get getIsSearchMusic {
    return isSearchMusic;
  }

  setIsSearchMusic(bool isSearchMusic) {
    this.isSearchMusic = isSearchMusic;
    notifyListeners();
  }

  String lastSelectSoundId = '';

  String get getLastSelectSoundId {
    return lastSelectSoundId;
  }

  setLastSelectSoundId(String lastSelectSoundId) {
    this.lastSelectSoundId = lastSelectSoundId;
    notifyListeners();
  }

  bool lastSelectSoundIsPlay = false;

  bool get getLastSelectSoundIsPlay {
    return lastSelectSoundIsPlay;
  }

  setLastSelectSoundIsPlay(bool lastSelectSoundIsPlay) {
    this.lastSelectSoundIsPlay = lastSelectSoundIsPlay;
    notifyListeners();
  }

  bool isDownloadClick = false;

  bool get getIsDownloadClick {
    return isDownloadClick;
  }

  setIsDownloadClick(bool isDownloadClick) {
    this.isDownloadClick = isDownloadClick;
    notifyListeners();
  }

  bool isUserBlockOrNot = false;

  bool get getIsUserBlockOrNot {
    return isUserBlockOrNot;
  }

  setIsUserBlockOrNot(bool isDownloadClick) {
    this.isUserBlockOrNot = isDownloadClick;
    notifyListeners();
  }

  bool isHomeDialogOpen = ConstRes.isDialog;

  bool get getIsHomeDialogOpen {
    return isHomeDialogOpen;
  }

  void setIsHomeDialogOpen(bool isHomeDialog) {
    this.isHomeDialogOpen = isHomeDialog;
    notifyListeners();
  }

  bool _isDark = true;

  bool get isDark => _isDark;

  MyLoading() {
    getPrefData();
  }

  //Switching the themes
  void setDarkMode(bool value) {
    _isDark = value;
    notifyListeners();
    SystemChrome.setSystemUIOverlayStyle(
      _isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
    sessionManager.saveBoolean(KeyRes.themeLoading, _isDark);
  }

  void getPrefData() {
    _isDark =
        sessionManager.getIsDarkMode(KeyRes.themeLoading, _isDark) ?? _isDark;
    print(_isDark);
    _languageCode =
        sessionManager.giveString(KeyRes.languageCode) ?? byDefaultLanguage;
    notifyListeners();
  }

  String _languageCode = byDefaultLanguage;

  String get languageCode => _languageCode;

  void setLanguageCode(int index, BuildContext context) async {
    _languageCode = AppRes.languages[index]['key'];
    await Get.updateLocale(Locale(_languageCode));
    sessionManager.saveString(KeyRes.languageCode, _languageCode);
  }
}
