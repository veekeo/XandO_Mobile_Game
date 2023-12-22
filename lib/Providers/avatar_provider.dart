import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/models/avatar_model.dart';

class AvatarProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _resMessage = '';
  bool _hasError = false;

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  bool get hasError => _hasError;

  bool isSelected = false;

  //select an Avatar
  Future<void> updateColor(BuildContext context, String? userId,
      AvatarContainerModel container) async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();

    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    final body = {
      'imageURL': container.imageURL,
    };

    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        dbProvider.saveUserImage(res['imageURL']);
        _resMessage = 'Avatar updated successfully';
        _isLoading = false;
        _hasError = false;
        container.selectedColor = const Color(0xFF38D21B);
        notifyListeners();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        final res = json.decode(req.body);
        print(req.statusCode);
        print(res);
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Avatar Update Failed';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _hasError = true;
      _resMessage = 'Internet connection is not available';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _resMessage = e.toString();
      print(e.toString());
      notifyListeners();
    }

    notifyListeners();
  }

  List<AvatarContainerModel> avatars = [
    AvatarContainerModel(
      id: 1,
      imageURL: 'https://api.multiavatar.com/Starcrasher.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 2,
      imageURL: 'https://api.multiavatar.com/dc8d09961b64430bc4.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 3,
      imageURL: 'https://api.multiavatar.com/dc3550586cec40b13d.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 4,
      imageURL: 'https://api.multiavatar.com/5b1271f9320afc278a.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 5,
      imageURL: 'https://api.multiavatar.com/e62efbacc955277ca9.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 6,
      imageURL: 'https://api.multiavatar.com/e2b302ab4e84fc569d.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 7,
      imageURL: 'https://api.multiavatar.com/b678ed6b66e18c747f.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 8,
      imageURL: 'https://api.multiavatar.com/a3c6f96e6a948f60bd.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 9,
      imageURL: 'https://api.multiavatar.com/5337098cc5c9f97109.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 10,
      imageURL: 'https://api.multiavatar.com/efc498d161331cb844.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 11,
      imageURL: 'https://api.multiavatar.com/f9b9a63120850479c8.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 12,
      imageURL: 'https://api.multiavatar.com/98950c2c7ab8975432.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 13,
      imageURL: 'https://api.multiavatar.com/7d4ea77f48d2bf34a8.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 14,
      imageURL: 'https://api.multiavatar.com/fcd36ae0e603c0753b.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 15,
      imageURL: 'https://api.multiavatar.com/294b2c548c62ffb042.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 16,
      imageURL: 'https://api.multiavatar.com/888ed67c739377816d.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 17,
      imageURL: 'https://api.multiavatar.com/6c98bbd9f4c7424401.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 18,
      imageURL: 'https://api.multiavatar.com/3949141b3cf0ffbac9.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 19,
      imageURL: 'https://api.multiavatar.com/924949a075b4936295.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 20,
      imageURL: 'https://api.multiavatar.com/359654366b326e6855.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 21,
      imageURL: 'https://api.multiavatar.com/28d7a12ba4170c4f6d.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 22,
      imageURL: 'https://api.multiavatar.com/88b503d643d6bde47d.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 23,
      imageURL: 'https://api.multiavatar.com/d7911f7a0ff8a871eb.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
    AvatarContainerModel(
      id: 24,
      imageURL: 'https://api.multiavatar.com/9fd14bcfc193e18d66.png',
      isSelected: false,
      selectedColor: const Color(0xFF3B4FFE),
    ),
  ];
}
