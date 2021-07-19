import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class UserProfileSection extends StatelessWidget {
  final String name;
  final String emailAddress;
  final Function navigation;
  final String avatarUrl;

  const UserProfileSection({
    @required this.name,
    @required this.emailAddress,
    @required this.navigation,
    @required this.avatarUrl,
  })  : assert(name != null),
        assert(navigation != null),
        assert(emailAddress != null);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 80,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // avatar
            CircleAvatar(
              radius: 30,
              backgroundImage: AdvancedNetworkImage(
                avatarUrl,
                useDiskCache: true,
                fallbackImage: kTransparentImage,
              ),
            ),

            SizedBox(
              width: 8,
            ),

            // name and addr column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),

                // address
                Text(
                  emailAddress,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFACACAC),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
      onTap: navigation,
    );
  }
}
