import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicLinksProvider extends ChangeNotifier {
  String _affliateurl = '';
  String _gameUrl = '';
  String? _gameId = '';
  String? _affliateRefCode = '';
  String get gameUrl => _gameUrl;
  String? get gameId => _gameId;
  String get affliateurl => _affliateurl;
  String? get affliateRefCode => _affliateRefCode;

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
        link: Uri.parse(url),
        uriPrefix: 'https://xandoanimationhub.page.link');

    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
    final refLink = await link.buildShortLink(parameters);
    return refLink.shortUrl.toString();
  }

  //Game Sharing
  Future<String> createGameLink(String? gameId) async {
    final String url = "https://xando.app?game=$gameId";
    _gameUrl = url;
    _gameId = gameId;
    notifyListeners();

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        androidParameters: const AndroidParameters(
            packageName: "xando.app", minimumVersion: 21),
        iosParameters:
            const IOSParameters(bundleId: "xando.app", minimumVersion: "0"),
        link: Uri.parse(url),
        uriPrefix: 'https://xandoanimationhub.page.link');

    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
    final gameLink = await link.buildShortLink(parameters);
    return gameLink.shortUrl.toString();
  }

  ///initialize dynamic link
  Future<bool?> initializeGameDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri gameLink = instanceLink.link;

      if (gameLink.queryParameters.containsKey('game')) {
        return true;
      }
    }

    // If none of the conditions above are met, return null
    return null;
  }

  Future<bool?> initializeDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri refLink = instanceLink.link;

      if (refLink.queryParameters.containsKey('ref')) {
        return true;
      }
    }

    // If none of the conditions above are met, return null
    return null;
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
