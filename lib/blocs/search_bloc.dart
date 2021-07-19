import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/models/search_suggestions.dart';
import 'package:infishare_client/repo/repo.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';

abstract class SearchEvent extends Equatable {
  SearchEvent([List props = const []]);
}

abstract class SearchState extends Equatable {
  SearchState([List props = const []]);
}

class SearchKeyWord extends SearchEvent {
  final String query;

  SearchKeyWord({@required this.query});

  @override
  String toString() => 'Search key word $query';

  @override
  List<Object> get props => [query];
}

class SearchTextChanged extends SearchEvent {
  final String query;
  SearchTextChanged({@required this.query});

  @override
  String toString() => 'Search word changed $query';

  @override
  List<Object> get props => [query];
}

class FetchSearchRecommed extends SearchEvent {
  @override
  String toString() => 'Fetch search recommed';

  @override
  List<Object> get props => ["Fertch search recommed"];
}

class Searching extends SearchState {
  @override
  String toString() => 'Searching';

  @override
  List<Object> get props => ["searching"];
}

//* search state*/

class ShowSearchRecommed extends SearchState {
  final SearchSuggestions whatsNew;

  ShowSearchRecommed({this.whatsNew});

  @override
  String toString() => 'Show whats new';

  @override
  List<Object> get props => [whatsNew];
}

class LocationPermissionError extends SearchState {
  @override
  String toString() => 'Location permission denid.';

  @override
  List<Object> get props => ['Location permission denid'];
}

class SearchError extends SearchState {
  @override
  String toString() => 'Search error';

  @override
  List<Object> get props => ['Search error'];
}

class ShowSearchResult extends SearchState {
  final List<Business> business;
  final List<CouponThumbnail> coupons;

  ShowSearchResult({this.business = const [], this.coupons = const []});

  @override
  String toString() => 'Show Search result';

  @override
  List<Object> get props => [business, coupons];
}

class ShowSearchSuggestion extends SearchState {
  final List<String> suggestions;

  ShowSearchSuggestion({this.suggestions});

  @override
  String toString() => 'Show search suggestions $suggestions';

  @override
  List<Object> get props => [suggestions];
}

class SearchInit extends SearchState {
  @override
  String toString() => 'SearchInit';

  @override
  List<Object> get props => ['SearchInit'];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<String> searchRecommed = [];
  final BusinessRepository businessRepository;
  final Geolocator geolocator;

  SearchBloc({this.businessRepository, this.geolocator});

  @override
  SearchState get initialState => SearchInit();

  @override
  Stream<SearchState> transformEvents(Stream<SearchEvent> events, Stream<SearchState> Function(SearchEvent event) next) {
    final observableStream = events;
    final nonDebounceStream =
        observableStream.where((event) => event is! SearchTextChanged);
    final debounceStream = observableStream
        .where((event) => event is SearchTextChanged)
        .debounceTime(const Duration(milliseconds: 300));
    return super.transformEvents(Rx.merge([nonDebounceStream, debounceStream]), next);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchKeyWord) {
      yield* _mapSearchKeyWordToState(event);
    } else if (event is FetchSearchRecommed) {
      yield* _mapFetchRecommedToState(event);
    } else if (event is SearchTextChanged) {
      yield* _mapSearchTextChange(event);
    }
  }

  Stream<SearchState> _mapSearchTextChange(SearchTextChanged event) async* {
    if (event.query.isEmpty) {
      add(FetchSearchRecommed());
    } else {
      try {
        final List<String> suggestions =
            await this.businessRepository.getSearchSuggestions(event.query);
        yield ShowSearchSuggestion(suggestions: suggestions);
      } catch (e) {
        yield SearchError();
      }
    }
  }

  Stream<SearchState> _mapSearchKeyWordToState(SearchKeyWord event) async* {
    yield Searching();
    try {
      final businesses = await this
          .businessRepository
          .fetchBusiness(queryWord: event.query, hitsPerPage: 50);
      final couponThumbnails =
          await this.businessRepository.getCouponThumbnail(query: event.query);
      final location = await this
          .geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      if (location != null) {
        businesses.forEach((business) {
          business.calculateDistance(location.latitude, location.longitude);
        });
      }
      yield ShowSearchResult(business: businesses, coupons: couponThumbnails);
    } on Exception catch (e) {
      print(e);
      if (e is PlatformException) {
        yield LocationPermissionError();
      } else {
        yield SearchError();
      }
    }
  }

  Stream<SearchState> _mapFetchRecommedToState(
      FetchSearchRecommed event) async* {
    if (searchRecommed.isEmpty) {
      try {
        final recommend = await this.businessRepository.fetchSearchRecommed();
        yield ShowSearchRecommed(whatsNew: recommend);
      } catch (e) {
        yield SearchError();
      }
    }
    
  }
}
