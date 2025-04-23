import 'package:edu_tech/Common/Commonsize.dart';
import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';

class EduNestChatbot extends StatefulWidget {
  @override
  _EduNestChatbotState createState() => _EduNestChatbotState();
}

class _EduNestChatbotState extends State<EduNestChatbot> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final Map<String, String> _chatbotResponses = {
    'hi': 'Hello! Welcome to Edu Nest.',
    'hello': 'Hi there! How can I assist you with your educational queries?',
    'how are you?': 'I am doing well, ready to help you learn!',
    'what is your name?': 'I am Edu Nest\'s learning assistant.',
    'tell me about courses': 'Edu Nest offers a wide range of courses, including Math, Science, Languages, and Programming. Which subject are you interested in?',
    'math': 'We have courses in Algebra, Geometry, Calculus, and more. Do you have a specific topic in mind?',
    'science': 'Our Science courses cover Physics, Chemistry, Biology, and Environmental Science. What area of Science are you curious about?',
    'programming': 'We offer courses in Python, Java, Flutter, and Web Development. Which programming language are you interested in learning?',
    'flutter': "Flutter is a great choice! We have beginner and advanced Flutter courses. Are you new to Flutter, or do you have some experience?",
    'explain a concept': 'Please provide the concept you\'d like explained, and I\'ll do my best to assist you.',
    'study tips': 'Here are some study tips: 1. Create a study schedule. 2. Take regular breaks. 3. Find a quiet study space. 4. Review your notes regularly. 5. Practice with sample questions.',
    'default': 'I do not understand. Please ask a question related to education.',
  };

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      String response = _chatbotResponses[text.toLowerCase()] ?? _chatbotResponses['default'].toString();
      _messages.add({'sender': 'chatbot', 'text': response});
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: 'Ask a question...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, String> message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: message['sender'] == 'user'
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: message['sender'] == 'user' ? Colors.blue[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SizedBox(
                width: displaywidth(context)*0.50,
                child: Text(message['text']!,style: commonstylepoppins())),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:common_appbar("Edu Nest ChatBot"),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _buildMessage(_messages[index]),
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}