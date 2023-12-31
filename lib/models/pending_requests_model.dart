import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xando/utils/game_requests_enums.dart';

class PendingRequestsModel {
  final String username;
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  final String gameID;
  final String stake;
  final RequestStatus status;
  final String profileAvatar;

  PendingRequestsModel({
    required this.username,
    required this.timestamp,
    required this.senderId,
    required this.receiverId,
    required this.gameID,
    required this.stake,
    required this.status,
    required this.profileAvatar,
  });
}
