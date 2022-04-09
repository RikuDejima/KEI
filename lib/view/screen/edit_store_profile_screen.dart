import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/state/common/store_state.dart';
import 'package:key/logic/view_controller/user_profile_view_controller.dart';
import 'package:key/view/util/theme.dart';

class EditStoreProfileScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final storeData = ref.watch(storeDataState);
    final viewController = ref.read(editProfileViewController);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // storeData?.topImage ?
          Container(
            color: Color(0xFFD8D8D8),
            width: double.infinity,
            height: screenWidth * 0.53,
            child: IconButton(
              alignment: Alignment.bottomRight,
              icon: Icon(Icons.add_photo_alternate_outlined),
              iconSize: 40,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  '写真を撮る',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(height: 0, color: AppColor.dividerColor),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'ライブラリから選ぶ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(height: 0, color: AppColor.dividerColor),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'キャンセル',
                                  style: TextStyle(color: Colors.red),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
          Text('名前'),
          TextField(
            onChanged: (str) => ref.read(userNameState.notifier).state = str,
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () async {
                await viewController.save();
                Navigator.pop(context);
              },
              child: Text(
                '保存',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 7),
                ),
                fixedSize: MaterialStateProperty.all(Size.infinite),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF3B2508)),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                ),
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
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  storeData?.introduce ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.textColor,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => print('go to the edit profile page'),
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
      ),
    );
  }
}
