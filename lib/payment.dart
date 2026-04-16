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
                      onTap: () {},
                    ),
                  ),
                );
              },
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
  // ✅ List is managed here now
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

  Map<String, dynamic>? _activeBill;

  @override
  void initState() {
    super.initState();
    if (_bills.isNotEmpty) {
      _activeBill = _bills.first;
    }
  }

  void _onBillTapped(Map<String, dynamic> bill) {
    setState(() {
      _activeBill = bill;
    });
  }

  void _handlePaymentSuccess() {
    setState(() {
      // 1. Remove the paid bill
      _bills.removeWhere((b) => b['reference'] == _activeBill?['reference']);
      
      // 2. Automatically prefill the next bill in the list
      if (_bills.isNotEmpty) {
        _activeBill = _bills.first;
      } else {
        _activeBill = null;
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
                const SizedBox(height: 16),
                _OutstandingBillsCard(
                  bills: _bills,
                  onSelect: _onBillTapped,
                ),
                const SizedBox(height: 18),
                _MakePaymentCard(
                  billToPay: _activeBill,
                  onSuccess: _handlePaymentSuccess,
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
  final Function(Map<String, dynamic>) onSelect;

  const _OutstandingBillsCard({required this.bills, required this.onSelect});

  @override
  Widget build(BuildContext context) {
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
          if (bills.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("No bills remaining."),
            ),
          ...bills.map((bill) => Column(
            children: [
              _BillRow(
                title: bill["title"],
                subtitle: bill["subtitle"],
                dueDate: "Due: ${bill["due"]}",
                amount: "RM ${bill["amount"]}",
                onTap: () => onSelect(bill),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
            ],
          )),
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
  });

  final String title;
  final String subtitle;
  final String dueDate;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFE5F4FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.receipt_long_outlined, color: Color(0xFF2AA0E6), size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text('$subtitle - $dueDate', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
                ],
              ),
            ),
            Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _MakePaymentCard extends StatefulWidget {
  final Map<String, dynamic>? billToPay;
  final VoidCallback onSuccess;

  const _MakePaymentCard({this.billToPay, required this.onSuccess});

  @override
  State<_MakePaymentCard> createState() => _MakePaymentCardState();
}

class _MakePaymentCardState extends State<_MakePaymentCard> {
  String _selectedAgency = 'PDRM';
  final TextEditingController _refController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final String baseUrl = "https://prettypie-api-661875192859.asia-southeast1.run.app";

  @override
  void initState() {
    super.initState();
    _syncFields();
  }

  // ✅ This triggers the update when the parent changes the active bill
  @override
  void didUpdateWidget(_MakePaymentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.billToPay != oldWidget.billToPay) {
      _syncFields();
    }
  }

  void _syncFields() {
    if (widget.billToPay != null) {
      setState(() {
        _selectedAgency = widget.billToPay!['agency'];
        _refController.text = widget.billToPay!['reference'];
        _amountController.text = widget.billToPay!['amount'];
      });
    } else {
      _refController.clear();
      _amountController.clear();
    }
  }

  Future<void> _processPayment() async {
    if (widget.billToPay == null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();

      final response = await http.post(
        Uri.parse("$baseUrl/pay"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "agency": _selectedAgency,
          "reference": _refController.text,
          "amount": _amountController.text,
          "category": _selectedAgency.toLowerCase(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        widget.onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Successful!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
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
          const Text('Make Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PaymentField(
                  label: 'Agency',
                  child: DropdownButtonFormField<String>(
                    value: _selectedAgency,
                    items: const [
                      DropdownMenuItem(value: 'PDRM', child: Text('PDRM')),
                      DropdownMenuItem(value: 'JPJ', child: Text('JPJ')),
                      DropdownMenuItem(value: 'PTPTN', child: Text('PTPTN')),
                    ],
                    onChanged: (val) => setState(() => _selectedAgency = val!),
                    decoration: _fieldDecoration(context),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PaymentField(
                  label: 'Reference No.',
                  child: TextField(controller: _refController, decoration: _fieldDecoration(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _PaymentField(
            label: 'Amount (RM)',
            child: TextField(controller: _amountController, decoration: _fieldDecoration(context)),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton.icon(
              onPressed: _processPayment,
              icon: const Icon(Icons.lock_outline, size: 18),
              label: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.w700)),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1F4468),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF273449) : const Color(0xFFEFF2F6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

class _PaymentField extends StatelessWidget {
  const _PaymentField({required this.label, required this.child});
  final String label; final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _PaymentNavItem {
  const _PaymentNavItem(this.title, this.icon, this.active);
  final String title; final IconData icon; final bool active;
}