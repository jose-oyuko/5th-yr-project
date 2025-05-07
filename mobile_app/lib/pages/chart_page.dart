import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/components/chat_bubble.dart';
import 'package:mobile_app/components/my_text_fields.dart';
import 'package:mobile_app/services/chat/chat_service.dart';

class ChartPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChartPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        debugPrint('Pickde file: ${pickedFile.path}');
      } else {
        debugPrint('No image selected');
      }
    } catch (e) {
      debugPrint('Error picking image: ${e.toString()}');
    }
  }

  void showAttachOptions() {
    // find the render box of the attach icon
    final RenderBox button = context.findRenderObject() as RenderBox;
    // get overlay's render box
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    // compute the global position of the button
    final Offset buttonPosition =
        button.localToGlobal(Offset.zero, ancestor: overlay);

    // relative postion of the menu
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy - button.size.height,
      buttonPosition.dx + button.size.width,
      buttonPosition.dy,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<String>(
          value: 'gallary',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.photo_library),
              SizedBox(
                width: 8,
              ),
              Text('Gallery'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'camera',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt),
              SizedBox(
                width: 8,
              ),
              Text('Camera'),
            ],
          ),
        )
      ],
    ).then((selectedValue) {
      if (selectedValue == 'gallery') {
        _pickImage(ImageSource.gallery);
      } else if (selectedValue == 'camers') {
        _pickImage(ImageSource.camera);
      }
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading ...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // aligning the messages to the right and to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          IconButton(
            onPressed: showAttachOptions,
            icon: const Icon(
              Icons.attach_file,
            ),
          ),
          // text field
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),
          // send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              // size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
