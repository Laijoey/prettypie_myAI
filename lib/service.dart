import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEFF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: const [
                SizedBox(
                  width: 220,
                  child: _ServicesSidebar(),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Color(0xFFF5F5F7),
                    child: _ServicesBody(),
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

class _ServicesSidebar extends StatelessWidget {
  const _ServicesSidebar();

  static const _items = [
    _ServiceNavItem('Dashboard', Icons.dashboard_outlined, false),
    _ServiceNavItem('Services', Icons.grid_view_outlined, true),
    _ServiceNavItem('My Applications', Icons.description_outlined, false),
    _ServiceNavItem('Payments', Icons.account_balance_wallet_outlined, false),
    _ServiceNavItem('Notifications', Icons.notifications_none_outlined, false),
    _ServiceNavItem('Profile', Icons.person_outline, false),
    _ServiceNavItem('Settings', Icons.settings_outlined, false),
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
                        if (item.title == 'Dashboard') {
                          Navigator.of(context).pushReplacementNamed('/dashboard');
                        }
                        if (item.title == 'My Applications') {
                          Navigator.of(context).pushReplacementNamed('/applications');
                        }
                        if (item.title == 'Payments') {
                          Navigator.of(context).pushReplacementNamed('/payments');
                        }
                        if (item.title == 'Notifications') {
                          Navigator.of(context).pushReplacementNamed('/notifications');
                        }
                        if (item.title == 'Profile') {
                          Navigator.of(context).pushReplacementNamed('/profile');
                        }
                        if (item.title == 'Settings') {
                          Navigator.of(context).pushReplacementNamed('/settings');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: Row(
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
        ],
      ),
    );
  }
}

class _ServicesBody extends StatelessWidget {
  const _ServicesBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 28),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Government Services',
                  style: TextStyle(
                    color: Color(0xFF1E2D3F),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Access all government services in one place',
                  style: TextStyle(
                    color: Color(0xFF6B7B8D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                _SearchServicesField(),
                SizedBox(height: 20),
                _ServiceSectionTitle('Popular Services'),
                SizedBox(height: 10),
                _ServiceGrid(popular: true),
                SizedBox(height: 18),
                _ServiceSectionTitle('All Services'),
                SizedBox(height: 10),
                _ServiceGrid(popular: false),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchServicesField extends StatelessWidget {
  const _SearchServicesField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search services... (e.g. renew license, check tax, apply bantuan)',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: const Color(0xFFF2F4F7),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD9DEE5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD9DEE5)),
        ),
      ),
    );
  }
}

class _ServiceSectionTitle extends StatelessWidget {
  const _ServiceSectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF1E2D3F),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({required this.popular});

  final bool popular;

  @override
  Widget build(BuildContext context) {
    final items = popular ? _popularItems : _allItems;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 84,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _ServiceTile(
          item: item,
          showArrow: popular,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => _ServiceActionPage(item: item),
              ),
            );
          },
        );
      },
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.item,
    required this.showArrow,
    required this.onTap,
  });

  final _ServiceItem item;
  final bool showArrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD9DEE5)),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Color(0xFF1E2D3F),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF7D8D9D),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF7D8D9D),
                  size: 14,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceActionPage extends StatefulWidget {
  const _ServiceActionPage({required this.item});

  final _ServiceItem item;

  @override
  State<_ServiceActionPage> createState() => _ServiceActionPageState();
}

class _ServiceActionPageState extends State<_ServiceActionPage> {
  final _formKey = GlobalKey<FormState>();
  final _tinController = TextEditingController();
  final _idController = TextEditingController();
  final _amountController = TextEditingController();
  String _taxType = 'Income Tax (Cukai Pendapatan)';
  String _assessmentYear = '${DateTime.now().year}';
  String _paymentCode = '084';

  bool get _isTaxFiling => widget.item.title == 'Tax Filing';

  @override
  void dispose() {
    _tinController.dispose();
    _idController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitTaxPayment() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tax details saved. Continue to payment.')),
    );
    Navigator.of(context).pushNamed('/payments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(widget.item.title),
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
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: widget.item.iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.item.icon, color: widget.item.iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.title,
                          style: const TextStyle(
                            color: Color(0xFF1E2D3F),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Agency: ${widget.item.subtitle}',
                          style: const TextStyle(
                            color: Color(0xFF6F8094),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: _isTaxFiling ? _buildTaxForm() : _buildGenericForm(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF214B74),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isTaxFiling
                    ? _submitTaxPayment
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.item.title} service started.'),
                          ),
                        );
                      },
                child: Text(
                  _isTaxFiling ? 'Pay Tax Now' : 'Proceed',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenericForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start Service',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Identification Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Reference (optional)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxForm() {
    final years = List.generate(8, (index) => '${DateTime.now().year - index}');
    if (!years.contains(_assessmentYear)) {
      years.add(_assessmentYear);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tax Payment Details',
              style: TextStyle(
                color: Color(0xFF1E2D3F),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
                    padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                      color: const Color(0xFFF5F8FC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDCE5F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4FE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.upload_file_outlined,
                                color: Color(0xFF3DA5F5),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upload Tax Document',
                                    style: TextStyle(
                                      color: Color(0xFF1E2D3F),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'UI only for now. Uploaded tax document will be used to auto-fill this form later.',
                                    style: TextStyle(
                                      color: Color(0xFF607489),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.file_upload_outlined),
                            label: const Text('Choose Document'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFDCE5F0)),
                          ),
                          child: const Text(
                            'Accepted file: PDF, image, or document upload placeholder',
                            style: TextStyle(
                              color: Color(0xFF6F8094),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 12),
            const Text(
              '1. Tax Identification Number (TIN)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your personal tax number (e.g. SGXXXXXXXX / OGXXXXXXXX).',
              style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _tinController,
              decoration: const InputDecoration(
                labelText: 'Tax Identification Number (TIN)',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'TIN is required' : null,
            ),
            const SizedBox(height: 12),
            const Text(
              '2. Identification Number',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Use IC (MyKad) for Malaysians or Passport for foreigners.',
              style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'IC / Passport Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Identification number is required'
                  : null,
            ),
            const SizedBox(height: 12),
            const Text(
              '3. Type of Tax',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _taxType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Income Tax (Cukai Pendapatan)',
                  child: Text('Income Tax (Cukai Pendapatan)'),
                ),
                DropdownMenuItem(
                  value: 'PCB Balance',
                  child: Text('PCB Balance'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _taxType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            const Text(
              '4. Assessment Year (Tahun Taksiran)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Wrong year can result in incorrect payment records.',
              style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _assessmentYear,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: years
                  .map(
                    (year) => DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _assessmentYear = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            const Text(
              '5. Payment Code',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              '084 is commonly used for balance of tax payment.',
              style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _paymentCode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '084', child: Text('084 - Balance of tax')),
                DropdownMenuItem(value: '085', child: Text('085 - CP500 installment')),
                DropdownMenuItem(value: '086', child: Text('086 - Additional assessment')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _paymentCode = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            const Text(
              '6. Amount (RM)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount to pay (RM)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Amount is required';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
}

const List<_ServiceItem> _popularItems = [
  _ServiceItem(
    title: 'Tax Filing',
    subtitle: 'LHDN / MyTax',
    icon: Icons.attach_money,
    iconColor: Color(0xFF2ECC71),
    iconBg: Color(0xFFE8F6EE),
  ),
  _ServiceItem(
    title: 'EPF Management',
    subtitle: 'KWSP',
    icon: Icons.account_balance,
    iconColor: Color(0xFF3DA5F5),
    iconBg: Color(0xFFE8F4FE),
  ),
  _ServiceItem(
    title: 'Health Services',
    subtitle: 'KKM',
    icon: Icons.favorite_border,
    iconColor: Color(0xFFF5A623),
    iconBg: Color(0xFFFFF3E6),
  ),
  _ServiceItem(
    title: 'Loan Payment',
    subtitle: 'PTPTN',
    icon: Icons.school_outlined,
    iconColor: Color(0xFFE57373),
    iconBg: Color(0xFFFDEDEE),
  ),
  _ServiceItem(
    title: 'License Renewal',
    subtitle: 'JPJ',
    icon: Icons.directions_car_outlined,
    iconColor: Color(0xFF607489),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Summons Payment',
    subtitle: 'PDRM',
    icon: Icons.warning_amber_outlined,
    iconColor: Color(0xFFF5A623),
    iconBg: Color(0xFFFFF3E6),
  ),
];

const List<_ServiceItem> _allItems = [
  _ServiceItem(
    title: 'Birth Certificate',
    subtitle: 'JPN',
    icon: Icons.description_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Housing Application',
    subtitle: 'PR1MA',
    icon: Icons.home_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Social Welfare',
    subtitle: 'JKM',
    icon: Icons.people_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Business Registration',
    subtitle: 'SSM',
    icon: Icons.work_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Legal Aid',
    subtitle: 'BHEUU',
    icon: Icons.balance_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Passport Renewal',
    subtitle: 'JIM',
    icon: Icons.flight_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
];

class _ServiceNavItem {
  const _ServiceNavItem(this.title, this.icon, this.active);

  final String title;
  final IconData icon;
  final bool active;
}
