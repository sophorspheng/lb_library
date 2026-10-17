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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Readora`
  String get hometitle {
    return Intl.message('Readora', name: 'hometitle', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Choose Language`
  String get chooseLanguage {
    return Intl.message(
      'Choose Language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Books`
  String get books {
    return Intl.message('Books', name: 'books', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Explore Categories`
  String get exploreCategories {
    return Intl.message(
      'Explore Categories',
      name: 'exploreCategories',
      desc: '',
      args: [],
    );
  }

  /// `Featured Books`
  String get featuredBooks {
    return Intl.message(
      'Featured Books',
      name: 'featuredBooks',
      desc: '',
      args: [],
    );
  }

  /// `Popular Books`
  String get popularBooks {
    return Intl.message(
      'Popular Books',
      name: 'popularBooks',
      desc: '',
      args: [],
    );
  }

  /// `Discover your next favorite book`
  String get discoverBooks {
    return Intl.message(
      'Discover your next favorite book',
      name: 'discoverBooks',
      desc: '',
      args: [],
    );
  }

  /// `Search books, authors...`
  String get searchBooksAuthors {
    return Intl.message(
      'Search books, authors...',
      name: 'searchBooksAuthors',
      desc: '',
      args: [],
    );
  }

  /// `Filter books`
  String get filterBooks {
    return Intl.message(
      'Filter books',
      name: 'filterBooks',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get seeAll {
    return Intl.message('See all', name: 'seeAll', desc: '', args: []);
  }

  /// `Continue Reading`
  String get continueReading {
    return Intl.message(
      'Continue Reading',
      name: 'continueReading',
      desc: '',
      args: [],
    );
  }

  /// `Continue your reading journey today.`
  String get continueReadingJourney {
    return Intl.message(
      'Continue your reading journey today.',
      name: 'continueReadingJourney',
      desc: '',
      args: [],
    );
  }

  /// `Fiction`
  String get fiction {
    return Intl.message('Fiction', name: 'fiction', desc: '', args: []);
  }

  /// `Education`
  String get education {
    return Intl.message('Education', name: 'education', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Science`
  String get science {
    return Intl.message('Science', name: 'science', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'km'),
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
