import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'services/ai_service.dart';
import 'services/prefill_service.dart';
import 'services/service_search_backend.dart';
import 'services/service_navigation_intent.dart';

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
                SizedBox(width: 220, child: _ServicesSidebar()),
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

class _ServicesBody extends StatefulWidget {
  const _ServicesBody();

  @override
  State<_ServicesBody> createState() => _ServicesBodyState();
}

class _ServicesBodyState extends State<_ServicesBody> {
  String query = '';
  bool _showAllServices = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _isSearching = false;
  ServiceItem? _searchResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openTargetServiceIfRequested();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _openTargetServiceIfRequested() {
    final targetTitle = ServiceNavigationIntent.targetServiceTitle;
    if (targetTitle == null || targetTitle.isEmpty) {
      return;
    }

    final allItems = [..._popularItems, ..._allItems];
    final target = allItems.where((item) => item.title == targetTitle).toList();
    ServiceNavigationIntent.targetServiceTitle = null;

    if (target.isEmpty || !mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ServiceActionPage(item: target.first)),
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    final normalized = value.trim();

    if (normalized.isEmpty) {
      setState(() {
        query = '';
        _isSearching = false;
        _searchResult = null;
      });
      return;
    }

    setState(() {
      query = normalized;
      _isSearching = true;
    });

    _searchDebounce = Timer(const Duration(milliseconds: 260), () {
      _searchSingleService(normalized);
    });
  }

  Future<void> _searchSingleService(String value) async {
    final requestedQuery = value.trim();
    final mergedItems = [..._popularItems, ..._allItems];
    final titles = mergedItems.map((item) => item.title).toSet().toList();

    final matchedTitle = await ServiceSearchBackend.searchSingleService(
      keyword: requestedQuery,
      serviceTitles: titles,
    );

    if (!mounted || requestedQuery != query) {
      return;
    }

    setState(() {
      _isSearching = false;
      _searchResult = matchedTitle == null
          ? null
          : mergedItems.firstWhere(
              (item) => item.title == matchedTitle,
              orElse: () => mergedItems.first,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleAllItems = _showAllServices
        ? _allItems
        : _allItems.take(6).toList();
    final isSearchMode = query.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Government Services',
                  style: TextStyle(
                    color: Color(0xFF1E2D3F),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Access all government services in one place',
                  style: TextStyle(
                    color: Color(0xFF6B7B8D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                _SearchServicesField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 20),
                if (isSearchMode) ...[
                  const _ServiceSectionTitle('Search Result'),
                  const SizedBox(height: 10),
                  if (_isSearching)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      ),
                    )
                  else if (_searchResult != null)
                    _ServiceGrid(items: [_searchResult!])
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'No service matched that keyword.',
                        style: TextStyle(
                          color: Color(0xFF6B7B8D),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ] else ...[
                  const _ServiceSectionTitle('Popular Services'),
                  const SizedBox(height: 10),
                  const _ServiceGrid(items: _popularItems, showArrow: true),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Expanded(child: _ServiceSectionTitle('All Services')),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showAllServices = !_showAllServices;
                          });
                        },
                        child: Text(
                          _showAllServices ? 'Show less' : 'View all',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ServiceGrid(items: visibleAllItems),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchServicesField extends StatelessWidget {
  const _SearchServicesField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        hintText:
            'Search services... (e.g. renew license, check tax, apply bantuan)',
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
  const _ServiceGrid({required this.items, this.showArrow = false});

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
  });

  final ServiceItem item;
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

class ServiceActionPage extends StatefulWidget {
  const ServiceActionPage({required this.item});

  final ServiceItem item;

  @override
  State<ServiceActionPage> createState() => ServiceActionPageState();
}

class ServiceActionPageState extends State<ServiceActionPage> {
  final _formKey = GlobalKey<FormState>();
  // Tax Filing Controllers
  final _nameController = TextEditingController();
  final _tinController = TextEditingController();
  final _idController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _amountController = TextEditingController();

  // Shared controllers for other services
  final _epfNameController = TextEditingController();
  final _epfIdController = TextEditingController();
  final _epfEmployerController = TextEditingController();
  final _epfPhoneController = TextEditingController();

  final _healthNameController = TextEditingController();
  final _healthIdController = TextEditingController();
  final _healthPhoneController = TextEditingController();
  final _healthDobController = TextEditingController();

  final _ptptnNameController = TextEditingController();
  final _ptptnIdController = TextEditingController();
  final _ptptnPhoneController = TextEditingController();

  final _licenseNameController = TextEditingController();
  final _licenseIdController = TextEditingController();
  final _licenseDobController = TextEditingController();

  final _summonsNameController = TextEditingController();
  final _summonsIdController = TextEditingController();
  final _summonsPhoneController = TextEditingController();
  final Map<String, TextEditingController> _infoFieldControllers = {};

  AiOcrResult? _latestOcrResult;
  String? _aiNote;
  String _taxType = 'Income Tax (Cukai Pendapatan)';
  String _assessmentYear = '${DateTime.now().year}';
  String _paymentCode = '084';

  bool get _isTaxFiling => widget.item.title == 'Tax Filing';
  bool get _isEpfManagement => widget.item.title == 'EPF Management';
  bool get _isHealthService => widget.item.title == 'Health Services';
  bool get _isLoanPayment => widget.item.title == 'Loan Payment';
  bool get _isLicenseRenewal => widget.item.title == 'License Renewal';
  bool get _isSummonsPayment => widget.item.title == 'Summons Payment';
  bool get _isPopularService =>
      _isTaxFiling ||
      _isEpfManagement ||
      _isHealthService ||
      _isLoanPayment ||
      _isLicenseRenewal ||
      _isSummonsPayment;
  bool isLoading = false;

  @override
  void dispose() {
    // Tax controllers
    _nameController.dispose();
    _tinController.dispose();
    _idController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _amountController.dispose();

    // EPF controllers
    _epfNameController.dispose();
    _epfIdController.dispose();
    _epfEmployerController.dispose();
    _epfPhoneController.dispose();

    // Health controllers
    _healthNameController.dispose();
    _healthIdController.dispose();
    _healthPhoneController.dispose();
    _healthDobController.dispose();

    // PTPTN controllers
    _ptptnNameController.dispose();
    _ptptnIdController.dispose();
    _ptptnPhoneController.dispose();

    // License controllers
    _licenseNameController.dispose();
    _licenseIdController.dispose();
    _licenseDobController.dispose();

    // Summons controllers
    _summonsNameController.dispose();
    _summonsIdController.dispose();
    _summonsPhoneController.dispose();

    for (final controller in _infoFieldControllers.values) {
      controller.dispose();
    }
    _infoFieldControllers.clear();

    super.dispose();
  }

  Future<void> fillWithAI() async {
    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Please sign in first.');
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
      final ocrResult = AiDraftStore.instance.lastOcrResult;

      _latestOcrResult = ocrResult;

      setState(() {
        _aiNote = ocrResult == null
            ? 'No OCR result yet. Upload a document first.'
            : 'OCR data loaded for ${widget.item.title}.';

        final name =
            ocrResult?.fullName ??
            (prefill['name'] ?? profile['name'] ?? '').toString();
        final ic =
            ocrResult?.icNumber ??
            (prefill['ic'] ?? profile['ic'] ?? '').toString();
        final address =
            ocrResult?.address ?? (profile['address'] ?? '').toString();
        final dob = ocrResult?.dob ?? (profile['dob'] ?? '').toString();
        final phone = ocrResult?.phone ?? (profile['phone'] ?? '').toString();
        final income = _formatAmount(
          ocrResult?.income ?? prefill['income'] ?? profile['income'],
        );
        final email =
          ocrResult?.email ?? _safeString(prefill['email'] ?? profile['email']);
        final gender = ocrResult?.gender ?? _safeString(profile['gender']);
        final nationality =
          ocrResult?.nationality ?? _safeString(profile['nationality']);
        final employer =
          ocrResult?.employerName ?? _safeString(profile['employer_name']);
        final taxId =
          ocrResult?.taxId ?? _safeString(profile['tax_id'] ?? profile['tin']);
        final documentNumber =
          ocrResult?.documentNumber ?? _safeString(profile['document_number']);

        if (_isTaxFiling) {
          _nameController.text = name;
          _tinController.text = (profile['tin'] ?? profile['tax_id'] ?? '')
              .toString();
          _idController.text = ic;
          _addressController.text = address;
          _dobController.text = dob;
          _amountController.text = income;

          final estimatedTax = profile['estimatedTax']?.toString();
          if (_amountController.text.isEmpty &&
              estimatedTax != null &&
              estimatedTax.isNotEmpty) {
            _amountController.text = estimatedTax;
          }
        } else if (_isEpfManagement) {
          _epfNameController.text = name;
          _epfIdController.text = ic;
          _epfPhoneController.text = phone;
          _epfEmployerController.text =
              ocrResult?.employerName ??
              (profile['employer_name'] ?? '').toString();
        } else if (_isHealthService) {
          _healthNameController.text = name;
          _healthIdController.text = ic;
          _healthPhoneController.text = phone;
          _healthDobController.text = dob;
        } else if (_isLoanPayment) {
          _ptptnNameController.text = name;
          _ptptnIdController.text = ic;
          _ptptnPhoneController.text = phone;
        } else if (_isLicenseRenewal) {
          _licenseNameController.text = name;
          _licenseIdController.text = ic;
          _licenseDobController.text = dob;
        } else if (_isSummonsPayment) {
          _summonsNameController.text = name;
          _summonsIdController.text = ic;
          _summonsPhoneController.text = phone;
        }

        _applyAutoFillToInfoRows(
          name: name,
          ic: ic,
          address: address,
          dob: dob,
          phone: phone,
          email: email,
          gender: gender,
          nationality: nationality,
          employer: employer,
          income: income,
          taxId: taxId,
          documentNumber: documentNumber,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ocrResult == null
                ? 'Profile details loaded for ${widget.item.title}.'
                : 'OCR data applied to ${widget.item.title}.',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('AI fill failed: $e')));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> uploadDocument(String type) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result == null || result.files.first.bytes == null) {
        return;
      }

      final file = result.files.first;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              ),
              SizedBox(width: 12),
              Expanded(child: Text('Uploading document')),
            ],
          ),
        ),
      );

      setState(() => isLoading = true);

      final extracted = await AiService.instance.extractDocument(
        bytes: file.bytes!,
        mimeType: _mimeTypeForExtension(file.extension),
      );
      AiDraftStore.instance.lastOcrResult = extracted;
      _latestOcrResult = extracted;
      _aiNote = 'OCR extracted from ${file.name}.';

      if (_isTaxFiling) {
        setState(() {
          _nameController.text = extracted.fullName ?? _nameController.text;
          _idController.text = extracted.icNumber ?? _idController.text;
          _addressController.text =
              extracted.address ?? _addressController.text;
          _dobController.text = extracted.dob ?? _dobController.text;
          _amountController.text = _formatAmount(extracted.income);
        });
      } else if (_isEpfManagement) {
        setState(() {
          _epfNameController.text =
              extracted.fullName ?? _epfNameController.text;
          _epfIdController.text = extracted.icNumber ?? _epfIdController.text;
          _epfPhoneController.text =
              extracted.phone ?? _epfPhoneController.text;
          _epfEmployerController.text =
              extracted.employerName ?? _epfEmployerController.text;
        });
      } else if (_isHealthService) {
        setState(() {
          _healthNameController.text =
              extracted.fullName ?? _healthNameController.text;
          _healthIdController.text =
              extracted.icNumber ?? _healthIdController.text;
          _healthPhoneController.text =
              extracted.phone ?? _healthPhoneController.text;
          _healthDobController.text =
              extracted.dob ?? _healthDobController.text;
        });
      } else if (_isLoanPayment) {
        setState(() {
          _ptptnNameController.text =
              extracted.fullName ?? _ptptnNameController.text;
          _ptptnIdController.text =
              extracted.icNumber ?? _ptptnIdController.text;
          _ptptnPhoneController.text =
              extracted.phone ?? _ptptnPhoneController.text;
        });
      } else if (_isLicenseRenewal) {
        setState(() {
          _licenseNameController.text =
              extracted.fullName ?? _licenseNameController.text;
          _licenseIdController.text =
              extracted.icNumber ?? _licenseIdController.text;
          _licenseDobController.text =
              extracted.dob ?? _licenseDobController.text;
        });
      } else if (_isSummonsPayment) {
        setState(() {
          _summonsNameController.text =
              extracted.fullName ?? _summonsNameController.text;
          _summonsIdController.text =
              extracted.icNumber ?? _summonsIdController.text;
          _summonsPhoneController.text =
              extracted.phone ?? _summonsPhoneController.text;
        });
      }

      setState(() {
        _applyAutoFillToInfoRows(
          name: _safeString(extracted.fullName),
          ic: _safeString(extracted.icNumber),
          address: _safeString(extracted.address),
          dob: _safeString(extracted.dob),
          phone: _safeString(extracted.phone),
          email: _safeString(extracted.email),
          gender: _safeString(extracted.gender),
          nationality: _safeString(extracted.nationality),
          employer: _safeString(extracted.employerName),
          income: _formatAmount(extracted.income),
          taxId: _safeString(extracted.taxId),
          documentNumber: _safeString(extracted.documentNumber),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isTaxFiling
                ? 'OCR extracted and applied to the tax form.'
                : 'Document extracted successfully for ${widget.item.title}.',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('OCR upload failed: $e')));
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String _mimeTypeForExtension(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  String _formatAmount(dynamic value) {
    if (value == null) {
      return '';
    }

    if (value is num) {
      return value.toStringAsFixed(0);
    }

    final text = value.toString().replaceAll(RegExp(r'[^0-9.]'), '');
    if (text.isEmpty) {
      return '';
    }

    final amount = double.tryParse(text);
    return amount == null ? text : amount.toStringAsFixed(0);
  }

  String _safeString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  String _labelKey(String label) {
    return label.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  bool _containsAny(String text, List<String> tokens) {
    final lower = text.toLowerCase();
    for (final token in tokens) {
      if (lower.contains(token)) {
        return true;
      }
    }
    return false;
  }

  TextEditingController _controllerForInfoField(String label) {
    final key = _labelKey(label);
    return _infoFieldControllers.putIfAbsent(key, TextEditingController.new);
  }

  String _valueForInfoLabel(String label, Map<String, String> values) {
    final lower = label.toLowerCase();

    if (_containsAny(lower, ['full name']) ||
        lower == 'name' ||
        lower == 'applicant name') {
      return values['name'] ?? '';
    }

    if (_containsAny(lower, [
      'identification',
      'ic number',
      'mykad',
      'passport',
      'tax id',
      'tin',
      'username / id',
      'mykad number',
    ])) {
      if (_containsAny(lower, ['tax id', 'tin'])) {
        return values['taxId'] ?? values['ic'] ?? '';
      }
      return values['ic'] ?? '';
    }

    if (_containsAny(lower, ['date of birth', 'dob'])) {
      return values['dob'] ?? '';
    }

    if (_containsAny(lower, ['gender', 'sex'])) {
      return values['gender'] ?? '';
    }

    if (_containsAny(lower, ['nationality'])) {
      return values['nationality'] ?? '';
    }

    if (_containsAny(lower, ['phone', 'mobile', 'contact'])) {
      return values['phone'] ?? '';
    }

    if (_containsAny(lower, ['email'])) {
      return values['email'] ?? '';
    }

    if (_containsAny(lower, ['address'])) {
      return values['address'] ?? '';
    }

    if (_containsAny(lower, ['employer', 'company'])) {
      return values['employer'] ?? '';
    }

    if (_containsAny(lower, ['salary', 'income', 'amount'])) {
      return values['income'] ?? '';
    }

    if (_containsAny(lower, [
      'document number',
      'reference number',
      'summons number',
      'vehicle plate',
      'policy number',
      'loan number',
      'licence number',
      'license number',
      'transaction id',
    ])) {
      return values['documentNumber'] ?? '';
    }

    return '';
  }

  void _applyAutoFillToInfoRows({
    required String name,
    required String ic,
    required String address,
    required String dob,
    required String phone,
    required String email,
    required String gender,
    required String nationality,
    required String employer,
    required String income,
    required String taxId,
    required String documentNumber,
  }) {
    final values = <String, String>{
      'name': name,
      'ic': ic,
      'address': address,
      'dob': dob,
      'phone': phone,
      'email': email,
      'gender': gender,
      'nationality': nationality,
      'employer': employer,
      'income': income,
      'taxId': taxId,
      'documentNumber': documentNumber,
    };

    for (final entry in _infoFieldControllers.entries) {
      final value = _valueForInfoLabel(entry.key, values);
      if (value.isNotEmpty) {
        entry.value.text = value;
      }
    }
  }

  Widget _buildAiOcrSummaryCard() {
    final result = _latestOcrResult;
    final note = _aiNote;

    if (result == null && (note == null || note.isEmpty)) {
      return const SizedBox.shrink();
    }

    final extractedEntries = result?.extracted.entries.where((entry) {
      final value = entry.value?.toString().trim();
      return value != null && value.isNotEmpty && value.toLowerCase() != 'null';
    }).toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD7EBDD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI document summary',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (note != null && note.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              note,
              style: const TextStyle(
                color: Color(0xFF607489),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (result != null) ...[
            const SizedBox(height: 8),
            if (extractedEntries == null || extractedEntries.isEmpty)
              const Text('No extracted fields found from the latest upload.')
            else
              ...extractedEntries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '${_formatExtractedLabel(entry.key)}: ${entry.value}',
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _formatExtractedLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
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

  void _submitCurrentService() {
    if (_isTaxFiling) {
      _submitTaxPayment();
      return;
    }

    if (!_isPopularService) {
      _submitGenericService();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.item.title} service started.')),
    );
  }

  Future<void> _submitGenericService() async {
    final config = _genericServiceConfigs[widget.item.title] ??
        _defaultGenericServiceConfig(widget.item);
    final missingRequired = <String>[];

    for (final label in config.requiredFields) {
      final value = _controllerForInfoField(label).text.trim();
      if (value.isEmpty) {
        missingRequired.add(label);
      }
    }

    if (missingRequired.isNotEmpty) {
      final preview = missingRequired.take(3).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill required fields: $preview')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please sign in first.')));
      return;
    }

    final formData = <String, String>{};
    final seenKeys = <String>{};
    for (final section in config.sections) {
      for (final field in section.fields) {
        final key = _labelKey(field);
        if (seenKeys.contains(key)) {
          continue;
        }
        seenKeys.add(key);
        formData[field] = _controllerForInfoField(field).text.trim();
      }
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('service_applications')
          .add({
            'service': widget.item.title,
            'agency': widget.item.subtitle,
            'fields': formData,
            'required_fields': config.requiredFields,
            'ai_extracted': _latestOcrResult?.extracted ?? const {},
            'created_at': FieldValue.serverTimestamp(),
            'status': 'submitted',
          });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.item.title} submitted successfully.')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Submission failed: $e')));
    }
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
                onPressed: _submitCurrentService,
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
    final config = _genericServiceConfigs[widget.item.title] ??
        _defaultGenericServiceConfig(widget.item);

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
            '${widget.item.title} Application',
            style: const TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            config.description,
            style: const TextStyle(color: Color(0xFF6F8094), fontSize: 12),
          ),
          const SizedBox(height: 14),
          _buildGenericUploadCard(config),
          const SizedBox(height: 14),
          for (final section in config.sections)
            _buildInfoSection(
              section.title,
              [
                for (final field in section.fields) _buildInfoField(field),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGenericUploadCard(_GenericServiceConfig config) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FC),
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
                      'Upload ${widget.item.title} document',
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
              onPressed: () => uploadDocument(config.uploadType),
              icon: const Icon(Icons.file_upload_outlined),
              label: const Text('Upload Document'),
            ),
          ),
          const SizedBox(height: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDCE5F0)),
            ),
            child: Text(
              'Accepted files: ${config.acceptedDocs}.',
              style: const TextStyle(
                color: Color(0xFF6F8094),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildAiOcrSummaryCard(),
        ],
      ),
    );
  }

  _GenericServiceConfig _defaultGenericServiceConfig(ServiceItem item) {
    return const _GenericServiceConfig(
      description:
          'Upload your documents, use AI auto-fill, and complete the required details below.',
      uploadType: 'general',
      uploadHint: 'Upload supporting documents relevant to this service.',
      acceptedDocs: 'PDF, JPG, PNG',
      requiredFields: ['Full Name', 'IC Number', 'Phone Number'],
      sections: [
        _ServiceSectionConfig(
          title: 'Applicant Information',
          fields: ['Full Name', 'IC Number', 'Phone Number', 'Email Address'],
          requiredFields: ['Full Name', 'IC Number', 'Phone Number'],
        ),
        _ServiceSectionConfig(
          title: 'Application Details',
          fields: ['Reference Number', 'Notes'],
          requiredFields: ['Reference Number'],
        ),
      ],
    );
  }

  Widget _buildEpfForm() {
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
          const Text(
            'EPF (KWSP) Management',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload your supporting documents before continuing with EPF services.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FC),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload document',
                            style: TextStyle(
                              color: Color(0xFF1E2D3F),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'PDF, JPG, PNG up to 10MB each. Scan clearly for faster verification.',
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument('epf'),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Choose File'),
                  ),
                ),

                const SizedBox(height: 8),

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCE5F0)),
                  ),
                  child: const Text(
                    'Accepted files: identification proof, employment letter, salary slip, EPF statement, or any supporting PDF/image.',
                    style: TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildAiOcrSummaryCard(),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ===== FORM FIELDS USING CONTROLLERS =====
          const Text(
            '1. Member Information',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _epfNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _epfIdController,
            decoration: const InputDecoration(
              labelText: 'IC Number (MyKad)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _epfPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _epfEmployerController,
            decoration: const InputDecoration(
              labelText: 'Employer Name',
              border: OutlineInputBorder(),
            ),
          ),

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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9E2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1E2D3F),
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
    final controller = _controllerForInfoField(label);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF607489),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
            ),
          ),
        ],
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

  Widget _buildHealthForm() {
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
          const Text(
            'Health Service Registration',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload supporting documents, then fill in the required health registration details manually.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FC),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload health document',
                            style: TextStyle(
                              color: Color(0xFF1E2D3F),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Medical card, referral letter, or previous reports.',
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument('kkm'),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Upload Document'),
                  ),
                ),

                const SizedBox(height: 8),

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCE5F0)),
                  ),
                  child: const Text(
                    'Accepted files: PDF, JPG, PNG (ID card, insurance card, medical report).',
                    style: TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildAiOcrSummaryCard(),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Quick Auto-Fill Fields',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _healthNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _healthIdController,
            decoration: const InputDecoration(
              labelText: 'IC Number / Passport',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _healthDobController,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _healthPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PTPTN Loan Payment',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload supporting documents and fill in payment details manually.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FC),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload payment document',
                            style: TextStyle(
                              color: Color(0xFF1E2D3F),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Optional: PTPTN statement, previous receipt, or payment reference slip.',
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument('ptptn'),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Upload Document'),
                  ),
                ),

                const SizedBox(height: 8),

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCE5F0)),
                  ),
                  child: const Text(
                    'Upload: PDF, JPG, PNG documents. Auto Fill will extract borrower details automatically.',
                    style: TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildAiOcrSummaryCard(),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Quick Auto-Fill Fields',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ptptnNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ptptnIdController,
            decoration: const InputDecoration(
              labelText: 'IC Number (MyKad)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ptptnPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Licence Renewal (JPJ)',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload your photo or use the existing JPJ photo, then complete the renewal details below.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FC),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload document',
                            style: TextStyle(
                              color: Color(0xFF1E2D3F),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Current license, IC, or supporting documents.',
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument('jpj'),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Upload Document'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument('jpj'),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Use Existing JPJ Photo'),
                  ),
                ),
                const SizedBox(height: 8),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCE5F0)),
                  ),
                  child: const Text(
                    'Accepted files: PDF, JPG, PNG (current license, IC, medical form if required).',
                    style: TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildAiOcrSummaryCard(),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Quick Auto-Fill Fields',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _licenseNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _licenseIdController,
            decoration: const InputDecoration(
              labelText: 'IC Number (MyKad)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _licenseDobController,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summons Payment',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your identification details to auto-fetch summons records, then complete the payment UI below.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FC),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summons lookup document',
                            style: TextStyle(
                              color: Color(0xFF1E2D3F),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Optional document upload placeholder for summons notice or related file.',
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => uploadDocument('pdrm'),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Upload Summons Document'),
                  ),
                ),
                const SizedBox(height: 8),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCE5F0)),
                  ),
                  child: const Text(
                    'Accepted files: summons notice, notice image, or supporting PDF/image. UI only.',
                    style: TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildAiOcrSummaryCard(),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Quick Auto-Fill Fields',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _summonsNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _summonsIdController,
            decoration: const InputDecoration(
              labelText: 'IC Number (MyKad)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _summonsPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
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
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Color(0xFF3DA5F5),
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1E2D3F),
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
                      onPressed: () => uploadDocument('tax'),
                      icon: const Icon(Icons.file_upload_outlined),
                      label: const Text('Upload Document'),
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

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 42,
              child: FilledButton.icon(
                onPressed: fillWithAI,
                icon: const Icon(Icons.auto_awesome),
                label: const Text("Auto Fill with AI"),
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
                'Upload: PDF, image, or document\nAuto Fill: uses AI to prefill tax form fields',
                style: TextStyle(
                  color: Color(0xFF6F8094),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            _buildAiOcrSummaryCard(),

            const SizedBox(height: 12),

            const Text(
              '0. Applicant Name',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'This is extracted from your IC or profile when available.',
              style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Name is required'
                  : null,
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
              '2a. Applicant Address',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              '2b. Date of Birth',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
              ),
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
            const Text(
              'Wrong year can result in incorrect payment records.',
              style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _assessmentYear,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: years
                  .map(
                    (year) => DropdownMenuItem(value: year, child: Text(year)),
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

class _ServiceSectionConfig {
  const _ServiceSectionConfig({
    required this.title,
    required this.fields,
    this.requiredFields = const [],
  });

  final String title;
  final List<String> fields;
  final List<String> requiredFields;
}

class _GenericServiceConfig {
  const _GenericServiceConfig({
    required this.description,
    required this.uploadType,
    required this.uploadHint,
    required this.acceptedDocs,
    required this.requiredFields,
    required this.sections,
  });

  final String description;
  final String uploadType;
  final String uploadHint;
  final String acceptedDocs;
  final List<String> requiredFields;
  final List<_ServiceSectionConfig> sections;
}

const Map<String, _GenericServiceConfig> _genericServiceConfigs = {
  'Birth Certificate': _GenericServiceConfig(
    description:
        'Request or verify birth certificate records with applicant and child details.',
    uploadType: 'jpn_birth',
    uploadHint: 'Upload supporting identity and birth-related documents.',
    acceptedDocs: 'MyKad, child hospital card, old certificate copy (PDF/JPG/PNG)',
    requiredFields: [
      'Applicant Name',
      'Applicant IC Number',
      'Child Full Name',
      'Child Date of Birth',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Applicant Information',
        fields: [
          'Applicant Name',
          'Applicant IC Number',
          'Phone Number',
          'Email Address',
          'Residential Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Child Information',
        fields: [
          'Child Full Name',
          'Child Date of Birth',
          'Birth Place',
          'Certificate Number (if reprint)',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Request Details',
        fields: ['Request Type', 'Reason for Request', 'Collection Method'],
      ),
    ],
  ),
  'Housing Application': _GenericServiceConfig(
    description:
        'Apply for PR1MA housing by providing household profile, income, and preferred unit.',
    uploadType: 'pr1ma',
    uploadHint: 'Upload income and family-supporting documents.',
    acceptedDocs: 'Pay slip, EPF statement, marriage cert, dependent docs',
    requiredFields: [
      'Applicant Name',
      'Applicant IC Number',
      'Monthly Household Income (RM)',
      'Preferred Project / Area',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Applicant Information',
        fields: [
          'Applicant Name',
          'Applicant IC Number',
          'Phone Number',
          'Email Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Household Profile',
        fields: [
          'Marital Status',
          'Number of Dependents',
          'Monthly Household Income (RM)',
          'Current Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Housing Preferences',
        fields: [
          'Preferred Project / Area',
          'Property Type',
          'Financing Preference',
          'Special Notes',
        ],
      ),
    ],
  ),
  'Social Welfare': _GenericServiceConfig(
    description:
        'Submit welfare aid application with household and financial vulnerability details.',
    uploadType: 'jkm',
    uploadHint: 'Upload proof of income and supporting household documents.',
    acceptedDocs: 'Income proof, OKU card, utility bill, family documents',
    requiredFields: [
      'Applicant Name',
      'Applicant IC Number',
      'Assistance Type',
      'Monthly Income (RM)',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Applicant Information',
        fields: [
          'Applicant Name',
          'Applicant IC Number',
          'Phone Number',
          'Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Household & Financial Info',
        fields: [
          'Number of Dependents',
          'Monthly Income (RM)',
          'Employment Status',
          'Current Hardship Description',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Aid Request',
        fields: ['Assistance Type', 'Preferred Channel', 'Bank Account Number'],
      ),
    ],
  ),
  'Business Registration': _GenericServiceConfig(
    description:
        'Register a new business with owner identity, business profile, and compliance details.',
    uploadType: 'ssm',
    uploadHint: 'Upload owner identity and supporting business documents.',
    acceptedDocs: 'MyKad/passport, tenancy agreement, partnership docs',
    requiredFields: [
      'Owner Full Name',
      'Owner IC Number',
      'Business Name',
      'Business Type',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Owner Details',
        fields: [
          'Owner Full Name',
          'Owner IC Number',
          'Phone Number',
          'Email Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Business Details',
        fields: [
          'Business Name',
          'Business Type',
          'Business Address',
          'Business Start Date',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Compliance Details',
        fields: [
          'Capital Amount (RM)',
          'Shareholders / Partners',
          'Supporting Notes',
        ],
      ),
    ],
  ),
  'Legal Aid': _GenericServiceConfig(
    description:
        'Apply for legal aid by describing your case, legal category, and urgency.',
    uploadType: 'bheuu',
    uploadHint: 'Upload court letters, notices, or legal evidence files.',
    acceptedDocs: 'Court notice, police report, supporting legal docs',
    requiredFields: [
      'Applicant Full Name',
      'Applicant IC Number',
      'Case Category',
      'Case Summary',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Applicant Information',
        fields: [
          'Applicant Full Name',
          'Applicant IC Number',
          'Phone Number',
          'Email Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Case Information',
        fields: [
          'Case Category',
          'Case Summary',
          'Court Location',
          'Urgency Level',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Representation Preference',
        fields: [
          'Preferred Consultation Method',
          'Hearing Date (if any)',
          'Additional Remarks',
        ],
      ),
    ],
  ),
  'Passport Renewal': _GenericServiceConfig(
    description:
        'Renew passport by confirming identity, passport details, and delivery preferences.',
    uploadType: 'jim',
    uploadHint: 'Upload current passport bio page and photo.',
    acceptedDocs: 'Current passport copy, photo, supporting travel docs',
    requiredFields: [
      'Full Name',
      'IC Number / Passport Number',
      'Passport Expiry Date',
      'Renewal Duration',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Identity Details',
        fields: [
          'Full Name',
          'IC Number / Passport Number',
          'Date of Birth',
          'Nationality',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Passport Details',
        fields: [
          'Passport Number',
          'Passport Expiry Date',
          'Renewal Duration',
          'Collection Office',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Contact & Delivery',
        fields: ['Phone Number', 'Email Address', 'Delivery Address'],
      ),
    ],
  ),
  'Marriage Registration': _GenericServiceConfig(
    description:
        'Register marriage by submitting bride and groom identity and ceremony details.',
    uploadType: 'jpn_marriage',
    uploadHint: 'Upload identification and marriage-supporting documents.',
    acceptedDocs: 'MyKad/passport, witness details, pre-marriage docs',
    requiredFields: [
      'Groom Full Name',
      'Groom IC Number',
      'Bride Full Name',
      'Bride IC Number',
      'Proposed Marriage Date',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Groom Information',
        fields: [
          'Groom Full Name',
          'Groom IC Number',
          'Groom Date of Birth',
          'Groom Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Bride Information',
        fields: [
          'Bride Full Name',
          'Bride IC Number',
          'Bride Date of Birth',
          'Bride Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Marriage Details',
        fields: [
          'Proposed Marriage Date',
          'Marriage Venue',
          'Witness 1 Name',
          'Witness 2 Name',
        ],
      ),
    ],
  ),
  'Land Tax Payment': _GenericServiceConfig(
    description:
        'Pay land tax by providing owner details, property references, and payment info.',
    uploadType: 'ptg',
    uploadHint: 'Upload land title or tax bill for auto extraction.',
    acceptedDocs: 'Land title, latest quit-rent bill, owner IC',
    requiredFields: [
      'Owner Full Name',
      'Owner IC Number',
      'Property Lot Number',
      'Amount to Pay (RM)',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Owner Information',
        fields: [
          'Owner Full Name',
          'Owner IC Number',
          'Phone Number',
          'Email Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Property Information',
        fields: [
          'Property Lot Number',
          'Title Number',
          'Property Address',
          'District / State',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Payment Details',
        fields: [
          'Assessment Year',
          'Amount to Pay (RM)',
          'Payment Method',
          'Reference Number',
        ],
      ),
    ],
  ),
  'Vehicle Ownership Transfer': _GenericServiceConfig(
    description:
        'Transfer vehicle ownership using seller/buyer details and vehicle records.',
    uploadType: 'jpj_transfer',
    uploadHint: 'Upload grant copy and transfer authorization documents.',
    acceptedDocs: 'Geran copy, seller/buyer IC, Puspakom documents',
    requiredFields: [
      'Seller Full Name',
      'Seller IC Number',
      'Buyer Full Name',
      'Buyer IC Number',
      'Vehicle Registration Number',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Seller Information',
        fields: [
          'Seller Full Name',
          'Seller IC Number',
          'Seller Phone Number',
          'Seller Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Buyer Information',
        fields: [
          'Buyer Full Name',
          'Buyer IC Number',
          'Buyer Phone Number',
          'Buyer Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Vehicle & Transfer Details',
        fields: [
          'Vehicle Registration Number',
          'Vehicle Chassis Number',
          'Transfer Date',
          'Transfer Fee (RM)',
        ],
      ),
    ],
  ),
  'Court Case Status': _GenericServiceConfig(
    description:
        'Check court case status by submitting case reference and litigant details.',
    uploadType: 'court_case',
    uploadHint: 'Upload case notice or court reference documents.',
    acceptedDocs: 'Court notice, case filing papers, legal letters',
    requiredFields: [
      'Applicant Full Name',
      'Applicant IC Number',
      'Case Reference Number',
      'Court Name',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Applicant Information',
        fields: [
          'Applicant Full Name',
          'Applicant IC Number',
          'Phone Number',
          'Email Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Case Information',
        fields: [
          'Case Reference Number',
          'Court Name',
          'Case Category',
          'Hearing Date (if any)',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Tracking Preference',
        fields: ['Notification Method', 'Additional Remarks'],
      ),
    ],
  ),
  'Zakat Payment': _GenericServiceConfig(
    description:
        'Calculate and submit zakat payment details with payer profile and declaration.',
    uploadType: 'zakat',
    uploadHint: 'Upload income statement or zakat support documents.',
    acceptedDocs: 'Income statement, zakat worksheet, identification',
    requiredFields: [
      'Payer Full Name',
      'Payer IC Number',
      'Zakat Type',
      'Amount to Pay (RM)',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Payer Information',
        fields: [
          'Payer Full Name',
          'Payer IC Number',
          'Phone Number',
          'Email Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Zakat Details',
        fields: [
          'Zakat Type',
          'Assessment Year',
          'Amount to Pay (RM)',
          'Declaration Notes',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Payment Channel',
        fields: ['Payment Method', 'Receipt Delivery Email'],
      ),
    ],
  ),
  'Public Complaint': _GenericServiceConfig(
    description:
        'Submit a public complaint with issue details, location, and supporting evidence.',
    uploadType: 'sispaa',
    uploadHint: 'Upload evidence such as photos, letters, or screenshots.',
    acceptedDocs: 'Photo evidence, documents, screenshots, PDF/JPG/PNG',
    requiredFields: [
      'Complainant Name',
      'Complainant IC Number',
      'Complaint Category',
      'Complaint Summary',
    ],
    sections: [
      _ServiceSectionConfig(
        title: 'Complainant Information',
        fields: [
          'Complainant Name',
          'Complainant IC Number',
          'Phone Number',
          'Email Address',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Complaint Details',
        fields: [
          'Complaint Category',
          'Incident Date',
          'Incident Location',
          'Complaint Summary',
        ],
      ),
      _ServiceSectionConfig(
        title: 'Follow-up',
        fields: ['Preferred Contact Method', 'Supporting Notes'],
      ),
    ],
  ),
};

class ServiceItem {
  const ServiceItem({
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

const List<ServiceItem> _popularItems = [
  ServiceItem(
    title: 'Tax Filing',
    subtitle: 'LHDN / MyTax',
    icon: Icons.attach_money,
    iconColor: Color(0xFF2ECC71),
    iconBg: Color(0xFFE8F6EE),
  ),
  ServiceItem(
    title: 'EPF Management',
    subtitle: 'KWSP',
    icon: Icons.account_balance,
    iconColor: Color(0xFF3DA5F5),
    iconBg: Color(0xFFE8F4FE),
  ),
  ServiceItem(
    title: 'Health Services',
    subtitle: 'KKM',
    icon: Icons.favorite_border,
    iconColor: Color(0xFFF5A623),
    iconBg: Color(0xFFFFF3E6),
  ),
  ServiceItem(
    title: 'Loan Payment',
    subtitle: 'PTPTN',
    icon: Icons.school_outlined,
    iconColor: Color(0xFFE57373),
    iconBg: Color(0xFFFDEDEE),
  ),
  ServiceItem(
    title: 'License Renewal',
    subtitle: 'JPJ',
    icon: Icons.directions_car_outlined,
    iconColor: Color(0xFF607489),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Summons Payment',
    subtitle: 'PDRM',
    icon: Icons.warning_amber_outlined,
    iconColor: Color(0xFFF5A623),
    iconBg: Color(0xFFFFF3E6),
  ),
];

const List<ServiceItem> _allItems = [
  ServiceItem(
    title: 'Birth Certificate',
    subtitle: 'JPN',
    icon: Icons.description_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Housing Application',
    subtitle: 'PR1MA',
    icon: Icons.home_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Social Welfare',
    subtitle: 'JKM',
    icon: Icons.people_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Business Registration',
    subtitle: 'SSM',
    icon: Icons.work_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Legal Aid',
    subtitle: 'BHEUU',
    icon: Icons.balance_outlined,
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
    title: 'Marriage Registration',
    subtitle: 'JPN',
    icon: Icons.favorite_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Land Tax Payment',
    subtitle: 'PTG',
    icon: Icons.map_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Vehicle Ownership Transfer',
    subtitle: 'JPJ',
    icon: Icons.swap_horiz_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Court Case Status',
    subtitle: 'e-Kehakiman',
    icon: Icons.gavel_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Zakat Payment',
    subtitle: 'PPZ',
    icon: Icons.volunteer_activism_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  ServiceItem(
    title: 'Public Complaint',
    subtitle: 'SISPAA',
    icon: Icons.campaign_outlined,
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
