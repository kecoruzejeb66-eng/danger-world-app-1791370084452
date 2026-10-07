import 'package:flutter/material.dart';

void main() {
  runApp(const AlayanSS2App());
}

class AlayanSS2App extends StatelessWidget {
  const AlayanSS2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alayan SS2 Members Group',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121B22),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00A884),
          secondary: Color(0xFF005C4B),
          surface: Color(0xFF1F2C34),
          background: Color(0xFF121B22),
          onBackground: Color(0xFFE9EDEF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2C34),
          elevation: 0,
        ),
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class User {
  final String username;
  final String phone;
  final String status;

  User({required this.username, required this.phone, this.status = 'Hey there! I am using Alayan SS2.'});
}

class Message {
  final String sender;
  final String text;
  final String time;

  Message({required this.sender, required this.text, required this.time});
}

// Global state for demonstration
class AppData {
  static final List<User> registeredUsers = [
    User(username: 'Alice Smith', phone: '111', status: 'At Alayan SS2 meetup'),
    User(username: 'Bob Jones', phone: '222', status: 'Coding Flutter apps'),
    User(username: 'Group Chat', phone: '000', status: 'Official SS2 Members Hub'),
  ];

  static User? currentUser;

  static final Map<String, List<Message>> chatMessages = {
    'Group Chat': [
      Message(sender: 'Alice Smith', text: 'Welcome everyone to Alayan SS2 Members Group!', time: '10:00 AM'),
      Message(sender: 'Bob Jones', text: 'Glad to be here! Great app.', time: '10:05 AM'),
    ],
    'Alice Smith': [
      Message(sender: 'Alice Smith', text: 'Hey, are we meeting today?', time: '9:30 AM'),
    ],
    'Bob Jones': [
      Message(sender: 'Bob Jones', text: 'Check out this new update.', time: 'Yesterday'),
    ]
  };
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final phone = _phoneController.text.trim();

      if (isLogin) {
        // Find user
        try {
          final user = AppData.registeredUsers.firstWhere(
            (u) => u.username.toLowerCase() == username.toLowerCase() && u.phone == phone,
          );
          AppData.currentUser = user;
          _navigateToHome();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or phone number. Register first!')),
          );
        }
      } else {
        // Register user
        final exists = AppData.registeredUsers.any((u) => u.username.toLowerCase() == username.toLowerCase());
        if (exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username already exists. Please login.')),
          );
        } else {
          final newUser = User(username: username, phone: phone);
          AppData.registeredUsers.add(newUser);
          AppData.currentUser = newUser;
          AppData.chatMessages[username] = [];
          _navigateToHome();
        }
      }
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Alayan SS2 - Login' : 'Alayan SS2 - Register'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_rounded,
                  size: 80,
                  color: Color(0xFF00A884),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Alayan SS2 Members',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (Password)',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Enter phone number' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A884),
                    ),
                    onPressed: _submit,
                    child: Text(
                      isLogin ? 'Login' : 'Register',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin ? 'Don\'t have an account? Register' : 'Already have an account? Login',
                    style: const TextStyle(color: Color(0xFF00A884)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alayan SS2'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AppData.currentUser = null;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00A884),
          labelColor: const Color(0xFF00A884),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'CHATS'),
            Tab(text: 'MEMBERS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChatListTab(),
          MembersListTab(),
        ],
      ),
    );
  }
}

class ChatListTab extends StatelessWidget {
  const ChatListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final users = AppData.registeredUsers.where((u) => u.username != AppData.currentUser?.username).toList();

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final messages = AppData.chatMessages[user.username] ?? [];
        final lastMessage = messages.isNotEmpty ? messages.last.text : user.status;
        final time = messages.isNotEmpty ? messages.last.time : '';

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF005C4B),
            child: Text(
              user.username[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(peerName: user.username),
              ),
            ).then((_) => (context as Element).markNeedsBuild());
          },
        );
      },
    );
  }
}

class MembersListTab extends StatelessWidget {
  const MembersListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: AppData.registeredUsers.length,
      itemBuilder: (context, index) {
        final user = AppData.registeredUsers[index];
        final isSelf = user.username == AppData.currentUser?.username;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF1F2C34),
            child: Text(
              user.username[0].toUpperCase(),
              style: const TextStyle(color: Color(0xFF00A884), fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            user.username + (isSelf ? ' (You)' : ''),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            user.status,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: isSelf
              ? null
              : IconButton(
                  icon: const Icon(Icons.message, color: Color(0xFF00A884)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(peerName: user.username),
                      ),
                    ).then((_) => (context as Element).markNeedsBuild());
                  },
                ),
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerName;

  const ChatScreen({super.key, required this.peerName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final timeStr = now.format(context);

    final newMessage = Message(
      sender: AppData.currentUser!.username,
      text: text,
      time: timeStr,
    );

    setState(() {
      AppData.chatMessages.putIfAbsent(widget.peerName, () => []);
      AppData.chatMessages[widget.peerName]!.add(newMessage);
      _messageController.clear();
    });

    // Simulate auto-reply for standalone immersion if chatting with bots
    if (widget.peerName == 'Group Chat' && text.toLowerCase().contains('hello')) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            AppData.chatMessages[widget.peerName]!.add(
              Message(sender: 'Alice Smith', text: 'Hello there! Welcome to SS2.', time: TimeOfDay.now().format(context)),
            );
          });
          _scrollToBottom();
        }
      });
    }

    _scrollToBottom();
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
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messages = AppData.chatMessages[widget.peerName] ?? [];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF005C4B),
              child: Text(
                widget.peerName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.peerName, style: const TextStyle(fontSize: 16)),
                const Text('Online', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0B141A),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg.sender == AppData.currentUser?.username;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF005C4B) : const Color(0xFF1F2C34),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.peerName == 'Group Chat' && !isMe)
                            Text(
                              msg.sender,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A884),
                              ),
                            ),
                          Text(
                            msg.text,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                msg.time,
                                style: const TextStyle(color: Colors.white54, fontSize: 10),
                              ),
                              if (isMe) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.done_all, size: 12, color: Colors.lightBlueAccent),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: const Color(0xFF1F2C34),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF2A3942),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF00A884),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}