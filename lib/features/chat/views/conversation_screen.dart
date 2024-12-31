import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:local_gen_ai/core/constants/icon_asset_constants.dart';
import '../../../global/global.dart';
import '../models/message.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key,});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  ChatUser? currentUser;
  ChatUser? otherUser;
  List<ChatMessage> hardcodedMessages = [];

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(
        id: '0872788898',
        firstName: 'You'
    );

    otherUser = ChatUser(
        id: 'AIMODEL',
        firstName: 'LLama 3.2',
        profileImage: CustomIcons.llama
    );

    // Hardcoded messages
    hardcodedMessages = [
      ChatMessage(
        user: otherUser!,
        text: "Hello! How can I assist you today?",
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        user: currentUser!,
        text: "I want to know more about AI.",
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      ChatMessage(
        user: otherUser!,
        text: "Sure! AI stands for Artificial Intelligence, which is a field of computer science focused on creating systems capable of performing tasks that typically require human intelligence.",
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: GestureDetector(
            onTap: Get.back,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                    Icons.arrow_back
                ),

                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset(
                    width: 30,
                    otherUser!.profileImage.toString().isNotEmpty
                        ? otherUser!.profileImage.toString()
                        : 'https://cdn-icons-png.flaticon.com/128/3177/3177440.png',
                  ),
                )
              ],
            ),
          ),
          title: Text(
            otherUser!.firstName!,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          ),

          actions: [

            GestureDetector(
                onTap: ()async{

                },
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: const Icon(
                    HugeIcons.strokeRoundedShare01,
                    size: 20,
                  ),
                )
            ),
            PopupMenuButton<String>(
              color: Colors.white,
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'saved',
                  child: Text(
                    'Saved Messages',

                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text(
                    'Chat Settings',

                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'help',
                  child: Text(
                    'Help',

                  ),
                ),
              ],
              onSelected: (String value) {
                switch (value) {
                  case 'saved':
                    break;
                  case 'settings':
                    break;
                  case 'help':
                    break;
                }
              },
            ),
          ],
        ),
        body: _buildChatUI()
    );
  }

  Widget _buildChatUI() {
    return DashChat(
        messageOptions: const MessageOptions(
            showOtherUsersAvatar: true,
            showTime: true
        ),
        inputOptions: const InputOptions(
            alwaysShowSend: true,
            trailing: [

            ]
        ),
        currentUser: currentUser!,
        messages: hardcodedMessages,
        onSend: _sendMessage
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async{
    if(chatMessage.medias?.isNotEmpty ?? false){
      if(chatMessage.medias!.first.type == MediaType.image){
        final Message message = Message(
            senderID: chatMessage.user.id,
            content: chatMessage.medias!.first.url,
            messageType: MessageType.image,
            sentAt: chatMessage.createdAt
        );
      }

    }else{
      final Message message = Message(
          senderID: currentUser!.id,
          content: chatMessage.text,
          messageType: MessageType.text,
          sentAt: chatMessage.createdAt
      );

    }
  }
}
