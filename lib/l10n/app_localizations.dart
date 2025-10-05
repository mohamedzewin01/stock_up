import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
/// import 'l10n/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get home;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'category'**
  String get category;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'categories'**
  String get categories;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get user;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get search;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Our Heroes'**
  String get appName;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login or create an account to continue'**
  String get loginToContinue;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'FirstName'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'LastName'**
  String get lastName;

  /// No description provided for @pleaseEnterYourUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get pleaseEnterYourUsername;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPasswordClicked.
  ///
  /// In en, this message translates to:
  /// **'Forgot password clicked'**
  String get forgotPasswordClicked;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Register with Google'**
  String get google;

  /// No description provided for @googleLoginClicked.
  ///
  /// In en, this message translates to:
  /// **'Google login clicked'**
  String get googleLoginClicked;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @facebookLoginClicked.
  ///
  /// In en, this message translates to:
  /// **'Facebook login clicked'**
  String get facebookLoginClicked;

  /// No description provided for @byContinuingYouAgreeToOur.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our'**
  String get byContinuingYouAgreeToOur;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsOfServiceClicked.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service clicked'**
  String get termsOfServiceClicked;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyClicked.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy clicked'**
  String get privacyPolicyClicked;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @meeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting'**
  String get meeting;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help your child grow through interactive stories'**
  String get appSubtitle;

  /// No description provided for @audioNarration.
  ///
  /// In en, this message translates to:
  /// **'Audio narration that engages and educates'**
  String get audioNarration;

  /// No description provided for @expertGuidedSolutions.
  ///
  /// In en, this message translates to:
  /// **'Expert-guided behavioral solutions through storytelling'**
  String get expertGuidedSolutions;

  /// No description provided for @personalizedStories.
  ///
  /// In en, this message translates to:
  /// **'Personalized stories for unique child needs'**
  String get personalizedStories;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get name;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'age'**
  String get age;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'birth date'**
  String get birthDate;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'female'**
  String get genderFemale;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'stories'**
  String get stories;

  /// No description provided for @deleteChild.
  ///
  /// In en, this message translates to:
  /// **'delete child'**
  String get deleteChild;

  /// No description provided for @areYouSureDelete.
  ///
  /// In en, this message translates to:
  /// **'are you sure delete'**
  String get areYouSureDelete;

  /// No description provided for @questionMark.
  ///
  /// In en, this message translates to:
  /// **'?'**
  String get questionMark;

  /// No description provided for @deleteWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this child?'**
  String get deleteWarning;

  /// No description provided for @genderBoy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get genderBoy;

  /// No description provided for @genderGirl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get genderGirl;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @enterAge.
  ///
  /// In en, this message translates to:
  /// **'Enter age'**
  String get enterAge;

  /// No description provided for @enterBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Enter birth date'**
  String get enterBirthDate;

  /// No description provided for @enterNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get enterNameError;

  /// No description provided for @enterAgeError.
  ///
  /// In en, this message translates to:
  /// **'Please enter age'**
  String get enterAgeError;

  /// No description provided for @enterBirthDateError.
  ///
  /// In en, this message translates to:
  /// **'Please enter birth date'**
  String get enterBirthDateError;

  /// No description provided for @familySiblings.
  ///
  /// In en, this message translates to:
  /// **'Family & Siblings'**
  String get familySiblings;

  /// No description provided for @addSibling.
  ///
  /// In en, this message translates to:
  /// **'Add Sibling'**
  String get addSibling;

  /// No description provided for @sibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get sibling;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @addFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get addFriends;

  /// No description provided for @noFriendsAdded.
  ///
  /// In en, this message translates to:
  /// **'No friends added'**
  String get noFriendsAdded;

  /// No description provided for @noSiblingsAdded.
  ///
  /// In en, this message translates to:
  /// **'No siblings added'**
  String get noSiblingsAdded;

  /// No description provided for @chooseImageSource.
  ///
  /// In en, this message translates to:
  /// **'Choose image source'**
  String get chooseImageSource;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @pleaseEnterTheLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the last name'**
  String get pleaseEnterTheLastName;

  /// No description provided for @pleaseEnterTheFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the first name'**
  String get pleaseEnterTheFirstName;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @receiveStoryRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Receive story recommendations'**
  String get receiveStoryRecommendations;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @removeAccount.
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get removeAccount;

  /// No description provided for @myChildren.
  ///
  /// In en, this message translates to:
  /// **'MyChildren'**
  String get myChildren;

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get yearsOld;

  /// No description provided for @bestPlaymate.
  ///
  /// In en, this message translates to:
  /// **'best playmate'**
  String get bestPlaymate;

  /// No description provided for @addBestPlaymate.
  ///
  /// In en, this message translates to:
  /// **'add best playmate'**
  String get addBestPlaymate;

  /// No description provided for @invalidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid age'**
  String get invalidAge;

  /// No description provided for @add_one_friend_only.
  ///
  /// In en, this message translates to:
  /// **'You can only add one friend'**
  String get add_one_friend_only;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @pleaseEnterYourFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterYourFirstName;

  /// No description provided for @pleaseEnterYourLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get pleaseEnterYourLastName;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @pleaseEnterYourAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter your age'**
  String get pleaseEnterYourAge;

  /// No description provided for @pleaseSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get pleaseSelectGender;

  /// No description provided for @pleaseConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @firstNameMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'First name must be at least 2 characters'**
  String get firstNameMustBeAtLeast2Characters;

  /// No description provided for @lastNameMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'Last name must be at least 2 characters'**
  String get lastNameMustBeAtLeast2Characters;

  /// No description provided for @pleaseEnterAValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterAValidPhoneNumber;

  /// No description provided for @pleaseEnterAValidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age'**
  String get pleaseEnterAValidAge;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @selectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Select photo'**
  String get selectPhoto;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @areYouSureRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the photo?'**
  String get areYouSureRemovePhoto;

  /// No description provided for @imageUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image updated successfully'**
  String get imageUpdatedSuccessfully;

  /// No description provided for @imageRemovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image removed successfully'**
  String get imageRemovedSuccessfully;

  /// No description provided for @failedToUpdateImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update the image'**
  String get failedToUpdateImage;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @enterEmailToResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to reset your password'**
  String get enterEmailToResetPassword;

  /// No description provided for @sendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetEmail;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @resetPasswordInfo.
  ///
  /// In en, this message translates to:
  /// **'A password reset link will be sent to your email address'**
  String get resetPasswordInfo;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPassword;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent!'**
  String get emailSent;

  /// No description provided for @checkEmailForResetLink.
  ///
  /// In en, this message translates to:
  /// **'Check your email and follow the link to reset your password'**
  String get checkEmailForResetLink;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
