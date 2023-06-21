import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/admin/aPsychologistPage.dart';
import 'package:psychological_consultation/src/screen/admin/aResourcesPage.dart';
import 'package:psychological_consultation/src/screen/admin/aUserPage.dart';
import 'package:psychological_consultation/src/screen/admin/adiscussionPage.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../wellCome.dart';
import 'aHomePage.dart';

class adminBottomNavigationBar extends StatefulWidget {
  const adminBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<adminBottomNavigationBar> createState() => _adminBottomNavigationBarState();
}

class _adminBottomNavigationBarState extends State<adminBottomNavigationBar> {
  final PersistentTabController _controller= PersistentTabController(initialIndex: 3);
  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const aDiscussionsPage(),
      const aResourcesPage(),
      const aPsychologistPage(),
      const aUserPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: appColors.textP,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people),
        title: ("Discussions"),
        activeColorPrimary: appColors.textP,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.folder ),
        title: ("Resources"),
        activeColorPrimary: appColors.textP,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.psychology),
        title: ("Psychologist"),
        activeColorPrimary: appColors.textP,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("User"),
        activeColorPrimary: appColors.textP,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
  String title="";
  getTitle()async {
    title=await SessionManager().get("user").then((value) => value['email']);
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.gray,
        title: Text(title,style:const TextStyle(color:appColors.textP)),
        actions: [TextButton(onPressed: () async {
          await SessionManager().destroy();
          ZegoUIKitPrebuiltCallInvitationService().uninit();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>wellCome()), (route) => false);
        }, child: Text("log out"))],
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: appColors.gray, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
      ),
    );
  }
}
