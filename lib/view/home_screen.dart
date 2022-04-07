import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:key/entity/user.dart';
import 'package:key/logic/controller/route_controller.dart';
import 'package:key/logic/state/common/firebase_user_state.dart';
import 'package:key/logic/state/common/login_user_state.dart';
import 'package:key/logic/state/common/store_state.dart';
import 'package:key/view/store_profile_screen.dart';
import 'package:key/view/util/theme.dart';

final pages = StateProvider<List<Widget>>((ref) => []);
final nowPage = StateProvider<Widget>((ref) => ref.read(pages)[0]);
final bottomNavigationBarItems =
    StateProvider<List<BottomNavigationBarItem>>((ref) => [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'プロフィール'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '通知'),
        ]);
final currentPageIndex = StateProvider<int>((ref) => 0);

class CustomeruserProfielPage extends HookConsumerWidget {
  final Color textColor;
  final User? loginUser;
  CustomeruserProfielPage(this.textColor, this.loginUser);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Color(0xFFDDDDDD), height: 0),
          GestureDetector(
            onTap: () => ref.read(routeController).push(AppRoute.editProfile),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '名前',
                      style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Text(
                  loginUser?.name ?? "未設定",
                  style: TextStyle(fontSize: 14, color: textColor),
                  // ),
                ),
                SizedBox(width: 30),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
          const Divider(color: Color(0xFFDDDDDD), height: 0),
          const SizedBox(height: 15),
          const Divider(color: Color(0xFFDDDDDD), height: 0),
          TextButton(
            onPressed: () =>
                ref.read(routeController).push(AppRoute.registerStore),
            child: const Text(
              '加盟店登録はこちら',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF955513),
              ),
            ),
          ),
          Divider(color: Color(0xFFDDDDDD), height: 0),
        ],
      ),
    );
  }
}

class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final ScreenHeight = MediaQuery.of(context).size.width;
    final textColor = AppColor.textColor;
    final loginUser = ref.watch(loginUserState);

    useEffect(() {
      if (ref.read(pages).isEmpty) {
        ref.read(pages).add(CustomeruserProfielPage(textColor, loginUser));
        ref.read(pages).add(Center(child: Text('準備中')));
        if (ref.read(storeState.notifier).state != null) {
          ref.read(pages).add(StoreProfileScreen());
          ref.read(bottomNavigationBarItems).add(const BottomNavigationBarItem(
              icon: Icon(Icons.storefront), label: '店舗プロフィール'));
        }
      }
    }, []);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(child: ref.watch(nowPage)),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          ref.read(nowPage.notifier).state = ref.read(pages)[index];
          ref.read(currentPageIndex.notifier).state = index;
        },
        currentIndex: ref.watch(currentPageIndex),
        items: ref.watch(bottomNavigationBarItems),
      ),
    );
  }
}
