class AlgoliaConsts {
  /// algolia filters consts
  static const String LABEL_FILTER_PREFIX = 'Labels.';
  static const String TYPE_FILTER_PREFIX = 'Type.';
  static const String CATEGORY_FILTER_PREFIX = 'Categories:';
  static const String PRICE_FILTER_PREFIX = 'Price=';
  static const String AND_OPERATOR = ' AND ';
  static const String OR_OPERATOR = ' OR ';
  static const String ISACTIVE_FILTER = 'IsActive=1';

  /// algolia sort type const
  /// restaurants, restaurants_rating_desc, restaurants_price_asc, restaurants_price_desc
  static const String RESTAURANT_INDEX = "restaurants";
  static const String RESTAURANT_COUPON_INDEX = "restaurants_coupons";
  static const String RESTAURANT_RATING_DESC = 'restaurants_rating_desc';
  static const String RESTAURANT_PRICE_ASC = 'restaurants_price_asc';
  static const String RESTAURANT_PRICE_DESC = 'restaurants_price_desc';
  static const String RESTAURANT_DISTANCE = 'restaurant_distance';
  static const String RESTAURANT_REVIEWCNT = 'restaurants_reviewcnt';
  

  /// algolia test sever sort type
  static const String TEST_RESTAURANT_INDEX = "test_restaurants";
  static const String TEST_RESTAURANT_COUPON_INDEX = "test_restaurants_coupons";
  static const String TEST_RESTAURANT_RATING_DESC =
      'test_restaurants_rating_desc';
  static const String TEST_RESTAURANT_PRICE_ASC = 'test_restaurants_price_asc';
  static const String TEST_RESTAURANT_PRICE_DESC =
      'test_restaurants_price_desc';

  /// algolia coupon sort type
  static const String COOUPON_INDEX = 'coupons';
  static const String COUPON_ADD_INDEX = 'coupons_added';
  static const String COUPON_DISCOUNT_INDEX = 'coupons_discount';
  static const String COUPON_SOLD_INDEX = 'coupons_soldcnt';
  
  /// algolia item index
  static const String TEST_ITEM = 'test_items';
  static const String INGREDIENTS = 'Ingredients:';
}
