import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/models/business.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/payment_repo.dart';
import 'package:infishare_client/repo/repo.dart';
import 'package:infishare_client/screens/businesslist/restaurants_route.dart';
import 'package:infishare_client/screens/auth/terms.dart';
import 'package:infishare_client/screens/checkoutPage/check_out_success.dart';
import 'package:infishare_client/screens/commen_widgets/image_page_view.dart';
import 'package:infishare_client/screens/myaccount/my_account_profile_route.dart';
import 'package:infishare_client/screens/screens.dart';
import 'package:http/http.dart' as http;
import 'package:infishare_client/screens/usecouponscreen/gift_success_route.dart';
import 'package:infishare_client/screens/usecouponscreen/success_route.dart';
import 'dart:developer';
import 'blocs/business_map_bloc.dart';
import 'screens/commen_widgets/fade_transition_route.dart';
import 'screens/commen_widgets/utils.dart';

class RouteGenerator {
  InfiShareApiClient infiShareApiClient;

  RouteGenerator({this.infiShareApiClient});

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //* MAIN PAGE
      //*
      //*
      case '/':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider<SplashBloc>(
                create: (context) => SplashBloc(
                  client: infiShareApiClient,
                )..add(
                    CheckAppVersion(),
                  ),
                child: SplashScreen(),
              );
            });
        break;
      case '/home':
        return SizeRoute(
            settings: settings,
            page: MultiBlocProvider(
              providers: [
                BlocProvider<MyAcountBloc>(
                  create: (context) {
                    return MyAcountBloc(
                      authBloc: BlocProvider.of<AuthBloc>(context),
                      paymentRepository: PaymentRepository(
                        infiShareApiClient: infiShareApiClient,
                      ),
                      userRepository:
                          BlocProvider.of<AuthBloc>(context).userRepository,
                    );
                  },
                ),
                BlocProvider<MainPageBloc>(
                  create: (context) {
                    return MainPageBloc(
                      wifiBloc: BlocProvider.of<WifiBloc>(context),
                      mainRepo: MainRepo(
                        infiShareApiClient: infiShareApiClient,
                      ),
                      geolocator: Geolocator(),
                    )..add(
                        FetchMainData(),
                      );
                  },
                )
              ],
              child: TabScreen(),
            ));
        break;
      //* END OF MAIN PAGE
      case '/onboarding':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return OnBoardingRoute();
            });
      case '/auth':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BlocProvider.value(
              value: BlocProvider.of<AuthBloc>(context),
              child: AuthScreen(),
            );
          },
        );
        break;
      //* PHONE AUTH
      case '/phoneauth':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BlocProvider.value(
              value: BlocProvider.of<AuthBloc>(context),
              child: AuthPhoneScreen(),
            );
          },
        );
        break;
      case '/image_page_view':
        final images = (settings.arguments as Map<String, dynamic>)['image']
            as List<String>;
        final index =
            (settings.arguments as Map<String, dynamic>)['index'] as int;
        return FadeInRoute(
            settings: settings,
            builder: (context) {
              return ImagePageView(
                images: images,
                index: index,
              );
            });
        break;
      //*HOME DISCOVER
      case '/home_discover':
        final categorys = (settings.arguments
            as Map<String, dynamic>)['categorys'] as List<String>;
        final prefix =
            (settings.arguments as Map<String, dynamic>)['prefix'] as String;
        final title =
            (settings.arguments as Map<String, dynamic>)['title'] as String;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider(
                create: (context) => BusinessMapBloc(
                  categorys: categorys,
                  prefixFilter: prefix,
                  location: Geolocator(),
                  businessRepository: BusinessRepository(
                    apiClient: infiShareApiClient,
                  ),
                )..add(
                    FetchBusiness(),
                  ),
                child: BusinessListScreen(
                  title: title,
                  restaurantCategory: categorys,
                ),
              );
            });
      //*
      //*

      //*SINGLE COUPON
      case '/single_coupon':
        final couponId =
            (settings.arguments as Map<String, dynamic>)['CouponId'] as String;
        final businessId =
            (settings.arguments as Map<String, dynamic>)['BusinessId'];

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<MyAcountBloc>(
                  create: (context) {
                    return MyAcountBloc(
                      authBloc: BlocProvider.of<AuthBloc>(context),
                      paymentRepository: PaymentRepository(
                        infiShareApiClient: infiShareApiClient,
                      ),
                      userRepository:
                          BlocProvider.of<AuthBloc>(context).userRepository,
                    );
                  },
                ),
                BlocProvider<SingleCouponDetailBloc>(
                  create: (context) {
                    return SingleCouponDetailBloc(
                      repository: BusinessRepository(
                        apiClient: infiShareApiClient,
                      ),
                      couponId: couponId,
                      businessId: businessId[0],
                    )..add(
                        FetchCouponAndBusiness(),
                      );
                  },
                ),
              ],
              child: SingleCouponPage(),
            );
            // return BlocProvider<SingleCouponDetailBloc>(
            //   create: (context) {
            //     return SingleCouponDetailBloc(
            //       repository: BusinessRepository(
            //         apiClient: infiShareApiClient,
            //       ),
            //       couponId: couponId,
            //       businessId: businessId,
            //     )..add(
            //         FetchCouponAndBusiness(),
            //       );
            //   },
            //   child: SingleCouponPage(),
            // );
          },
        );
        break;
      case '/coupon_detail':
        final business = (settings.arguments
            as Map<String, dynamic>)['business'] as Business;
        final coupon = (settings.arguments as Map<String, dynamic>)['coupon']
            as List<Coupon>;
        final selectedIndex =
            (settings.arguments as Map<String, dynamic>)['index'] as int;
        final title =
            (settings.arguments as Map<String, dynamic>)['title'] as String;
        return SizeRoute(
            settings: settings,
            page: MultiBlocProvider(
              providers: [
                BlocProvider<MyAcountBloc>(
                  create: (context) {
                    return MyAcountBloc(
                      authBloc: BlocProvider.of<AuthBloc>(context),
                      paymentRepository: PaymentRepository(
                        infiShareApiClient: infiShareApiClient,
                      ),
                      userRepository:
                          BlocProvider.of<AuthBloc>(context).userRepository,
                    );
                  },
                ),
              ],
              child: CouponDetailsRoute(
                business: business,
                coupons: coupon,
                selectIndex: selectedIndex,
                title: title,
              ),
            ));
        // return SizeRoute(
        //     settings: settings,
        //     page: MultiBlocProvider(
        //       providers: [
        //         BlocProvider<MyAcountBloc>(
        //           create: (context) {
        //             return MyAcountBloc(
        //               authBloc: BlocProvider.of<AuthBloc>(context),
        //               paymentRepository: PaymentRepository(
        //                 infiShareApiClient: infiShareApiClient,
        //               ),
        //               userRepository:
        //                   BlocProvider.of<AuthBloc>(context).userRepository,
        //             );
        //           },
        //         ),
        //         BlocProvider<MainPageBloc>(
        //           create: (context) {
        //             return MainPageBloc(
        //               wifiBloc: BlocProvider.of<WifiBloc>(context),
        //               mainRepo: MainRepo(
        //                 infiShareApiClient: infiShareApiClient,
        //               ),
        //               geolocator: Geolocator(),
        //             )..add(
        //                 FetchMainData(),
        //               );
        //           },
        //         )
        //       ],
        //       child: TabScreen(),
        //     ));

        break;
      //*
      //*
      case '/business/id':
        final businessId = (settings.arguments
            as Map<String, dynamic>)['businessId'] as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) => MultiBlocProvider(
            providers: [
              BlocProvider<BusinessDetailBloc>(
                create: (context) => BusinessDetailBloc(
                  businessRepository: BusinessRepository(
                    apiClient: infiShareApiClient,
                  ),
                )..add(
                    FetchCouponAndNearby(
                      businessId: businessId,
                    ),
                  ),
              ),
            ],
            child: BusinessDetailScreen(),
          ),
        );
        break;
      case '/business':
        final business = settings.arguments as Business;
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) => MultiBlocProvider(
            providers: [
              BlocProvider<BusinessDetailBloc>(
                create: (context) => BusinessDetailBloc(
                  businessRepository: BusinessRepository(
                    apiClient: infiShareApiClient,
                  ),
                )..add(
                    FetchCouponAndNearby(
                      businessId: business.businessId,
                    ),
                  ),
              ),
            ],
            child: BusinessDetailScreen(),
          ),
        );
        break;
      case '/check_out':
        final business = (settings.arguments
            as Map<String, dynamic>)['business'] as Business;
        final coupon =
            (settings.arguments as Map<String, dynamic>)['coupon'] as Coupon;
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider<CheckOutBloc>(
                create: (context) => CheckOutBloc(
                  paymentRepository: PaymentRepository(),
                  coupon: coupon,
                )..add(
                    InitData(),
                  ),
                child: CheckoutScreen(
                  coupon: coupon,
                  business: business,
                ),
              );
            });
        break;
      case '/check_out_success':
        final receipt = (settings.arguments as Map<String, String>)['receipt'];
        final type = (settings.arguments as Map<String, String>)['type'];

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return CheckOutSuccessScreen(
              receipNum: receipt,
              type: type,
            );
          },
        );
        break;
      case '/change_profile':
        final name = (settings.arguments as Map<String, String>)['name'];
        final email = (settings.arguments as Map<String, String>)['email'];
        final avatar = (settings.arguments as Map<String, String>)['avatar'];
        final phone = (settings.arguments as Map<String, String>)['phoneNum'];
        final addressLine1 =
            (settings.arguments as Map<String, String>)['addressLine1'];
        final addressLine2 =
            (settings.arguments as Map<String, String>)['addressLine2'];
        final city = (settings.arguments as Map<String, String>)['city'];
        final signupType =
            (settings.arguments as Map<String, String>)['signupType'];
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider(
                create: (context) {
                  return UserProfileBloc(
                    infiShareApiClient: infiShareApiClient,
                  )..add(
                      LoadUserProfile(
                        email: email,
                        imageUrl: avatar,
                        userName: name,
                      ),
                    );
                },
                child: MyAccountProfileRoute(
                    username: name,
                    email: email,
                    phoneNum: phone,
                    imageUrl: avatar,
                    addressLine1: addressLine1,
                    addressLine2: addressLine2,
                    city: city,
                    signupType: signupType),
              );
            });
      case '/redeem_success':
        final orderNum = (settings.arguments as String);
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return SuccessRoute(
              orderNumber: orderNum,
            );
          },
        );
        break;
      case '/gift_success':
        final orderNum = (settings.arguments as String);
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return GiftSuccessRoute(
              orderNumber: orderNum,
            );
          },
        );
        break;
      case '/terms':
        final orderNum = (settings.arguments as String);
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return TermsScreen();
          },
        );
        break;
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
