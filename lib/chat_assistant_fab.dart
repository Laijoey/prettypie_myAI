import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'services/ai_service.dart';
import 'services/prefill_service.dart';
import 'services/service_navigation_intent.dart';

class ChatAssistantFab extends StatefulWidget {
  const ChatAssistantFab({super.key});

  @override
  State<ChatAssistantFab> createState() => _ChatAssistantFabState();
}

class _ChatAssistantFabState extends State<ChatAssistantFab> {
  bool _isChatOpen = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = (screenWidth - 32).clamp(320.0, 480.0).toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isChatOpen) ...[
          _AiAssistantPanel(
            width: panelWidth,
            onClose: () {
              setState(() {
                _isChatOpen = false;
              });
            },
          ),
          const SizedBox(height: 12),
        ],
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _isChatOpen = !_isChatOpen;
            });
          },
          backgroundColor: const Color(0xFF1F4468),
          child: Icon(
            _isChatOpen ? Icons.close : Icons.smart_toy_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _AiAssistantPanel extends StatefulWidget {
  const _AiAssistantPanel({required this.width, required this.onClose});

  final double width;
  final VoidCallback onClose;

  @override
  State<_AiAssistantPanel> createState() => _AiAssistantPanelState();
}

class _AiAssistantPanelState extends State<_AiAssistantPanel> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          'Ask me about STR, eKasih, PTPTN, licences, summons, or other government services.',
      isUser: false,
    ),
  ];

  static const List<_ChatShortcut> _shortcuts = [
    _ChatShortcut(label: 'STR/Welfare', prompt: 'Am I eligible for STR or eKasih?', icon: Icons.card_giftcard),
    _ChatShortcut(label: 'Student Loan', prompt: 'Tell me about PTPTN loan and waiving options.', icon: Icons.school),
    _ChatShortcut(label: 'License Renewal', prompt: 'How do I renew my driving license?', icon: Icons.directions_car),
    _ChatShortcut(label: 'Tax Filing', prompt: 'I need to file my income tax.', icon: Icons.description),
    _ChatShortcut(label: 'Summons Payment', prompt: 'How do I check and pay my summons?', icon: Icons.receipt),
    _ChatShortcut(label: 'EPF/Retirement', prompt: 'Help me with my EPF account management.', icon: Icons.savings),
  ];

  Map<String, dynamic> _userProfile = const {};
  bool _loadingProfile = true;
  bool _sendingChat = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final profileDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final profile = profileDoc.data() ?? const {};

      final documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .get();

      final documents = documentSnapshot.docs.map((doc) => doc.data()).toList();
      final prefill = PrefillService.buildPrefill(
        profile: profile,
        documents: documents,
      );

      final derivedIncome = _parseIncome(prefill['income']) ?? _parseIncome(profile['income']);
      final derivedAge = _parseAge(profile['age']) ?? _ageFromDob(profile['dob']);

      _userProfile = {
        ...profile,
        'income': derivedIncome,
        'age': derivedAge,
      };
    } catch (_) {
      _userProfile = const {};
    } finally {
      if (mounted) {
        setState(() => _loadingProfile = false);
      }
    }
  }

  int? _parseIncome(dynamic value) {
    if (value is num) {
      return value.round();
    }

    final text = value?.toString().replaceAll(RegExp(r'[^0-9.]'), '');
    if (text == null || text.isEmpty) {
      return null;
    }

    return double.tryParse(text)?.round();
  }

  int? _parseAge(dynamic value) {
    if (value is num) {
      return value.round();
    }

    return int.tryParse(value?.toString() ?? '');
  }

  int? _ageFromDob(dynamic value) {
    final dobText = value?.toString();
    if (dobText == null || dobText.isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(dobText);
    if (parsed == null) {
      return null;
    }

    final today = DateTime.now();
    var age = today.year - parsed.year;
    final hadBirthdayThisYear = today.month > parsed.month ||
        (today.month == parsed.month && today.day >= parsed.day);
    if (!hadBirthdayThisYear) {
      age -= 1;
    }
    return age;
  }

  AiChatResponse _buildFallbackResponse(String message) {
    final income = _parseIncome(_userProfile['income']) ?? 0;
    final age = _parseAge(_userProfile['age']) ?? 0;
    final lowerMessage = message.toLowerCase();

    if (income > 0 && income < 2000) {
      return AiChatResponse(
        reply:
            'Based on your profile, eKasih looks relevant because your income is below RM2000. You can open the services page and apply there.',
        toolsUsed: const [],
        actionLabel: 'Apply eKasih',
        actionRoute: '/services',
        workflow: const {'service': 'eKasih'},
      );
    }

    if (income > 0 && income < 5000) {
      return AiChatResponse(
        reply:
            'Based on your profile, STR looks relevant because your income is below RM5000. You can open the services page and apply there.',
        toolsUsed: const [],
        actionLabel: 'Apply STR',
        actionRoute: '/services',
        workflow: const {'service': 'STR Application'},
      );
    }

    if (lowerMessage.contains('license') || lowerMessage.contains('lesen')) {
      return AiChatResponse(
        reply:
            'For licence renewal, open the Services page and choose JPJ Licence Renewal. If you upload your document there, OCR will help prepare the form.',
        toolsUsed: const [],
        actionLabel: 'Open License Renewal',
        actionRoute: '/services',
        workflow: const {'service': 'License Renewal'},
      );
    }

    if (age >= 18 && lowerMessage.contains('vote')) {
      return AiChatResponse(
        reply:
            'You are old enough to register as a voter. Open the Services page to continue.',
        toolsUsed: const [],
        actionLabel: 'Open Services',
        actionRoute: '/services',
        workflow: const {'service': 'Voter Registration'},
      );
    }

    return AiChatResponse(
      reply:
          'I can help with STR, eKasih, PTPTN, licence renewal, summons payment, and document upload. Tell me which service you want, or open Services to continue.',
      toolsUsed: const [],
      actionLabel: 'Open Services',
      actionRoute: '/services',
      workflow: const {},
    );
  }

  String? _inferServiceTitle(String text) {
    final lower = text.toLowerCase();
    final map = <String, String>{
      'tax': 'Tax Filing',
      'lhdn': 'Tax Filing',
      'epf': 'EPF Management',
      'kwsp': 'EPF Management',
      'health': 'Health Services',
      'medical': 'Health Services',
      'clinic': 'Health Services',
      'vaccine': 'Health Services',
      'loan': 'Loan Payment',
      'ptptn': 'Loan Payment',
      'student': 'Loan Payment',
      'education': 'Loan Payment',
      'license': 'License Renewal',
      'lesen': 'License Renewal',
      'renew': 'License Renewal',
      'driving': 'License Renewal',
      'jpj': 'License Renewal',
      'summons': 'Summons Payment',
      'saman': 'Summons Payment',
      'traffic': 'Summons Payment',
      'fine': 'Summons Payment',
      'pdrm': 'Summons Payment',
    };

    for (final entry in map.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  Future<void> _sendChat() async {
    final message = _chatController.text.trim();
    if (message.isEmpty || _sendingChat) {
      return;
    }

    setState(() {
      _sendingChat = true;
      _messages.add(_ChatMessage(text: message, isUser: true));
      _chatController.clear();
    });
    _scrollChatToBottom();

    try {
      final response = await AiService.instance.chat(
        message: message,
        userProfile: _userProfile,
      );
      AiDraftStore.instance.lastChatResponse = response;

      if (!mounted) {
        return;
      }

      setState(() {
        final serviceTitle = _inferServiceTitle(
          '${response.reply} ${response.actionLabel ?? ''} $message',
        );
        _messages.add(
          _ChatMessage(
            text: response.reply,
            isUser: false,
            actionLabel: response.actionLabel,
            actionRoute: response.actionRoute,
            serviceTitle: serviceTitle,
          ),
        );
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      final fallback = _buildFallbackResponse(message);
      AiDraftStore.instance.lastChatResponse = fallback;

      setState(() {
        final serviceTitle = _inferServiceTitle(
          '${fallback.reply} ${fallback.actionLabel ?? ''} $message',
        );
        _messages.add(
          _ChatMessage(
            text: fallback.reply,
            isUser: false,
            actionLabel: fallback.actionLabel,
            actionRoute: fallback.actionRoute,
            serviceTitle: serviceTitle,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _sendingChat = false);
        _scrollChatToBottom();
      }
    }
  }

  void _scrollChatToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_chatScrollController.hasClients) {
        return;
      }

      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendShortcut(String prompt) {
    _chatController.text = prompt;
    _sendChat();
  }

  void _handleActionTap(String? route, String? serviceTitle) {
    widget.onClose();

    if (route == null || route.isEmpty) {
      return;
    }

    if (route.startsWith('/services')) {
      if (serviceTitle != null && serviceTitle.isNotEmpty) {
        ServiceNavigationIntent.targetServiceTitle = serviceTitle;
      }
      Navigator.of(context).pushReplacementNamed('/services');
      return;
    }

    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
=======
    final theme = Theme.of(context);

>>>>>>> Stashed changes
    return Material(
      color: Colors.transparent,
      child: Container(
        width: widget.width,
        height: 560,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F5),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x30000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF214B74),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
<<<<<<< Updated upstream
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SmartGOV AI Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Ask me anything about government services',
                    style: TextStyle(
                      color: Color(0xFFD6E0EA),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEE2E6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Selamat datang!  How can I help you today? You can ask about government services, applications, or payments.',
                      style: TextStyle(
                        color: Color(0xFF182637),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: [
                      _PromptChip(
                        label: 'How to apply bantuan?',
                        onTap: () => onSuggestionTap('How to apply bantuan?'),
                      ),
                      _PromptChip(
                        label: 'Check my tax status',
                        onTap: () => onSuggestionTap('Check my tax status'),
                      ),
                      _PromptChip(
                        label: 'Renew driving license',
                        onTap: () => onSuggestionTap('Renew driving license'),
                      ),
                      _PromptChip(
                        label: 'Pay PTPTN loan',
                        onTap: () => onSuggestionTap('Pay PTPTN loan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFD4D9DE)),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEE2E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Type your question...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9AA5B3),
=======
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SmartGOV AI Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Ask questions and get service recommendations.',
                          style: TextStyle(
                            color: Color(0xFFD6E0EA),
                            fontSize: 12,
>>>>>>> Stashed changes
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildChatTab(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        children: [
          // Enhanced Shortcuts Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF214B74).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF214B74).withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF214B74),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _shortcuts.map((shortcut) {
                    return InkWell(
                      onTap: _sendingChat ? null : () => _sendShortcut(shortcut.prompt),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF214B74).withValues(alpha: 0.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF214B74).withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              shortcut.icon,
                              size: 14,
                              color: const Color(0xFF214B74),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              shortcut.label,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF214B74),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loadingProfile
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _chatScrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _ChatBubble(
                        message: message,
                        onActionTap: message.actionRoute == null
                            ? null
                            : () => _handleActionTap(message.actionRoute, message.serviceTitle),
                        onReturnTap: widget.onClose,
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type your question...',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendChat(),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 46,
                height: 46,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF214B74),
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  onPressed: _sendingChat ? null : _sendChat,
                  child: _sendingChat
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.actionLabel,
    this.actionRoute,
    this.serviceTitle,
  });

  final String text;
  final bool isUser;
  final String? actionLabel;
  final String? actionRoute;
  final String? serviceTitle;
}

class _ChatShortcut {
  const _ChatShortcut({
    required this.label,
    required this.prompt,
    required this.icon,
  });

  final String label;
  final String prompt;
  final IconData icon;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.onActionTap,
    required this.onReturnTap,
  });

  final _ChatMessage message;
  final VoidCallback? onActionTap;
  final VoidCallback onReturnTap;

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
=======
    final alignment = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isUser ? const Color(0xFF214B74) : const Color(0xFFF1F5F9);
    final textColor = message.isUser ? Colors.white : const Color(0xFF1E2D3F);

    return Align(
      alignment: alignment,
>>>>>>> Stashed changes
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
<<<<<<< Updated upstream
          color: const Color(0xFFE8EDF2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1F4A72),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
=======
          color: bubbleColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!message.isUser && (message.actionLabel?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF7C51A),
                        foregroundColor: const Color(0xFF123A61),
                      ),
                      onPressed: onActionTap,
                      child: Text(message.actionLabel ?? 'Apply service'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onReturnTap,
                    child: const Text('Return'),
                  ),
                ],
              ),
            ],
          ],
>>>>>>> Stashed changes
        ),
      ),
    );
  }
}