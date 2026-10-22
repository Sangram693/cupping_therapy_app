// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Cupping Therapy';

  @override
  String get appTagline => 'আপনার সুস্থতায়, আমাদের যত্ন';

  @override
  String get preparingCare => 'আপনার যত্নের অভিজ্ঞতা প্রস্তুত করা হচ্ছে...';

  @override
  String get sessionRestoreFailed => 'আপনার সেশন পুনরুদ্ধার করা যায়নি।';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String welcomeMessage(String appName) {
    return '$appName-এ আপনাকে স্বাগতম';
  }

  @override
  String get welcomeSubtitle =>
      'আপনার সুস্থতা ও শেখার যাত্রা শুরু হোক এখান থেকে।';

  @override
  String homeCarouselImageLabel(int imageNumber) {
    return 'কাপিং থেরাপি ব্যবসার ছবি $imageNumber';
  }

  @override
  String homeCarouselPageCounter(int currentPage, int totalPages) {
    return '$totalPages-এর মধ্যে $currentPage';
  }

  @override
  String get discoverTherapy => 'কাপিং থেরাপি সম্পর্কে জানুন';

  @override
  String get therapyServiceTitle => 'কাপিং থেরাপি';

  @override
  String get exploreServicesAndTraining =>
      'আমাদের সেবা ও পেশাদার প্রশিক্ষণ কর্মসূচি সম্পর্কে জানুন।';

  @override
  String get exploreServices => 'সেবাগুলো দেখুন';

  @override
  String get exploreTraining => 'প্রশিক্ষণ দেখুন';

  @override
  String get trainingPromoTitle => 'কাপিং প্রশিক্ষণ';

  @override
  String get trainingPromoDescription =>
      'ব্যবহারিক শেখার সুযোগগুলো দেখুন। কোর্সের বিস্তারিত ও সময়সূচি শিগগিরই জানানো হবে।';

  @override
  String get quickActions => 'দ্রুত কার্যাবলি';

  @override
  String get quickActionsSubtitle => 'প্রয়োজনীয় বিষয় দ্রুত খুঁজে নিন।';

  @override
  String get bookAppointment => 'অ্যাপয়েন্টমেন্ট নিন';

  @override
  String get exploreTherapy => 'থেরাপি সম্পর্কে জানুন';

  @override
  String get trainingPrograms => 'প্রশিক্ষণ কর্মসূচি';

  @override
  String get contactUs => 'যোগাযোগ করুন';

  @override
  String get ourServices => 'আমাদের সেবাসমূহ';

  @override
  String get serviceInformationPreparing => 'সেবার তথ্য প্রস্তুত করা হচ্ছে।';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get contactAndLocation => 'যোগাযোগ ও অবস্থান';

  @override
  String get serviceDetailsUnavailable =>
      'সেবার বিস্তারিত ও প্রাপ্যতা জানতে আমাদের সঙ্গে যোগাযোগ করুন।';

  @override
  String get consultation => 'পরামর্শ';

  @override
  String get consultationDetails =>
      'পরামর্শের সুযোগ সম্পর্কে আমাদের জিজ্ঞাসা করুন।';

  @override
  String get therapyPackages => 'থেরাপি প্যাকেজ';

  @override
  String get packageDetailsUnavailable => 'প্যাকেজের তথ্য শিগগিরই জানানো হবে।';

  @override
  String get trainingSectionSubtitle =>
      'ব্যবহারিক প্রশিক্ষণ সম্পর্কে আরও জানুন।';

  @override
  String get contactDetailsUnavailable =>
      'যোগাযোগের তথ্য এখনো পাওয়া যাচ্ছে না। পরে আবার দেখুন।';

  @override
  String get businessDetailsUnavailable =>
      'ব্যবসার যোগাযোগ ও অবস্থানের তথ্য এখনো যোগ করা হয়নি।';

  @override
  String get contactUsForDetails => 'বিস্তারিত জানতে যোগাযোগ করুন';

  @override
  String get appointments => 'অ্যাপয়েন্টমেন্ট';

  @override
  String get appointmentsPlaceholder => 'অ্যাপয়েন্টমেন্টের তথ্য';

  @override
  String get appointmentIntroTitle => 'আপনার অ্যাপয়েন্টমেন্টের অনুরোধ জানান';

  @override
  String get appointmentIntroDescription =>
      'আপনার পছন্দের সেবা ও সময় জানান। বিস্তারিত নিশ্চিত করতে আমরা আপনার সঙ্গে যোগাযোগ করব।';

  @override
  String get bookingStepService => 'একটি সেবা বেছে নিন';

  @override
  String get bookingStepDateTime => 'পছন্দের তারিখ ও সময় নির্বাচন করুন';

  @override
  String get bookingStepRequest => 'অ্যাপয়েন্টমেন্টের অনুরোধ পাঠান';

  @override
  String get serviceSelection => 'সেবা বেছে নিন';

  @override
  String get serviceOptionsNote =>
      'এগুলো প্রাথমিক বিকল্প মাত্র। সেবার বিস্তারিত ও অ্যাপয়েন্টমেন্টের প্রাপ্যতা আমাদের দল নিশ্চিত করবে।';

  @override
  String get preferredDate => 'পছন্দের তারিখ';

  @override
  String get selectPreferredDate => 'পছন্দের তারিখ নির্বাচন করুন';

  @override
  String get dateAvailabilityNote =>
      'এটি আপনার পছন্দের তারিখ, নিশ্চিতভাবে উপলভ্য অ্যাপয়েন্টমেন্ট নয়।';

  @override
  String get preferredTime => 'পছন্দের সময়';

  @override
  String get preferredTimeNote =>
      'আপনার সুবিধামতো দিনের সময় বেছে নিন। এগুলো নিশ্চিত সময়সূচি নয়।';

  @override
  String get morning => 'সকাল';

  @override
  String get afternoon => 'দুপুর';

  @override
  String get evening => 'সন্ধ্যা';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get phoneNumberHint => 'আপনার ফোন নম্বর লিখুন';

  @override
  String get bookingSummary => 'অনুরোধের সারসংক্ষেপ';

  @override
  String get notSelected => 'নির্বাচন করা হয়নি';

  @override
  String get requestNotConfirmed =>
      'আমাদের দল আপনার সঙ্গে যোগাযোগ না করা পর্যন্ত অ্যাপয়েন্টমেন্ট নিশ্চিত নয়।';

  @override
  String get requestAppointment => 'অ্যাপয়েন্টমেন্টের অনুরোধ জানান';

  @override
  String get completeRequiredDetails =>
      'এগিয়ে যেতে সেবা, তারিখ ও পছন্দের সময় নির্বাচন করুন এবং যোগাযোগের তথ্য লিখুন।';

  @override
  String get appointmentRequestUnavailable =>
      'অ্যাপ থেকে এখনো অ্যাপয়েন্টমেন্টের অনুরোধ পাঠানো যায় না। আপনার তথ্য পাঠানো বা সংরক্ষণ করা হয়নি।';

  @override
  String get upcomingAppointments => 'আসন্ন অ্যাপয়েন্টমেন্ট';

  @override
  String get appointmentsEmptyState =>
      'অ্যাপয়েন্টমেন্টের তথ্য পাওয়া গেলে নিশ্চিত অ্যাপয়েন্টমেন্টগুলো এখানে দেখা যাবে।';

  @override
  String get therapyServices => 'থেরাপি সেবাসমূহ';

  @override
  String get therapyServicesPlaceholder => 'থেরাপি সেবার তথ্য';

  @override
  String get therapyServicesIntroTitle =>
      'আপনার স্বাচ্ছন্দ্যকে গুরুত্ব দিয়ে যত্ন';

  @override
  String get therapyServicesIntroDescription =>
      'কাপিং থেরাপি ও পরামর্শের বিকল্পগুলো দেখুন। সিদ্ধান্ত নেওয়ার আগে বিস্তারিত জানতে আমাদের দল আপনাকে সহায়তা করবে।';

  @override
  String get serviceCatalogPreviewNote =>
      'সেবার তথ্য এখনো প্রস্তুত করা হচ্ছে। এই প্রাথমিক বিবরণগুলো নিশ্চিত সেবার তালিকা নয়; বর্তমান সেবা ও বিস্তারিত জানতে আমাদের সঙ্গে যোগাযোগ করুন।';

  @override
  String get servicePreviewLabel => 'প্রাথমিক তথ্য';

  @override
  String get viewServiceDetails => 'বিস্তারিত দেখুন';

  @override
  String get serviceDetailsPreviewNote =>
      'এটি কেবল প্রাথমিক তথ্য। বিস্তারিত ও প্রাপ্যতা এখনো নিশ্চিত করা হয়নি।';

  @override
  String get trainingProgramsPlaceholder => 'প্রশিক্ষণ কর্মসূচির তথ্য';

  @override
  String get trainingIntroTitle => 'কাপিং থেরাপি শেখার সুযোগ দেখুন';

  @override
  String get trainingIntroDescription =>
      'কাপিং থেরাপির ব্যবহারিক প্রশিক্ষণের সুযোগ সম্পর্কে জানুন। কর্মসূচির বিস্তারিত নিশ্চিত হলে জানানো হবে।';

  @override
  String get trainingProgramsEmptyTitle => 'প্রশিক্ষণের বিস্তারিত শিগগিরই আসছে';

  @override
  String get trainingProgramsEmptyDescription =>
      'এই মুহূর্তে দেখানোর মতো কোনো নিশ্চিত কর্মসূচি নেই। যাচাইকৃত কোর্সের তথ্য ও ভর্তির আপডেট পাওয়া গেলে এখানে দেওয়া হবে।';

  @override
  String get trainingEducationDisclaimer =>
      'প্রশিক্ষণের তথ্য শিক্ষামূলক; এটি চিকিৎসকের পরামর্শ বা পেশাগত লাইসেন্সের শর্তের বিকল্প নয়।';

  @override
  String get trainingIconLabel => 'শেখা ও শিক্ষা';

  @override
  String get profileAndAccount => 'প্রোফাইল ও অ্যাকাউন্ট';

  @override
  String get yourAccount => 'আপনার অ্যাকাউন্ট';

  @override
  String get myAppointments => 'আমার অ্যাপয়েন্টমেন্ট';

  @override
  String get myTraining => 'আমার প্রশিক্ষণ';

  @override
  String get login => 'লগইন';

  @override
  String get signInToAccessAccount =>
      'আপনার অ্যাকাউন্ট ব্যবহার করতে সাইন ইন করুন।';

  @override
  String get register => 'নিবন্ধন';

  @override
  String get createAccountSubtitle => 'শুরু করতে একটি অ্যাকাউন্ট তৈরি করুন।';

  @override
  String get settings => 'সেটিংস';

  @override
  String get information => 'তথ্য';

  @override
  String get helpAndSupport => 'সহায়তা ও সমর্থন';

  @override
  String get supportDetailsUnavailable =>
      'যোগাযোগের তথ্য এখনো পাওয়া যাচ্ছে না।';

  @override
  String get supportContactUnavailable =>
      'সহায়তার যোগাযোগের তথ্য এখনো যোগ করা হয়নি। পরে আবার দেখুন।';

  @override
  String get aboutApp => 'অ্যাপ সম্পর্কে';

  @override
  String get session => 'সেশন';

  @override
  String get logout => 'লগ আউট';

  @override
  String get loggingOut => 'লগ আউট হচ্ছে…';

  @override
  String get logoutConfirmationTitle => 'লগ আউট করবেন?';

  @override
  String get logoutConfirmationMessage =>
      'আপনার অ্যাকাউন্টে আবার প্রবেশ করতে সাইন ইন করতে হবে।';

  @override
  String get cancel => 'বাতিল';

  @override
  String get aboutDescription =>
      'কাপিং থেরাপি সেবা ও প্রশিক্ষণ সম্পর্কে জানার একটি অ্যাপ।';

  @override
  String get loadingAccount => 'অ্যাকাউন্টের তথ্য লোড হচ্ছে…';

  @override
  String get yourProfile => 'আপনার প্রোফাইল';

  @override
  String get welcomeGuest => 'স্বাগতম, অতিথি';

  @override
  String get accountDetailsUnavailable =>
      'অ্যাকাউন্টের বিস্তারিত তথ্য পাওয়া যাচ্ছে না।';

  @override
  String get signInOrCreateAccount =>
      'শুরু করতে সাইন ইন করুন অথবা একটি অ্যাকাউন্ট তৈরি করুন।';

  @override
  String get unableToLoadAccount => 'অ্যাকাউন্টের তথ্য লোড করা যায়নি।';

  @override
  String get unableToLogout => 'লগ আউট করা যায়নি।';

  @override
  String get unableToLoadCredentials => 'সংরক্ষিত সাইন-ইন তথ্য লোড করা যায়নি।';

  @override
  String get unableToSaveSignInState => 'সাইন-ইন অবস্থা সংরক্ষণ করা যায়নি।';

  @override
  String get back => 'পেছনে';

  @override
  String get settingsPlaceholder => 'সেটিংস';

  @override
  String get language => 'ভাষা';

  @override
  String get appearance => 'থিম ও প্রদর্শন';

  @override
  String get chooseTheme => 'অ্যাপের প্রদর্শন পদ্ধতি নির্বাচন করুন।';

  @override
  String get systemDefault => 'সিস্টেমের ডিফল্ট';

  @override
  String get lightTheme => 'লাইট';

  @override
  String get darkTheme => 'ডার্ক';

  @override
  String get themeSaveFailed => 'আপনার থিমের পছন্দ সংরক্ষণ করা যায়নি।';

  @override
  String get chooseLanguage => 'আপনার পছন্দের ভাষা নির্বাচন করুন।';

  @override
  String get english => 'English';

  @override
  String get bengali => 'বাংলা';

  @override
  String get languageSaveFailed => 'আপনার ভাষার পছন্দ সংরক্ষণ করা যায়নি।';

  @override
  String get welcomeBack => 'আবার স্বাগতম';

  @override
  String get signInTagline => 'আপনার যত্নের যাত্রা চালিয়ে যেতে সাইন ইন করুন।';

  @override
  String get emailAddress => 'ইমেইল ঠিকানা';

  @override
  String get email => 'ইমেইল';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get passwordHint => 'আপনার পাসওয়ার্ড লিখুন';

  @override
  String get rememberMe => 'আমাকে মনে রাখুন';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get noAccountPrompt => 'অ্যাকাউন্ট নেই?';

  @override
  String get createAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get wellbeingPriority => 'আপনার সুস্থতাই আমাদের অগ্রাধিকার';

  @override
  String get createYourAccount => 'আপনার অ্যাকাউন্ট তৈরি করুন';

  @override
  String get registrationTagline =>
      'আমাদের সঙ্গে যোগ দিন এবং যত্নের যাত্রায় এগিয়ে যান।';

  @override
  String get fullName => 'পুরো নাম';

  @override
  String get nameHint => 'আপনার নাম লিখুন';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get confirmPasswordHint => 'আবার পাসওয়ার্ড লিখুন';

  @override
  String get passwordLengthHint => 'কমপক্ষে ৮টি অক্ষর';

  @override
  String get termsAndPrivacy =>
      'আমি ব্যবহারের শর্তাবলি ও গোপনীয়তা নীতিতে সম্মত';

  @override
  String get termsRequired => 'চালিয়ে যেতে শর্তাবলিতে সম্মতি দিন।';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে?';

  @override
  String get registrationUnavailable =>
      'নিবন্ধন ব্যবস্থা এখনো সার্ভারের সঙ্গে সংযুক্ত নয়।';

  @override
  String fieldRequired(String fieldName) {
    return '$fieldName দেওয়া আবশ্যক।';
  }

  @override
  String get emailRequired => 'ইমেইল দেওয়া আবশ্যক।';

  @override
  String get invalidEmail => 'একটি সঠিক ইমেইল ঠিকানা লিখুন।';

  @override
  String get passwordRequired => 'পাসওয়ার্ড দেওয়া আবশ্যক।';

  @override
  String passwordMinLength(int minLength) {
    return 'পাসওয়ার্ডে কমপক্ষে $minLengthটি অক্ষর থাকতে হবে।';
  }

  @override
  String get confirmPasswordRequired => 'আপনার পাসওয়ার্ড নিশ্চিত করুন।';

  @override
  String get passwordsDoNotMatch => 'পাসওয়ার্ড দুটি মিলছে না।';

  @override
  String get accountIconLabel => 'প্রোফাইল ও অ্যাকাউন্ট';

  @override
  String get wellnessIconLabel => 'সুস্থতা';

  @override
  String get splashFooter => 'থেরাপি • প্রশিক্ষণ • সুস্থতা';

  @override
  String logoLabel(String appName) {
    return '$appName লোগো';
  }

  @override
  String get restoringSession => 'আপনার সেশন পুনরুদ্ধার করা হচ্ছে';

  @override
  String get preparingExperience => 'আপনার যত্নের অভিজ্ঞতা প্রস্তুত করা হচ্ছে';

  @override
  String get unableToRestoreSession => 'আপনার সেশন পুনরুদ্ধার করা যায়নি।';

  @override
  String get passwordVisibility => 'পাসওয়ার্ড দেখানো বা লুকানো';

  @override
  String get contactDetails => 'যোগাযোগের তথ্য';

  @override
  String get consultationOptions =>
      'পরামর্শের সুযোগ সম্পর্কে আমাদের জিজ্ঞাসা করুন।';
}
