import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  // Example messages
  final List<Map<String, dynamic>> messages = const [
    {
      'sender': 'Carsome Support',
      'avatar': Icons.support_agent,
      'message': 'Your inspection is confirmed for tomorrow 10:00AM.',
      'time': '1h ago',
      'unread': true,
    },
    {
      'sender': 'John Doe',
      'avatar': Icons.person,
      'message': 'Can I schedule a test drive for Friday?',
      'time': '3h ago',
      'unread': false,
    },
    {
      'sender': 'Carsome',
      'avatar': Icons.directions_car,
      'message': 'Congrats! Your car listing is now live.',
      'time': 'Yesterday',
      'unread': true,
    },
    {
      'sender': 'Inspection Team',
      'avatar': Icons.assignment_turned_in,
      'message': 'Please upload your vehicle documents.',
      'time': '2d ago',
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211F24),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Inbox",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: messages.isEmpty
          ? _emptyInbox()
          : ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (_, __) => const Divider(
                color: Colors.white12,
                indent: 18,
                endIndent: 18,
                height: 0,
              ),
              itemBuilder: (context, i) => _messageTile(context, messages[i]),
            ),
      // bottomNavigationBar: _bottomNavBar(context), // Removed nav bar
    );
  }

  Widget _emptyInbox() => Center(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail_outline, color: Colors.white24, size: 72),
          const SizedBox(height: 20),
          Text(
            "Your inbox is empty",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You have no messages yet.",
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  Widget _messageTile(BuildContext context, Map<String, dynamic> msg) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFD69C39).withOpacity(0.13),
        child: Icon(msg['avatar'], color: const Color(0xFFD69C39)),
      ),
      title: Text(
        msg['sender'],
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: msg['unread'] ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        msg['message'],
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontWeight: msg['unread'] ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            msg['time'],
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
          ),
          if (msg['unread'])
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFFD69C39),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      onTap: () {
        // TODO: Navigate to message details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Open message from ${msg['sender']}')),
        );
      },
    );
  }
}
