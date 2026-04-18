import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                const SizedBox(width: 220, child: _PaymentSidebar()),
                Expanded(
                  child: ColoredBox(
                    color: theme.scaffoldBackgroundColor,
                    child: const _PaymentBody(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const ChatAssistantFab(),
    );
  }
}

class _PaymentSidebar extends StatelessWidget {
  const _PaymentSidebar();

  static const _items = [
    _PaymentNavItem('Dashboard', Icons.dashboard_outlined, false),
    _PaymentNavItem('Services', Icons.grid_view_outlined, false),
    _PaymentNavItem('My Applications', Icons.description_outlined, false),
    _PaymentNavItem('Payments', Icons.account_balance_wallet_outlined, true),
    _PaymentNavItem('Notifications', Icons.notifications_none_outlined, false),
    _PaymentNavItem('Profile', Icons.person_outline, false),
    _PaymentNavItem('Settings', Icons.settings_outlined, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF214B74),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7C51A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF123A61),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SmartGOV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'One-Stop Portal',
                      style: TextStyle(
                        color: Color(0xFF9DB3C7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item.active
                          ? Colors.white.withValues(alpha: 0.10)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Icon(item.icon, color: const Color(0xFFC2D1DF)),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          color: Color(0xFFC2D1DF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        final routes = {
                          'Dashboard': '/dashboard',
                          'Services': '/services',
                          'My Applications': '/applications',
                          'Notifications': '/notifications',
                          'Profile': '/profile',
                          'Settings': '/settings',
                        };
                        if (routes.containsKey(item.title)) {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(routes[item.title]!);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                // IMPORTANT: clear navigation stack
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Color(0xFFC2D1DF)),
                  SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFC2D1DF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBody extends StatefulWidget {
  const _PaymentBody();

  @override
  State<_PaymentBody> createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<_PaymentBody> {
  // Centralized List of Bills
  final List<Map<String, dynamic>> _bills = [
    {
      "title": "Traffic Summons",
      "subtitle": "PDRM",
      "due": "20 Apr 2026",
      "amount": "300.00",
      "agency": "PDRM",
      "reference": "SUMM-102934",
    },
    {
      "title": "Road Tax Renewal",
      "subtitle": "JPJ",
      "due": "19 Apr 2026",
      "amount": "90.00",
      "agency": "JPJ",
      "reference": "JPJ-77821",
    },
    {
      "title": "PTPTN Monthly Payment",
      "subtitle": "PTPTN",
      "due": "15 Apr 2026",
      "amount": "120.00",
      "agency": "PTPTN",
      "reference": "PTPTN-55211",
    },
  ];

  Map<String, dynamic>? _selectedBill;

  @override
  void initState() {
    super.initState();
    if (_bills.isNotEmpty) {
      _selectedBill = _bills.first;
    }
  }

  void _handleBillSelected(Map<String, dynamic> bill) {
    setState(() {
      _selectedBill = bill;
    });
  }

  void _handlePaymentSuccess() {
    setState(() {
      // Remove the bill that was just paid
      _bills.removeWhere((b) => b['reference'] == _selectedBill?['reference']);

      // Auto-fill the next bill in the list if available
      if (_bills.isNotEmpty) {
        _selectedBill = _bills.first;
      } else {
        _selectedBill = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payments',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pay your government bills securely in one place',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                _OutstandingBillsCard(
                  bills: _bills,
                  selectedReference: _selectedBill?['reference'],
                  onSelectBill: _handleBillSelected,
                ),
                const SizedBox(height: 18),
                _MakePaymentCard(
                  selectedBill: _selectedBill,
                  onPaymentSuccess: _handlePaymentSuccess,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OutstandingBillsCard extends StatelessWidget {
  final List<Map<String, dynamic>> bills;
  final String? selectedReference;
  final Function(Map<String, dynamic>) onSelectBill;

  const _OutstandingBillsCard({
    required this.bills,
    required this.onSelectBill,
    this.selectedReference,
  });

  @override
  Widget build(BuildContext context) {
    if (bills.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Text(
                  'Outstanding Bills',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ...bills.map((bill) {
            final isSelected = bill['reference'] == selectedReference;
            return Column(
              children: [
                _BillRow(
                  title: bill["title"],
                  subtitle: bill["subtitle"],
                  dueDate: "Due: ${bill["due"]}",
                  amount: "RM ${bill["amount"]}",
                  isSelected: isSelected,
                  onTap: () => onSelectBill(bill),
                ),
                if (bill != bills.last)
                  Divider(height: 1, color: Theme.of(context).dividerColor),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow({
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.amount,
    required this.onTap,
    this.isSelected = false,
  });

  final String title;
  final String subtitle;
  final String dueDate;
  final String amount;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFE5F4FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFF2AA0E6),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$subtitle - $dueDate',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MakePaymentCard extends StatefulWidget {
  final Map<String, dynamic>? selectedBill;
  final VoidCallback onPaymentSuccess;

  const _MakePaymentCard({this.selectedBill, required this.onPaymentSuccess});

  @override
  State<_MakePaymentCard> createState() => _MakePaymentCardState();
}

class _MakePaymentCardState extends State<_MakePaymentCard> {
  String _selectedAgency = 'LHDN';
  late TextEditingController _referenceController;
  late TextEditingController _amountController;
  final String baseUrl =
      "https://prettypie-api-661875192859.asia-southeast1.run.app";

  @override
  void initState() {
    super.initState();
    _referenceController = TextEditingController(
      text: widget.selectedBill?['reference'] ?? '',
    );
    _amountController = TextEditingController(
      text: widget.selectedBill?['amount'] ?? '',
    );
    _selectedAgency = widget.selectedBill?['agency'] ?? 'LHDN';
  }

  @override
  void didUpdateWidget(_MakePaymentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedBill != oldWidget.selectedBill) {
      _referenceController.text = widget.selectedBill?['reference'] ?? '';
      _amountController.text = widget.selectedBill?['amount'] ?? '';
      _selectedAgency = widget.selectedBill?['agency'] ?? 'LHDN';
    }
  }

  String getCategory(String agency) {
    switch (agency) {
      case "LHDN":
        return "lhdn";
      case "KWSP":
        return "kwsp";
      case "KKM":
        return "kkm";
      case "PTPTN":
        return "ptptn";
      case "JPJ":
        return "jpj";
      case "PDRM":
        return "pdrm";
      default:
        return "general";
    }
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> makePayment() async {
    try {
      // 1. Check if a bill is actually selected
      if (widget.selectedBill == null) {
        throw Exception("No bill selected to pay.");
      }

      // 2. STRICT VALIDATION: Match form fields against the selected bill data
      bool agencyMatches = _selectedAgency == widget.selectedBill?['agency'];
      bool amountMatches =
          _amountController.text == widget.selectedBill?['amount'];
      bool refMatches =
          _referenceController.text == widget.selectedBill?['reference'];

      if (!agencyMatches || !amountMatches || !refMatches) {
        throw Exception(
          "Verification failed: Agency, Reference, or Amount does not match the selected bill.",
        );
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final token = await user.getIdToken();

      final response = await http.post(
        Uri.parse("$baseUrl/pay"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "agency": _selectedAgency,
          "reference": _referenceController.text,
          "amount": _amountController.text,
          "category": getCategory(_selectedAgency),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200 || data["success"] != true) {
        throw Exception(data["error"] ?? "Unknown error");
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Payment Success ✅ TXN: ${data['data']['transactionId']}",
            ),
          ),
        );
        widget.onPaymentSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make Payment',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PaymentField(
                  label: 'Agency',
                  child: DropdownButtonFormField<String>(
                    value: _selectedAgency,
                    items: const [
                      DropdownMenuItem(value: 'LHDN', child: Text('LHDN')),
                      DropdownMenuItem(value: 'KWSP', child: Text('KWSP')),
                      DropdownMenuItem(value: 'KKM', child: Text('KKM')),
                      DropdownMenuItem(value: 'PTPTN', child: Text('PTPTN')),
                      DropdownMenuItem(value: 'JPJ', child: Text('JPJ')),
                      DropdownMenuItem(value: 'PDRM', child: Text('PDRM')),
                    ],
                    onChanged: (value) {
                      if (value != null)
                        setState(() => _selectedAgency = value);
                    },
                    decoration: _fieldDecoration(context),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PaymentField(
                  label: 'Reference No.',
                  child: TextField(
                    controller: _referenceController,
                    decoration: _fieldDecoration(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _PaymentField(
            label: 'Amount (RM)',
            child: TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _fieldDecoration(context),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton.icon(
              onPressed: makePayment,
              icon: const Icon(Icons.lock_outline, size: 18),
              label: const Text(
                'Pay Now',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1F4468),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InputDecoration(
      filled: true,
      fillColor: isDark ? const Color(0xFF273449) : const Color(0xFFEFF2F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFD9DEE5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFD9DEE5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
    );
  }
}

class _PaymentField extends StatelessWidget {
  const _PaymentField({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _PaymentNavItem {
  const _PaymentNavItem(this.title, this.icon, this.active);
  final String title;
  final IconData icon;
  final bool active;
}
