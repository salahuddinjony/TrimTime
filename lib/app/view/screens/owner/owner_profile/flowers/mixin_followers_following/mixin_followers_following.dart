import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_selon_management.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/flowers/model/followers_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/following/model/following_model.dart';
import 'package:get/get.dart';

mixin MixinFollowersFollowing on MixinSelonManagement{
  RxList<Follower> followersList = RxList<Follower>([]);
  RxList<Following> followingList = RxList<Following>([]);
  Rx<RxStatus> followersStatus = Rx<RxStatus>(RxStatus.empty());
  Rx<RxStatus> followingStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchFollowerOrFollowingData({required bool isFollowers, bool needLoader=true}) async {
    try {
      if(needLoader){
        if (isFollowers) {
          followersStatus.value = RxStatus.loading();
        } else {
          followingStatus.value = RxStatus.loading();
        }
      }
      final url = isFollowers
          ? ApiUrl.fetchUserData(filter: 'followers')
          : ApiUrl.fetchUserData(filter: 'following');
      final response = await ApiClient.getData(url);
      if (response.statusCode == 200) {
        final data = response.body;

        if (isFollowers) {
          followersList.value = FollowersResponse.fromJson(data).data;
          followersStatus.value = RxStatus.success();
        } else {
          followingList.value = FollowingResponse.fromJson(data).data;
          followingStatus.value = RxStatus.success();
        }
      } else {
        final errorMessage = response.body['message'] ?? 'Failed to load data';
        if (isFollowers) {
          followersStatus.value = RxStatus.error(errorMessage);
        } else {
          followingStatus.value = RxStatus.error(errorMessage);
        }
      }
    } catch (e) {
      followersStatus.value = RxStatus.error(e.toString());
      followingStatus.value = RxStatus.error(e.toString());
    } finally {}
  }

  
}
