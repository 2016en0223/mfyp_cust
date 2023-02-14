import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mfyp_cust/screens/history.scr.dart';

import 'account.scr.dart';
import 'home.scr.dart';


class MFYPMainScreen extends StatefulWidget {
  const MFYPMainScreen({Key? key}) : super(key: key);

  @override
  MFYPMainScreenState createState() => MFYPMainScreenState();
}
LocationPermission? userLocationPermission;

deviceLocationPermission() async {
  userLocationPermission = await Geolocator.requestPermission();
  if (userLocationPermission == LocationPermission.denied) {
    userLocationPermission = await Geolocator.requestPermission();
  }
}

class MFYPMainScreenState extends State<MFYPMainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: "Records",
            activeIcon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            label: "Ratings",
            activeIcon: Icon(Icons.star),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: "Account",
            activeIcon: Icon(Icons.person),
          ),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          MFYPHomeScreen(),
          MFYPHistoryScreen(),
          MFYPAccount(),
        ],
      ),
    );
  }
}

