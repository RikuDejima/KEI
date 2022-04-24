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
                    decoration: BoxDecoration(),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFE2BF62),
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
              )
            ],
          ),
        )
      ],
    );
  }
}
