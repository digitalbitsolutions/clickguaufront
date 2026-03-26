import 'package:bubbly/languages/languages_string/arabic_ar.dart';
import 'package:bubbly/languages/languages_string/chinese_zh.dart';
import 'package:bubbly/languages/languages_string/danish_da.dart';
import 'package:bubbly/languages/languages_string/dutch_nl.dart';
import 'package:bubbly/languages/languages_string/english_en.dart';
import 'package:bubbly/languages/languages_string/france_fr.dart';
import 'package:bubbly/languages/languages_string/german_de.dart';
import 'package:bubbly/languages/languages_string/greek_el.dart';
import 'package:bubbly/languages/languages_string/hindi_hi.dart';
import 'package:bubbly/languages/languages_string/indonesian_id.dart';
import 'package:bubbly/languages/languages_string/japanese_ja.dart';
import 'package:bubbly/languages/languages_string/korean_ko.dart';
import 'package:bubbly/languages/languages_string/norwegian_bokmal_nb.dart';
import 'package:bubbly/languages/languages_string/polish_pl.dart';
import 'package:bubbly/languages/languages_string/portuguese_pt.dart';
import 'package:bubbly/languages/languages_string/russian_ru.dart';
import 'package:bubbly/languages/languages_string/spanish_es.dart';
import 'package:bubbly/languages/languages_string/thai_th.dart';
import 'package:bubbly/languages/languages_string/turkish_tr.dart';
import 'package:bubbly/languages/languages_string/vietnamese_vi.dart';
import 'package:get/get.dart';

class LanguagesKeys extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': arabicAR,
        'zh': chineseZH,
        'da': danishDA,
        'nl': dutchNL,
        'en': englishEN,
        'fr': franceFR,
        'de': germanDE,
        'el': greekEL,
        'hi': hindiHI,
        'id': indonesianID,
        'ja': japaneseJA,
        'ko': koreanKO,
        'nb': norwegianBokmalNB,
        'pl': polishPL,
        'pt': portuguesePT,
        'ru': russianRU,
        'es': spanishES,
        'th': thaiTH,
        'tr': turkishTR,
        'vi': vietnameseVI,
      };
}

class LKey {
  static const dataNotFound = 'dataNotFound';
  static const sentSuccessfully = 'sentSuccessfully';
  static const insufficientBalance = 'insufficientBalance';
  static const areYouSure = 'areYouSure';
  static const doYouReallyWantToGoBack = 'doYouReallyWantToGoBack';
  static const no = 'no';
  static const yes = 'yes';
  static const tooLargeVideo = 'tooLargeVideo';
  static const thisVideoIsGreaterThan50MbNPleaseSelectAnother = 'thisVideoIsGreaterThan50MbNPleaseSelectAnother';
  static const cancel = 'cancel';
  static const selectAnother = 'selectAnother';
  static const tooLongVideo = 'tooLongVideo';
  static const thisVideoIsGreaterThan1MinNPleaseSelectAnother = 'thisVideoIsGreaterThan1MinNPleaseSelectAnother';
  static const whichItemWouldYouLikeToSelectNSelectAItem = 'whichItemWouldYouLikeToSelectNSelectAItem';
  static const images = 'images';
  static const videos = 'videos';
  static const close = 'close';
  static const selected = 'selected';
  static const youBlockThisUser = 'youBlockThisUser';
  static const typeSomething = 'typeSomething';
  static const sendMedia = 'sendMedia';
  static const writeMessage = 'writeMessage';
  static const submit = 'submit';
  static const reportUser = 'reportUser';
  static const unblockUser = 'unblockUser';
  static const blockUser = 'blockUser';
  static const failedVideo = 'failedVideo';
  static const youAreBlockFromOther = 'youAreBlockFromOther';
  static const deleteMessage = 'deleteMessage';
  static const areYouSureYouWantToDeleteThisMessage = 'areYouSureYouWantToDeleteThisMessage';
  static const delete = 'delete';
  static const comments = 'comments';
  static const leaveYourComment = 'leaveYourComment';
  static const enterCommentFirst = 'enterCommentFirst';
  static const forgotPassword = 'forgotPassword';
  static const enterYourMailOnWhichYouHaveCreatedNanAccount = 'enterYourMailOnWhichYouHaveCreatedNanAccount';
  static const email = 'email';
  static const reset = 'reset';
  static const signUpFor = 'signUpFor';
  static const createAProfileFollowOtherCreatorsNBuildYourFanFollowingBy = 'createAProfileFollowOtherCreatorsNBuildYourFanFollowingBy';
  static const singInWithApple = 'singInWithApple';
  static const singInWithEmail = 'singInWithEmail';
  static const singInWithGoogle = 'singInWithGoogle';
  static const termOfUse = 'termOfUse';
  static const privacyPolicy = 'privacyPolicy';
  static const signInFor = 'signInFor';
  static const enterYourMail = 'enterYourMail';
  static const password = 'password';
  static const login = 'login';
  static const signUp = 'signUp';
  static const donTHaveAccount = 'donTHaveAccount';
  static const pleaseEnterEmail = 'pleaseEnterEmail';
  static const pleaseEnterCorrectEmail = 'pleaseEnterCorrectEmail';
  static const pleaseEnterPassword = 'pleaseEnterPassword';
  static const pleaseVerifiedYourEmail = 'pleaseVerifiedYourEmail';
  static const emailNotFound = 'emailNotFound';
  static const pleaseEnterValidEmailAddress = 'pleaseEnterValidEmailAddress';
  static const emailSentSuccessfully = 'emailSentSuccessfully';
  static const enterYourName = 'enterYourName';
  static const confirmPassword = 'confirmPassword';
  static const register = 'register';
  static const pleaseEnterValidEmail = 'pleaseEnterValidEmail';
  static const enterReenterPassword = 'enterReenterPassword';
  static const passwordDoseNotMatch = 'passwordDoseNotMatch';
  static const search = 'search';
  static const lives = 'lives';
  static const viewAll = 'viewAll';
  static const following = 'following';
  static const followers = 'followers';
  static const popularCreator = 'popularCreator';
  static const followSomeCreatorsTonWatchTheirVideos = 'followSomeCreatorsTonWatchTheirVideos';
  static const pleaseAccept = 'pleaseAccept';
  static const pleaseCheckThesePrivacyEtc = 'pleaseCheckThesePrivacyPolicyAndTermsOfUseBefore';
  static const termsConditions = 'termsConditions';
  static const accept = 'accept';
  static const follow = 'follow';
  static const yourLiveStreamHasEtc = 'yourLiveStreamHasBeenEndedNBelowIsASummaryOf';
  static const streamFor = 'streamFor';
  static const users = 'users';
  static const collected = 'collected';
  static const ok = 'ok';
  static const live = 'live';
  static const goLive = 'goLive';
  static const noUserLive = 'noUserLive';
  static const home = 'home';
  static const explore = 'explore';
  static const create = 'create';
  static const notification = 'notification';
  static const profile = 'profile';
  static const endUserLicenseAgreement = 'endUserLicenseAgreement';
  static const more = 'more';
  static const back = 'back';
  static const discover = 'discover';
  static const favourite = 'favourite';
  static const somethingWentWrong = 'somethingWentWrong';
  static const deleteThisChat = 'deleteThisChat';
  static const messageWillOnlyBeRemovedFromThisDeviceNAreYouSure = 'messageWillOnlyBeRemovedFromThisDeviceNAreYouSure';
  static const deleteChat = 'deleteChat';
  static const admin = 'admin';
  static const notifications = 'notifications';
  static const chats = 'chats';
  static const chooseCategory = 'chooseCategory';
  static const editProfile = 'editProfile';
  static const change = 'change';
  static const profileCategory = 'profileCategory';
  static const fullName = 'fullName';
  static const username = 'username';
  static const bio = 'bio';
  static const presentYourself = 'presentYourself';
  static const social = 'social';
  static const facebook = 'facebook';
  static const instagram = 'instagram';
  static const youtube = 'youtube';
  static const updateProfileSuccessfully = 'updateProfileSuccessfully';
  static const update = 'update';
  static const removePost = 'removePost';
  static const areYouSureNWantToRemovePost = 'areYouSureNWantToRemovePost';
  static const shareProfile = 'shareProfile';
  static const likes = 'likes';
  static const invalidUrl = 'invalidUrl';
  static const unfollow = 'unfollow';
  static const fileSavedSuccessfully = 'fileSavedSuccessfully';
  static const saveCode = 'saveCode';
  static const scanToFollowMe = 'scanToFollowMe';
  static const myCode = 'myCode';
  static const scanQrCode = 'scanQrCode';
  static const scanQrCodeToSeeProfile = 'scanQrCodeToSeeProfile';
  static const redeemShortzz = 'redeemShortzz';
  static const youHave = 'youHave';
  static const selectMethod = 'selectMethod';
  static const account = 'account';
  static const mailMobile = 'mailMobile';
  static const pleaseSelectPaymentMethod = 'pleaseSelectPaymentMethod';
  static const pleaseEnterAccount = 'pleaseEnterAccount';
  static const redeem = 'redeem';
  static const redeemRequestsAreProcessedWithIn10DaysNAndBePrepared = 'redeemRequestsAreProcessedWithIn10DaysNAndBePrepared';
  static const policyCenter = 'policyCenter';
  static const selectReason = 'selectReason';
  static const howItHurtsYou = 'howItHurtsYou';
  static const explainBriefly = 'explainBriefly';
  static const contactDetailMailOrMobile = 'contactDetailMailOrMobile';
  static const mailOrPhone = 'mailOrPhone';
  static const pleaseSelectReason = 'pleaseSelectReason';
  static const pleaseEnterDescription = 'pleaseEnterDescription';
  static const pleaseEnterContactDetail = 'pleaseEnterContactDetail';
  static const byClickingThisSubmitButtonYouAgreeThatNYouAreTakingAll = 'byClickingThisSubmitButtonYouAgreeThatNYouAreTakingAll';
  static const fans = 'fans';
  static const send = 'Send';
  static const creatorWillBeNotifiedNAboutYourLove = 'creatorWillBeNotifiedNAboutYourLove';
  static const settings = 'settings';
  static const notifyMe = 'notifyMe';
  static const myQrCode = 'myQrCode';
  static const wallet = 'wallet';
  static const minimumFollower = 'minimumFollower';
  static const requestVerification = 'requestVerification';
  static const general = 'general';
  static const help = 'help';
  static const termsOfUse = 'termsOfUse';
  static const allOfYourDataIncludingPostsNLikesFollowsAndEverything = 'allOfYourDataIncludingPostsNLikesFollowsAndEverything';
  static const confirm = 'confirm';
  static const deleteAccount = 'deleteAccount';
  static const doYoReallyNWantToLogOut = 'doYoReallyNWantToLogOut';
  static const logOut = 'logOut';
  static const soundVideos = 'soundVideos';
  static const unFavourite = 'unFavourite';
  static const useThisSound = 'useThisSound';
  static const uploadVideo = 'uploadVideo';
  static const describe = 'describe';
  static const awesomeCaption = 'awesomeCaption';
  static const postUploadSuccessfully = 'postUploadSuccessfully';
  static const publish = 'publish';
  static const yourPhotoHoldingYourIdCard = 'yourPhotoHoldingYourIdCard';
  static const capture = 'capture';
  static const photoOfIdClearPhoto = 'photoOfIdClearPhoto';
  static const attach = 'attach';
  static const idNumber = 'idNumber';
  static const nameOnId = 'nameOnId';
  static const sameAsId = 'sameAsId';
  static const fullAddress = 'fullAddress';
  static const pleaseCaptureImage = 'pleaseCaptureImage';
  static const pleaseAttachYourIdCard = 'pleaseAttachYourIdCard';
  static const pleaseEnterYourIdNumber = 'pleaseEnterYourIdNumber';
  static const pleaseEnterYourName = 'pleaseEnterYourName';
  static const pleaseEnterYourFullAddress = 'pleaseEnterYourFullAddress';
  static const requestForVerificationSuccessfully = 'requestForVerificationSuccessfully';
  static const shop = 'shop';
  static const wheneverYouUploadVideo = 'wheneverYouUploadVideo';
  static const add = 'add';
  static const totalEarning = 'totalEarning';
  static const totalSpending = 'totalSpending';
  static const passbook = 'passbook';
  static const fromYourFans = 'fromYourFans';
  static const purchased = 'purchased';
  static const rewardingActions = 'rewardingActions';
  static const requestRedeem = 'requestRedeem';
  static const preview = 'preview';
  static const languages = 'languages';
  static const nothingToShow = 'nothingToShow';
  static const end = 'end';
  static const forYou = 'forYou';
  static const enterIdNumber = 'enterIdNumber';
  static const darkMode = 'darkMode';
  static const fullNameRequired = 'fullNameRequired';
  static const userNameRequired = 'userNameRequired';
  static const videoIsToShort = 'videoIsToShort';
}
