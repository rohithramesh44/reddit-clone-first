import 'package:flutter/material.dart';
import 'package:reddit_clone/feature/feed/screens/feed_screen.dart';
import 'package:reddit_clone/feature/post/screens/add_post_screen.dart';

class Constant {
  static var logoPath = 'assets/images/reddit_logo.png';
  static var googlePath = 'assets/images/google.png';
  static var loginEmotePath = 'assets/images/loginEmote.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];

  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constant.awardsPath}/awesomeanswer.png',
    'gold': '${Constant.awardsPath}/gold.png',
    'platinum': '${Constant.awardsPath}/platinum.png',
    'helpful': '${Constant.awardsPath}/helpful.png',
    'plusone': '${Constant.awardsPath}/plusone.png',
    'rocket': '${Constant.awardsPath}/rocket.png',
    'thankyou': '${Constant.awardsPath}/thankyou.png',
    'til': '${Constant.awardsPath}/til.png',
  };
}
