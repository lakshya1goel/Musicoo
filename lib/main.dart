import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:musicoo/AuthViews/AuthView.dart';
import 'package:musicoo/AuthViews/Login.dart';
import 'package:musicoo/AuthViews/Register.dart';
import 'package:musicoo/AuthViews/Verification.dart';
import 'package:musicoo/AuthViews/addArtist.dart';
import 'package:musicoo/AuthViews/addArtist2/addArtist2.dart';
import 'package:musicoo/AuthViews/forgotpassword.dart';
import 'package:musicoo/InitialPages/Splash.dart';
import 'package:musicoo/MainViews/dashboard.dart';
import 'package:musicoo/desgins.dart';
import 'package:musicoo/providers.dart';

void main() async {
  // Initialize the Branch object
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      routes: [
        GoRoute(
          path: 'Auth',
          routes: [
            GoRoute(
                path: 'login',
                builder: (context, state) => LoginView(),
                routes: [
                  GoRoute(
                    path: 'forgot',
                    builder: (context, state) => ForgotPassword(),
                  ),
                ]),
            GoRoute(
                path: 'register',
                builder: (context, state) => RegisterView(),
                routes: [
                  GoRoute(
                    path: 'verify',
                    builder: (context, state) => VerificationPage(),
                  ),
                ]),
          ],
          builder: (context, state) => AuthView(),
        ),
      ],
      builder: (context, state) => MyHomePage(),
    ),
    GoRoute(path: '/home', builder: ((context, state) => Addartist())),
    GoRoute(path: '/addartists2', builder: ((context, state) => Addartist2()))
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Musicoo',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.light().copyWith(primary: mainColor),
      ),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key});
  BranchContentMetaData metadata = BranchContentMetaData();
  BranchUniversalObject? buo;
  BranchLinkProperties lp = BranchLinkProperties();
  BranchEvent? eventStandart;
  BranchEvent? eventCustom;

  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  void listenDynamicLinks(ref) async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      controllerData.sink.add((data.toString()));

      if (data['0'] == 'verified') {
        ref.watch(verified.notifier).state = true;
      }
    }, onError: (error) {
      print('InitSesseion error: ${error.toString()}');
    });
  }

  void initDeepLinkData() {
    metadata = BranchContentMetaData()
      ..addCustomMetadata('custom_string', 'abcd')
      ..addCustomMetadata('custom_number', 12345)
      ..addCustomMetadata('custom_bool', true)
      ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
      ..addCustomMetadata('custom_list_string', ['a', 'b', 'c'])
      //--optional Custom Metadata
      ..contentSchema = BranchContentSchema.COMMERCE_PRODUCT
      ..price = 50.99
      ..currencyType = BranchCurrencyType.BRL
      ..quantity = 50
      ..sku = 'sku'
      ..productName = 'productName'
      ..productBrand = 'productBrand'
      ..productCategory = BranchProductCategory.ELECTRONICS
      ..productVariant = 'productVariant'
      ..condition = BranchCondition.NEW
      ..rating = 100
      ..ratingAverage = 50
      ..ratingMax = 100
      ..ratingCount = 2
      ..setAddress(
          street: 'street',
          city: 'city',
          region: 'ES',
          country: 'Brazil',
          postalCode: '99999-987')
      ..setLocation(31.4521685, -114.7352207);

    buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        //parameter canonicalUrl
        //If your content lives both on the web and in the app, make sure you set its canonical URL
        // (i.e. the URL of this piece of content on the web) when building any BUO.
        // By doing so, we’ll attribute clicks on the links that you generate back to their original web page,
        // even if the user goes to the app instead of your website! This will help your SEO efforts.
        canonicalUrl: 'https://flutter.dev',
        title: 'Flutter Branch Plugin',
        contentDescription: 'Flutter Branch Description',
        /*
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('custom_string', 'abc')
          ..addCustomMetadata('custom_number', 12345)
          ..addCustomMetadata('custom_bool', true)
          ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
          ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
         */
        contentMetadata: metadata,
        keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        expirationDateInMilliSec: DateTime.now()
            .add(const Duration(days: 365))
            .millisecondsSinceEpoch);

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        //parameter alias
        //Instead of our standard encoded short url, you can specify the vanity alias.
        // For example, instead of a random string of characters/integers, you can set the vanity alias as *.app.link/devonaustin.
        // Aliases are enforced to be unique** and immutable per domain, and per link - they cannot be reused unless deleted.
        //alias: 'https://branch.io' //define link url,
        stage: 'new share',
        campaign: 'campaign',
        tags: ['one', 'two', 'three'])
      ..addControlParam('\$uri_redirect_mode', '1')
      ..addControlParam('\$ios_nativelink', true)
      ..addControlParam('\$match_duration', 7200)
      ..addControlParam('\$always_deeplink', true)
      ..addControlParam('\$android_redirect_timeout', 750)
      ..addControlParam('referring_user_id', 'user_id');

    eventStandart = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART)
      //--optional Event data
      ..transactionID = '12344555'
      ..currency = BranchCurrencyType.BRL
      ..revenue = 1.5
      ..shipping = 10.2
      ..tax = 12.3
      ..coupon = 'test_coupon'
      ..affiliation = 'test_affiliation'
      ..eventDescription = 'Event_description'
      ..searchQuery = 'item 123'
      ..adType = BranchEventAdType.BANNER
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');

    eventCustom = BranchEvent.customEvent('Custom_event')
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  }

  @override
  Widget build(BuildContext context, ref) {
    initDeepLinkData();
    listenDynamicLinks(ref);
    ref.listen(login, (previous, next) {
      if (next.value == "Success") {
        context.go('/home');
      }
    });
    ref.listen(verified, (previous, next) {
      if (next == true) {
        log('here');
        ref.watch(email.notifier).state = ref.watch(emailstate);
        ref.watch(password.notifier).state = ref.watch(passwordstate);
        ref.watch(loader.notifier).state = true;
        ref.refresh(login);
      }
    });
    final token = ref.watch(token_provider);
    return token.when(data: (data) {
      return  Addartist();
    }, error: ((error, stackTrace) {
      // context.go('/Auth');
      return const AuthView();
      // return null;
    }), loading: () {
      return const SplashScreen();
    });
  }
}
