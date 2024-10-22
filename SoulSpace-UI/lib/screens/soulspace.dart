import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soul/models/chat_session.dart';
import 'package:soul/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String? sessionId;

  const ChatScreen({Key? key, this.sessionId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatSession _currentSession;
  bool _isLoading = false;
  late String _userName;
  late Map<String, String> _questionnaireResponses;

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    if (widget.sessionId != null) {
      // Load existing session
      final existingSession =
          await HiveService.getChatSession(widget.sessionId!);
      if (existingSession != null) {
        setState(() {
          _currentSession = existingSession;
          _messages.addAll(existingSession.messages
              .map((m) => {'role': m.role, 'content': m.content}));
        });
      } else {
        // Handle case where session ID is provided but not found
        await _createNewSession();
      }
    } else {
      // Create new session
      await _createNewSession();
    }
    await _loadUserInfo();
    _addInitialBotMessage();
  }

  Future<void> _loadUserInfo() async {
    final userProfile = await HiveService.getUserProfile();
    _userName = userProfile?.name ?? 'User';
    _questionnaireResponses = await HiveService.getQuestionnaireResponses();
  }

  Future<void> _createNewSession() async {
    final newSession = ChatSession(
      id: const Uuid().v4(),
      title: 'New Chat',
      dateTime: DateTime.now(),
      messages: [],
    );
    await HiveService.saveChatSession(newSession);
    setState(() {
      _currentSession = newSession;
    });
  }

  void _addInitialBotMessage() {
    if (_messages.isEmpty) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content':
              "Hello $_userName! I'm SOULSCOPE, your AI mental health assistant. How are you feeling today?",
        });
      });
    }
  }

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });
    _scrollToBottom();

    // Get bot response
    final response = await _getBotResponse(text);
    setState(() {
      _messages.add({'role': 'assistant', 'content': response});
      _isLoading = false;
    });
    _scrollToBottom();

    // Update session
    _currentSession.messages = _messages
        .map((m) => ChatMessage(role: m['role']!, content: m['content']!))
        .toList();
    _currentSession.dateTime = DateTime.now();
    _currentSession.title = _generateSessionTitle();
    await HiveService.saveChatSession(_currentSession);
  }

  String _generateSessionTitle() {
    // Generate a title based on the first user message or use a default title
    final userMessages = _messages.where((m) => m['role'] == 'user');
    if (userMessages.isNotEmpty) {
      String firstMessage = userMessages.first['content']!;
      return firstMessage.length > 30
          ? '${firstMessage.substring(0, 30)}...'
          : firstMessage;
    }
    return 'Chat Session';
  }

  Future<String> _getBotResponse(String userInput) async {
    final Uri url =
        Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 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',
    };

    final List<Map<String, String>> conversationHistory = [
      {
        'role': 'system',
        'content':
            '''You are Soulscope, an AI mental health assistant based in India. Your primary functions are:
        1. Provide empathetic listening and support.
        2. Offer basic coping strategies for stress, anxiety, and depression.
        3. Suggest Indian resources for professional mental health support when necessary.
        4. Use a warm, friendly tone but maintain professional boundaries.
        5. Keep responses concise, ideally 2-3 sentences.
        6. If asked about your capabilities, be honest about being an AI without human-level understanding.
        7. Never diagnose mental health conditions.
        8. Encourage users to seek professional help for serious concerns.
        9. Remember user details within the conversation to provide personalized responses.
        10. Do not repeat your introduction unless explicitly asked.
        
        User's name: $_userName
        
        Questionnaire responses:
        ${_questionnaireResponses.entries.map((e) => "${e.key}: ${e.value}").join("\n")}
        
        Use this information to tailor your responses and provide personalized support.
        When user asks for the REPORT you should procide a report like a Therapist based on the conversations and overall analysis
        '''
      },
      ..._messages.map((m) => {'role': m['role']!, 'content': m['content']!}),
      {'role': 'user', 'content': userInput}
    ];

    final Map<String, dynamic> body = {
      'model': 'llama3-70b-8192',
      'messages': conversationHistory,
      'temperature': 0.7,
      'max_tokens': 150,
    };

    try {
      final response =
          await http.post(url, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['choices'][0]['message']['content'];
      } else {
        return 'Sorry, I encountered an error. Please try again.';
      }
    } catch (e) {
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Chat with SOULSCOPE',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black.withOpacity(1),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg2.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return message['role'] == 'user'
                        ? _buildUserMessage(message['content']!)
                        : _buildBotMessage(message['content']!);
                  },
                ),
              ),
              if (_isLoading) const LinearProgressIndicator(),
              _buildInputArea(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                _handleSubmitted(_textController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 50),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBotMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 50),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[800]!.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
