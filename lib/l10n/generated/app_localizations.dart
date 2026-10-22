import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Cupping Therapy'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Wellness, Our Care'**
  String get appTagline;

  /// No description provided for @preparingCare.
  ///
  /// In en, this message translates to:
  /// **'Preparing your care experience...'**
  String get preparingCare;

  /// No description provided for @sessionRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t restore your session.'**
  String get sessionRestoreFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String welcomeMessage(String appName);

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your wellness and learning journey starts here.'**
  String get welcomeSubtitle;

  /// No description provided for @homeCarouselImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Cupping therapy business image {imageNumber}'**
  String homeCarouselImageLabel(int imageNumber);

  /// No description provided for @homeCarouselPageCounter.
  ///
  /// In en, this message translates to:
  /// **'{currentPage} of {totalPages}'**
  String homeCarouselPageCounter(int currentPage, int totalPages);

  /// No description provided for @homeCarouselOpenImage.
  ///
  /// In en, this message translates to:
  /// **'Open cupping therapy business image {imageNumber}'**
  String homeCarouselOpenImage(int imageNumber);

  /// No description provided for @homeImageViewerClose.
  ///
  /// In en, this message translates to:
  /// **'Close image viewer'**
  String get homeImageViewerClose;

  /// No description provided for @homeImageViewerPosition.
  ///
  /// In en, this message translates to:
  /// **'Image {currentPage} of {totalPages}'**
  String homeImageViewerPosition(int currentPage, int totalPages);

  /// No description provided for @discoverTherapy.
  ///
  /// In en, this message translates to:
  /// **'Discover Cupping Therapy'**
  String get discoverTherapy;

  /// No description provided for @therapyServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Cupping Therapy'**
  String get therapyServiceTitle;

  /// No description provided for @exploreServicesAndTraining.
  ///
  /// In en, this message translates to:
  /// **'Explore our services and professional training programs.'**
  String get exploreServicesAndTraining;

  /// No description provided for @exploreServices.
  ///
  /// In en, this message translates to:
  /// **'Explore Services'**
  String get exploreServices;

  /// No description provided for @exploreTraining.
  ///
  /// In en, this message translates to:
  /// **'Explore Training'**
  String get exploreTraining;

  /// No description provided for @trainingPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Cupping training'**
  String get trainingPromoTitle;

  /// No description provided for @trainingPromoDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore practical learning opportunities. Course details and availability are coming soon.'**
  String get trainingPromoDescription;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @quickActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find what you need, quickly.'**
  String get quickActionsSubtitle;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book an Appointment'**
  String get bookAppointment;

  /// No description provided for @exploreTherapy.
  ///
  /// In en, this message translates to:
  /// **'Explore Therapy'**
  String get exploreTherapy;

  /// No description provided for @trainingPrograms.
  ///
  /// In en, this message translates to:
  /// **'Training Programs'**
  String get trainingPrograms;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get ourServices;

  /// No description provided for @serviceInformationPreparing.
  ///
  /// In en, this message translates to:
  /// **'Service information is being prepared.'**
  String get serviceInformationPreparing;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @contactAndLocation.
  ///
  /// In en, this message translates to:
  /// **'Contact & location'**
  String get contactAndLocation;

  /// No description provided for @serviceDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Contact us for service details and availability.'**
  String get serviceDetailsUnavailable;

  /// No description provided for @consultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get consultation;

  /// No description provided for @consultationDetails.
  ///
  /// In en, this message translates to:
  /// **'Ask us about available consultation options.'**
  String get consultationDetails;

  /// No description provided for @therapyPackages.
  ///
  /// In en, this message translates to:
  /// **'Therapy Packages'**
  String get therapyPackages;

  /// No description provided for @packageDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Package information will be shared soon.'**
  String get packageDetailsUnavailable;

  /// No description provided for @trainingSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn more about practical training.'**
  String get trainingSectionSubtitle;

  /// No description provided for @contactDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Contact details are not available yet. Please check back soon.'**
  String get contactDetailsUnavailable;

  /// No description provided for @businessDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Business contact and location details have not been added yet.'**
  String get businessDetailsUnavailable;

  /// No description provided for @contactUsForDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact us for details'**
  String get contactUsForDetails;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @appointmentsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Appointments placeholder'**
  String get appointmentsPlaceholder;

  /// No description provided for @appointmentIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Book your appointment'**
  String get appointmentIntroTitle;

  /// No description provided for @appointmentIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'Tell us which service and preferred time work for you. We will contact you to confirm the details.'**
  String get appointmentIntroDescription;

  /// No description provided for @bookingStepService.
  ///
  /// In en, this message translates to:
  /// **'Choose a service'**
  String get bookingStepService;

  /// No description provided for @bookingStepDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select a preferred date and time'**
  String get bookingStepDateTime;

  /// No description provided for @bookingStepRequest.
  ///
  /// In en, this message translates to:
  /// **'Send your appointment request'**
  String get bookingStepRequest;

  /// No description provided for @serviceSelection.
  ///
  /// In en, this message translates to:
  /// **'Choose a service'**
  String get serviceSelection;

  /// No description provided for @serviceOptionsNote.
  ///
  /// In en, this message translates to:
  /// **'These are preview options only. Service details and appointment availability will be confirmed by our team.'**
  String get serviceOptionsNote;

  /// No description provided for @preferredDate.
  ///
  /// In en, this message translates to:
  /// **'Preferred date'**
  String get preferredDate;

  /// No description provided for @selectPreferredDate.
  ///
  /// In en, this message translates to:
  /// **'Select a preferred date'**
  String get selectPreferredDate;

  /// No description provided for @dateAvailabilityNote.
  ///
  /// In en, this message translates to:
  /// **'This is a date preference, not a confirmed available appointment.'**
  String get dateAvailabilityNote;

  /// No description provided for @preferredTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred time'**
  String get preferredTime;

  /// No description provided for @preferredTimeNote.
  ///
  /// In en, this message translates to:
  /// **'Choose a time of day that suits you. These preferences are not confirmed time slots.'**
  String get preferredTimeNote;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberHint;

  /// No description provided for @bookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Request summary'**
  String get bookingSummary;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @requestNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your appointment is not confirmed until our team contacts you.'**
  String get requestNotConfirmed;

  /// No description provided for @requestAppointment.
  ///
  /// In en, this message translates to:
  /// **'Request appointment'**
  String get requestAppointment;

  /// No description provided for @completeRequiredDetails.
  ///
  /// In en, this message translates to:
  /// **'Choose a service, date and preferred time, and enter your contact details to continue.'**
  String get completeRequiredDetails;

  /// No description provided for @appointmentRequestUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Appointment requests cannot be submitted in the app yet. Your details have not been sent or saved.'**
  String get appointmentRequestUnavailable;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming appointments'**
  String get upcomingAppointments;

  /// No description provided for @appointmentsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Confirmed appointments will appear here when appointment information is available.'**
  String get appointmentsEmptyState;

  /// No description provided for @therapyServices.
  ///
  /// In en, this message translates to:
  /// **'Therapy Services'**
  String get therapyServices;

  /// No description provided for @therapyServicesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Therapy services placeholder'**
  String get therapyServicesPlaceholder;

  /// No description provided for @therapyServicesIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Care, with your comfort in mind'**
  String get therapyServicesIntroTitle;

  /// No description provided for @therapyServicesIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore our cupping therapy and consultation options. Our team can help you learn more before you decide.'**
  String get therapyServicesIntroDescription;

  /// No description provided for @serviceCatalogPreviewNote.
  ///
  /// In en, this message translates to:
  /// **'Service information is still being prepared. These previews are not a confirmed service catalogue; please contact us to verify current services and details.'**
  String get serviceCatalogPreviewNote;

  /// No description provided for @servicePreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview information'**
  String get servicePreviewLabel;

  /// No description provided for @viewServiceDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewServiceDetails;

  /// No description provided for @serviceDetailsPreviewNote.
  ///
  /// In en, this message translates to:
  /// **'This is introductory information only. Details and availability have not been confirmed.'**
  String get serviceDetailsPreviewNote;

  /// No description provided for @trainingProgramsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Training programs placeholder'**
  String get trainingProgramsPlaceholder;

  /// No description provided for @trainingIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore cupping therapy training'**
  String get trainingIntroTitle;

  /// No description provided for @trainingIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn about practical training opportunities in cupping therapy. Program details will be shared when confirmed.'**
  String get trainingIntroDescription;

  /// No description provided for @trainingProgramsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Training details are coming soon'**
  String get trainingProgramsEmptyTitle;

  /// No description provided for @trainingProgramsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'There are no confirmed programs to show right now. Verified course information and enrollment updates will appear here when available.'**
  String get trainingProgramsEmptyDescription;

  /// No description provided for @trainingEducationDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Training information is educational and does not replace medical advice or professional licensing requirements.'**
  String get trainingEducationDisclaimer;

  /// No description provided for @trainingIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Learning and education'**
  String get trainingIconLabel;

  /// No description provided for @profileAndAccount.
  ///
  /// In en, this message translates to:
  /// **'Profile & account'**
  String get profileAndAccount;

  /// No description provided for @yourAccount.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get yourAccount;

  /// No description provided for @myAppointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// No description provided for @myTraining.
  ///
  /// In en, this message translates to:
  /// **'My Training'**
  String get myTraining;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signInToAccessAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your account.'**
  String get signInToAccessAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to get started.'**
  String get createAccountSubtitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @supportDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Contact details are not available yet.'**
  String get supportDetailsUnavailable;

  /// No description provided for @supportContactUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Support contact details have not been added yet. Please check back soon.'**
  String get supportContactUnavailable;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out…'**
  String get loggingOut;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your account.'**
  String get logoutConfirmationMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'An app for exploring cupping therapy services and training information.'**
  String get aboutDescription;

  /// No description provided for @loadingAccount.
  ///
  /// In en, this message translates to:
  /// **'Loading account…'**
  String get loadingAccount;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get yourProfile;

  /// No description provided for @welcomeGuest.
  ///
  /// In en, this message translates to:
  /// **'Welcome, guest'**
  String get welcomeGuest;

  /// No description provided for @accountDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Account details are not available yet.'**
  String get accountDetailsUnavailable;

  /// No description provided for @signInOrCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to get started.'**
  String get signInOrCreateAccount;

  /// No description provided for @unableToLoadAccount.
  ///
  /// In en, this message translates to:
  /// **'Unable to load account information.'**
  String get unableToLoadAccount;

  /// No description provided for @unableToLogout.
  ///
  /// In en, this message translates to:
  /// **'Unable to log out.'**
  String get unableToLogout;

  /// No description provided for @unableToLoadCredentials.
  ///
  /// In en, this message translates to:
  /// **'Unable to load saved sign-in details.'**
  String get unableToLoadCredentials;

  /// No description provided for @unableToSaveSignInState.
  ///
  /// In en, this message translates to:
  /// **'Unable to save sign-in state.'**
  String get unableToSaveSignInState;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Settings placeholder'**
  String get settingsPlaceholder;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose how the app looks.'**
  String get chooseTheme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @themeSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to save your theme preference.'**
  String get themeSaveFailed;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language.'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get bengali;

  /// No description provided for @languageSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to save your language preference.'**
  String get languageSaveFailed;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInTagline.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your care journey.'**
  String get signInTagline;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @wellbeingPriority.
  ///
  /// In en, this message translates to:
  /// **'Your wellbeing is our priority'**
  String get wellbeingPriority;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @registrationTagline.
  ///
  /// In en, this message translates to:
  /// **'Join us and take the next step in your care journey.'**
  String get registrationTagline;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password again'**
  String get confirmPasswordHint;

  /// No description provided for @passwordLengthHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordLengthHint;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and privacy policy'**
  String get termsAndPrivacy;

  /// No description provided for @termsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms to continue.'**
  String get termsRequired;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @registrationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Registration is not connected to a server yet.'**
  String get registrationUnavailable;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required.'**
  String fieldRequired(String fieldName);

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters.'**
  String passwordMinLength(int minLength);

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @accountIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile and account'**
  String get accountIconLabel;

  /// No description provided for @wellnessIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get wellnessIconLabel;

  /// No description provided for @splashFooter.
  ///
  /// In en, this message translates to:
  /// **'THERAPY • TRAINING • WELLNESS'**
  String get splashFooter;

  /// No description provided for @logoLabel.
  ///
  /// In en, this message translates to:
  /// **'{appName} logo'**
  String logoLabel(String appName);

  /// No description provided for @restoringSession.
  ///
  /// In en, this message translates to:
  /// **'Restoring your session'**
  String get restoringSession;

  /// No description provided for @preparingExperience.
  ///
  /// In en, this message translates to:
  /// **'Preparing your care experience'**
  String get preparingExperience;

  /// No description provided for @unableToRestoreSession.
  ///
  /// In en, this message translates to:
  /// **'Unable to restore your session.'**
  String get unableToRestoreSession;

  /// No description provided for @passwordVisibility.
  ///
  /// In en, this message translates to:
  /// **'Toggle password visibility'**
  String get passwordVisibility;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get contactDetails;

  /// No description provided for @consultationOptions.
  ///
  /// In en, this message translates to:
  /// **'Ask us about available consultation options.'**
  String get consultationOptions;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
