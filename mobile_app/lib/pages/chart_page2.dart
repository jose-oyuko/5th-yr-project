import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: 'jose',
    lastName: 'jose',
  );
  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'agri',
    lastName: 'bot',
  );
  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  Future<Map<String, dynamic>?> postRequest(msg) async {
    // Define the URL endpoint.
    final url =
        Uri.parse('https://payload.vextapp.com/hook/XJOWCO5HU5/catch/hello');

    // Define your custom headers.
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'ApiKey': 'Api-Key W315hWGM.cdAgsdg8IyShB1boucXsv84LMwKtgUVq',
    };

    // Define the body of your POST request.
    final body = jsonEncode({"payload": msg.toString()});

    try {
      // Make the POST request.
      final http.Response response =
          await http.post(url, headers: headers, body: body);

      // Check the response status code.
      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON.
        final data = jsonDecode(response.body);
        debugPrint('Response data: $data');
        return data;
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the request.
      debugPrint('Error making POST request: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(
          0,
          166,
          126,
          1,
        ),
        title: const Center(
          child: Text(
            'Agri Bot Chat Page',
          ),
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromARGB(255, 73, 225, 59),
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile')
        ],
        currentIndex: 1,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });
    Iterable<Map<String, dynamic>?> messageHistory =
        _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return {'role': 'user', 'context': m.text};
      } else {
        return {'role': 'assistant', 'context': m.text};
      }
    }).toList();
    final request = await postRequest(messageHistory);
    if (request != null) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            createdAt: DateTime.now(),
            text: request['text'].toString(),
            user: _gptChatUser,
          ),
        );
      });
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
}
