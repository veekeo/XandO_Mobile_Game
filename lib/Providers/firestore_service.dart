import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xando/utils/game_requests_enums.dart';

class FireStoreServiceProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  CollectionReference pendingRequests =
      FirebaseFirestore.instance.collection('pendingRequests');
  //create request
  Future<void> addGameRequest(
    String? senderId,
    String? receiverId,
    String? senderDeviceToken,
    String? receiverDeviceToken,
    String? username,
    String? gameID,
    String? gameNumberId,
    String? stake,
    String? senderUsername,
    String? receiverAvatar,
    String? senderAvatar,
    RequestStatus? status,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await pendingRequests.doc(receiverId).set({
        'senderId': senderId,
        'username': username,
        'senderUsername': senderUsername,
        'receiverId': receiverId,
        'receiverDeviceToken': receiverDeviceToken,
        'senderDeviceToken': senderDeviceToken,
        'receiverAvatar': receiverAvatar,
        'senderAvatar': senderAvatar,
        'gameID': gameID,
        'gameNumberId': gameNumberId,
        'stake': stake,
        'timestamp': FieldValue.serverTimestamp(),
        'status': status.toString(),
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error adding game request: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //read request
  Future readDocument(String documentID) async {
    CollectionReference pendingRequests =
        FirebaseFirestore.instance.collection('pendingRequests');

    // Get a reference to the specific document using the specified document ID
    DocumentReference documentReference = pendingRequests.doc(documentID);

    // Retrieve the document snapshot
    DocumentSnapshot documentSnapshot = await documentReference.get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return data;
    } else {
      print('Document with ID $documentID does not exist.');
    }
  }

  //update request
  Future<void> updatePendingRequest(
      String documentID, RequestStatus? status) async {
    _isLoading = true;
    notifyListeners();
    // Get a reference to the 'pendingRequests' collection
    CollectionReference pendingRequests =
        FirebaseFirestore.instance.collection('pendingRequests');

    // Get a reference to the specific document using the specified document ID
    DocumentReference documentReference = pendingRequests.doc(documentID);

    // Update the document
    await documentReference.update({
      'status': status.toString(),
      // Add other fields as needed
    });

    _isLoading = false;
    notifyListeners();

    print('Document with ID $documentID updated successfully.');
  }

  // delete request
  Future<void> deletePendingRequest(String documentID) async {
    _isLoading = true;
    notifyListeners();
    // Get a reference to the 'pendingRequests' collection
    CollectionReference pendingRequests =
        FirebaseFirestore.instance.collection('pendingRequests');

    // Get a reference to the specific document using the specified document ID
    DocumentReference documentReference = pendingRequests.doc(documentID);

    // Delete the document
    await documentReference.delete();
    _isLoading = false;
    notifyListeners();
  }

  //pending requests streams

  // Retrieve a real-time stream of requests received by a specific user
  Stream<List<Map<String, dynamic>>> getRequestsStreamForUser(String userId) {
    try {
      return pendingRequests
          .where('receiverId', isEqualTo: userId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error getting requests: $e');
      return Stream.value([]); // Return an empty stream in case of error
    }
  }

  //user Requests
  // Retrieve a real-time stream of requests made by a specific user
  Stream<List<Map<String, dynamic>>> getRequestsStreamByUser(String userId) {
    try {
      return pendingRequests
          .where('senderId', isEqualTo: userId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error getting requests stream: $e');
      return Stream.value([]); // Return an empty stream in case of error
    }
  }

  // Send Push Notifications
  Future<void> sendNotification(
      String? deviceToken, String title, String content, String? avatar) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse('https://onesignal.com/api/v1/notifications');

    // Create headers with the OAuth 2.0 token
    final Map<String, String> headers = {
      'Authorization':
          'Bearer YzcxY2NhMmUtNGRhNC00YWY3LTlkM2EtMGM5NjUyMDg3NTEx',
      'Content-Type': 'application/json',
    };

    final body = {
      "app_id": "3e491355-9e26-457b-a665-0583d99eca77",
      "include_aliases": {
        "external_id": [
          deviceToken,
        ]
      },
      "target_channel": "push",
      "small_icon": "ic_stat_onesignal_default",
      "large_icon": avatar,
      "headings": {"en": title},
      "contents": {"en": content}
    };

    try {
      http.Response req =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        print(res);
        _isLoading = false;
        notifyListeners();
      } else {
        final res = json.decode(req.body);
        print(res);
        print(req.statusCode);
        print('hereooooooo');
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      notifyListeners();
      print('no internet connect');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  // For game
  // Add a reference to your Firestore collection
  final CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection('games');

  //connect players
  Future<void> connectPlayersToGame({
    required String gameId,
    required String hostId,
    required String gameNumberId,
    required String player2Id,
    required bool exTurn,
    required bool ohTurn,
    required List<String> displayExOh,
    required List<int> matchedIndexes,
    required int filledBoxes,
    required int attempts,
    required int seconds,
    required String hostAvatar,
    required String player2Avatar,
    required bool gameState,
    required double stake,
    required bool isHostConnected,
    required bool isPlayer2Connected,
  }) async {
    try {
      await gamesCollection.doc(gameId).set({
        'host': {
          'exTurn': exTurn,
          'hostId': hostId,
          'gameNumberId': gameNumberId,
          'hostGameId': hostId,
          'displayExOh': displayExOh,
          'matchedIndexes': matchedIndexes,
          'filledBoxes': filledBoxes,
          'attempts': attempts,
          'hostAvatar': hostAvatar,
          'player2Avatar': player2Avatar,
          'isHostConnected': isHostConnected,
        },
        'player2': {
          'ohTurn': ohTurn,
          'player2Id': player2Id,
          'displayExOh': displayExOh,
          'matchedIndexes': matchedIndexes,
          'filledBoxes': filledBoxes,
          'attempts': attempts,
          'hostAvatar': hostAvatar,
          'player2Avatar': player2Avatar,
          'isPlayer2Connected': isPlayer2Connected,
        },
        'state': gameState,
        'seconds': seconds,
        'stake': stake,
      });
      print('Players connected to the game successfully!');
    } catch (e) {
      print('Error connecting players to the game: $e');
    }
  }

  Future<void> updateUserState({
    required String documentID,
    required bool hostState,
    required bool player2State,
    required bool exTurn,
    required bool ohTurn,
    required List<dynamic> displayExOh,
    required List<dynamic> matchedIndexes,
    required String hostId,
    required String player2Id,
    required String hostAvatar,
    required String player2Avatar,
    required int filledBoxes,
    required int attempts,
    required bool gameState,
    required String hostGameId,
    required String gameNumberId,
  }) async {
    _isLoading = true;
    notifyListeners();
    // Get a reference to the 'pendingRequests' collection
    CollectionReference gamesCollection =
        FirebaseFirestore.instance.collection('games');

    DocumentReference documentReference = gamesCollection.doc(documentID);

    await documentReference.update({
      'host': {
        'isHostConnected': hostState,
        'exTurn': exTurn,
        'displayExOh': displayExOh,
        'matchedIndexes': matchedIndexes,
        'hostId': hostId,
        'hostAvatar': hostAvatar,
        'hostGameId': hostId,
        'gameNumberId': gameNumberId,
        'filledBoxes': filledBoxes,
        'attempts': attempts,
      },
      'player2': {
        'isPlayer2Connected': player2State,
        'ohTurn': ohTurn,
        'displayExOh': displayExOh,
        'player2Id': player2Id,
        'player2Avatar': player2Avatar,
        'matchedIndexes': matchedIndexes,
        'filledBoxes': filledBoxes,
        'attempts': attempts,
      }
    });

    _isLoading = false;
    notifyListeners();

    print('Document with ID $documentID updated successfully.');
  }

  // delete game
  Future<void> deleteGame(String documentID) async {
    _isLoading = true;
    notifyListeners();
    // Get a reference to the 'pendingRequests' collection
    CollectionReference gamesCollection =
        FirebaseFirestore.instance.collection('games');

    // Get a reference to the specific document using the specified document ID
    DocumentReference documentReference = gamesCollection.doc(documentID);

    // Delete the document
    await documentReference.delete();
    _isLoading = false;
    notifyListeners();
  }

  // Add a method to get real-time updates from Firestore
  Stream<DocumentSnapshot<Map<String, dynamic>>> getGameStream(String gameId) {
    return FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .snapshots();
  }
}
