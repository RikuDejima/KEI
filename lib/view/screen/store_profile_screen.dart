import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/state/common/store_state.dart';
import 'package:key/logic/view_controller/store_profile_view_controller.dart';
import 'package:key/view/util/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StoreProfileScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = AppColor.textColor;
    final storeData = ref.watch(storeDataState);
    final viewController = ref.read(storeProfileViewController);
    final imageUrls = ref.watch(storeImageUrlsState);

    useEffect(() {
      viewController.initState();
    }, []);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageUrls.isEmpty
            ? Container(
                color: Color(0xFFD8D8D8),
                height: screenWidth * 0.53,
                width: double.infinity,
              )
            : Container(
                color: Color(0xFFD8D8D8),
                height: screenWidth * 0.53,
                width: double.infinity,
                child: Image.network(
                  ref.watch(storeImageUrlsState)[0],
                  fit: BoxFit.cover,
                  // errorBuilder: (context, error, stackTrace) {
                  //   return Container(
                  //     color: Color(0xFFD8D8D8),
                  //     height: screenWidth * 0.53,
                  //     width: double.infinity,
                  //     child: const Text(
                  //       '',
                  //       style: TextStyle(fontSize: 30),
                  //     ),
                  //   );
                  // },
                ),
              ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    storeData!.storeName,
                    style: TextStyle(
                      fontSize: 20,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFB7B7B7),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: AppColor.accentColor,
                      foregroundColor: Colors.white,
                      radius: 17,
                      child: IconButton(
                        onPressed: () {
                          launchUrlString(storeData.location);
                        },
                        icon: Icon(Icons.location_on),
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                  )
                ],
              ),
              Text(
                storeData.introduce ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () =>
                      routemaster.push(AppRoute.editStoreProfile.path),
                  child: Text(
                    'プロフィールを編集する',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.zero,
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(AppColor.textColor),
                    alignment: Alignment.center,
                    minimumSize: MaterialStateProperty.all(Size.fromHeight(25)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Column(children: [
                  storeData.advertisementImage == null
                      ? Container(
                          color: Color(0xFFD8D8D8),
                          height: screenWidth * 0.53,
                          width: double.infinity,
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.all(5),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColor.accentColor),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                            child: const Text(
                              '宣伝する',
                              style: TextStyle(
                                color: AppColor.textColor,
                              ),
                            ),
                            onPressed: () {
                              ref.read(routeController).push(AppRoute.editAdvertisement);
                            },
                          ),
                        )
                      : Image.network(
                          storeData.advertisementImage!,
                          fit: BoxFit.cover,
                        )
                ]),
              ),
            ],
          ),
        )
      ],
    );
  }
}
