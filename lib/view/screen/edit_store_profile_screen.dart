import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/repository/store_repository.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/store_state.dart';
import 'package:key/logic/view_controller/edit_store_profile_view_controller.dart';
import 'package:key/logic/view_controller/user_profile_view_controller.dart';
import 'package:key/view/util/theme.dart';

class EditStoreProfileScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final storeData = ref.watch(storeDataState);
    final viewController = ref.read(editStoreProfileViewController);
    final storageRef = ref.read(storeRepository).storageRef;
    // final storeStorageRef = ref.watch(storeRepository).

    useEffect(() {
      Future.microtask(() {
        print('called useEffect');
        viewController.initState();
      });
    }, []);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              showGeneralDialog(
                context: context,
                barrierDismissible: false,
                transitionDuration: Duration(milliseconds: 300),
                barrierColor: Colors.black.withOpacity(0.5),
                pageBuilder: (BuildContext context, Animation animation,
                    Animation secondaryAnimation) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                // routeSettings: RouteSettings(name: AppRoute.home.path),
              );
              await viewController.save().then((value) {
                Navigator.of(context, rootNavigator: true)
                  ..pop()
                  ..pop();
              });
            },
            child: Text(
              '保存',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ref.watch(editStoreImages).isEmpty
                  ? Container(
                      color: Color(0xFFD8D8D8),
                      width: double.infinity,
                      height: screenWidth * 0.53,
                      child: IconButton(
                        icon: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                        iconSize: 40,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return choosePhotoOption(
                                  context: context,
                                  viewController: viewController);
                            },
                          );
                        },
                      ))
                  : Container(
                      color: Color(0xFFD8D8D8),
                      width: double.infinity,
                      height: screenWidth * 0.53,
                      // storeData!.Images?[0] == null ?
                      child: ref.watch(editStoreImages)[0].getImage()!,
                    ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('店名'),
                    TextField(
                      onChanged: (str) => ref
                          .read(editStoreProfileItemsState.notifier)
                          .state['storeName'] = str,
                      maxLength: 120,
                      controller:
                          TextEditingController(text: storeData?.storeName),
                    ),
                    SizedBox(height: 30),
                    Text('店舗紹介'),
                    TextField(
                      onChanged: (str) {
                        ref
                            .read(editStoreProfileItemsState.notifier)
                            .state['introduce'] = str;
                      },
                      maxLength: 120,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller:
                          TextEditingController(text: storeData?.introduce),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget choosePhotoOption(
    {required BuildContext context,
    required EditStoreProfileViewController viewController}) {
  return SizedBox(
    height: 200,
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => viewController.takePicture(),
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
            onPressed: () => viewController.chooseImage(isTop: true),
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
            onPressed: () => Navigator.of(context).pop(),
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
}
