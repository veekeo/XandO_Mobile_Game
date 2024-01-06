import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xando/screens/Auth_Screens/signup_screen.dart';
import 'package:xando/screens/Main_Screens/game_details_screen.dart';

class DynamicLinksProvider extends ChangeNotifier {
  String _affliateurl = '';
  String _gameUrl = '';

  String? _affliateRefCode = '';
  String get gameUrl => _gameUrl;

  String get affliateurl => _affliateurl;
  String? get affliateRefCode => _affliateRefCode;

//Game Variables
  String? _gameId = '';
  bool? _state = true;
  String? _stake = '';
  String? _potentialWin = '';
  String? _gameTitle = '';
  String? _idOfgame = '';
  String? _username = '';
  String? _senderUsername = '';
  String? _senderId = '';
  String? _receiverId = '';
  String? _receiverDeviceToken = '';
  String? _receiverAvatar = '';
  String? _senderAvatar = '';
  String? _senderDeviceToken = '';

  // String? get gameId => _gameId;
  // bool? get state => _state;
  // String? get stake => _stake;
  // String? get potentialWin => _potentialWin;
  // String? get gameTitle => _gameTitle;
  // String? get idOfgame => _idOfgame;
  // String? get username => _username;
  // String? get senderUsername => _senderUsername;
  // String? get senderId => _senderId;
  // String? get receiverId => _receiverId;
  // String? get receiverDeviceToken => _receiverDeviceToken;
  // String? get receiverAvatar => _receiverAvatar;
  // String? get senderAvatar => _senderAvatar;
  // String? get senderDeviceToken => _senderDeviceToken;

  final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
  Future<String> createLink(String? refCode) async {
    final String url = "https://xando.app?ref=$refCode";
    _affliateurl = url;
    _affliateRefCode = refCode;
    notifyListeners();

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        androidParameters: const AndroidParameters(
            packageName: "xando.app", minimumVersion: 21),
        iosParameters:
            const IOSParameters(bundleId: "xando.app", minimumVersion: "0"),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: 'Join the Ultimate XandO Showdown!',
            description:
                'join our Tic Tac Toe game now and challenge friends or foes. Claim victory, win, and let the games begin!',
            imageUrl: Uri.parse(
                'https://res.cloudinary.com/dbofcawb1/image/upload/v1704439011/social_tag_azyrpv.png')),
        link: Uri.parse(url),
        uriPrefix: 'https://xandoanimationhub.page.link');

    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
    final refLink = await link.buildShortLink(parameters);
    return refLink.shortUrl.toString();
  }

  //Game Sharing
  Future<String> createGameLink({
    String? stake,
    required String potentialWin,
    String? gameTitle,
    String? gameId,
    String? idOfgame,
    String? username,
    String? senderUsername,
    String? senderId,
    String? receiverId,
    bool? state,
    String? receiverDeviceToken,
    String? senderDeviceToken,
    String? senderAvatar,
    String? receiverAvatar,
  }) async {
    final String url = "https://xando.app?game=$gameId";
    _gameUrl = url;
    _gameId = gameId;
    _stake = stake;
    _potentialWin = potentialWin;
    _gameTitle = gameTitle;
    _idOfgame = idOfgame;
    _username = username;
    _senderUsername = senderUsername;
    _senderId = senderId;
    _receiverId = receiverId;
    _state = state;
    _receiverDeviceToken = receiverDeviceToken;
    _senderDeviceToken = senderDeviceToken;
    _senderAvatar = senderAvatar;
    _receiverAvatar = receiverAvatar;
    notifyListeners();

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        androidParameters: const AndroidParameters(
            packageName: "xando.app", minimumVersion: 21),
        iosParameters:
            const IOSParameters(bundleId: "xando.app", minimumVersion: "0"),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: 'Join the Ultimate XandO Showdown!',
            description:
                'join our Tic Tac Toe game now and challenge friends or foes. Claim victory, win, and let the games begin!',
            imageUrl: Uri.parse(
                'https://res.cloudinary.com/dbofcawb1/image/upload/v1704439011/social_tag_azyrpv.png')),
        link: Uri.parse(url),
        uriPrefix: 'https://xandoanimationhub.page.link');

    final gameLink = await link.buildShortLink(parameters);
    return gameLink.shortUrl.toString();
  }

  Future<void> initRefDynamicLink(BuildContext context) async {
    link.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      var isReferral = deepLink.pathSegments.contains('ref');
      if (isReferral) {
        if (deepLink.toString().isNotEmpty) {
          try {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => const SignUpScreen()));
          } catch (e) {
            debugPrint(e.toString());
          }
        } else {
          return;
        }
      }
    });

    await link.getInitialLink().then(
      (PendingDynamicLinkData? data) {
        final Uri? deepLink = data?.link;
        var isReferral = deepLink?.pathSegments.contains('ref');
        if (isReferral == true) {
          if (deepLink.toString().isNotEmpty) {
            try {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const SignUpScreen()));
            } catch (e) {
              debugPrint(e.toString());
            }
          } else {
            return;
          }
        }
      },
    );
  }

  // ///initialize dynamic link
  Future<void> initgameDynamicLink(BuildContext context) async {
    link.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      var isReferral = deepLink.pathSegments.contains('game');
      if (isReferral) {
        if (deepLink.toString().isNotEmpty) {
          try {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => GameDetailsScreen(
                          state: _state,
                          stake: _stake,
                          potentialWin: _potentialWin!,
                          gameTitle: _gameTitle,
                          gameId: _gameId,
                          idOfgame: _idOfgame,
                          username: _username,
                          senderUsername: _senderUsername,
                          senderId: _senderId,
                          receiverId: _receiverId,
                          receiverDeviceToken: _receiverDeviceToken,
                          receiverAvatar: _receiverAvatar,
                          senderAvatar: _senderAvatar,
                          senderDeviceToken: _senderDeviceToken,
                        )));
          } catch (e) {
            debugPrint(e.toString());
          }
        } else {
          return;
        }
      }
    });

    await link.getInitialLink().then(
      (PendingDynamicLinkData? data) {
        final Uri? deepLink = data?.link;
        var isReferral = deepLink?.pathSegments.contains('game');
        if (isReferral == true) {
          if (deepLink.toString().isNotEmpty) {
            try {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => GameDetailsScreen(
                            state: _state,
                            stake: _stake,
                            potentialWin: _potentialWin!,
                            gameTitle: _gameTitle,
                            gameId: _gameId,
                            idOfgame: _idOfgame,
                            username: _username,
                            senderUsername: _senderUsername,
                            senderId: _senderId,
                            receiverId: _receiverId,
                            receiverDeviceToken: _receiverDeviceToken,
                            receiverAvatar: _receiverAvatar,
                            senderAvatar: _senderAvatar,
                            senderDeviceToken: _senderDeviceToken,
                          )));
            } catch (e) {
              debugPrint(e.toString());
            }
          } else {
            return;
          }
        }
      },
    );
  }

  void shareOnSocialMedia(String link, String platform) async {
    Uri socialMediaUrl;

    switch (platform) {
      case 'facebook':
        socialMediaUrl =
            Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$link');
        break;
      case 'twitter':
        socialMediaUrl =
            Uri.parse('https://twitter.com/intent/tweet?url=$link');
        break;
      case 'telegram':
        socialMediaUrl = Uri.parse('https://t.me/share/url?url=$link');
        break;
      case 'linkedin':
        socialMediaUrl = Uri.parse(
            'https://www.linkedin.com/sharing/share-offsite/?url=$link');
        break;
      case 'instagram':
        // Note: Directly sharing to Instagram might be more complex due to restrictions.
        // Opening the Instagram app with a caption and link is an option:
        socialMediaUrl = Uri.parse(
            'https://www.instagram.com/?url=$link&caption=Check%20out%20this%20link');
        break;

      default:
        throw 'Unsupported social media platform: $platform';
    }

    if (await canLaunchUrl(socialMediaUrl)) {
      await launchUrl(socialMediaUrl);
    } else {
      throw 'Could not launch $socialMediaUrl';
    }
  }
}
