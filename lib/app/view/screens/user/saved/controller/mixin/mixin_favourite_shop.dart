import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/user/saved/models/favourite_shop_model.dart';
import 'package:get/get.dart';

mixin FavoriteShopMixin {
  RxList<FavouriteShopModel> favoriteShops = RxList<FavouriteShopModel>([]);
  Rx<RxStatus> favoriteShopsStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchFavoriteShops() async {
    favoriteShopsStatus.value = RxStatus.loading();
    try {
      final Map<String, dynamic> query = {
        'limit': '100',
      };
      final response =
          await ApiClient.getData(ApiUrl.getFavouriteShops, query: query);

      if (response.statusCode == 200) {
        final favouriteShopResponse =
            FavouriteShopResponse.fromJson(response.body);
        favoriteShops.value = favouriteShopResponse.data;
        favoriteShopsStatus.value = RxStatus.success();
      } else {
        favoriteShopsStatus.value =
            RxStatus.error('Failed to load favorite shops');
        throw Exception('Failed to load favorite shops');
      }

      favoriteShopsStatus.value = RxStatus.success();
    } catch (e) {
      favoriteShopsStatus.value =
          RxStatus.error('Failed to fetch favorite shops');
    }
  }
}
