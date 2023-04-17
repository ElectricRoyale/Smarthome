// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get titleLogin {
    return Intl.message(
      'Login',
      name: 'titleLogin',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get titleRegister {
    return Intl.message(
      'Register',
      name: 'titleRegister',
      desc: '',
      args: [],
    );
  }

  /// `Cropper`
  String get titleImageCropper {
    return Intl.message(
      'Cropper',
      name: 'titleImageCropper',
      desc: '',
      args: [],
    );
  }

  /// `Rooms`
  String get titleRooms {
    return Intl.message(
      'Rooms',
      name: 'titleRooms',
      desc: '',
      args: [],
    );
  }

  /// `Network`
  String get titleNetwork {
    return Intl.message(
      'Network',
      name: 'titleNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get titleSettings {
    return Intl.message(
      'Settings',
      name: 'titleSettings',
      desc: '',
      args: [],
    );
  }

  /// `Select your Home Assistant Server`
  String get discoverySelectServer {
    return Intl.message(
      'Select your Home Assistant Server',
      name: 'discoverySelectServer',
      desc: '',
      args: [],
    );
  }

  /// `Enter address manually`
  String get discoveryEnterManual {
    return Intl.message(
      'Enter address manually',
      name: 'discoveryEnterManual',
      desc: '',
      args: [],
    );
  }

  /// `Enter your address`
  String get discoveryDialogMessage {
    return Intl.message(
      'Enter your address',
      name: 'discoveryDialogMessage',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get loginFieldHintName {
    return Intl.message(
      'Name',
      name: 'loginFieldHintName',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get loginFieldHintPassword {
    return Intl.message(
      'Password',
      name: 'loginFieldHintPassword',
      desc: '',
      args: [],
    );
  }

  /// `Field can't be empty!`
  String get loginFieldErrorEmpty {
    return Intl.message(
      'Field can\'t be empty!',
      name: 'loginFieldErrorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get loginPasswordForgot {
    return Intl.message(
      'Forgot Password?',
      name: 'loginPasswordForgot',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an Account?`
  String get loginDontHaveAccount {
    return Intl.message(
      'Don\'t have an Account?',
      name: 'loginDontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `SignUp`
  String get loginSignUp {
    return Intl.message(
      'SignUp',
      name: 'loginSignUp',
      desc: '',
      args: [],
    );
  }

  /// `First name, Last name`
  String get registerFieldHintName {
    return Intl.message(
      'First name, Last name',
      name: 'registerFieldHintName',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail Address`
  String get registerFieldHintEmail {
    return Intl.message(
      'E-Mail Address',
      name: 'registerFieldHintEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get registerFieldHintPassword {
    return Intl.message(
      'Password',
      name: 'registerFieldHintPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get registerFieldHintConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'registerFieldHintConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please, enter your first and last name!`
  String get registerFieldErrorName {
    return Intl.message(
      'Please, enter your first and last name!',
      name: 'registerFieldErrorName',
      desc: '',
      args: [],
    );
  }

  /// `Please, enter correct email address!`
  String get registerFieldErrorEmail {
    return Intl.message(
      'Please, enter correct email address!',
      name: 'registerFieldErrorEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password don't be the same!`
  String get registerFieldErrorPassword {
    return Intl.message(
      'Password don\'t be the same!',
      name: 'registerFieldErrorPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters!`
  String get registerFieldErrorPasswordLength {
    return Intl.message(
      'Password must be at least 8 characters!',
      name: 'registerFieldErrorPasswordLength',
      desc: '',
      args: [],
    );
  }

  /// `Password must contains lower case letters!`
  String get registerFieldErrorPasswordCharactersLow {
    return Intl.message(
      'Password must contains lower case letters!',
      name: 'registerFieldErrorPasswordCharactersLow',
      desc: '',
      args: [],
    );
  }

  /// `Password must contains capital letters!`
  String get registerFieldErrorPasswordCharactersCapital {
    return Intl.message(
      'Password must contains capital letters!',
      name: 'registerFieldErrorPasswordCharactersCapital',
      desc: '',
      args: [],
    );
  }

  /// `Field can't be empty!`
  String get registerFieldErrorEmpty {
    return Intl.message(
      'Field can\'t be empty!',
      name: 'registerFieldErrorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Have already an Account`
  String get registerAlreadyHaveAccount {
    return Intl.message(
      'Have already an Account',
      name: 'registerAlreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get registerErrorFailed {
    return Intl.message(
      'Registration failed',
      name: 'registerErrorFailed',
      desc: '',
      args: [],
    );
  }

  /// `Oops, something went wrong!`
  String get registerErrorFailedMessage {
    return Intl.message(
      'Oops, something went wrong!',
      name: 'registerErrorFailedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Duplicated user`
  String get registerErrorUserDuplicated {
    return Intl.message(
      'Duplicated user',
      name: 'registerErrorUserDuplicated',
      desc: '',
      args: [],
    );
  }

  /// `This username already exist! Please, take another Name!`
  String get registerErrorUserDuplicatedMessage {
    return Intl.message(
      'This username already exist! Please, take another Name!',
      name: 'registerErrorUserDuplicatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Connection Error`
  String get connectionerrorTitle {
    return Intl.message(
      'Connection Error',
      name: 'connectionerrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection! Please check your wifi, for connecting to server!`
  String get connectionerrorMessage {
    return Intl.message(
      'No internet connection! Please check your wifi, for connecting to server!',
      name: 'connectionerrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Appliances`
  String get devicegridAppliances {
    return Intl.message(
      'Appliances',
      name: 'devicegridAppliances',
      desc: '',
      args: [],
    );
  }

  /// `ALL DEVICES`
  String get devicegridAllDevices {
    return Intl.message(
      'ALL DEVICES',
      name: 'devicegridAllDevices',
      desc: '',
      args: [],
    );
  }

  /// ` kWh USED`
  String get devicegridUsage {
    return Intl.message(
      ' kWh USED',
      name: 'devicegridUsage',
      desc: '',
      args: [],
    );
  }

  /// `Delete?`
  String get weatherDialogDeleteTitle {
    return Intl.message(
      'Delete?',
      name: 'weatherDialogDeleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete this City?`
  String get weatherDialogDeleteMessage {
    return Intl.message(
      'Do you really want to delete this City?',
      name: 'weatherDialogDeleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get weatherDialogDeleteButtonDelete {
    return Intl.message(
      'Delete',
      name: 'weatherDialogDeleteButtonDelete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get weatherDialogDeleteButtonCancel {
    return Intl.message(
      'Cancel',
      name: 'weatherDialogDeleteButtonCancel',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail Address:`
  String get accountLabelEmail {
    return Intl.message(
      'E-Mail Address:',
      name: 'accountLabelEmail',
      desc: '',
      args: [],
    );
  }

  /// `Birthday:`
  String get accountLabelBirthday {
    return Intl.message(
      'Birthday:',
      name: 'accountLabelBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Address:`
  String get accountLabelAddress {
    return Intl.message(
      'Address:',
      name: 'accountLabelAddress',
      desc: '',
      args: [],
    );
  }

  /// `Telephone-number:`
  String get accountLabelTelephone {
    return Intl.message(
      'Telephone-number:',
      name: 'accountLabelTelephone',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get accountLogout {
    return Intl.message(
      'Logout',
      name: 'accountLogout',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get accountEdit {
    return Intl.message(
      'Edit',
      name: 'accountEdit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get accountSave {
    return Intl.message(
      'Save',
      name: 'accountSave',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get accountCancel {
    return Intl.message(
      'Cancel',
      name: 'accountCancel',
      desc: '',
      args: [],
    );
  }

  /// `Unlock the app.`
  String get biometricLocalizedReason {
    return Intl.message(
      'Unlock the app.',
      name: 'biometricLocalizedReason',
      desc: '',
      args: [],
    );
  }

  /// `The app is looked!`
  String get biometricScreenHeading {
    return Intl.message(
      'The app is looked!',
      name: 'biometricScreenHeading',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Add City`
  String get locationadddialogHeading {
    return Intl.message(
      'Add City',
      name: 'locationadddialogHeading',
      desc: '',
      args: [],
    );
  }

  /// `City name`
  String get locationadddialogHint {
    return Intl.message(
      'City name',
      name: 'locationadddialogHint',
      desc: '',
      args: [],
    );
  }

  /// `This place could not be found.`
  String get locationadddialogError {
    return Intl.message(
      'This place could not be found.',
      name: 'locationadddialogError',
      desc: '',
      args: [],
    );
  }

  /// `LIGHT`
  String get appliancesLight {
    return Intl.message(
      'LIGHT',
      name: 'appliancesLight',
      desc: '',
      args: [],
    );
  }

  /// `SOCKET`
  String get appliancesSocket {
    return Intl.message(
      'SOCKET',
      name: 'appliancesSocket',
      desc: '',
      args: [],
    );
  }

  /// `ROLLER SHUTTER`
  String get appliancesShutter {
    return Intl.message(
      'ROLLER SHUTTER',
      name: 'appliancesShutter',
      desc: '',
      args: [],
    );
  }

  /// `AIR CONDITIONER`
  String get appliancesAirConditioner {
    return Intl.message(
      'AIR CONDITIONER',
      name: 'appliancesAirConditioner',
      desc: '',
      args: [],
    );
  }

  /// `VIDEO DEVICES`
  String get appliancesVideoDevices {
    return Intl.message(
      'VIDEO DEVICES',
      name: 'appliancesVideoDevices',
      desc: '',
      args: [],
    );
  }

  /// `HEATING SYSTEM`
  String get appliancesHeatingSystem {
    return Intl.message(
      'HEATING SYSTEM',
      name: 'appliancesHeatingSystem',
      desc: '',
      args: [],
    );
  }

  /// `KITCHEN TOOLS`
  String get appliancesKitchenTools {
    return Intl.message(
      'KITCHEN TOOLS',
      name: 'appliancesKitchenTools',
      desc: '',
      args: [],
    );
  }

  /// `WASHING MACHINE`
  String get appliancesWashingMachine {
    return Intl.message(
      'WASHING MACHINE',
      name: 'appliancesWashingMachine',
      desc: '',
      args: [],
    );
  }

  /// `IRRIGATION`
  String get appliancesIrrigation {
    return Intl.message(
      'IRRIGATION',
      name: 'appliancesIrrigation',
      desc: '',
      args: [],
    );
  }

  /// `Energy Consumption`
  String get energystatisticsAxisLableY {
    return Intl.message(
      'Energy Consumption',
      name: 'energystatisticsAxisLableY',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get energystatisticsAxisLableX {
    return Intl.message(
      'Time',
      name: 'energystatisticsAxisLableX',
      desc: '',
      args: [],
    );
  }

  /// `Energy Consumption`
  String get energystatisticsAxisLableLine {
    return Intl.message(
      'Energy Consumption',
      name: 'energystatisticsAxisLableLine',
      desc: '',
      args: [],
    );
  }

  /// `No energy data found!`
  String get energystatisticsEmpty {
    return Intl.message(
      'No energy data found!',
      name: 'energystatisticsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get mon {
    return Intl.message(
      'Mon',
      name: 'mon',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get tue {
    return Intl.message(
      'Tue',
      name: 'tue',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get wed {
    return Intl.message(
      'Wed',
      name: 'wed',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get thu {
    return Intl.message(
      'Thu',
      name: 'thu',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get fri {
    return Intl.message(
      'Fri',
      name: 'fri',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get sat {
    return Intl.message(
      'Sat',
      name: 'sat',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sun {
    return Intl.message(
      'Sun',
      name: 'sun',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get unavailable {
    return Intl.message(
      'Unavailable',
      name: 'unavailable',
      desc: '',
      args: [],
    );
  }

  /// `speed`
  String get speed {
    return Intl.message(
      'speed',
      name: 'speed',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// ` changed state to `
  String get logbook {
    return Intl.message(
      ' changed state to ',
      name: 'logbook',
      desc: '',
      args: [],
    );
  }

  /// `No devices available`
  String get noDevicesAvailable {
    return Intl.message(
      'No devices available',
      name: 'noDevicesAvailable',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
