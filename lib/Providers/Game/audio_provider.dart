import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class AudioProvider extends ChangeNotifier {
  bool _isSoundOn = true;
  bool get isSoundOn => _isSoundOn;

  void playSound(String sound) async {
    AudioPlayer player = AudioPlayer();
    await player.setAsset(sound);
    player.play();
  }

  void toggleSound() async {
    _isSoundOn = !_isSoundOn;
    pauseAndPlay();
    notifyListeners();
  }

  void pauseAndPlay() {
    AudioPlayer player = AudioPlayer();
    if (_isSoundOn) {
      player.play();
    } else {
      player.pause();
    }
  }
}
