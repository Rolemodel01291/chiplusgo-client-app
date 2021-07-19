import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titles = [
      AppLocalizations.of(context).translate('faqTitleOne'),
      AppLocalizations.of(context).translate('faqTitleTwo'),
      // AppLocalizations.of(context).translate('faqTitleThree'),
      // AppLocalizations.of(context).translate('faqTitleFour'),
      // AppLocalizations.of(context).translate('faqTitleFive')
    ];
    print('-----------------${MediaQuery.of(context).size.height}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('FAQ'),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/faq.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      //  GestureDetector(
      //   child: Container(
      //     child: LayoutBuilder(
      //       builder: (context, constraints) => SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: SizedBox(
      //           height: constraints.biggest.height,
      //           child: Image.asset(
      //             'assets/images/faq.jpg',
      //             width: MediaQuery.of(context).size.width,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // CustomScrollView(
      //   // physics: const BouncingScrollPhysics(),
      //   // controller: _scrollController,
      //   slivers: <Widget>[
      //     Image.asset(
      //       'assets/images/faq.jpg',
      //       width: MediaQuery.of(context).size.width,
      //       fit: BoxFit.cover,
      //     ),
      //   ],
    );
    // ListView.separated(
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text(
    //         titles[index],
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    //       ),
    //       onTap: () {
    //         _onFAQTapped(index);
    //       },
    //       trailing: Icon(
    //         Icons.chevron_right,
    //         color: Colors.grey,
    //       ),
    //     );
    //   },
    //   itemCount: titles.length,
    //   separatorBuilder: (BuildContext context, int index) {
    //     return Divider(
    //       height: 0.5,
    //       indent: 16,
    //       color: Colors.black12,
    //     );
    //   },
    // ),
    // );
  }

  void _onFAQTapped(int index) async {
    String url = '';
    switch (index) {
      case 0:
        url = "https://mp.weixin.qq.com/s/cAkWFgGs5H2aoVtHfgqzhw";
        break;
      case 1:
        url = "https://mp.weixin.qq.com/s/llBYujw-DB3KY9-Q0Yh25Q";
        break;
      case 2:
        url = "https://mp.weixin.qq.com/s/PwIcNh66mqbL92SKg0frUQ";
        break;
      case 3:
        url = "https://mp.weixin.qq.com/s/bqV18LozSYc-HDhiRf0cTA";
        break;
      case 4:
        url = "https://mp.weixin.qq.com/s/qj3w3P4_3AGCgLAL5lRQhw";
        break;
      default:
        break;
    }

    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
