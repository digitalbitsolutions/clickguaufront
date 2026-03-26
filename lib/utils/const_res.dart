class ConstRes {
  static final String base = 'https://clickguau.com/';
  static const String apiKey = 'dev123';
  static final String baseUrl = '${base}api/';

  static final String itemBaseUrl = 'https://clickguau.s3.amazonaws.com/bubbly/';

  // Agora Credential
  static final String customerId = '4b45e129e9fa43548e12da641717edd6';
  static final String customerSecret =
      '38142e32aa8145338130918c204c5216';

  // Starting screen open end_user_license_agreement sheet link
  static final String agreementUrl = "https://clickguau.es/index.php/politica-de-cookies/";

  static final String bubblyCamera = 'bubbly_camera';
  static final bool isDialog = false;
}

const String appName = 'Clickguau';
const companyName = 'Tulio';
const defaultPlaceHolderText = 'S';
const byDefaultLanguage = 'es';

const int paginationLimit = 10;

// Live broadcast Video Quality : Resolution (Width×Height)
int liveWeight = 640;
int liveHeight = 480;
int liveFrameRate = 15; //Frame rate (fps）

// Image Quality
double maxHeight = 720;
double maxWidth = 720;
int imageQuality = 100;

//Strings
const List<String> paymentMethods = ['Paypal', 'Paytm', 'Other'];
const List<String> reportReasons = ['Sexual', 'Nudity', 'Religion', 'Other'];

// Video Moderation models  :- https://sightengine.com/docs/moderate-stored-video-asynchronously
String nudityModels = 'nudity,wad';
