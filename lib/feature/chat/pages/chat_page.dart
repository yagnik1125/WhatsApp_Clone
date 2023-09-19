import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_me/common/models/user_model.dart';
import 'package:whatsapp_me/common/routes/routes.dart';
import 'package:whatsapp_me/feature/chat/controllers/chat_controller.dart';
import 'package:whatsapp_me/feature/chat/widgets/chat_text_field.dart';
import 'package:whatsapp_me/feature/chat/widgets/message_card.dart';
import 'package:whatsapp_me/feature/chat/widgets/show_date_card.dart';
import 'package:whatsapp_me/feature/chat/widgets/yellow_card.dart';
import 'package:whatsapp_me/feature/welcome/widgets/custom_icon_button.dart';

final pageStorageBucket = PageStorageBucket();

class ChatPage extends ConsumerWidget {
  ChatPage({
    super.key,
    required this.user,
  });

  final UserModel user;
  final ScrollController scrollController = ScrollController();

  String _getLastSeenText(int lastSeenTimestamp) {
    final now = DateTime.now();
    final lastSeen = DateTime.fromMillisecondsSinceEpoch(lastSeenTimestamp);

    if (now.difference(lastSeen).inDays == 0) {
      // If last seen was today, display the time
      return "today at ${DateFormat.Hm().format(lastSeen)}";
    } else if (now.difference(lastSeen).inDays == 1) {
      // If last seen was yesterday, display "yesterday"
      return "yesterday";
    } else {
      // Otherwise, display the date
      return DateFormat.yMMMMd().format(lastSeen);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.theme.chatPageBgColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              Hero(
                tag: 'profile',
                child: Container(
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () async {
            Navigator.pushNamed(
              context,
              Routes.profile,
              arguments: user,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(
                  height: 3,
                ),
                // Text(
                //   "last seen 2 min ago",
                //   // DateFormat.Hm()
                //   // .format(user.lastSeen),
                //   style: const TextStyle(
                //     fontSize: 12,
                //   ),
                // ),
                // ShowDateCard(date: user.lastSeen),
                // if (user.active) // Check if the user is active
                //   const Text(
                //     "Online", // You can customize this text
                //     style: TextStyle(
                //       fontSize: 12,
                //     ),
                //   ),
                Text(
                  "Last seen ${_getLastSeenText(user.lastSeen)}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Icons.video_call,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onPressed: () {},
            icon: Icons.call,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onPressed: () {},
            icon: Icons.more_vert,
            iconColor: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          Image(
            height: double.maxFinite,
            width: double.maxFinite,
            image: const AssetImage('assets/images/doodle_bg.png'),
            fit: BoxFit.cover,
            color: context.theme.chatPageDoodleColor,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: StreamBuilder(
              stream: ref
                  .watch(chatControllerProvider)
                  .getAllOneToOneMessage(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return ListView.builder(
                    itemCount: 15,
                    itemBuilder: (_, index) {
                      final random = Random().nextInt(14);
                      return Container(
                        alignment: random.isEven
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: random.isEven ? 150 : 15,
                          right: random.isEven ? 15 : 150,
                        ),
                        child: ClipPath(
                          clipper: UpperNipMessageClipperTwo(
                            random.isEven
                                ? MessageType.send
                                : MessageType.receive,
                            nipWidth: 8,
                            nipHeight: 10,
                            bubbleRadius: 12,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: random.isEven
                                ? context.theme.greyColor!.withOpacity(0.3)
                                : context.theme.greyColor!.withOpacity(0.2),
                            highlightColor: random.isEven
                                ? context.theme.greyColor!.withOpacity(0.4)
                                : context.theme.greyColor!.withOpacity(0.3),
                            child: Container(
                              height: 40,
                              width:
                                  170 * double.parse((random * 2).toString()),
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return PageStorage(
                  bucket: pageStorageBucket,
                  child: ListView.builder(
                    key: const PageStorageKey('chat_page_list'),
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    controller: scrollController,
                    itemBuilder: (_, index) {
                      final message = snapshot.data![index];
                      final isSender = message.senderId ==
                          FirebaseAuth.instance.currentUser!.uid;
                      final haveNip = (index == 0) ||
                          (index == snapshot.data!.length - 1 &&
                              message.senderId !=
                                  snapshot.data![index - 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId ==
                                  snapshot.data![index + 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId !=
                                  snapshot.data![index + 1].senderId);
                      final isShowDateCard = (index == 0) ||
                          ((index == snapshot.data!.length - 1) &&
                              (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day)) ||
                          (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day &&
                              message.timeSent.day <=
                                  snapshot.data![index + 1].timeSent.day);
                      return Column(
                        children: [
                          if (index == 0) const YellowCard(),
                          if (isShowDateCard)
                            ShowDateCard(date: message.timeSent),
                          MessageCard(
                            isSender: isSender,
                            haveNip: haveNip,
                            message: message,
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: const Alignment(0, 1),
            child: ChatTextField(
              receiverId: user.uid,
              scrollController: scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
