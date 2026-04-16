import 'package:flutter/material.dart';

class ChatAssistantFab extends StatefulWidget {
  const ChatAssistantFab({super.key});

  @override
  State<ChatAssistantFab> createState() => _ChatAssistantFabState();
}

class _ChatAssistantFabState extends State<ChatAssistantFab> {
  bool _isChatOpen = false;
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = (screenWidth - 32).clamp(280.0, 430.0).toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isChatOpen) ...[
          _AiAssistantPanel(
            width: panelWidth,
            controller: _chatController,
            onSuggestionTap: (text) {
              setState(() {
                _chatController.text = text;
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

class _AiAssistantPanel extends StatelessWidget {
  const _AiAssistantPanel({
    required this.width,
    required this.controller,
    required this.onSuggestionTap,
  });

  final double width;
  final TextEditingController controller;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
              decoration: const BoxDecoration(
                color: Color(0xFF214B74),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
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
                      color: theme.colorScheme.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Selamat datang!  How can I help you today? You can ask about government services, applications, or payments.',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
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
                        color: theme.colorScheme.surface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Type your question...',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF214B74),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
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

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.surface,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
