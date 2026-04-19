import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: const ChatAssistantFab(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                // ================= SIDEBAR =================
                const SizedBox(width: 220, child: _ServicesSidebar()),

                // ================= MAIN CONTENT =================
                Expanded(
                  child: ColoredBox(
                    color: isDark
                        ? theme.scaffoldBackgroundColor
                        : const Color(0xFFF5F5F7),
                    child: const _ServicesBody(),
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
                Column(
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
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/dashboard');
                        }
                        if (item.title == 'My Applications') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/applications');
                        }
                        if (item.title == 'Payments') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/payments');
                        }
                        if (item.title == 'Notifications') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/notifications');
                        }
                        if (item.title == 'Profile') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/profile');
                        }
                        if (item.title == 'Settings') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/settings');
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

class _ServicesBody extends StatefulWidget {
  const _ServicesBody();

  @override
  State<_ServicesBody> createState() => _ServicesBodyState();
}

class _ServicesBodyState extends State<_ServicesBody> {
  String query = '';
  bool _showAllServices = false;
  final List<ServiceItem> _allItems = [
    ..._popularItems,
    ..._governmentServices,
  ];

  @override
  Widget build(BuildContext context) {
    final lowerQuery = query.toLowerCase();

    List<ServiceItem> filter(List<ServiceItem> items) {
      return items.where((item) {
        final titleMatch = item.title.toLowerCase().contains(lowerQuery);
        final subtitleMatch = item.subtitle.toLowerCase().contains(lowerQuery);

        final subServiceMatch =
            _subServiceMap[item.title]?.any(
              (sub) => sub.toLowerCase().contains(lowerQuery),
            ) ??
            false;

        return titleMatch || subtitleMatch || subServiceMatch;
      }).toList();
    }

    final filteredPopular = filter(_popularItems);
    final filteredAll = filter(_allItems);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= TITLE =================
                Text(
                  'Government Services',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Access all government services in one place',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                // ================= SEARCH =================
                SearchServicesField(
                  onSearch: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ================= MAIN LOGIC (NO UI CHANGE) =================
                if (query.isNotEmpty) ...[
                  _ServiceSectionTitle('Popular Services'),
                  const SizedBox(height: 10),
                  filteredPopular.isEmpty
                      ? const Text("No results found")
                      : _ServiceGrid(items: filteredPopular, showArrow: true),

                  const SizedBox(height: 18),

                  _ServiceSectionTitle('All Services'),
                  const SizedBox(height: 10),
                  filteredAll.isEmpty
                      ? const Text("No results found")
                      : _ServiceGrid(items: filteredAll, showArrow: false),
                ] else ...[
                  SearchServicesField(
                    onSearch: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  const _ServiceSectionTitle('Popular Services'),
                  const SizedBox(height: 10),
                  _ServiceGrid(items: _popularItems, showArrow: true),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const _ServiceSectionTitle('All Services'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showAllServices = !_showAllServices;
                          });
                        },
                        child: Text(
                          _showAllServices ? 'Show Less' : 'View All',
                          style: const TextStyle(
                            color: Color(0xFF214B74),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  _ServiceGrid(
                    items: _showAllServices
                        ? _allItems
                        : _allItems.take(6).toList(),
                    showArrow: false,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchServicesField extends StatefulWidget {
  final Function(String) onSearch;

  const SearchServicesField({super.key, required this.onSearch});

  @override
  State<SearchServicesField> createState() => _SearchServicesFieldState();
}

class _SearchServicesFieldState extends State<SearchServicesField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    // ✅ debounce (avoid too many calls)
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged, // 🔥 search while typing
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText:
            'Search services... (e.g. renew license, check tax, apply bantuan)',

        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),

        prefixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.onSurfaceVariant,
        ),

        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onSearch('');
                  setState(() {}); // refresh clear button
                },
              )
            : null,

        filled: true,
        fillColor: theme.colorScheme.surface,

        contentPadding: const EdgeInsets.symmetric(vertical: 12),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.dividerColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.dividerColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.primary),
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
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({required this.items, required this.showArrow});

  final List<ServiceItem> items;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
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
          showArrow: showArrow,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ServiceActionPage(item: item)),
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
    super.key,
  });

  final ServiceItem item;
  final bool showArrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    //     final Map<String, String> routeMap = {
    //       'Tax Filing': '/tax',
    //       'EPF Management': '/epf',
    //       'Health Services': '/health',
    //       'Loan Payment': '/ptptn',
    //       'License Renewal': '/jpj',
    //       'Summons Payment': '/pdrm',
    // };
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
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

class ServiceActionPage extends StatefulWidget {
  const ServiceActionPage({required this.item});

  final ServiceItem item;

  @override
  State<ServiceActionPage> createState() => _ServiceActionPageState();
}

class _ServiceActionPageState extends State<ServiceActionPage> {
  final _formKey = GlobalKey<FormState>();
  final _tinController = TextEditingController();
  final _idController = TextEditingController();
  final _amountController = TextEditingController();
  String _taxType = 'Income Tax (Cukai Pendapatan)';
  String _assessmentYear = '${DateTime.now().year}';
  String _paymentCode = '084';

  bool get _isTaxFiling => widget.item.title == 'Tax Filing';
  bool get _isEpfManagement => widget.item.title == 'EPF Management';
  bool get _isHealthService => widget.item.title == 'Health Services';
  bool get _isLoanPayment => widget.item.title == 'Loan Payment';
  bool get _isLicenseRenewal => widget.item.title == 'License Renewal';
  bool get _isSummonsPayment => widget.item.title == 'Summons Payment';

  bool isLoading = false;
  Map<String, dynamic>? taxResult;
  Map<String, dynamic>? income;
  List<dynamic>? reliefs;
  String? taxStatus;

  final String baseUrl =
      "https://prettypie-api-661875192859.asia-southeast1.run.app";

  @override
  void dispose() {
    _tinController.dispose();
    _idController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> fillWithAI() async {
    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user!.getIdToken();

      final response = await http.post(
        Uri.parse("$baseUrl/auto-fill-profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"uid": user.uid}),
      );

      final data = jsonDecode(response.body);

      final profile = data["data"];

      setState(() {
        // ✅ PREFILL FORM (USER CAN STILL EDIT)
        _tinController.text = profile["tin"] ?? "";
        _idController.text = profile["identificationNumber"] ?? "";
        _amountController.text =
            profile["estimatedTax"]?.toString() ?? _amountController.text;

        _taxType = profile["taxType"] ?? _taxType;
        _assessmentYear = profile["assessmentYear"] ?? _assessmentYear;
        _paymentCode = profile["paymentCode"] ?? _paymentCode;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form filled with AI suggestions ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("AI fill failed: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> uploadDocument(String type) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
        withData: true,
      );

      if (result == null || result.files.first.bytes == null) return;

      final file = result.files.first;

      setState(() => isLoading = true);

      final user = FirebaseAuth.instance.currentUser;
      final token = await user!.getIdToken();

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/upload-doc"), // ✅ updated endpoint
      );

      request.headers["Authorization"] = "Bearer $token";

      // ✅ ADD TYPE (epf, health, loan, lesen, summons)
      request.fields["type"] = type;

      request.files.add(
        http.MultipartFile.fromBytes("file", file.bytes!, filename: file.name),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("UPLOAD STATUS: ${response.statusCode}");
      print("UPLOAD RESPONSE: $responseBody");

      final data = jsonDecode(responseBody);

      if (response.statusCode != 200 || data["success"] != true) {
        throw Exception(data["error"] ?? "Upload failed");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Document uploaded successfully ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    } finally {
      setState(() => isLoading = false);
    }
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

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.item.title} draft saved.')),
    );
  }

  String get _submitButtonLabel => switch (widget.item.title) {
    'Tax Filing' => 'Pay Tax Now',
    'EPF Management' => 'Submit Application',
    'Health Services' => 'Book Appointment',
    'Loan Payment' => 'Submit Payment',
    'License Renewal' => 'Renew License',
    'Summons Payment' => 'Pay Summons',
    'MyKad Replacement' => 'Submit Request',
    'Birth Certificate Extract' => 'Request Extract',
    'Marriage Registration' => 'Book Appointment',
    'Passport Renewal' => 'Renew Passport',
    'Road Tax Renewal' => 'Renew Road Tax',
    'Business Registration' => 'Register Business',
    'Legal Aid' => 'Submit Appeal',
    'Vehicle Ownership Transfer' => 'Submit Transfer',
    'eKasih Registration' => 'Submit Registration',
    'Tax Refund Status' => 'Check Refund',
    'Zakat Payment' => 'Pay Zakat',
    'Public Complaints (SISPAA)' => 'Submit Complaint',
    'Civil Service Recruitment' => 'Submit Application',
    'Welfare Aid (eBantuan)' => 'Apply Now',
    'SOCSO Claims' => 'Submit Claim',
    'PR1MA Housing' => 'Apply Now',
    'Assessment Tax / Quit Rent' => 'Pay Now',
    'UPU Online' => 'Submit UPU',
    'Tabung Haji Services' => 'Proceed',
    'MyFutureJobs' => 'Apply Now',
    _ => 'Submit',
  };

  void _submitCurrentService() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_isTaxFiling) {
      _submitTaxPayment();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.item.title} submitted successfully.')),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.item.title),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurfaceVariant,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor),
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
                      child: Icon(
                        widget.item.icon,
                        color: widget.item.iconColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Agency: ${widget.item.subtitle}',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
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
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: _isTaxFiling
                            ? _buildTaxForm()
                            : _isEpfManagement
                            ? _buildEpfForm()
                            : _isHealthService
                            ? _buildHealthForm()
                            : _isLoanPayment
                            ? _buildLoanPaymentForm()
                            : _isLicenseRenewal
                            ? _buildLicenseRenewalForm()
                            : _isSummonsPayment
                            ? _buildSummonsPaymentForm()
                            : _buildGenericForm(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: OutlinedButton(
                        onPressed: _saveDraft,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Save Draft',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF214B74),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _submitCurrentService,
                        child: Text(
                          _submitButtonLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenericForm() {
    final config =
        _serviceFormConfigs[widget.item.title] ??
        _defaultServiceFormConfig(widget.item);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.item.title} Registration',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Part 1: Upload supporting documents (UI only placeholder for auto-fill).',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
          ),
          const SizedBox(height: 10),
          _buildUploadCard(config),
          if (config.suggestedDocuments.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Suggested documents',
              style: TextStyle(
                color: Color(0xFF1E2D3F),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...config.suggestedDocuments.map(_buildDocumentChip),
          ],
          const SizedBox(height: 12),
          const Text(
            'Part 2: Manual form fill',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...config.sections.map(
            (section) => _buildInfoSection(
              section.title,
              _buildSectionRows(section.rows),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(_ServiceFormConfig config) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE5F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.upload_file_outlined,
                  color: Color(0xFF3DA5F5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.uploadTitle,
                      style: const TextStyle(
                        color: Color(0xFF1E2D3F),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      config.uploadHint,
                      style: const TextStyle(
                        color: Color(0xFF607489),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_upload_outlined),
              label: const Text('Choose Document'),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDCE5F0)),
            ),
            child: const Text(
              'Auto-fill is UI placeholder only. Accepted files: PDF, JPG, PNG (up to 10MB).',
              style: TextStyle(
                color: Color(0xFF6F8094),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionRows(List<List<String>> rows) {
    return rows
        .map(
          (row) => row.length == 2
              ? _buildInfoPair(row[0], row[1])
              : _buildInfoField(row.first),
        )
        .toList();
  }

  _ServiceFormConfig _defaultServiceFormConfig(ServiceItem item) {
    return _ServiceFormConfig(
      uploadTitle: 'Upload ${item.title} document',
      uploadHint:
          'Attach available references for ${item.title} before manual submission.',
      suggestedDocuments: const [
        'MyKad / Passport copy',
        'Latest supporting document',
      ],
      sections: const [
        _ServiceFormSection(
          title: '1. Applicant Information',
          rows: [
            ['Full Name'],
            ['IC Number / Passport'],
            ['Phone Number', 'Email Address'],
          ],
        ),
        _ServiceFormSection(
          title: '2. Application Details',
          rows: [
            ['Application Type'],
            ['Reference Number (if any)'],
            ['Notes / Additional Details'],
          ],
        ),
      ],
    );
  }

  Widget _buildEpfForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EPF Document Upload',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your supporting documents before continuing with EPF services.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.upload_file_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload document',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'PDF, JPG, PNG up to 10MB each. Scan clearly for faster verification.',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument("kwsp"),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Choose File'),
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: FilledButton.icon(
                    onPressed: fillWithAI, // added
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Auto Fill with AI'),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Accepted files: identification proof, employment letter, salary slip, EPF statement, or any supporting PDF/image.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Suggested documents',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _buildDocumentChip('MyKad / Passport copy'),
          _buildDocumentChip('Employment confirmation letter'),
          _buildDocumentChip('Latest salary slip'),
          _buildDocumentChip('EPF account statement'),
          _buildDocumentChip('Supporting withdrawal or contribution document'),
          const SizedBox(height: 14),
          _buildInfoSection('1. Member (User) Information', [
            _buildInfoField('Full Name'),
            _buildInfoField('IC Number (MyKad)'),
            _buildInfoPair('Date of Birth', 'Gender'),
            _buildInfoPair('Phone Number', 'Email Address'),
            _buildInfoField('Address'),
            _buildInfoField('Employment Status'),
          ]),
          _buildInfoSection('2. Employment Details', [
            _buildInfoPair('Employer Name', 'Company ID'),
            _buildInfoPair('Start Date of Employment', 'Employment Type'),
            _buildInfoField('Salary Amount (RM)'),
          ]),
          _buildInfoSection('3. Contribution Information', [
            _buildInfoPair(
              'Employee Contribution (%)',
              'Employee Contribution (RM)',
            ),
            _buildInfoPair(
              'Employer Contribution (%)',
              'Employer Contribution (RM)',
            ),
            _buildInfoField('Monthly Contribution Records'),
            _buildInfoPair(
              'Contribution Date',
              'Total Accumulated Balance (RM)',
            ),
          ]),
          _buildInfoSection('4. Account Structure', [
            _buildInfoPair('Account 1 Balance (RM)', 'Account 2 Balance (RM)'),
            _buildInfoField('Account 3 Balance (optional)'),
            _buildInfoField('Transaction History Summary'),
          ]),
          _buildInfoSection('5. Transaction Records', [
            _buildInfoField('Monthly Deposits'),
            _buildInfoField('Withdrawals'),
            _buildInfoField('Transfers Between Accounts'),
            _buildInfoField('Dividend Payments'),
          ]),
          _buildInfoSection('6. Dividend / Interest Info', [
            _buildInfoPair(
              'Annual Dividend Rate (%)',
              'Dividend Earned Per Year (RM)',
            ),
            _buildInfoField('Historical Dividend Records'),
          ]),
          _buildInfoSection('7. Withdrawal Management', [
            _buildInfoField('Type of Withdrawal (housing, education, etc.)'),
            _buildInfoPair('Amount Withdrawn (RM)', 'Date of Withdrawal'),
            _buildInfoField('Approval Status'),
          ]),
          _buildInfoSection('8. Login & Security', [
            _buildInfoField('Username / ID'),
            _buildInfoField('Password (encrypted placeholder)'),
            _buildInfoField('Authentication Method (OTP, etc.)'),
          ]),
          _buildInfoSection('9. Reports / Summary', [
            _buildInfoField('Annual Statement'),
            _buildInfoField('Contribution Summary'),
            _buildInfoField('Total Savings Overview'),
            _buildInfoField('Retirement Savings Simulation'),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
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
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        validator: (value) => _validateField(label, value),
      ),
    );
  }

  Widget _buildInfoPair(String leftLabel, String rightLabel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: _buildInfoField(leftLabel)),
          const SizedBox(width: 10),
          Expanded(child: _buildInfoField(rightLabel)),
        ],
      ),
    );
  }

  String? _validateField(String label, String? value) {
    final text = value?.trim() ?? '';
    final lowerLabel = label.toLowerCase();
    final isOptional =
        lowerLabel.contains('optional') || lowerLabel.contains('if any');

    if (text.isEmpty) {
      return isOptional ? null : '$label is required';
    }

    if (lowerLabel.contains('email')) {
      final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailPattern.hasMatch(text)) {
        return 'Enter a valid email address';
      }
    }

    if (lowerLabel.contains('phone')) {
      final phonePattern = RegExp(r'^[0-9+\-\s]{8,15}$');
      if (!phonePattern.hasMatch(text)) {
        return 'Enter a valid phone number';
      }
    }

    if (lowerLabel.contains('amount') ||
        lowerLabel.contains('income') ||
        lowerLabel.contains('salary')) {
      if (double.tryParse(text.replaceAll(',', '')) == null) {
        return 'Enter a valid amount';
      }
    }

    if (lowerLabel.contains('year')) {
      final yearPattern = RegExp(r'^\d{4}$');
      if (!yearPattern.hasMatch(text)) {
        return 'Enter a valid year';
      }
    }

    if (lowerLabel.contains('ic number') ||
        lowerLabel.contains('mykad') ||
        lowerLabel.contains('passport')) {
      if (text.length < 6) {
        return 'Enter a valid identification number';
      }
    }

    if (lowerLabel.contains('tin')) {
      if (text.length < 6) {
        return 'Enter a valid TIN';
      }
    }

    return null;
  }

  Widget _buildHealthForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Service Registration',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload supporting documents, then fill in the required health registration details manually.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.upload_file_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload health document',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Medical card, referral letter, or previous reports (UI placeholder only).',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // keep UI same, only add function
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument("kkm"),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Choose Document'),
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: FilledButton.icon(
                    onPressed: fillWithAI, // added
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Auto Fill with AI'),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Accepted files: PDF, JPG, PNG (ID card, insurance card, medical report).',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildInfoSection('1. Personal Information (Basic Identity)', [
            _buildInfoField('Full Name'),
            _buildInfoField('IC Number / Passport'),
            _buildInfoPair('Date of Birth', 'Gender'),
            _buildInfoField('Nationality'),
          ]),
          _buildInfoSection('2. Contact Information', [
            _buildInfoPair('Phone Number', 'Email Address'),
            _buildInfoField('Home Address'),
          ]),
          _buildInfoSection('3. Health Profile (Very Important)', [
            _buildInfoField('Blood Type (if known)'),
            _buildInfoField('Allergies (medication, food, etc.)'),
            _buildInfoField(
              'Existing Medical Conditions (diabetes, asthma, etc.)',
            ),
            _buildInfoField('Current Medications'),
          ]),
          _buildInfoSection('4. Emergency Contact', [
            _buildInfoField('Emergency Contact Name'),
            _buildInfoPair('Relationship', 'Emergency Contact Phone Number'),
          ]),
          _buildInfoSection('5. Insurance / Payment Info', [
            _buildInfoField('Insurance Provider (if any)'),
            _buildInfoField('Policy Number'),
            _buildInfoField('Payment Method'),
          ]),
          _buildInfoSection('6. Appointment / Service Details', [
            _buildInfoField('Type of Service (check-up, vaccination, etc.)'),
            _buildInfoPair(
              'Preferred Date & Time',
              'Selected Clinic / Hospital',
            ),
          ]),
          _buildInfoSection('7. Health ID / Integration', [
            _buildInfoField('MyKad Number (Main ID)'),
            _buildInfoField('Link to Government Systems (optional)'),
          ]),
          _buildInfoSection('8. Account & Login', [
            _buildInfoField('Username / Email'),
            _buildInfoField('Password'),
            _buildInfoField('OTP / Verification'),
          ]),
          _buildInfoSection('9. Consent & Declarations', [
            _buildInfoField('Consent to Share Medical Data (Yes/No)'),
            _buildInfoField('Agreement to Terms & Privacy Policy (Yes/No)'),
          ]),
          _buildInfoSection('MVP Quick Registration', [
            _buildInfoPair('Name', 'IC Number'),
            _buildInfoField('Phone Number'),
            _buildInfoField('Allergy + Medical Condition Summary'),
            _buildInfoField('Appointment Booking Notes'),
            _buildInfoField('Emergency Contact (Name + Phone)'),
          ]),
        ],
      ),
    );
  }

  Widget _buildLoanPaymentForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PTPTN Loan Payment',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload supporting documents and fill in payment details manually.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.upload_file_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload payment document',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Optional: PTPTN statement, previous receipt, or payment reference slip.',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument("ptptn"),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Choose Document'),
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: FilledButton.icon(
                    onPressed: fillWithAI, // 👈 added
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Auto Fill with AI'),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Accepted files: PDF, JPG, PNG. UI only (no backend upload).',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildInfoSection('1. Borrower Identification (VERY IMPORTANT)', [
            _buildInfoField('Full Name'),
            _buildInfoField('IC Number (MyKad)'),
            _buildInfoField('PTPTN Loan Number (if available)'),
          ]),
          _buildInfoSection('2. Contact Information', [
            _buildInfoPair('Phone Number', 'Email Address'),
          ]),
          _buildInfoSection('3. Loan Details', [
            _buildInfoField('Outstanding Balance (auto-fetch placeholder)'),
            _buildInfoField(
              'Monthly Instalment Amount (auto-fetch placeholder)',
            ),
            _buildInfoField('Account Status (active / overdue)'),
          ]),
          _buildInfoSection('4. Payment Information', [
            _buildInfoField('Payment Amount (RM)'),
            _buildInfoField(
              'Payment Type (full settlement / monthly / extra payment)',
            ),
            _buildInfoField('Payment Method (FPX / card / e-wallet)'),
          ]),
          _buildInfoSection('5. Payment Reference Details', [
            _buildInfoPair(
              'Payment Date',
              'Reference Number (auto-generated placeholder)',
            ),
            _buildInfoField('Transaction ID'),
          ]),
          _buildInfoSection('6. Authentication / Verification', [
            _buildInfoField('Login Account'),
            _buildInfoField('OTP / TAC Verification'),
          ]),
          _buildInfoSection('7. Confirmation & Receipt', [
            _buildInfoField('Payment Summary (before confirm)'),
            _buildInfoField('Digital Receipt (after payment)'),
            _buildInfoField('Send Receipt (download / email)'),
          ]),
          _buildInfoSection('Important Checks Before Payment', [
            _buildInfoField('IC / Loan Number verified'),
            _buildInfoField('Payment amount verified'),
            _buildInfoField('Payment type selected correctly'),
          ]),
          _buildInfoSection('MVP Quick Pay', [
            _buildInfoField('IC Number'),
            _buildInfoField('Auto-fetched Loan Info (placeholder)'),
            _buildInfoField('Enter Amount'),
            _buildInfoField('Choose Payment Method'),
            _buildInfoField('Confirm & Pay'),
          ]),
        ],
      ),
    );
  }

  Widget _buildLicenseRenewalForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Licence Renewal',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your photo or use the existing JPJ photo, then complete the renewal details below.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Photo upload / existing photo',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Passport-style photo or existing JPJ photo placeholder (UI only).',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ONLY CHANGE: add function
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument("jpj"),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Upload Photo'),
                  ),
                ),

                const SizedBox(height: 8),

                // ONLY CHANGE: add AI autofill if needed
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: FilledButton.icon(
                    onPressed: fillWithAI, // reused AI function
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Auto Fill with AI'),
                  ),
                ),

                const SizedBox(height: 8),

                // keep existing second button UI but still functional if you want
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed:
                        () {}, // optional: keep or map to uploadDocument too
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Use Existing JPJ Photo'),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Accepted files: JPG, PNG, PDF for supporting documents. UI placeholder only.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildInfoSection('1. Personal Identification (Core)', [
            _buildInfoField('Full Name'),
            _buildInfoField('IC Number (MyKad) - Main Identifier'),
            _buildInfoField('Date of Birth'),
          ]),
          _buildInfoSection('2. Licence Information', [
            _buildInfoField('Licence Number'),
            _buildInfoPair('Licence Class (D, B2, etc.)', 'Expiry Date'),
            _buildInfoField('Licence Status (active / expired / suspended)'),
          ]),
          _buildInfoSection('3. Contact Information', [
            _buildInfoPair('Phone Number', 'Email Address'),
            _buildInfoField('Address'),
          ]),
          _buildInfoSection('4. Medical Declaration', [
            _buildInfoField('Health Condition Declaration'),
            _buildInfoField('Vision / Medical Fitness'),
          ]),
          _buildInfoSection('5. Renewal Details & Payment', [
            _buildInfoField('Renewal Duration (1 year / 2 years / etc.)'),
            _buildInfoField('Fee Amount (auto-calculated placeholder)'),
            _buildInfoField('Payment Method (FPX / card / e-wallet)'),
          ]),
          _buildInfoSection('6. Delivery / Collection Method', [
            _buildInfoField('Self-Collect at Counter'),
            _buildInfoField('Delivery Address (if posting licence)'),
          ]),
          _buildInfoSection('7. Verification & Security', [
            _buildInfoField('Login / Account'),
            _buildInfoField('OTP / TAC Verification'),
          ]),
          _buildInfoSection('8. Confirmation', [
            _buildInfoField('Summary Before Payment'),
            _buildInfoField('Receipt After Payment'),
            _buildInfoField('Renewal Confirmation Status'),
          ]),
          _buildInfoSection('Important Checks', [
            _buildInfoField('Licence not blacklisted / suspended'),
            _buildInfoField('No outstanding summons (if required)'),
            _buildInfoField('Correct licence class selected'),
          ]),
          _buildInfoSection('MVP Quick Renewal', [
            _buildInfoField('IC Number'),
            _buildInfoField('Auto-fetch licence info (placeholder)'),
            _buildInfoField('Choose Renewal Duration'),
            _buildInfoField('Pay / Done'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSummonsPaymentForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summons Payment',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your identification details to auto-fetch summons records, then complete the payment UI below.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 14),

          // ===== UPLOAD CARD (ONLY ONE - FIXED) =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.upload_file_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summons lookup document',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Optional document upload placeholder for summons notice or related file.',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Upload button
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument("pdrm"),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Upload Summons Document'),
                  ),
                ),

                const SizedBox(height: 8),

                // AI autofill button
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: FilledButton.icon(
                    onPressed: fillWithAI,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Auto Fill with AI'),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Accepted files: summons notice, notice image, or supporting PDF/image.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== REST OF YOUR FORM (UNCHANGED) =====
          _buildInfoSection('1. Identification (VERY IMPORTANT)', [
            _buildInfoField('IC Number (MyKad)'),
            _buildInfoField('Vehicle Plate Number'),
            _buildInfoField('Summons Number (best & most accurate)'),
          ]),
          _buildInfoSection('2. Summons Details (Auto-Fetched)', [
            _buildInfoField('Summons Number'),
            _buildInfoField('Offence Type (speeding, parking, etc.)'),
            _buildInfoPair(
              'Date & Location of Offence',
              'Issuing Authority (PDRM / JPJ / council)',
            ),
            _buildInfoPair(
              'Amount to Pay',
              'Status (unpaid / discounted / overdue)',
            ),
          ]),
          _buildInfoSection('3. Contact Information', [
            _buildInfoPair('Phone Number', 'Email'),
          ]),
          _buildInfoSection('4. Payment Information', [
            _buildInfoField('Payment Amount (auto or editable)'),
            _buildInfoField('Payment Type (single summons / multiple summons)'),
            _buildInfoField('Payment Method (FPX / card / e-wallet)'),
          ]),
          _buildInfoSection('5. Transaction Details', [
            _buildInfoPair('Payment Date', 'Reference Number'),
            _buildInfoField('Transaction ID'),
          ]),
          _buildInfoSection('6. Verification / Security', [
            _buildInfoField('Login (optional but recommended)'),
            _buildInfoField('OTP / TAC Verification'),
          ]),
          _buildInfoSection('7. Confirmation & Receipt', [
            _buildInfoField('Payment Summary Before Confirm'),
            _buildInfoField('Digital Receipt After Payment'),
            _buildInfoField('Updated Status (paid)'),
          ]),
          _buildInfoSection('Important Checks', [
            _buildInfoField('Correct summons selected (if multiple)'),
            _buildInfoField('Amount matches official record'),
            _buildInfoField('Check discount campaigns / promotions'),
          ]),
          _buildInfoSection('MVP Quick Pay', [
            _buildInfoField('IC / Plate / Summons Number'),
            _buildInfoField('Auto-fetch summons info (placeholder)'),
            _buildInfoField('Enter Amount'),
            _buildInfoField('Choose Payment Method'),
            _buildInfoField('Confirm & Pay'),
          ]),
        ],
      ),
    );
  }

  Widget _buildDocumentChip(String label) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.description_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF7D8D9D),
            size: 18,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tax Payment Details',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== HEADER =====
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.upload_file_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tax Document & AI Autofill',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Upload document or use AI to auto-fill form fields',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ===== UPLOAD BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: () => uploadDocument("lhdn"),
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload Document"),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ===== AUTO FILL BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: FilledButton.icon(
                      onPressed: fillWithAI, // 👈 backend API
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text("Auto Fill with AI"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===== INFO TEXT =====
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).dividerColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'Upload: PDF, image, or document\nAuto Fill: uses AI to prefill tax form fields',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            Text(
              'Your personal tax number (e.g. SGXXXXXXXX / OGXXXXXXXX).',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _tinController,
              decoration: const InputDecoration(
                labelText: 'Tax Identification Number (TIN)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'TIN is required'
                  : null,
            ),
            const SizedBox(height: 12),
            const Text(
              '2. Identification Number',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Use IC (MyKad) for Malaysians or Passport for foreigners.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
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
              decoration: const InputDecoration(border: OutlineInputBorder()),
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
            Text(
              'Wrong year can result in incorrect payment records.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _assessmentYear,
              decoration: const InputDecoration(border: OutlineInputBorder()),
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
            Text(
              '084 is commonly used for balance of tax payment.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _paymentCode,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(
                  value: '084',
                  child: Text('084 - Balance of tax'),
                ),
                DropdownMenuItem(
                  value: '085',
                  child: Text('085 - CP500 installment'),
                ),
                DropdownMenuItem(
                  value: '086',
                  child: Text('086 - Additional assessment'),
                ),
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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

class _ServiceFormConfig {
  const _ServiceFormConfig({
    required this.uploadTitle,
    required this.uploadHint,
    required this.suggestedDocuments,
    required this.sections,
  });

  final String uploadTitle;
  final String uploadHint;
  final List<String> suggestedDocuments;
  final List<_ServiceFormSection> sections;
}

class _ServiceFormSection {
  const _ServiceFormSection({required this.title, required this.rows});

  final String title;
  final List<List<String>> rows;
}

const Map<String, _ServiceFormConfig> _serviceFormConfigs = {
  'MyKad Replacement': _ServiceFormConfig(
    uploadTitle: 'Upload identity documents',
    uploadHint:
        'Upload damaged/lost card report and identity proof for faster verification.',
    suggestedDocuments: [
      'Police report (if lost)',
      'Birth certificate',
      'Old MyKad photo',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Identity Information',
        rows: [
          ['Full Name'],
          ['IC Number (Old / Existing)'],
          ['Date of Birth', 'Nationality'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Replacement Details',
        rows: [
          ['Reason for Replacement'],
          ['Preferred JPN Branch'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'Birth Certificate Extract': _ServiceFormConfig(
    uploadTitle: 'Upload birth record support documents',
    uploadHint:
        'Upload IC and related references to speed up extract request review.',
    suggestedDocuments: [
      'Applicant IC copy',
      'Parent/guardian IC copy',
      'Hospital reference (if any)',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Applicant Details',
        rows: [
          ['Applicant Full Name'],
          ['IC Number / Passport'],
          ['Relationship to Certificate Owner'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Certificate Details',
        rows: [
          ['Name on Birth Certificate'],
          ['Date of Birth', 'Place of Birth'],
          ['Reason for Request'],
        ],
      ),
    ],
  ),
  'Marriage Registration': _ServiceFormConfig(
    uploadTitle: 'Upload marriage registration documents',
    uploadHint:
        'Upload both applicants documents before selecting appointment slot.',
    suggestedDocuments: [
      'Applicant A IC',
      'Applicant B IC',
      'Single status confirmation',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Applicant A',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Phone Number', 'Email Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Applicant B & Appointment',
        rows: [
          ['Applicant B Full Name'],
          ['Applicant B IC Number'],
          ['Preferred Date', 'Preferred JPN Branch'],
        ],
      ),
    ],
  ),
  'Passport Renewal': _ServiceFormConfig(
    uploadTitle: 'Upload passport renewal documents',
    uploadHint:
        'Upload current passport and photo to pre-check renewal eligibility.',
    suggestedDocuments: [
      'Current passport bio page',
      'Passport photo',
      'Payment slip (if any)',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Passport Holder Information',
        rows: [
          ['Full Name'],
          ['IC Number / Passport Number'],
          ['Date of Birth', 'Nationality'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Renewal Preferences',
        rows: [
          ['Renewal Duration'],
          ['Collection Branch'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'Road Tax Renewal': _ServiceFormConfig(
    uploadTitle: 'Upload vehicle tax documents',
    uploadHint:
        'Upload grant/ownership details to prefill vehicle profile (UI only).',
    suggestedDocuments: [
      'Vehicle grant copy',
      'Insurance cover note',
      'Owner IC copy',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Owner & Vehicle',
        rows: [
          ['Owner Name'],
          ['IC Number'],
          ['Vehicle Plate Number', 'Vehicle Type'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Renewal & Contact',
        rows: [
          ['Renewal Period (months)'],
          ['Insurance Provider'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'Business Registration': _ServiceFormConfig(
    uploadTitle: 'Upload business registration documents',
    uploadHint:
        'Upload business name proposals and owner details for validation.',
    suggestedDocuments: [
      'Owner IC',
      'Business address proof',
      'Partnership agreement (if any)',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Business Profile',
        rows: [
          ['Proposed Business Name'],
          ['Business Type'],
          ['Business Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Owner Information',
        rows: [
          ['Owner Full Name'],
          ['Owner IC Number'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'Legal Aid': _ServiceFormConfig(
    uploadTitle: 'Upload case and support documents',
    uploadHint:
        'Upload relevant legal notices and evidence for initial screening.',
    suggestedDocuments: ['IC copy', 'Case reference documents', 'Income proof'],
    sections: [
      _ServiceFormSection(
        title: '1. Applicant Background',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Monthly Income', 'Employment Status'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Case Information',
        rows: [
          ['Case Type'],
          ['Case Summary'],
          ['Preferred Contact Method'],
        ],
      ),
    ],
  ),
  'Vehicle Ownership Transfer': _ServiceFormConfig(
    uploadTitle: 'Upload ownership transfer documents',
    uploadHint:
        'Upload seller/buyer documents and grant details for transfer review.',
    suggestedDocuments: ['Seller IC', 'Buyer IC', 'Vehicle grant copy'],
    sections: [
      _ServiceFormSection(
        title: '1. Seller Information',
        rows: [
          ['Seller Name'],
          ['Seller IC Number'],
          ['Seller Phone Number'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Buyer & Vehicle Details',
        rows: [
          ['Buyer Name'],
          ['Buyer IC Number'],
          ['Vehicle Plate Number', 'Chassis Number'],
        ],
      ),
    ],
  ),
  'eKasih Registration': _ServiceFormConfig(
    uploadTitle: 'Upload household support documents',
    uploadHint:
        'Upload income proof and dependants details for aid eligibility checks.',
    suggestedDocuments: [
      'Head of household IC',
      'Salary/income slip',
      'Utility bill',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Household Information',
        rows: [
          ['Head of Household Name'],
          ['IC Number'],
          ['Home Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Income & Dependants',
        rows: [
          ['Monthly Household Income'],
          ['Number of Dependants'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'Tax Refund Status': _ServiceFormConfig(
    uploadTitle: 'Upload tax supporting files',
    uploadHint: 'Upload tax reference if available to verify refund details.',
    suggestedDocuments: ['IC copy', 'Tax return submission receipt'],
    sections: [
      _ServiceFormSection(
        title: '1. Taxpayer Details',
        rows: [
          ['Full Name'],
          ['Tax Identification Number (TIN)'],
          ['IC Number / Passport'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Refund Inquiry',
        rows: [
          ['Assessment Year'],
          ['Bank Account Number (for refund)'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'Zakat Payment': _ServiceFormConfig(
    uploadTitle: 'Upload zakat payment references',
    uploadHint:
        'Upload income or business records to prepare zakat calculation.',
    suggestedDocuments: [
      'IC copy',
      'Income statement',
      'Business records (if applicable)',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Payer Information',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Phone Number', 'Email Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Zakat Details',
        rows: [
          ['Zakat Type (income/business/etc.)'],
          ['Assessment Period'],
          ['Amount to Pay (RM)'],
        ],
      ),
    ],
  ),
  'Public Complaints (SISPAA)': _ServiceFormConfig(
    uploadTitle: 'Upload complaint evidence',
    uploadHint:
        'Upload screenshots/documents to support your complaint submission.',
    suggestedDocuments: [
      'Evidence screenshot/photo',
      'Supporting letter (if any)',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Complainant Details',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Phone Number', 'Email Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Complaint Details',
        rows: [
          ['Agency Involved'],
          ['Complaint Category'],
          ['Complaint Description'],
        ],
      ),
    ],
  ),
  'Civil Service Recruitment': _ServiceFormConfig(
    uploadTitle: 'Upload recruitment documents',
    uploadHint:
        'Upload qualifications and resume before filling the application profile.',
    suggestedDocuments: ['Resume/CV', 'Academic certificate', 'IC copy'],
    sections: [
      _ServiceFormSection(
        title: '1. Candidate Profile',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Date of Birth', 'Nationality'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Application Details',
        rows: [
          ['Position Applied'],
          ['Highest Education Level'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'Welfare Aid (eBantuan)': _ServiceFormConfig(
    uploadTitle: 'Upload welfare aid documents',
    uploadHint:
        'Upload financial and household proof to support aid application.',
    suggestedDocuments: [
      'IC copy',
      'Income declaration',
      'Dependants supporting docs',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Applicant Information',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Home Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Aid Eligibility Details',
        rows: [
          ['Household Income (RM)'],
          ['Number of Dependants'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'SOCSO Claims': _ServiceFormConfig(
    uploadTitle: 'Upload SOCSO claim documents',
    uploadHint: 'Upload incident and employment records for claim processing.',
    suggestedDocuments: [
      'IC copy',
      'Employer letter',
      'Medical report / incident report',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Claimant Information',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['SOCSO Member Number'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Claim Details',
        rows: [
          ['Claim Type'],
          ['Incident Date', 'Incident Location'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'PR1MA Housing': _ServiceFormConfig(
    uploadTitle: 'Upload PR1MA housing documents',
    uploadHint:
        'Upload income and family details to support housing application.',
    suggestedDocuments: [
      'IC copy',
      'Salary slip',
      'Marriage certificate (if applicable)',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Applicant Profile',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Marital Status', 'Household Size'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Housing Preferences',
        rows: [
          ['Preferred Location'],
          ['Preferred Property Type'],
          ['Monthly Income', 'Phone Number'],
        ],
      ),
    ],
  ),
  'Assessment Tax / Quit Rent': _ServiceFormConfig(
    uploadTitle: 'Upload property and tax references',
    uploadHint:
        'Upload ownership and past bill references for property tax payment.',
    suggestedDocuments: [
      'Property ownership document',
      'Previous bill',
      'IC copy',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Property Owner Information',
        rows: [
          ['Owner Full Name'],
          ['IC Number'],
          ['Phone Number', 'Email Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Property Tax Details',
        rows: [
          ['Property Account Number'],
          ['Local Council / Authority'],
          ['Amount to Pay (RM)'],
        ],
      ),
    ],
  ),
  'UPU Online': _ServiceFormConfig(
    uploadTitle: 'Upload academic application documents',
    uploadHint:
        'Upload academic certificates and transcripts for UPU application profile.',
    suggestedDocuments: [
      'SPM/STPM result slip',
      'IC copy',
      'Co-curricular certificates',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Student Information',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Phone Number', 'Email Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Admission Preferences',
        rows: [
          ['Education Level Applied (Diploma/Degree)'],
          ['Program Choice 1', 'Program Choice 2'],
          ['Current Qualification'],
        ],
      ),
    ],
  ),
  'Tabung Haji Services': _ServiceFormConfig(
    uploadTitle: 'Upload Tabung Haji documents',
    uploadHint:
        'Upload account references for savings and haj registration services.',
    suggestedDocuments: [
      'IC copy',
      'TH account statement',
      'Supporting declaration',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Account Holder Information',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Tabung Haji Account Number'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Service Request',
        rows: [
          ['Service Type (savings / hajj / transfer)'],
          ['Amount / Target (if applicable)'],
          ['Phone Number', 'Email Address'],
        ],
      ),
    ],
  ),
  'MyFutureJobs': _ServiceFormConfig(
    uploadTitle: 'Upload job application documents',
    uploadHint:
        'Upload CV and certificates to complete your job-seeker profile.',
    suggestedDocuments: [
      'Resume/CV',
      'Academic certificates',
      'Professional certificates',
    ],
    sections: [
      _ServiceFormSection(
        title: '1. Job Seeker Profile',
        rows: [
          ['Full Name'],
          ['IC Number'],
          ['Phone Number', 'Email Address'],
        ],
      ),
      _ServiceFormSection(
        title: '2. Employment Details',
        rows: [
          ['Preferred Job Role'],
          ['Industry Preference'],
          ['Expected Salary (RM)'],
        ],
      ),
    ],
  ),
};

class ServiceItem {
  const ServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
}

final List<ServiceItem> _popularItems = [
  ServiceItem(
    title: 'Tax Filing',
    subtitle: 'LHDN / MyTax',
    icon: Icons.attach_money,
    iconColor: const Color(0xFF2ECC71),
    iconBg: const Color(0xFFE8F6EE),
  ),
  ServiceItem(
    title: 'EPF Management',
    subtitle: 'KWSP',
    icon: Icons.account_balance,
    iconColor: const Color(0xFF3DA5F5),
    iconBg: const Color(0xFFE8F4FE),
  ),
  ServiceItem(
    title: 'Health Services',
    subtitle: 'KKM',
    icon: Icons.favorite_border,
    iconColor: const Color(0xFFF5A623),
    iconBg: const Color(0xFFFFF3E6),
  ),
  ServiceItem(
    title: 'Loan Payment',
    subtitle: 'PTPTN',
    icon: Icons.school_outlined,
    iconColor: const Color(0xFFE57373),
    iconBg: const Color(0xFFFDEDEE),
  ),
  ServiceItem(
    title: 'License Renewal',
    subtitle: 'JPJ',
    icon: Icons.directions_car_outlined,
    iconColor: const Color(0xFF607489),
    iconBg: const Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Summons Payment',
    subtitle: 'PDRM',
    icon: Icons.warning_amber_outlined,
    iconColor: const Color(0xFFF5A623),
    iconBg: const Color(0xFFFFF3E6),
  ),
];

const List<ServiceItem> _governmentServices = [
  ServiceItem(
    title: 'MyKad Replacement',
    subtitle: 'JPN',
    icon: Icons.badge_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Birth Certificate Extract',
    subtitle: 'JPN',
    icon: Icons.description_outlined,
    iconColor: const Color(0xFF7D8D9D),
    iconBg: const Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Marriage Registration',
    subtitle: 'JPN',
    icon: Icons.favorite_border,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Passport Renewal',
    subtitle: 'JIM',
    icon: Icons.flight_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Road Tax Renewal',
    subtitle: 'JPJ / MyEG',
    icon: Icons.directions_car_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Business Registration',
    subtitle: 'SSM',
    icon: Icons.business_center_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Legal Aid',
    subtitle: 'BHEUU',
    icon: Icons.balance_outlined,
    iconColor: const Color(0xFF7D8D9D),
    iconBg: const Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Vehicle Ownership Transfer',
    subtitle: 'JPJ',
    icon: Icons.swap_horiz_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'eKasih Registration',
    subtitle: 'ICU JPM',
    icon: Icons.assignment_ind_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Tax Refund Status',
    subtitle: 'LHDN / MyTax',
    icon: Icons.receipt_long_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Zakat Payment',
    subtitle: 'Pusat Pungutan Zakat',
    icon: Icons.volunteer_activism_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Public Complaints (SISPAA)',
    subtitle: 'SISPAA',
    icon: Icons.campaign_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Civil Service Recruitment',
    subtitle: 'SPA9',
    icon: Icons.badge_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Welfare Aid (eBantuan)',
    subtitle: 'JKM',
    icon: Icons.people_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'SOCSO Claims',
    subtitle: 'PERKESO',
    icon: Icons.shield_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'PR1MA Housing',
    subtitle: 'PR1MA',
    icon: Icons.home_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Assessment Tax / Quit Rent',
    subtitle: 'Local Councils',
    icon: Icons.payments_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'UPU Online',
    subtitle: 'KPT',
    icon: Icons.school_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Tabung Haji Services',
    subtitle: 'THiJARI',
    icon: Icons.mosque_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'MyFutureJobs',
    subtitle: 'MyFutureJobs',
    icon: Icons.work_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
];

void openServiceActionPage(BuildContext context, String serviceTitle) {
  final allItems = [..._popularItems, ..._governmentServices];
  final matchedItems = allItems.where((item) => item.title == serviceTitle);
  final item = matchedItems.isNotEmpty
      ? matchedItems.first
      : ServiceItem(
          title: serviceTitle,
          subtitle: 'SmartGOV',
          icon: Icons.grid_view_outlined,
          iconColor: const Color(0xFF7D8D9D),
          iconBg: const Color(0xFFE9EDF2),
        );

  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => ServiceActionPage(item: item)));
}

class _ServiceNavItem {
  const _ServiceNavItem(this.title, this.icon, this.active);

  final String title;
  final IconData icon;
  final bool active;
}

const Map<String, List<String>> _subServiceMap = {
  'Tax Filing': [
    'Check Tax Status',
    'Auto File Tax',
    'Tax Return',
    'Refund Inquiry',
  ],
  'EPF Management': ['Check Balance', 'Withdraw EPF'],
  'License Renewal': ['Renew License', 'Road Tax Renewal'],
  'Summons Payment': ['Check Summons', 'Pay Traffic Fine'],
};
