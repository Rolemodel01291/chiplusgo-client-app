import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/models/coupon_thumbnail.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:infishare_client/repo/main_repo.dart';
import './bloc.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  final MainRepo mainRepo;
  final Geolocator geolocator;
  final WifiBloc wifiBloc;

  MainPageBloc({
    this.wifiBloc,
    this.mainRepo,
    this.geolocator,
  });

  @override
  MainPageState get initialState => MainPageLoading();

  @override
  Stream<MainPageState> mapEventToState(
    MainPageEvent event,
  ) async* {
    if (event is FetchMainData) {
      yield* _mapFetchMainDataToState(event);
    }
  }

  Stream<MainPageState> _mapFetchMainDataToState(FetchMainData event) async* {
    yield MainPageLoading();
    Position location;
    try {
      location = Position(latitude: 40.730754, longitude: -73.997684);
      // location = await this
      //     .geolocator
      //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      if (location == null) {
        yield MainPageLocationRequire();
        return;
      }
    } catch (e) {
      yield MainPageLocationRequire();
      return;
    }
    try {
      final appBanner = await mainRepo.fetchAppBanner();
      List<CouponTicket> reoders = [];
      List<String> couponName = [];
      try {
        final reorderDocs = await mainRepo.fetchRecentOrder();

        reorderDocs.forEach((doc) {
          final ticket = CouponTicket.fromJson(doc.data);
          if (!couponName.contains(ticket.name)) {
            if (reoders.length < 5) {
              couponName.add(ticket.name);
              reoders.add(ticket);
            } else {
              return;
            }
          }
        });
      } catch (e) {
        if (!e.toString().contains('login')) {
          yield MainPageError(
            errorMsg: e.toString(),
          );
          return;
        }
      }

      // final bestSale = await mainRepo.fetchBestSell();
      // final mostDis = await mainRepo.fetchMostDiscount();
      // final newest = await mainRepo.fetchNewCoupon();
      // final recmdBusiness = await mainRepo.fetchRecommend();
      // final newBusiness = await mainRepo.fetchNewBusiness();
      // final hotBusiness = await mainRepo.fetchHottest();
      // final nearby = await mainRepo.fetchNearBy(
      //   location: '${location.latitude}, ${location.longitude}',
      //   radius: 1500,
      // );
      // final categorys = await mainRepo.fetchRestaurantCate();

      // recmdBusiness.forEach((business) {
      //   business.calculateDistance(location.latitude, location.longitude);
      // });
      // newBusiness.forEach((business) {
      //   business.calculateDistance(location.latitude, location.longitude);
      // });
      // hotBusiness.forEach((business) {
      //   business.calculateDistance(location.latitude, location.longitude);
      // });
      // nearby.forEach((business) {
      //   business.calculateDistance(location.latitude, location.longitude);
      // });

      List<CouponThumbnail> discounts = [];
      // List<String> ids = [];
      // mostDis.forEach((thumbnail) {
      //   if (!ids.contains(thumbnail.businessId)) {
      //     if (discounts.length < 10) {
      //       discounts.add(thumbnail);
      //       ids.add(thumbnail.businessId);
      //     } else {
      //       return;
      //     }
      //   }
      // });

      yield BaseMainPageState(
        appBanner,
        reoders,
        // bestSale,
        discounts,
        // newest,
        // recmdBusiness,
        // newBusiness,
        // hotBusiness,
        // nearby,
        // categorys,
      );
    } catch (e) {
      print(e.toString());
      yield MainPageError(
        errorMsg: e.toString(),
      );
    }
  }
}
