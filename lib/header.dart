import 'package:admin_panel_komp/custom_text.dart';
import 'package:admin_panel_komp/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Login_Page.dart';
import 'colors.dart';
import 'custom_buuton.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(icon: Icon(Icons.menu), onPressed: () {}),
          if (!Responsive.isMobile(context))
            Row(
              children: [
                SizedBox(
                    height: 80,
                    width: 250,
                    child: Image.asset(
                      'assets/images/bgName.png',
                    )),
                SizedBox(
                  width: 30,
                ),
              ],
            ),

          if (!Responsive.isMobile(context))
            Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          // Expanded(child: SearchField()),
          ProfileCard()
        ],
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userName = '';
  String userImage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInitState();
    });
  }

  asyncInitState() async {
    DocumentSnapshot user = await firestore
        .collection('userDetails')
        .doc(auth.currentUser!.uid)
        .get();
    setState(() {
      userName = user['name'];
      userImage = user['profileImageUrl'];
    });
    print("loaded: ${userName}");
    print("loaded: ${userImage}");
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[


            CustomButton(
              color: Colors.transparent,
              width: 100,
              height: 40,
              text: 'No',
              textColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CustomButton(
              width: 100,
              height: 40,
              text: 'Yes',
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },

            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: primaryColorKom.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: GestureDetector(
        onTap: _showLogoutDialog,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(userImage), fit: BoxFit.cover)),
            ),
            if (!Responsive.isMobile(context))
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Row(
                  children: [
                    AsulCustomText(
                      text: userName!,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.logout_outlined,
                      color: primaryColorKom,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
