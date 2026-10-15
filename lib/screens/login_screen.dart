import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Supported Languages in AndaExpress
enum AppLanguage {
  hindi,
  marathi,
  english,
}

/// Selected Role on Login
enum UserAppRole {
  buyer,
  seller,
}

class LoginScreen extends StatefulWidget {
  final Function(String phone, String role, String language)? onLoginSuccess;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  AppLanguage _selectedLanguage = AppLanguage.english;
  UserAppRole _selectedRole = UserAppRole.buyer;

  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _agreedToTerms = false;
  int _resendCountdown = 30;

  // Localized strings
  Map<String, String> get _strings {
    switch (_selectedLanguage) {
      case AppLanguage.hindi:
        return {
          'tagline': 'खेत से सीधे ताज़ा अंडे और चिकन हर रोज़',
          'welcome': 'नमस्ते!',
          'subwelcome': 'जारी रखने के लिए अपना मोबाइल नंबर दर्ज करें',
          'buyRole': 'अंडे / चिकन खरीदें',
          'sellRole': 'खेत से बेचें (किसान)',
          'phoneLabel': 'मोबाइल नंबर',
          'phoneHint': '10 अंकों का नंबर',
          'getOtp': 'ओटीपी प्राप्त करें',
          'otpSentMsg': 'पर 6-अंकों का ओटीपी भेजा गया',
          'changeNumber': 'नंबर बदलें',
          'verifyOtp': 'ओटीपी सत्यापित करें और आगे बढ़ें',
          'resendOtp': 'ओटीपी पुनः भेजें',
          'terms': 'लॉगिन करके आप हमारे नियम और शर्तों से सहमत होते हैं',
          'freshGuarantee': '100% फ्लोट टेस्ट ताज़गी गारंटी',
        };
      case AppLanguage.marathi:
        return {
          'tagline': 'थेट शेतातून ताजी अंडी आणि चिकन दररोज',
          'welcome': 'नमस्कार!',
          'subwelcome': 'सुरू ठेवण्यासाठी आपला मोबाईल नंबर टाका',
          'buyRole': 'अंडी / चिकन खरेदी करा',
          'sellRole': 'शेतातून विका (शेतकरी)',
          'phoneLabel': 'मोबाईल नंबर',
          'phoneHint': '10 अंकी नंबर',
          'getOtp': 'ओटीपी मिळवा',
          'otpSentMsg': 'वर 6-अंकी ओटीपी पाठवला आहे',
          'changeNumber': 'नंबर बदला',
          'verifyOtp': 'ओटीपी सत्यापित करा आणि पुढे जा',
          'resendOtp': 'ओटीपी पुन्हा पाठवा',
          'terms': 'लॉगिन करून आपण आमच्या सेवा अटींशी सहमत आहात',
          'freshGuarantee': '100% फ्लोट टेस्ट ताजेपणा हमी',
        };
      case AppLanguage.english:
        return {
          'tagline': 'Farm-Fresh Eggs & Chicken Every Day',
          'welcome': 'Welcome!',
          'subwelcome': 'Enter your mobile number to get started',
          'buyRole': 'I want to Buy',
          'sellRole': 'I want to Sell',
          'phoneLabel': 'Mobile Number',
          'phoneHint': '10-digit number',
          'getOtp': 'Request OTP',
          'otpSentMsg': '6-digit OTP sent to',
          'changeNumber': 'Change Number',
          'verifyOtp': 'Verify OTP & Continue',
          'resendOtp': 'Resend OTP',
          'terms': 'By continuing, you agree to AndaExpress Terms & Privacy',
          'freshGuarantee': '100% Float-Test Freshness Guaranteed',
        };
    }
  }

  void _handleRequestOtp() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate Firebase Auth phone sign-in verification
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isOtpSent = true;
        });
      }
    });
  }

  void _handleVerifyOtp() {
    final otp = _otpController.text.trim();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit OTP code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isLoading = false);
        widget.onLoginSuccess?.call(
          '+91${_phoneController.text.trim()}',
          _selectedRole == UserAppRole.seller ? 'seller' : 'buyer',
          _selectedLanguage.name,
        );
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Farm-fresh green and clean white mobile palette
    const primaryGreen = Color(0xFF1B5E20); // Deep Farm Pasture Green
    const accentGreen = Color(0xFF2E7D32);
    const softGreenBg = Color(0xFFF1F8E9); // Very light fresh mint
    const eggGold = Color(0xFFF59E0B); // Fresh egg golden yolk

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar: Language Selection Pill Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Guarantee mini pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: softGreenBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryGreen.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 14, color: primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          _strings['freshGuarantee']!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Language Segmented Switcher
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLangBtn('हिन्दी', AppLanguage.hindi),
                        _buildLangBtn('मराठी', AppLanguage.marathi),
                        _buildLangBtn('EN', AppLanguage.english),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Brand Logo & Farm-Fresh Green Header
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: softGreenBg,
                            border: Border.all(color: primaryGreen.withOpacity(0.3), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: primaryGreen.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                        // Golden Egg with Green Leaf Accent
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 48,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFDE68A), Color(0xFFF59E0B)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                  bottom: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: eggGold.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text('🥚', style: TextStyle(fontSize: 26)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'AndaExpress',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: primaryGreen,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _strings['tagline']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Role Selection: 'I want to Buy' vs 'I want to Sell'
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        role: UserAppRole.buyer,
                        title: _strings['buyRole']!,
                        icon: Icons.shopping_basket_rounded,
                        subtitle: 'Fresh Eggs & Poultry',
                        primaryColor: primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildRoleCard(
                        role: UserAppRole.seller,
                        title: _strings['sellRole']!,
                        icon: Icons.agriculture_rounded,
                        subtitle: 'Poultry Farm / Breeder',
                        primaryColor: const Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Welcome Text
              Text(
                _strings['welcome']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _strings['subwelcome']!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              // Step 1: Mobile Number Input
              Text(
                _strings['phoneLabel']!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isOtpSent ? Colors.grey.shade300 : primaryGreen,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // +91 Flag Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                      decoration: BoxDecoration(
                        color: softGreenBg,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                      child: const Row(
                        children: [
                          Text('🇮🇳', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 6),
                          Text(
                            '+91',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        enabled: !_isOtpSent,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: _strings['phoneHint'],
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    if (_isOtpSent)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18, color: primaryGreen),
                        onPressed: () => setState(() => _isOtpSent = false),
                        tooltip: _strings['changeNumber'],
                      ),
                  ],
                ),
              ),

              // Step 2: OTP Verification Box (Appears when OTP requested)
              if (_isOtpSent) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_strings['otpSentMsg']} +91 ${_phoneController.text}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isOtpSent = false),
                      child: Text(
                        _strings['changeNumber']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: primaryGreen, width: 1.5),
                  ),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 10,
                      color: primaryGreen,
                    ),
                    decoration: const InputDecoration(
                      hintText: '• • • • • •',
                      hintStyle: TextStyle(
                        letterSpacing: 8,
                        color: Colors.grey,
                        fontSize: 22,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Interactive Legal Terms & Conditions Gate (Strict Enforcement Before OTP)
              if (!_isOtpSent) ...[
                _buildLegalTermsCheckbox(),
                const SizedBox(height: 16),
              ],

              // Primary Action Button (Strictly Disabled by default until checkbox is checked)
              ElevatedButton(
                onPressed: _isLoading || (!_isOtpSent && !_agreedToTerms)
                    ? null
                    : (_isOtpSent ? _handleVerifyOtp : _handleRequestOtp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedRole == UserAppRole.seller
                      ? const Color(0xFFD97706)
                      : primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: (!_isOtpSent && !_agreedToTerms) ? 0 : 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _isOtpSent ? _strings['verifyOtp']! : _strings['getOtp']!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Trust Badges: Safe, Organic, Fresh
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTrustBadge('🌿', '100% Farm Pure'),
                  _buildTrustBadge('⚡', '24h Delivery'),
                  _buildTrustBadge('💧', 'Float Tested'),
                ],
              ),

              const SizedBox(height: 20),

              // Terms & Footer
              Text(
                _strings['terms']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangBtn(String label, AppLanguage lang) {
    final isSelected = _selectedLanguage == lang;
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = lang),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserAppRole role,
    required String title,
    required IconData icon,
    required String subtitle,
    required Color primaryColor,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? primaryColor : Colors.grey.shade600,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? primaryColor : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadge(String emoji, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  /// Interactive Legal Terms & Conditions Gate
  Widget _buildLegalTermsCheckbox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _agreedToTerms ? primaryGreen : Colors.grey.shade300,
          width: _agreedToTerms ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _agreedToTerms,
                  activeColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (bool? value) {
                    setState(() {
                      _agreedToTerms = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: () => _showLegalTermsModal('Terms & Conditions'),
                          child: const Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: () => _showLegalTermsModal('Privacy Policy'),
                          child: const Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!_agreedToTerms)
            const Padding(
              padding: EdgeInsets.only(left: 32, top: 4),
              child: Text(
                '⚠️ Check this box to activate Request OTP',
                style: TextStyle(fontSize: 10, color: Color(0xFFB45309), fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  /// English Bottom Sheet Modal with Complete Legal Requirements
  void _showLegalTermsModal(String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.92,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Top Handle & Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.gavel_rounded, color: primaryGreen, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const Text(
                              'Intermediary Notice (IT Act 2000, Sec 79)',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Scrollable Legal Body with all 4 required legal clauses
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildLegalSection(
                        number: '1',
                        title: 'Intermediary Platform Notice (IT Act 2000, Sec 79)',
                        body:
                            'AndaExpress operates solely as a digital mediator/technology aggregator connecting Buyers and Sellers.',
                        color: primaryGreen,
                      ),
                      const SizedBox(height: 14),
                      _buildLegalSection(
                        number: '2',
                        title: 'Dispute & Liability Disclaimer',
                        body:
                            'The platform is NOT a party to any transaction. Any dispute regarding product quality, pricing, delivery, payments, or damages is strictly between the Buyer and Seller.',
                        color: const Color(0xFFD97706),
                      ),
                      const SizedBox(height: 14),
                      _buildLegalSection(
                        number: '3',
                        title: 'Legal Immunity',
                        body:
                            'The App, its owners, operators, and affiliates hold zero liability or financial/legal obligation in any legal proceeding, cyber claim, or consumer dispute. Buyers and Sellers accept full sole responsibility.',
                        color: const Color(0xFFDC2626),
                      ),
                      const SizedBox(height: 14),
                      _buildLegalSection(
                        number: '4',
                        title: 'Mandatory Compliance',
                        body:
                            'Both parties must strictly adhere to platform guidelines (GPS verification, lay-date accuracy, Water Float Test refund policies).',
                        color: const Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),

                // Accept button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _agreedToTerms = true;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text(
                        'I Agree & Accept Terms',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLegalSection({
    required String number,
    required String title,
    required String body,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              body,
              style: const TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
