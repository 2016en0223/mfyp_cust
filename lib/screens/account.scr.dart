import 'package:flutter/material.dart';
import '../includes/utilities/colors.dart';

class MFYPAccount extends StatefulWidget {
  const MFYPAccount({Key? key}) : super(key: key);

  @override
  MFYPAccountState createState() => MFYPAccountState();
}

class MFYPAccountState extends State<MFYPAccount> {
  final List<String> account = [
    "Account",
    "Account",
    "Account",
    "Account",
    "Account"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _accountTop(),
          _accountOption(),
        ],
      ),
    );
  }

  Widget _accountTop() {
    final accountContainer = MediaQuery.of(context).size.height * 0.35;
    final containerWidth = MediaQuery.of(context).size.height - 20;
    return Container(
        height: accountContainer,
        width: containerWidth,
        // color: AppColor.containerColor,
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(5, 5),
                blurRadius: 5,
              )
            ],
            color: AppColor.containerColor,
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(50),
            )),
        child: const Center(
          child: Icon(
            Icons.account_circle_outlined,
            size: 140,
            color: Colors.white,
          ),
        ));
  }

  Widget _accountList() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        children: ListTile.divideTiles(
            context: context,
            color: AppColor.listViewDivider,
            tiles: const [
              ListTile(
                title: Text('Horse'),
              ),
              ListTile(
                title: Text('Cow'),
              ),
              ListTile(
                title: Text('Camel'),
              ),
              ListTile(
                title: Text('Sheep'),
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]).toList(),
      ),
    );
  }

  Widget _accountOption() {
    return Expanded(
      child: ListView.separated(
        itemCount: account.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: Text(
              account[index],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: AppColor.listViewDivider,
          );
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: AppColor.primaryColor,
      toolbarHeight: 45,
      title: const Text(
        "Account info",
        style: TextStyle(
            color: AppColor.containerColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
