import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/reusable_widgets/sections/pending_requests.dart';
import 'package:xando/reusable_widgets/sections/user_requests.dart';

// ignore: must_be_immutable
class GameRequestsScreen extends StatefulWidget {
  const GameRequestsScreen({
    super.key,
  });

  @override
  State<GameRequestsScreen> createState() => _GameRequestsScreenState();
}

class _GameRequestsScreenState extends State<GameRequestsScreen> {
  bool isDataAvailable = false;

  late String _userId;

  _loadUserData() async {
    String? userId = await DatabaseProvider().getUserId();
    if (mounted) {
      setState(() {
        _userId = userId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userId = '';
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Set this height
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 13.0,
              left: 13,
              top: 50,
              bottom: 20,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Game Requests',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: FireStoreServiceProvider()
                    .getRequestsStreamForUser(_userId),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data?.isEmpty ?? true) {
                    return const Text('');
                  } else {
                    isDataAvailable = true;
                    List<Map<String, dynamic>> receivedRequests =
                        snapshot.data ?? [];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 20),
                      child: Column(
                        children: [
                          receivedRequests.isEmpty
                              ? const Text('')
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Pending Requests',
                                      style: TextStyle(
                                        fontFamily: 'Bold',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'See all',
                                      style: TextStyle(
                                        fontFamily: 'Bold',
                                        fontSize: 14,
                                        color: Colors.white
                                            .withOpacity(0.5)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: receivedRequests.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index >= 0 &&
                                    index < receivedRequests.length) {
                                  return PendingRequests(
                                    username: receivedRequests[index]
                                            ['username'] ??
                                        '',
                                    documentID: _userId,
                                    gameNumberId: receivedRequests[index]
                                        ['gameNumberId'],
                                    profileAvatar: receivedRequests[index]
                                            ['senderAvatar'] ??
                                        '',
                                    receiverAvatar: receivedRequests[index]
                                            ['receiverAvatar'] ??
                                        '',
                                    senderUsername: receivedRequests[index]
                                            ['senderUsername'] ??
                                        '',
                                    requestTime: formatTimestamp(
                                        receivedRequests[index]['timestamp'] ??
                                            ''),
                                    gameID:
                                        receivedRequests[index]['gameID'] ?? '',
                                    stake:
                                        receivedRequests[index]['stake'] ?? '',
                                    status: receivedRequests[index]['status'] ??
                                        ''.toString(),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    );
                  }
                }),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<List<Map<String, dynamic>>>(
                stream:
                    FireStoreServiceProvider().getRequestsStreamByUser(_userId),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data?.isEmpty ?? true) {
                    return const Text('');
                  } else {
                    isDataAvailable = true;
                    List<Map<String, dynamic>> receivedRequests =
                        snapshot.data ?? [];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 20)
                          .copyWith(top: 0),
                      child: Column(
                        children: [
                          receivedRequests.isEmpty
                              ? const Text('')
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sent Requests',
                                      style: TextStyle(
                                        fontFamily: 'Medium',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'See all',
                                      style: TextStyle(
                                        fontFamily: 'Bold',
                                        fontSize: 14,
                                        color: Colors.white
                                            .withOpacity(0.5)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: receivedRequests.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index >= 0 &&
                                  index < receivedRequests.length) {
                                return UserRequests(
                                  gameNumberId: receivedRequests[index]
                                      ['gameNumberId'],
                                  documentID: receivedRequests[index]
                                          ['receiverId'] ??
                                      '',
                                  profileAvatar: receivedRequests[index]
                                          ['receiverAvatar'] ??
                                      '',
                                  username:
                                      receivedRequests[index]['username'] ?? '',
                                  requestTime: formatTimestamp(
                                      receivedRequests[index]['timestamp'] ??
                                          ''),
                                  gameID:
                                      receivedRequests[index]['gameID'] ?? '',
                                  stake: receivedRequests[index]['stake'] ?? '',
                                  status: receivedRequests[index]['status'] ??
                                      ''.toString(),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ),
          // Check if both streams have no data
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: Future.wait([
                FireStoreServiceProvider()
                    .getRequestsStreamForUser(_userId)
                    .first,
                FireStoreServiceProvider()
                    .getRequestsStreamByUser(_userId)
                    .first,
              ]),
              builder: (context,
                  AsyncSnapshot<List<List<Map<String, dynamic>>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Color(0xFF3B4FFE),
                      ),
                    ),
                  );
                } else {
                  bool isDataAvailable =
                      snapshot.data?.any((list) => list.isNotEmpty) ?? false;

                  if (!isDataAvailable) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/3d_bell.png',
                                  width: 136,
                                  height: 145,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'No Game Requests yet',
                                style: TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' No worries! when new requests come \nin it will appear here. ',
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ).animate().fadeIn(duration: 500.ms),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime dateTime =
        timestamp.toDate(); // Convert Firebase Timestamp to DateTime
    Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat.yMMMd().format(dateTime);
    }
  }
}
