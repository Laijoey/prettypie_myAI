import 'dart:math';

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
      _bills.removeWhere((b) => b['reference'] == _selectedBill?['reference']);

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
  String _selectedAgency = 'PDRM';

  final TextEditingController _referenceController = TextEditingController(
    text: 'SUMM-102934',
  );

  final TextEditingController _amountController = TextEditingController(
    text: '300.00',
  );

  @override
  void didUpdateWidget(covariant _MakePaymentCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedBill != oldWidget.selectedBill &&
        widget.selectedBill != null) {
      final bill = widget.selectedBill!;

      setState(() {
        _selectedAgency = bill['agency'];
        _referenceController.text = bill['reference'];
        _amountController.text = bill['amount'].toString();
      });
    }
  }

  Future<void> _goToPaymentMethodPage() async {
    try {
      final reference = _referenceController.text.trim();
      final amountText = _amountController.text.trim();
      final amount = double.tryParse(amountText.replaceAll(',', ''));

      if (reference.isEmpty) {
        throw Exception('Please enter a reference number.');
      }

      if (amount == null || amount <= 0) {
        throw Exception('Please enter a valid amount.');
      }

      // ✅ Strict validation for selected bill
      if (widget.selectedBill != null) {
        final bill = widget.selectedBill!;

        final inputAmount = amount;
        final billAmount = double.tryParse(bill['amount'].toString()) ?? 0;

        if (_selectedAgency != bill['agency'] ||
            reference != bill['reference'] ||
            inputAmount != billAmount) {
          throw Exception("Bill verification failed.");
        }
      }

      // ✅ CALL PAYMENT
      final txnId = await _makePaymentRequest();

      // ✅ Update parent (remove paid bill)
      widget.onPaymentSuccess();

      if (!mounted) return;

      // ✅ Navigate after success
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _PaymentMethodPage(
            agency: _selectedAgency,
            referenceNo: reference,
            amount: amount!,
            transactionId: txnId,
          ),
        ),
      );
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

  Future<String> _makePaymentRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final token = await user.getIdToken();

    final baseUrl =
        "https://prettypie-api-661875192859.asia-southeast1.run.app";

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
      throw Exception(data["error"] ?? "Payment failed");
    }

    return data['data']['transactionId'];
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
                    onChanged: widget.selectedBill == null
                        ? (value) {
                            if (value != null) {
                              setState(() => _selectedAgency = value);
                            }
                          }
                        : null,
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
                    enabled: widget.selectedBill == null,
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
              enabled: widget.selectedBill == null,
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
              onPressed: _goToPaymentMethodPage,
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

class _PaymentMethodPage extends StatefulWidget {
  const _PaymentMethodPage({
    required this.agency,
    required this.referenceNo,
    required this.amount,
    required this.transactionId, 
  });

  final String agency;
  final String referenceNo;
  final double amount;
  final String transactionId; 

  @override
  State<_PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<_PaymentMethodPage> {
  String _selectedMethod = 'Online Banking (FPX)';

  static const _methods = [
    ('Online Banking (FPX)', Icons.account_balance_outlined),
    ('Debit / Credit Card', Icons.credit_card_outlined),
    ('E-Wallet', Icons.account_balance_wallet_outlined),
    ('DuitNow QR', Icons.qr_code_2_outlined),
  ];

  void _openMethodFlow() {
    Widget nextPage;
    if (_selectedMethod == 'Online Banking (FPX)') {
      nextPage = _FpxBankSelectionPage(
        agency: widget.agency,
        referenceNo: widget.referenceNo,
        amount: widget.amount,
      );
    } else if (_selectedMethod == 'Debit / Credit Card') {
      nextPage = _CardDetailsPage(
        agency: widget.agency,
        referenceNo: widget.referenceNo,
        amount: widget.amount,
      );
    } else if (_selectedMethod == 'E-Wallet') {
      nextPage = _EWalletSelectionPage(
        agency: widget.agency,
        referenceNo: widget.referenceNo,
        amount: widget.amount,
      );
    } else {
      nextPage = _DuitNowQrPage(
        agency: widget.agency,
        referenceNo: widget.referenceNo,
        amount: widget.amount,
      );
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => nextPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Choose Payment Method'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E2D3F),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD9DEE5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agency: ${widget.agency}',
                    style: const TextStyle(
                      color: Color(0xFF1E2D3F),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Reference No.: ${widget.referenceNo}',
                    style: const TextStyle(
                      color: Color(0xFF546579),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Amount: RM ${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF1F4468),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Select your payment method',
              style: TextStyle(
                color: Color(0xFF1E2D3F),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RadioGroup<String>(
                groupValue: _selectedMethod,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedMethod = value;
                  });
                },
                child: ListView.separated(
                  itemCount: _methods.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final method = _methods[index];
                    return RadioListTile<String>(
                      value: method.$1,
                      activeColor: const Color(0xFF1F4468),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFD9DEE5)),
                      ),
                      secondary: Icon(
                        method.$2,
                        color: const Color(0xFF1F4468),
                      ),
                      title: Text(
                        method.$1,
                        style: const TextStyle(
                          color: Color(0xFF1E2D3F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1F4468),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _openMethodFlow();
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FpxBankSelectionPage extends StatefulWidget {
  const _FpxBankSelectionPage({
    required this.agency,
    required this.referenceNo,
    required this.amount,
  });

  final String agency;
  final String referenceNo;
  final double amount;

  @override
  State<_FpxBankSelectionPage> createState() => _FpxBankSelectionPageState();
}

class _FpxBankSelectionPageState extends State<_FpxBankSelectionPage> {
  String _selectedBank = 'Maybank2u';

  static const _banks = [
    'Maybank2u',
    'CIMB Clicks',
    'Public Bank',
    'RHB Now',
    'Bank Islam',
    'Hong Leong Connect',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('FPX Bank Selection'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E2D3F),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PaymentSummaryCard(
              agency: widget.agency,
              referenceNo: widget.referenceNo,
              amount: widget.amount,
              methodLabel: 'Online Banking (FPX)',
            ),
            const SizedBox(height: 14),
            const Text(
              'Choose your bank',
              style: TextStyle(
                color: Color(0xFF1E2D3F),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RadioGroup<String>(
                groupValue: _selectedBank,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedBank = value;
                  });
                },
                child: ListView.separated(
                  itemCount: _banks.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final bank = _banks[index];
                    return RadioListTile<String>(
                      value: bank,
                      activeColor: const Color(0xFF1F4468),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFD9DEE5)),
                      ),
                      title: Text(
                        bank,
                        style: const TextStyle(
                          color: Color(0xFF1E2D3F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1F4468),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _PaymentConfirmationPage(
                        agency: widget.agency,
                        referenceNo: widget.referenceNo,
                        amount: widget.amount,
                        paymentMethod: 'FPX - $_selectedBank',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Continue to Bank',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardDetailsPage extends StatefulWidget {
  const _CardDetailsPage({
    required this.agency,
    required this.referenceNo,
    required this.amount,
  });

  final String agency;
  final String referenceNo;
  final double amount;

  @override
  State<_CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<_CardDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String get _cardHolderPreview {
    final text = _nameController.text.trim();
    return text.isEmpty ? 'CARDHOLDER NAME' : text.toUpperCase();
  }

  String get _cardNumberPreview {
    final digits = _numberController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '•••• •••• •••• ••••';
    }
    final groups = <String>[];
    for (var i = 0; i < digits.length; i += 4) {
      final end = (i + 4 < digits.length) ? i + 4 : digits.length;
      groups.add(digits.substring(i, end));
    }
    return groups.join(' ');
  }

  String get _expiryPreview {
    final text = _expiryController.text.trim();
    return text.isEmpty ? 'MM/YY' : text;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Card Details'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E2D3F),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PaymentSummaryCard(
                        agency: widget.agency,
                        referenceNo: widget.referenceNo,
                        amount: widget.amount,
                        methodLabel: 'Debit / Credit Card',
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF214B74), Color(0xFF102B45)],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE9C46A),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.contactless,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _cardNumberPreview,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'CARD HOLDER',
                                        style: TextStyle(
                                          color: Color(0xFFBCD2E6),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        _cardHolderPreview,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'VALID THRU',
                                      style: TextStyle(
                                        color: Color(0xFFBCD2E6),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      _expiryPreview,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD9DEE5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Accepted Cards',
                              style: TextStyle(
                                color: Color(0xFF1E2D3F),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: const [
                                _CardBrandBadge(
                                  label: 'VISA',
                                  color: Color(0xFF1434CB),
                                ),
                                _CardBrandBadge(
                                  label: 'MC',
                                  color: Color(0xFFEA001B),
                                ),
                                _CardBrandBadge(
                                  label: 'AMEX',
                                  color: Color(0xFF2E77BB),
                                ),
                                _CardBrandBadge(
                                  label: 'JCB',
                                  color: Color(0xFF0B8F3E),
                                ),
                                _CardBrandBadge(
                                  label: 'UNIONPAY',
                                  color: Color(0xFFCB1D2C),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD9DEE5)),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Cardholder Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                  ? 'Cardholder name is required'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _numberController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Card Number',
                                hintText: '16 digits',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                final digits =
                                    value?.replaceAll(RegExp(r'\s+'), '') ?? '';
                                if (digits.length < 13 ||
                                    digits.length > 19 ||
                                    int.tryParse(digits) == null) {
                                  return 'Enter a valid card number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _expiryController,
                                    onChanged: (_) => setState(() {}),
                                    decoration: const InputDecoration(
                                      labelText: 'Expiry (MM/YY)',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      final text = value?.trim() ?? '';
                                      final valid = RegExp(
                                        r'^(0[1-9]|1[0-2])\/\d{2}$',
                                      ).hasMatch(text);
                                      return valid ? null : 'Use MM/YY format';
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _cvvController,
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'CVV',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      final text = value?.trim() ?? '';
                                      final valid = RegExp(
                                        r'^\d{3,4}$',
                                      ).hasMatch(text);
                                      return valid ? null : 'Invalid CVV';
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1F4468),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _PaymentConfirmationPage(
                          agency: widget.agency,
                          referenceNo: widget.referenceNo,
                          amount: widget.amount,
                          paymentMethod: 'Debit / Credit Card',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Continue Payment',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardBrandBadge extends StatelessWidget {
  const _CardBrandBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.40)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _EWalletSelectionPage extends StatefulWidget {
  const _EWalletSelectionPage({
    required this.agency,
    required this.referenceNo,
    required this.amount,
  });

  final String agency;
  final String referenceNo;
  final double amount;

  @override
  State<_EWalletSelectionPage> createState() => _EWalletSelectionPageState();
}

class _EWalletSelectionPageState extends State<_EWalletSelectionPage> {
  String _selectedWallet = 'Touch n Go eWallet';

  static const _wallets = [
    'Touch n Go eWallet',
    'Boost',
    'GrabPay',
    'ShopeePay',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('E-Wallet Selection'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E2D3F),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PaymentSummaryCard(
              agency: widget.agency,
              referenceNo: widget.referenceNo,
              amount: widget.amount,
              methodLabel: 'E-Wallet',
            ),
            const SizedBox(height: 14),
            Expanded(
              child: RadioGroup<String>(
                groupValue: _selectedWallet,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedWallet = value;
                  });
                },
                child: ListView.separated(
                  itemCount: _wallets.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final wallet = _wallets[index];
                    return RadioListTile<String>(
                      value: wallet,
                      activeColor: const Color(0xFF1F4468),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFD9DEE5)),
                      ),
                      title: Text(
                        wallet,
                        style: const TextStyle(
                          color: Color(0xFF1E2D3F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1F4468),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _PaymentConfirmationPage(
                        agency: widget.agency,
                        referenceNo: widget.referenceNo,
                        amount: widget.amount,
                        paymentMethod: 'E-Wallet - $_selectedWallet',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Continue with E-Wallet',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DuitNowQrPage extends StatefulWidget {
  const _DuitNowQrPage({
    required this.agency,
    required this.referenceNo,
    required this.amount,
  });

  final String agency;
  final String referenceNo;
  final double amount;

  @override
  State<_DuitNowQrPage> createState() => _DuitNowQrPageState();
}

class _DuitNowQrPageState extends State<_DuitNowQrPage> {
  late List<List<bool>> _qrData;

  @override
  void initState() {
    super.initState();
    _qrData = _generateQrData();
  }

  List<List<bool>> _generateQrData() {
    const size = 29;
    final random = Random();
    final data = List.generate(
      size,
      (_) => List.generate(size, (_) => random.nextBool()),
    );

    void setFinder(int startRow, int startCol) {
      for (var row = 0; row < 7; row++) {
        for (var col = 0; col < 7; col++) {
          final currentRow = startRow + row;
          final currentCol = startCol + col;
          final border = row == 0 || row == 6 || col == 0 || col == 6;
          final center = row >= 2 && row <= 4 && col >= 2 && col <= 4;
          data[currentRow][currentCol] = border || center;
        }
      }
    }

    setFinder(0, 0);
    setFinder(0, size - 7);
    setFinder(size - 7, 0);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('DuitNow QR Payment'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E2D3F),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PaymentSummaryCard(
              agency: widget.agency,
              referenceNo: widget.referenceNo,
              amount: widget.amount,
              methodLabel: 'DuitNow QR',
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD9DEE5)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Scan this random QR with your banking app',
                      style: TextStyle(
                        color: Color(0xFF1E2D3F),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFD9DEE5),
                              ),
                              color: Colors.white,
                            ),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _qrData.length * _qrData.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: _qrData.length,
                                  ),
                              itemBuilder: (context, index) {
                                final row = index ~/ _qrData.length;
                                final col = index % _qrData.length;
                                return Container(
                                  color: _qrData[row][col]
                                      ? Colors.black
                                      : Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _qrData = _generateQrData();
                              });
                            },
                            child: const Text('Generate New QR'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF1F4468),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => _PaymentConfirmationPage(
                                    agency: widget.agency,
                                    referenceNo: widget.referenceNo,
                                    amount: widget.amount,
                                    paymentMethod: 'DuitNow QR',
                                  ),
                                ),
                              );
                            },
                            child: const Text('I Have Paid'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  const _PaymentSummaryCard({
    required this.agency,
    required this.referenceNo,
    required this.amount,
    required this.methodLabel,
  });

  final String agency;
  final String referenceNo;
  final double amount;
  final String methodLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agency: $agency',
            style: const TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Reference No.: $referenceNo',
            style: const TextStyle(
              color: Color(0xFF546579),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Method: $methodLabel',
            style: const TextStyle(
              color: Color(0xFF546579),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Amount: RM ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF1F4468),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentConfirmationPage extends StatefulWidget {
  const _PaymentConfirmationPage({
    required this.agency,
    required this.referenceNo,
    required this.amount,
    required this.paymentMethod,
  });

  final String agency;
  final String referenceNo;
  final double amount;
  final String paymentMethod;

  @override
  State<_PaymentConfirmationPage> createState() =>
      _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<_PaymentConfirmationPage> {
  bool _isProcessing = true;
  late final String _transactionId;
  late final DateTime _processedAt;

  @override
  void initState() {
    super.initState();
    _processedAt = DateTime.now();
    _transactionId = _generateTransactionId(_processedAt);
    _simulatePaymentProcessing();
  }

  String _generateTransactionId(DateTime dateTime) {
    final randomPart = Random().nextInt(900000) + 100000;
    final datePart =
        '${dateTime.year.toString().padLeft(4, '0')}'
        '${dateTime.month.toString().padLeft(2, '0')}'
        '${dateTime.day.toString().padLeft(2, '0')}'
        '${dateTime.hour.toString().padLeft(2, '0')}'
        '${dateTime.minute.toString().padLeft(2, '0')}'
        '${dateTime.second.toString().padLeft(2, '0')}';
    return 'TXN-$datePart-$randomPart';
  }

  String _formatTimestamp(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute:$second';
  }

  Future<void> _simulatePaymentProcessing() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    setState(() {
      _isProcessing = false;
    });
  }

  void _backToPayments() {
    Navigator.of(
      context,
    ).popUntil((route) => route.settings.name == '/payments' || route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Payment Confirmation'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E2D3F),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD9DEE5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agency: ${widget.agency}',
                    style: const TextStyle(
                      color: Color(0xFF1E2D3F),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Reference No.: ${widget.referenceNo}',
                    style: const TextStyle(
                      color: Color(0xFF546579),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Payment Method: ${widget.paymentMethod}',
                    style: const TextStyle(
                      color: Color(0xFF546579),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Amount: RM ${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF1F4468),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD9DEE5)),
                ),
                child: _isProcessing
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFF1F4468)),
                          SizedBox(height: 16),
                          Text(
                            'Processing your payment...',
                            style: TextStyle(
                              color: Color(0xFF1E2D3F),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please do not close this page.',
                            style: TextStyle(
                              color: Color(0xFF6F8094),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7F7EE),
                              borderRadius: BorderRadius.circular(37),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Color(0xFF2E9E63),
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Payment Successful',
                            style: TextStyle(
                              color: Color(0xFF1E2D3F),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your transaction has been completed securely.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6F8094),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFD9DEE5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transaction ID: $_transactionId',
                                  style: const TextStyle(
                                    color: Color(0xFF1E2D3F),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Paid at: ${_formatTimestamp(_processedAt)}',
                                  style: const TextStyle(
                                    color: Color(0xFF546579),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: FilledButton(
                              onPressed: _backToPayments,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1F4468),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Back to Payments',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentNavItem {
  const _PaymentNavItem(this.title, this.icon, this.active);
  final String title;
  final IconData icon;
  final bool active;
}
