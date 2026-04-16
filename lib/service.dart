import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';
<<<<<<< Updated upstream
=======
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
>>>>>>> Stashed changes

import 'services/ai_service.dart';
import 'services/prefill_service.dart';
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
<<<<<<< Updated upstream
=======
  State<_ServicesBody> createState() => _ServicesBodyState();
}

class _ServicesBodyState extends State<_ServicesBody> {
  String query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openTargetServiceIfRequested();
    });
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
      MaterialPageRoute(builder: (_) => _ServiceActionPage(item: target.first)),
    );
  }

  @override
>>>>>>> Stashed changes
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
    
    super.dispose();
  }

<<<<<<< Updated upstream
=======
  Future<void> fillWithAI() async {
    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Please sign in first.');
      }

      final profileDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final profile = profileDoc.data() ?? const {};

      final documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .get();

      final documents = documentSnapshot.docs.map((doc) => doc.data()).toList();
      final prefill = PrefillService.buildPrefill(profile: profile, documents: documents);
      final ocrResult = AiDraftStore.instance.lastOcrResult;

      _latestOcrResult = ocrResult;

      setState(() {
        _aiNote = ocrResult == null
            ? 'No OCR result yet. Upload a document first.'
            : 'OCR data loaded for ${widget.item.title}.';

        final name = ocrResult?.fullName ?? (prefill['name'] ?? profile['name'] ?? '').toString();
        final ic = ocrResult?.icNumber ?? (prefill['ic'] ?? profile['ic'] ?? '').toString();
        final address = ocrResult?.address ?? (profile['address'] ?? '').toString();
        final dob = ocrResult?.dob ?? (profile['dob'] ?? '').toString();
        final phone = ocrResult?.phone ?? (profile['phone'] ?? '').toString();
        final income = _formatAmount(ocrResult?.income ?? prefill['income'] ?? profile['income']);

        if (_isTaxFiling) {
          _nameController.text = name;
          _tinController.text = (profile['tin'] ?? profile['tax_id'] ?? '').toString();
          _idController.text = ic;
          _addressController.text = address;
          _dobController.text = dob;
          _amountController.text = income;

          final estimatedTax = profile['estimatedTax']?.toString();
          if (_amountController.text.isEmpty && estimatedTax != null && estimatedTax.isNotEmpty) {
            _amountController.text = estimatedTax;
          }
        } else if (_isEpfManagement) {
          _epfNameController.text = name;
          _epfIdController.text = ic;
          _epfPhoneController.text = phone;
          _epfEmployerController.text = ocrResult?.phone ?? profile['employer_name'] ?? '';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI fill failed: $e')),
      );
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
          _addressController.text = extracted.address ?? _addressController.text;
          _dobController.text = extracted.dob ?? _dobController.text;
          _amountController.text = _formatAmount(extracted.income);
        });
      } else if (_isEpfManagement) {
        setState(() {
          _epfNameController.text = extracted.fullName ?? _epfNameController.text;
          _epfIdController.text = extracted.icNumber ?? _epfIdController.text;
          _epfPhoneController.text = extracted.phone ?? _epfPhoneController.text;
        });
      } else if (_isHealthService) {
        setState(() {
          _healthNameController.text = extracted.fullName ?? _healthNameController.text;
          _healthIdController.text = extracted.icNumber ?? _healthIdController.text;
          _healthPhoneController.text = extracted.phone ?? _healthPhoneController.text;
          _healthDobController.text = extracted.dob ?? _healthDobController.text;
        });
      } else if (_isLoanPayment) {
        setState(() {
          _ptptnNameController.text = extracted.fullName ?? _ptptnNameController.text;
          _ptptnIdController.text = extracted.icNumber ?? _ptptnIdController.text;
          _ptptnPhoneController.text = extracted.phone ?? _ptptnPhoneController.text;
        });
      } else if (_isLicenseRenewal) {
        setState(() {
          _licenseNameController.text = extracted.fullName ?? _licenseNameController.text;
          _licenseIdController.text = extracted.icNumber ?? _licenseIdController.text;
          _licenseDobController.text = extracted.dob ?? _licenseDobController.text;
        });
      } else if (_isSummonsPayment) {
        setState(() {
          _summonsNameController.text = extracted.fullName ?? _summonsNameController.text;
          _summonsIdController.text = extracted.icNumber ?? _summonsIdController.text;
          _summonsPhoneController.text = extracted.phone ?? _summonsPhoneController.text;
        });
      }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OCR upload failed: $e')),
      );
    } finally {
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

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
            'Upload your supporting documents before continuing with EPF services.',
            style: TextStyle(
              color: Color(0xFF6F8094),
              fontSize: 12,
            ),
=======
            'Upload your EPF documents and auto-fill your details.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
>>>>>>> Stashed changes
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
                    onPressed: () {},
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Choose File'),
                  ),
                ),
<<<<<<< Updated upstream
=======

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

>>>>>>> Stashed changes
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
          
          const SizedBox(height: 14),
<<<<<<< Updated upstream
          _buildInfoSection(
            '1. Member (User) Information',
            [
              _buildInfoField('Full Name'),
              _buildInfoField('IC Number (MyKad)'),
              _buildInfoPair('Date of Birth', 'Gender'),
              _buildInfoPair('Phone Number', 'Email Address'),
              _buildInfoField('Address'),
              _buildInfoField('Employment Status'),
            ],
          ),
          _buildInfoSection(
            '2. Employment Details',
            [
              _buildInfoPair('Employer Name', 'Company ID'),
              _buildInfoPair('Start Date of Employment', 'Employment Type'),
              _buildInfoField('Salary Amount (RM)'),
            ],
          ),
          _buildInfoSection(
            '3. Contribution Information',
            [
              _buildInfoPair('Employee Contribution (%)', 'Employee Contribution (RM)'),
              _buildInfoPair('Employer Contribution (%)', 'Employer Contribution (RM)'),
              _buildInfoField('Monthly Contribution Records'),
              _buildInfoPair('Contribution Date', 'Total Accumulated Balance (RM)'),
            ],
          ),
          _buildInfoSection(
            '4. Account Structure',
            [
              _buildInfoPair('Account 1 Balance (RM)', 'Account 2 Balance (RM)'),
              _buildInfoField('Account 3 Balance (optional)'),
              _buildInfoField('Transaction History Summary'),
            ],
          ),
          _buildInfoSection(
            '5. Transaction Records',
            [
              _buildInfoField('Monthly Deposits'),
              _buildInfoField('Withdrawals'),
              _buildInfoField('Transfers Between Accounts'),
              _buildInfoField('Dividend Payments'),
            ],
          ),
          _buildInfoSection(
            '6. Dividend / Interest Info',
            [
              _buildInfoPair('Annual Dividend Rate (%)', 'Dividend Earned Per Year (RM)'),
              _buildInfoField('Historical Dividend Records'),
            ],
          ),
          _buildInfoSection(
            '7. Withdrawal Management',
            [
              _buildInfoField('Type of Withdrawal (housing, education, etc.)'),
              _buildInfoPair('Amount Withdrawn (RM)', 'Date of Withdrawal'),
              _buildInfoField('Approval Status'),
            ],
          ),
          _buildInfoSection(
            '8. Login & Security',
            [
              _buildInfoField('Username / ID'),
              _buildInfoField('Password (encrypted placeholder)'),
              _buildInfoField('Authentication Method (OTP, etc.)'),
            ],
          ),
          _buildInfoSection(
            '9. Reports / Summary',
            [
              _buildInfoField('Annual Statement'),
              _buildInfoField('Contribution Summary'),
              _buildInfoField('Total Savings Overview'),
              _buildInfoField('Retirement Savings Simulation'),
            ],
=======
          const Text(
            '2. Employment Details',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _epfEmployerController,
            decoration: const InputDecoration(
              labelText: 'Employer Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Employment Start Date',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Monthly Salary (RM)',
              border: OutlineInputBorder(),
              hintText: '0.00',
            ),
          ),
          
          const SizedBox(height: 14),
          const Text(
            '3. Account Information',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Account 1 Balance (RM) - Savings',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Account 2 Balance (RM) - Investment',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Total Accumulated Balance (RM)',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 14),
          const Text(
            '4. Contribution & Withdrawals',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Withdrawal Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'retirement', child: Text('Retirement (Age 55+)')),
              DropdownMenuItem(value: 'housing', child: Text('Housing Loan')),
              DropdownMenuItem(value: 'medical', child: Text('Medical/Education')),
              DropdownMenuItem(value: 'none', child: Text('No Withdrawal')),
            ],
            onChanged: (value) {},
>>>>>>> Stashed changes
          ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
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
<<<<<<< Updated upstream
            'Upload supporting documents, then fill in the required health registration details manually.',
            style: TextStyle(
              color: Color(0xFF6F8094),
              fontSize: 12,
            ),
=======
            'Upload supporting documents and auto-fill your health registration details.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Choose Document'),
                  ),
                ),
<<<<<<< Updated upstream
=======

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

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          _buildInfoSection(
            '1. Personal Information (Basic Identity)',
            [
              _buildInfoField('Full Name'),
              _buildInfoField('IC Number / Passport'),
              _buildInfoPair('Date of Birth', 'Gender'),
              _buildInfoField('Nationality'),
            ],
          ),
          _buildInfoSection(
            '2. Contact Information',
            [
              _buildInfoPair('Phone Number', 'Email Address'),
              _buildInfoField('Home Address'),
            ],
          ),
          _buildInfoSection(
            '3. Health Profile (Very Important)',
            [
              _buildInfoField('Blood Type (if known)'),
              _buildInfoField('Allergies (medication, food, etc.)'),
              _buildInfoField('Existing Medical Conditions (diabetes, asthma, etc.)'),
              _buildInfoField('Current Medications'),
            ],
          ),
          _buildInfoSection(
            '4. Emergency Contact',
            [
              _buildInfoField('Emergency Contact Name'),
              _buildInfoPair('Relationship', 'Emergency Contact Phone Number'),
            ],
          ),
          _buildInfoSection(
            '5. Insurance / Payment Info',
            [
              _buildInfoField('Insurance Provider (if any)'),
              _buildInfoField('Policy Number'),
              _buildInfoField('Payment Method'),
            ],
          ),
          _buildInfoSection(
            '6. Appointment / Service Details',
            [
              _buildInfoField('Type of Service (check-up, vaccination, etc.)'),
              _buildInfoPair('Preferred Date & Time', 'Selected Clinic / Hospital'),
            ],
          ),
          _buildInfoSection(
            '7. Health ID / Integration',
            [
              _buildInfoField('MyKad Number (Main ID)'),
              _buildInfoField('Link to Government Systems (optional)'),
            ],
          ),
          _buildInfoSection(
            '8. Account & Login',
            [
              _buildInfoField('Username / Email'),
              _buildInfoField('Password'),
              _buildInfoField('OTP / Verification'),
            ],
          ),
          _buildInfoSection(
            '9. Consent & Declarations',
            [
              _buildInfoField('Consent to Share Medical Data (Yes/No)'),
              _buildInfoField('Agreement to Terms & Privacy Policy (Yes/No)'),
            ],
          ),
          _buildInfoSection(
            'MVP Quick Registration',
            [
              _buildInfoPair('Name', 'IC Number'),
              _buildInfoField('Phone Number'),
              _buildInfoField('Allergy + Medical Condition Summary'),
              _buildInfoField('Appointment Booking Notes'),
              _buildInfoField('Emergency Contact (Name + Phone)'),
            ],
=======
          
          // ===== FORM FIELDS USING CONTROLLERS =====
          const Text(
            '1. Personal Information',
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
          
          const SizedBox(height: 14),
          const Text(
            '2. Contact Information',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _healthPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 14),
          const Text(
            '3. Health Profile',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Blood Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'O+', child: Text('O+')),
              DropdownMenuItem(value: 'O-', child: Text('O-')),
              DropdownMenuItem(value: 'A+', child: Text('A+')),
              DropdownMenuItem(value: 'A-', child: Text('A-')),
              DropdownMenuItem(value: 'B+', child: Text('B+')),
              DropdownMenuItem(value: 'B-', child: Text('B-')),
              DropdownMenuItem(value: 'AB+', child: Text('AB+')),
              DropdownMenuItem(value: 'AB-', child: Text('AB-')),
              DropdownMenuItem(value: 'Unknown', child: Text('Unknown')),
            ],
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Allergies (medication, food, etc.)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Existing Medical Conditions',
              border: OutlineInputBorder(),
              hintText: 'e.g. diabetes, asthma, hypertension',
            ),
          ),
          
          const SizedBox(height: 14),
          const Text(
            '4. Emergency Contact',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Emergency Contact Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Emergency Contact Phone',
              border: OutlineInputBorder(),
            ),
>>>>>>> Stashed changes
          ),
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
<<<<<<< Updated upstream
            'Upload supporting documents and fill in payment details manually.',
            style: TextStyle(
              color: Color(0xFF6F8094),
              fontSize: 12,
            ),
=======
            'Upload supporting documents and fill in payment details. Auto Fill will extract from your documents.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
>>>>>>> Stashed changes
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
                    onPressed: () {},
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Choose Document'),
                  ),
                ),
<<<<<<< Updated upstream
=======

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

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          _buildInfoSection(
            '1. Borrower Identification (VERY IMPORTANT)',
            [
              _buildInfoField('Full Name'),
              _buildInfoField('IC Number (MyKad)'),
              _buildInfoField('PTPTN Loan Number (if available)'),
            ],
          ),
          _buildInfoSection(
            '2. Contact Information',
            [
              _buildInfoPair('Phone Number', 'Email Address'),
            ],
          ),
          _buildInfoSection(
            '3. Loan Details',
            [
              _buildInfoField('Outstanding Balance (auto-fetch placeholder)'),
              _buildInfoField('Monthly Instalment Amount (auto-fetch placeholder)'),
              _buildInfoField('Account Status (active / overdue)'),
            ],
          ),
          _buildInfoSection(
            '4. Payment Information',
            [
              _buildInfoField('Payment Amount (RM)'),
              _buildInfoField('Payment Type (full settlement / monthly / extra payment)'),
              _buildInfoField('Payment Method (FPX / card / e-wallet)'),
            ],
          ),
          _buildInfoSection(
            '5. Payment Reference Details',
            [
              _buildInfoPair('Payment Date', 'Reference Number (auto-generated placeholder)'),
              _buildInfoField('Transaction ID'),
            ],
          ),
          _buildInfoSection(
            '6. Authentication / Verification',
            [
              _buildInfoField('Login Account'),
              _buildInfoField('OTP / TAC Verification'),
            ],
          ),
          _buildInfoSection(
            '7. Confirmation & Receipt',
            [
              _buildInfoField('Payment Summary (before confirm)'),
              _buildInfoField('Digital Receipt (after payment)'),
              _buildInfoField('Send Receipt (download / email)'),
            ],
          ),
          _buildInfoSection(
            'Important Checks Before Payment',
            [
              _buildInfoField('IC / Loan Number verified'),
              _buildInfoField('Payment amount verified'),
              _buildInfoField('Payment type selected correctly'),
            ],
          ),
          _buildInfoSection(
            'MVP Quick Pay',
            [
              _buildInfoField('IC Number'),
              _buildInfoField('Auto-fetched Loan Info (placeholder)'),
              _buildInfoField('Enter Amount'),
              _buildInfoField('Choose Payment Method'),
              _buildInfoField('Confirm & Pay'),
            ],
=======
          
          // ===== FORM FIELDS USING CONTROLLERS =====
          const Text(
            '1. Borrower Identification',
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
            decoration: const InputDecoration(
              labelText: 'PTPTN Loan Number (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 14),
          const Text(
            '2. Contact Information',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ptptnPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 14),
          const Text(
            '3. Payment Information',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Outstanding Balance (RM)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Payment Amount (RM)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Payment Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'monthly', child: Text('Monthly Instalment')),
              DropdownMenuItem(value: 'full', child: Text('Full Settlement')),
              DropdownMenuItem(value: 'extra', child: Text('Extra Payment')),
            ],
            onChanged: (value) {},
>>>>>>> Stashed changes
          ),
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
<<<<<<< Updated upstream
            'Upload your photo or use the existing JPJ photo, then complete the renewal details below.',
            style: TextStyle(
              color: Color(0xFF6F8094),
              fontSize: 12,
            ),
=======
            'Upload your identification and auto-fill your renewal details.',
            style: TextStyle(color: Color(0xFF6F8094), fontSize: 12),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Upload Document'),
                  ),
                ),
                const SizedBox(height: 8),
<<<<<<< Updated upstream
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Use Existing JPJ Photo'),
                  ),
                ),
=======

                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: FilledButton.icon(
                    onPressed: fillWithAI,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Auto Fill with AI'),
                  ),
                ),

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          _buildInfoSection(
            '1. Personal Identification (Core)',
            [
              _buildInfoField('Full Name'),
              _buildInfoField('IC Number (MyKad) - Main Identifier'),
              _buildInfoField('Date of Birth'),
            ],
          ),
          _buildInfoSection(
            '2. Licence Information',
            [
              _buildInfoField('Licence Number'),
              _buildInfoPair('Licence Class (D, B2, etc.)', 'Expiry Date'),
              _buildInfoField('Licence Status (active / expired / suspended)'),
            ],
          ),
          _buildInfoSection(
            '3. Contact Information',
            [
              _buildInfoPair('Phone Number', 'Email Address'),
              _buildInfoField('Address'),
            ],
          ),
          _buildInfoSection(
            '4. Medical Declaration',
            [
              _buildInfoField('Health Condition Declaration'),
              _buildInfoField('Vision / Medical Fitness'),
            ],
          ),
          _buildInfoSection(
            '5. Renewal Details & Payment',
            [
              _buildInfoField('Renewal Duration (1 year / 2 years / etc.)'),
              _buildInfoField('Fee Amount (auto-calculated placeholder)'),
              _buildInfoField('Payment Method (FPX / card / e-wallet)'),
            ],
          ),
          _buildInfoSection(
            '6. Delivery / Collection Method',
            [
              _buildInfoField('Self-Collect at Counter'),
              _buildInfoField('Delivery Address (if posting licence)'),
            ],
          ),
          _buildInfoSection(
            '7. Verification & Security',
            [
              _buildInfoField('Login / Account'),
              _buildInfoField('OTP / TAC Verification'),
            ],
          ),
          _buildInfoSection(
            '8. Confirmation',
            [
              _buildInfoField('Summary Before Payment'),
              _buildInfoField('Receipt After Payment'),
              _buildInfoField('Renewal Confirmation Status'),
            ],
          ),
          _buildInfoSection(
            'Important Checks',
            [
              _buildInfoField('Licence not blacklisted / suspended'),
              _buildInfoField('No outstanding summons (if required)'),
              _buildInfoField('Correct licence class selected'),
            ],
          ),
          _buildInfoSection(
            'MVP Quick Renewal',
            [
              _buildInfoField('IC Number'),
              _buildInfoField('Auto-fetch licence info (placeholder)'),
              _buildInfoField('Choose Renewal Duration'),
              _buildInfoField('Pay / Done'),
            ],
          ),
=======
          
          // ===== FORM FIELDS USING CONTROLLERS =====
          const Text(
            '1. Personal Identification',
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
          const Text(
            '2. Licence Information',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Licence Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Licence Class',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'D', child: Text('Class D - Car')),
              DropdownMenuItem(value: 'E', child: Text('Class E - Motorcycle')),
              DropdownMenuItem(value: 'B2', child: Text('Class B2 - Heavy Vehicle')),
            ],
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Current Expiry Date',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 14),
          const Text(
            '3. Renewal Details',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Renewal Duration',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: '1', child: Text('1 Year')),
              DropdownMenuItem(value: '2', child: Text('2 Years')),
              DropdownMenuItem(value: '5', child: Text('5 Years')),
            ],
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Renewal Fee (RM)',
              border: OutlineInputBorder(),
              hintText: 'RM 60-90',
            ),
          ),
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
>>>>>>> Stashed changes
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
            style: TextStyle(
              color: Color(0xFF6F8094),
              fontSize: 12,
            ),
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
                    onPressed: () {},
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('Upload Summons Document'),
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
                    'Accepted files: summons notice, notice image, or supporting PDF/image. UI only.',
                    style: TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
<<<<<<< Updated upstream
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildInfoSection(
            '1. Identification (VERY IMPORTANT)',
            [
              _buildInfoField('IC Number (MyKad)'),
              _buildInfoField('Vehicle Plate Number'),
              _buildInfoField('Summons Number (best & most accurate)'),
            ],
          ),
          _buildInfoSection(
            '2. Summons Details (Auto-Fetched)',
            [
              _buildInfoField('Summons Number'),
              _buildInfoField('Offence Type (speeding, parking, etc.)'),
              _buildInfoPair('Date & Location of Offence', 'Issuing Authority (PDRM / JPJ / council)'),
              _buildInfoPair('Amount to Pay', 'Status (unpaid / discounted / overdue)'),
            ],
          ),
          _buildInfoSection(
            '3. Contact Information',
            [
              _buildInfoPair('Phone Number', 'Email'),
            ],
          ),
          _buildInfoSection(
            '4. Payment Information',
            [
              _buildInfoField('Payment Amount (auto or editable)'),
              _buildInfoField('Payment Type (single summons / multiple summons)'),
              _buildInfoField('Payment Method (FPX / card / e-wallet)'),
            ],
          ),
          _buildInfoSection(
            '5. Transaction Details',
            [
              _buildInfoPair('Payment Date', 'Reference Number'),
              _buildInfoField('Transaction ID'),
            ],
          ),
          _buildInfoSection(
            '6. Verification / Security',
            [
              _buildInfoField('Login (optional but recommended)'),
              _buildInfoField('OTP / TAC Verification'),
            ],
          ),
          _buildInfoSection(
            '7. Confirmation & Receipt',
            [
              _buildInfoField('Payment Summary Before Confirm'),
              _buildInfoField('Digital Receipt After Payment'),
              _buildInfoField('Updated Status (paid)'),
            ],
          ),
          _buildInfoSection(
            'Important Checks',
            [
              _buildInfoField('Correct summons selected (if multiple)'),
              _buildInfoField('Amount matches official record'),
              _buildInfoField('Check discount campaigns / promotions'),
            ],
          ),
          _buildInfoSection(
            'MVP Quick Pay',
            [
              _buildInfoField('IC / Plate / Summons Number'),
              _buildInfoField('Auto-fetch summons info (placeholder)'),
              _buildInfoField('Enter Amount'),
              _buildInfoField('Choose Payment Method'),
              _buildInfoField('Confirm & Pay'),
            ],
          ),
        ],
      ),
    );
  }
=======
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDCE5F0)),
                ),
                child: const Text(
                  'Accepted files: summons notice, notice image, or supporting PDF/image.',
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
          '1. Identification',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _summonsIdController,
          decoration: const InputDecoration(
            labelText: 'IC Number (MyKad)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Vehicle Plate Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Summons Number',
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 14),
        const Text(
          '2. Summons Details',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Offence Type',
            border: OutlineInputBorder(),
            hintText: 'e.g. speeding, parking, expired road tax',
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Date of Offence',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Fine Amount (RM)',
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 14),
        const Text(
          '3. Contact Information',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _summonsPhoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 14),
        const Text(
          '4. Payment Information',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Payment Amount (RM)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Payment Method',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'fpx', child: Text('FPX Online')),
            DropdownMenuItem(value: 'card', child: Text('Credit/Debit Card')),
            DropdownMenuItem(value: 'ewallet', child: Text('E-Wallet')),
            DropdownMenuItem(value: 'counter', child: Text('Counter Payment')),
          ],
          onChanged: (value) {},
        ),
      ],
    ),
  );
}
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
=======

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
                ],
              ),
            ),
>>>>>>> Stashed changes
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
