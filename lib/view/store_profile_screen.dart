import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/state/common/store_state.dart';
import 'package:key/view/util/theme.dart';

class StoreProfileScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = AppColor.textColor;
    final storeData = ref.watch(storeDataState);
    // final storageRef = FirebaseSt
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // storeData?.topImage ? 
            Container(
              color: Color(0xFFD8D8D8),
              width: double.infinity,
              height: screenWidth * 0.53,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add_photo_alternate_outlined),
                  iconSize: 60,
                  onPressed: () =>
                      print(' ${ref.read(storeDataState)?.toJson()}'),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeData?.storeName ?? '店舗名が設定されていません',
                    style: TextStyle(
                      fontSize: 20,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    storeData?.introduce ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => print('go to the edit profile page'),
                      child: Text('プロフィールを編集する', style: TextStyle(color: Colors.white),),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.zero,
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(AppColor.textColor),
                        alignment: Alignment.center,
                        minimumSize:
                            MaterialStateProperty.all(Size.fromHeight(25)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
