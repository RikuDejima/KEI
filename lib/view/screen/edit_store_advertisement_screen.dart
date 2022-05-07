import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:key/logic/state/common/store_state.dart';
import 'package:key/logic/view_controller/edit_store_profile_view_controller.dart';
import 'package:key/view/screen/edit_store_profile_screen.dart';
import 'package:key/view/util/theme.dart';

class EditStoreAdvertisementScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeData = ref.watch(storeDataState);
    final screenWidth = MediaQuery.of(context).size.width;
    final viewController = ref.read(editStoreProfileViewController);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  storeData!.advertisementImage == null
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
                                    viewController: ref
                                        .read(editStoreProfileViewController),
                                    isAdvertisement: true,
                                  );
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
                        Text('お客様へのメッセージ'),
                        TextField(
                          onChanged: (str) => ref
                              .read(editStoreItemsState.notifier)
                              .state['advertisementMessage'] = str,
                          maxLength: 120,
                          controller: TextEditingController(
                              text: storeData.advertisementMessage),
                        ),
                        SizedBox(height: 25),
                        Text('e-mailでの招待メッセージ'),
                        TextField(
                          onChanged: (str) {
                            ref
                                .read(editStoreItemsState.notifier)
                                .state[' emailInvitationMessage'] = str;
                          },
                          maxLength: 120,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: TextEditingController(
                              text: storeData.emailInvitationMessage),
                        ),
                        SizedBox(height: 25),
                        Text('紹介するお店'),
                        
                        Divider(
                          thickness: 3,
                          color: AppColor.dividerColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
