import React, { useState, useEffect } from 'react';
import { 
  Smartphone, 
  Wifi, 
  Battery, 
  Signal, 
  ArrowRight, 
  Sparkles, 
  Check, 
  ShoppingBag, 
  Tractor, 
  ShieldCheck, 
  Lock, 
  Globe, 
  RefreshCw,
  Phone,
  KeyRound,
  CheckCircle2,
  X,
  FileText,
  Scale
} from 'lucide-react';

export type AppLanguage = 'hindi' | 'marathi' | 'english';
export type UserRole = 'buyer' | 'seller';

interface MobilePreviewProps {
  onLoginSuccess?: (phone: string, role: UserRole, language: AppLanguage) => void;
}

export const MobileLoginPreview: React.FC<MobilePreviewProps> = ({ onLoginSuccess }) => {
  const [language, setLanguage] = useState<AppLanguage>('english');
  const [role, setRole] = useState<UserRole>('buyer');
  const [phoneNumber, setPhoneNumber] = useState<string>('9811223344');
  const [otpCode, setOtpCode] = useState<string>('');
  const [isOtpSent, setIsOtpSent] = useState<boolean>(false);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [timer, setTimer] = useState<number>(30);
  const [showSuccessBadge, setShowSuccessBadge] = useState<boolean>(false);
  const [agreedToTerms, setAgreedToTerms] = useState<boolean>(false);
  const [showLegalModal, setShowLegalModal] = useState<boolean>(false);
  const [legalModalTitle, setLegalModalTitle] = useState<string>('Terms & Conditions and Privacy Policy');

  useEffect(() => {
    let interval: NodeJS.Timeout;
    if (isOtpSent && timer > 0) {
      interval = setInterval(() => setTimer((t) => t - 1), 1000);
    }
    return () => clearInterval(interval);
  }, [isOtpSent, timer]);

  // Localized strings
  const strings = {
    english: {
      tagline: 'Farm-Fresh Eggs & Chicken Every Day',
      welcome: 'Welcome!',
      subwelcome: 'Enter your mobile number to get started',
      buyRole: 'I want to Buy',
      buySub: 'Fresh Eggs & Meat',
      sellRole: 'I want to Sell',
      sellSub: 'Poultry Farm / Breeder',
      phoneLabel: 'Mobile Number',
      phoneHint: '10-digit number',
      getOtp: 'Request OTP',
      otpSentTo: '6-digit OTP sent to',
      changeNum: 'Change',
      verifyBtn: 'Verify OTP & Continue',
      resendOtp: 'Resend OTP in',
      resendNow: 'Resend OTP',
      terms: 'By continuing, you agree to AndaExpress Terms & Privacy Policy',
      freshGuarantee: '100% Float-Test Guarantee',
      successMsg: 'OTP Verified! Redirecting to AndaExpress Home...',
    },
    hindi: {
      tagline: 'खेत से सीधे ताज़ा अंडे और चिकन हर रोज़',
      welcome: 'नमस्ते!',
      subwelcome: 'जारी रखने के लिए अपना मोबाइल नंबर दर्ज करें',
      buyRole: 'अंडे / चिकन खरीदें',
      buySub: 'ताज़ा पोल्ट्री उत्पाद',
      sellRole: 'खेत से बेचें',
      sellSub: 'किसान / पोल्ट्री फार्म',
      phoneLabel: 'मोबाइल नंबर',
      phoneHint: '10 अंकों का नंबर',
      getOtp: 'ओटीपी प्राप्त करें',
      otpSentTo: 'पर 6-अंकों का ओटीपी भेजा गया',
      changeNum: 'बदलें',
      verifyBtn: 'ओटीपी सत्यापित करें और आगे बढ़ें',
      resendOtp: 'ओटीपी पुनः भेजें',
      resendNow: 'ओटीपी भेजें',
      terms: 'आगे बढ़कर आप अंडाएक्सप्रेस की सेवा शर्तों से सहमत होते हैं',
      freshGuarantee: '100% फ्लोट टेस्ट ताज़गी गारंटी',
      successMsg: 'सत्यापन सफल! मुख्य पृष्ठ पर ले जाया जा रहा है...',
    },
    marathi: {
      tagline: 'थेट शेतातून ताजी अंडी आणि चिकन दररोज',
      welcome: 'नमस्कार!',
      subwelcome: 'सुरू ठेवण्यासाठी आपला मोबाईल नंबर टाका',
      buyRole: 'अंडी / चिकन खरेदी करा',
      buySub: 'ताजे पोल्ट्री उत्पादने',
      sellRole: 'शेतातून विका',
      sellSub: 'शेतकरी / पोल्ट्री फार्म',
      phoneLabel: 'मोबाईल नंबर',
      phoneHint: '10 अंकी नंबर',
      getOtp: 'ओटीपी मिळवा',
      otpSentTo: 'वर 6-अंकी ओटीपी पाठवला आहे',
      changeNum: 'बदला',
      verifyBtn: 'ओटीपी सत्यापित करा आणि पुढे जा',
      resendOtp: 'ओटीपी पुन्हा पाठवा',
      resendNow: 'ओटीपी पाठवा',
      terms: 'पुढे जाऊन आपण अंडाएक्सप्रेसच्या सेवा अटींशी सहमत आहात',
      freshGuarantee: '100% फ्लोट टेस्ट हमी',
      successMsg: 'यशस्वी पडताळणी! मुख्य पृष्ठावर नेत आहे...',
    },
  }[language];

  const handleRequestOtp = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (phoneNumber.replace(/\D/g, '').length < 10) return;
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      setIsOtpSent(true);
      setTimer(30);
      setOtpCode('894210'); // Simulated received OTP for quick testing
    }, 700);
  };

  const handleVerifyOtp = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (otpCode.length < 6) return;
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      setShowSuccessBadge(true);
      if (onLoginSuccess) {
        onLoginSuccess(`+91${phoneNumber}`, role, language);
      }
      setTimeout(() => setShowSuccessBadge(false), 3000);
    }, 600);
  };

  return (
    <div className="flex flex-col items-center justify-center p-2">
      {/* Mobile Device Mockup Frame */}
      <div className="relative w-[340px] sm:w-[375px] h-[730px] bg-slate-950 rounded-[48px] p-3 shadow-2xl ring-1 ring-slate-800 border-[7px] border-slate-900 flex flex-col overflow-hidden">
        
        {/* Device Notch & Sensors */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-36 h-6 bg-slate-900 rounded-b-2xl z-30 flex items-center justify-center">
          <div className="w-10 h-1 bg-slate-700 rounded-full mb-1"></div>
          <div className="w-2.5 h-2.5 rounded-full bg-slate-800 ml-2 mb-1 border border-slate-700"></div>
        </div>

        {/* Mobile Screen Surface */}
        <div className="w-full h-full bg-white rounded-[40px] overflow-hidden flex flex-col relative text-slate-900 shadow-inner">
          
          {/* Status Bar */}
          <div className="h-10 pt-2 px-6 flex items-center justify-between text-[11px] font-semibold text-slate-800 z-20">
            <span>9:41</span>
            <div className="flex items-center space-x-1.5 text-slate-700">
              <Signal className="w-3 h-3" />
              <Wifi className="w-3 h-3" />
              <Battery className="w-3.5 h-3.5 fill-current" />
            </div>
          </div>

          {/* Screen Content Container */}
          <div className="flex-1 overflow-y-auto px-5 pt-2 pb-6 flex flex-col justify-between scrollbar-none">
            
            {/* Top Bar: Guarantee Badge & Language Selector */}
            <div>
              <div className="flex items-center justify-between gap-1 pt-1 pb-2">
                {/* Guarantee Pill */}
                <div className="flex items-center space-x-1 bg-emerald-50 text-emerald-800 border border-emerald-200/80 px-2 py-0.5 rounded-full text-[10px] font-bold">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                  <span className="truncate max-w-[130px]">{strings.freshGuarantee}</span>
                </div>

                {/* Language Switcher */}
                <div className="flex items-center bg-slate-100 p-0.5 rounded-full border border-slate-200 text-[10px] font-bold">
                  <button
                    onClick={() => setLanguage('hindi')}
                    className={`px-2 py-0.5 rounded-full transition-all ${
                      language === 'hindi'
                        ? 'bg-emerald-800 text-white shadow-xs'
                        : 'text-slate-600 hover:text-slate-950'
                    }`}
                  >
                    हिन्दी
                  </button>
                  <button
                    onClick={() => setLanguage('marathi')}
                    className={`px-2 py-0.5 rounded-full transition-all ${
                      language === 'marathi'
                        ? 'bg-emerald-800 text-white shadow-xs'
                        : 'text-slate-600 hover:text-slate-950'
                    }`}
                  >
                    मराठी
                  </button>
                  <button
                    onClick={() => setLanguage('english')}
                    className={`px-2 py-0.5 rounded-full transition-all ${
                      language === 'english'
                        ? 'bg-emerald-800 text-white shadow-xs'
                        : 'text-slate-600 hover:text-slate-950'
                    }`}
                  >
                    EN
                  </button>
                </div>
              </div>

              {/* Brand Logo & Header */}
              <div className="text-center mt-3 mb-4">
                <div className="inline-flex relative mb-2">
                  <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-emerald-500/10 via-emerald-600/20 to-amber-500/20 border-2 border-emerald-600/30 flex items-center justify-center shadow-lg shadow-emerald-700/10">
                    <span className="text-3xl filter drop-shadow">🥚</span>
                  </div>
                  {/* Farm Leaf Badge */}
                  <span className="absolute -bottom-1 -right-1 bg-emerald-700 text-white text-[9px] px-1.5 py-0.2 rounded-full font-bold shadow-xs">
                    🌱
                  </span>
                </div>
                <h1 className="text-2xl font-black text-emerald-950 tracking-tight flex items-center justify-center gap-1">
                  <span>AndaExpress</span>
                </h1>
                <p className="text-[11px] font-medium text-slate-500 mt-0.5">
                  {strings.tagline}
                </p>
              </div>

              {/* Role Toggle: Buy vs Sell */}
              <div className="grid grid-cols-2 gap-2 bg-slate-100 p-1.5 rounded-2xl border border-slate-200 mb-5">
                <button
                  type="button"
                  onClick={() => setRole('buyer')}
                  className={`flex flex-col items-center py-2 px-2 rounded-xl transition-all ${
                    role === 'buyer'
                      ? 'bg-white text-emerald-900 font-bold shadow-sm ring-1.5 ring-emerald-600'
                      : 'text-slate-600 hover:text-slate-900'
                  }`}
                >
                  <div className="flex items-center space-x-1.5">
                    <ShoppingBag className={`w-3.5 h-3.5 ${role === 'buyer' ? 'text-emerald-700' : 'text-slate-500'}`} />
                    <span className="text-xs">{strings.buyRole}</span>
                  </div>
                  <span className="text-[9px] text-slate-400 font-normal mt-0.5">{strings.buySub}</span>
                </button>

                <button
                  type="button"
                  onClick={() => setRole('seller')}
                  className={`flex flex-col items-center py-2 px-2 rounded-xl transition-all ${
                    role === 'seller'
                      ? 'bg-white text-amber-900 font-bold shadow-sm ring-1.5 ring-amber-600'
                      : 'text-slate-600 hover:text-slate-900'
                  }`}
                >
                  <div className="flex items-center space-x-1.5">
                    <Tractor className={`w-3.5 h-3.5 ${role === 'seller' ? 'text-amber-600' : 'text-slate-500'}`} />
                    <span className="text-xs">{strings.sellRole}</span>
                  </div>
                  <span className="text-[9px] text-slate-400 font-normal mt-0.5">{strings.sellSub}</span>
                </button>
              </div>

              {/* Form Card */}
              <div className="space-y-3.5">
                <div>
                  <h2 className="text-base font-bold text-slate-900">{strings.welcome}</h2>
                  <p className="text-xs text-slate-500">{strings.subwelcome}</p>
                </div>

                {/* Mobile Input */}
                <div className="space-y-1">
                  <label className="text-[11px] font-bold text-slate-700 flex items-center justify-between">
                    <span>{strings.phoneLabel}</span>
                    {isOtpSent && (
                      <button
                        type="button"
                        onClick={() => setIsOtpSent(false)}
                        className="text-emerald-700 font-semibold hover:underline"
                      >
                        {strings.changeNum}
                      </button>
                    )}
                  </label>

                  <div className="flex items-center rounded-xl border-2 border-emerald-700/60 overflow-hidden focus-within:border-emerald-700 focus-within:ring-2 focus-within:ring-emerald-700/20 bg-white shadow-xs">
                    {/* Country Code Pill */}
                    <div className="bg-emerald-50 px-3 py-2.5 border-r border-emerald-200/80 flex items-center space-x-1.5 text-xs font-bold text-emerald-900">
                      <span>🇮🇳</span>
                      <span>+91</span>
                    </div>

                    <input
                      type="tel"
                      disabled={isOtpSent}
                      maxLength={10}
                      value={phoneNumber}
                      onChange={(e) => setPhoneNumber(e.target.value.replace(/\D/g, ''))}
                      placeholder={strings.phoneHint}
                      className="w-full px-3 py-2.5 text-sm font-bold text-slate-900 placeholder:text-slate-300 focus:outline-none tracking-wider disabled:bg-slate-50 disabled:text-slate-500"
                    />
                  </div>
                </div>

                {/* OTP Input (Shown when OTP is requested) */}
                {isOtpSent && (
                  <div className="space-y-1.5 animate-fadeIn">
                    <div className="flex items-center justify-between text-[11px]">
                      <span className="text-slate-600">
                        {strings.otpSentTo} <strong className="text-emerald-900">+91 {phoneNumber}</strong>
                      </span>
                    </div>

                    <div className="relative">
                      <input
                        type="text"
                        maxLength={6}
                        value={otpCode}
                        onChange={(e) => setOtpCode(e.target.value.replace(/\D/g, ''))}
                        placeholder="• • • • • •"
                        className="w-full text-center py-2.5 px-3 rounded-xl border-2 border-emerald-600 text-lg font-black tracking-[0.45em] text-emerald-900 focus:outline-none focus:ring-2 focus:ring-emerald-600/30 bg-emerald-50/40"
                      />
                      <KeyRound className="w-4 h-4 text-emerald-600 absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" />
                    </div>

                    <div className="flex items-center justify-between text-[11px] pt-0.5">
                      {timer > 0 ? (
                        <span className="text-slate-400">
                          {strings.resendOtp} <strong className="text-slate-600 font-mono">{timer}s</strong>
                        </span>
                      ) : (
                        <button
                          type="button"
                          onClick={() => {
                            setTimer(30);
                            setOtpCode('765432');
                          }}
                          className="text-emerald-700 font-bold hover:underline"
                        >
                          {strings.resendNow}
                        </button>
                      )}
                      <span className="text-[10px] text-emerald-600 font-mono font-semibold bg-emerald-100/60 px-1.5 py-0.5 rounded">
                        Demo OTP: 894210
                      </span>
                    </div>
                  </div>
                )}

                {/* Interactive Legal Terms & Conditions Gate (Strict Enforcement Before OTP) */}
                {!isOtpSent && (
                  <div className="pt-1 pb-1">
                    <div className="bg-slate-50 border border-slate-200/80 rounded-xl p-2.5 shadow-2xs">
                      <label className="flex items-start space-x-2.5 cursor-pointer select-none">
                        <input
                          type="checkbox"
                          checked={agreedToTerms}
                          onChange={(e) => setAgreedToTerms(e.target.checked)}
                          className="mt-0.5 w-4 h-4 rounded text-emerald-700 border-slate-300 focus:ring-emerald-600 focus:ring-offset-0 cursor-pointer accent-emerald-700 shrink-0"
                        />
                        <span className="text-[11px] leading-snug text-slate-700 font-medium">
                          I agree to the{' '}
                          <button
                            type="button"
                            onClick={(e) => {
                              e.preventDefault();
                              e.stopPropagation();
                              setLegalModalTitle('Terms & Conditions');
                              setShowLegalModal(true);
                            }}
                            className="text-emerald-800 font-bold underline underline-offset-2 hover:text-emerald-950 transition-colors"
                          >
                            Terms & Conditions
                          </button>{' '}
                          and{' '}
                          <button
                            type="button"
                            onClick={(e) => {
                              e.preventDefault();
                              e.stopPropagation();
                              setLegalModalTitle('Privacy Policy');
                              setShowLegalModal(true);
                            }}
                            className="text-emerald-800 font-bold underline underline-offset-2 hover:text-emerald-950 transition-colors"
                          >
                            Privacy Policy
                          </button>
                        </span>
                      </label>
                      {!agreedToTerms && (
                        <div className="text-[10px] text-amber-700 font-semibold mt-1.5 flex items-center space-x-1 pl-6">
                          <span>⚠️ Check the box above to activate Request OTP</span>
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Primary Action Button (Strictly Disabled by default until checkbox is checked) */}
                <button
                  type="button"
                  disabled={isLoading || (isOtpSent ? otpCode.length < 6 : (phoneNumber.length < 10 || !agreedToTerms))}
                  onClick={isOtpSent ? handleVerifyOtp : handleRequestOtp}
                  className={`w-full py-3 rounded-xl text-xs font-black tracking-wide text-white transition-all shadow-md flex items-center justify-center space-x-2 ${
                    role === 'seller'
                      ? 'bg-amber-600 hover:bg-amber-700 shadow-amber-600/20'
                      : 'bg-emerald-800 hover:bg-emerald-900 shadow-emerald-800/20'
                  } disabled:bg-slate-300 disabled:text-slate-500 disabled:shadow-none disabled:cursor-not-allowed`}
                >
                  {isLoading ? (
                    <RefreshCw className="w-4 h-4 animate-spin" />
                  ) : (
                    <>
                      <span>{isOtpSent ? strings.verifyBtn : strings.getOtp}</span>
                      <ArrowRight className="w-3.5 h-3.5" />
                    </>
                  )}
                </button>
              </div>
            </div>

            {/* Bottom Section: Trust Badges & Terms */}
            <div className="space-y-3 pt-3">
              {/* Trust Badges */}
              <div className="grid grid-cols-3 gap-1 py-1.5 px-1 bg-emerald-50/60 rounded-xl border border-emerald-100 text-center text-[9px] font-bold text-emerald-900">
                <div className="flex flex-col items-center">
                  <span>🌿</span>
                  <span>100% Bio-Pure</span>
                </div>
                <div className="flex flex-col items-center border-x border-emerald-200/60 px-1">
                  <span>⚡</span>
                  <span>24h Farm Fresh</span>
                </div>
                <div className="flex flex-col items-center">
                  <span>💧</span>
                  <span>Float Tested</span>
                </div>
              </div>

              {/* Terms disclaimer */}
              <p className="text-[10px] text-slate-400 text-center leading-tight">
                {strings.terms}
              </p>
            </div>

          </div>

          {/* Success Overlay Notification */}
          {showSuccessBadge && (
            <div className="absolute inset-0 bg-emerald-950/85 backdrop-blur-xs z-50 flex flex-col items-center justify-center p-6 text-white text-center animate-fadeIn">
              <div className="w-16 h-16 rounded-full bg-emerald-500/20 border-2 border-emerald-400 flex items-center justify-center mb-3">
                <CheckCircle2 className="w-9 h-9 text-emerald-400" />
              </div>
              <h3 className="text-lg font-bold">Authentication Success</h3>
              <p className="text-xs text-emerald-200 mt-1 max-w-[200px]">{strings.successMsg}</p>
              <div className="mt-4 px-3 py-1 bg-emerald-800/90 rounded-full text-[10px] font-mono">
                Role: {role.toUpperCase()} • {language.toUpperCase()}
              </div>
            </div>
          )}

          {/* Legal Terms & Conditions English Modal / Bottom Sheet */}
          {showLegalModal && (
            <div className="absolute inset-0 bg-slate-950/80 backdrop-blur-xs z-50 flex flex-col justify-end animate-fadeIn">
              <div className="bg-white rounded-t-3xl max-h-[85%] flex flex-col shadow-2xl border-t border-slate-200 animate-slideUp">
                
                {/* Modal Header */}
                <div className="p-4 border-b border-slate-100 flex items-center justify-between shrink-0 bg-slate-50/80 rounded-t-3xl">
                  <div className="flex items-center space-x-2">
                    <div className="w-8 h-8 rounded-lg bg-emerald-100 text-emerald-800 flex items-center justify-center">
                      <Scale className="w-4 h-4" />
                    </div>
                    <div>
                      <h3 className="text-xs font-black text-slate-900 tracking-tight">
                        {legalModalTitle}
                      </h3>
                      <p className="text-[10px] text-slate-500 font-mono">
                        IT Act 2000 • Section 79 Intermediary
                      </p>
                    </div>
                  </div>

                  <button
                    type="button"
                    onClick={() => setShowLegalModal(false)}
                    className="w-7 h-7 rounded-full bg-slate-200/70 hover:bg-slate-300 text-slate-600 flex items-center justify-center transition-colors cursor-pointer"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>

                {/* Modal Body: Complete English Legal Notice */}
                <div className="p-4 overflow-y-auto space-y-3.5 text-[11px] leading-relaxed text-slate-700 scrollbar-thin">
                  
                  {/* Notice Badge */}
                  <div className="bg-amber-50 border border-amber-300/80 rounded-xl p-2.5 text-amber-900 font-medium">
                    <strong className="block font-bold text-amber-950 mb-0.5 text-xs">
                      ⚖️ Legal Notice & Intermediary Binding Terms
                    </strong>
                    Please read carefully before requesting an OTP or transacting on the AndaExpress digital marketplace.
                  </div>

                  {/* Section 1 */}
                  <div className="bg-slate-50 rounded-xl p-3 border border-slate-200/80 space-y-1">
                    <h4 className="font-bold text-slate-950 text-xs flex items-center space-x-1.5 text-emerald-900">
                      <span className="w-1.5 h-1.5 rounded-full bg-emerald-600"></span>
                      <span>1. Intermediary Platform Notice (IT Act 2000, Sec 79)</span>
                    </h4>
                    <p className="text-slate-600 pl-3">
                      AndaExpress operates solely as a digital mediator/technology aggregator connecting Buyers and Sellers.
                    </p>
                  </div>

                  {/* Section 2 */}
                  <div className="bg-slate-50 rounded-xl p-3 border border-slate-200/80 space-y-1">
                    <h4 className="font-bold text-slate-950 text-xs flex items-center space-x-1.5 text-amber-900">
                      <span className="w-1.5 h-1.5 rounded-full bg-amber-600"></span>
                      <span>2. Dispute & Liability Disclaimer</span>
                    </h4>
                    <p className="text-slate-600 pl-3">
                      The platform is NOT a party to any transaction. Any dispute regarding product quality, pricing, delivery, payments, or damages is strictly between the Buyer and Seller.
                    </p>
                  </div>

                  {/* Section 3 */}
                  <div className="bg-slate-50 rounded-xl p-3 border border-slate-200/80 space-y-1">
                    <h4 className="font-bold text-slate-950 text-xs flex items-center space-x-1.5 text-red-900">
                      <span className="w-1.5 h-1.5 rounded-full bg-red-600"></span>
                      <span>3. Legal Immunity</span>
                    </h4>
                    <p className="text-slate-600 pl-3">
                      The App, its owners, operators, and affiliates hold zero liability or financial/legal obligation in any legal proceeding, cyber claim, or consumer dispute. Buyers and Sellers accept full sole responsibility.
                    </p>
                  </div>

                  {/* Section 4 */}
                  <div className="bg-slate-50 rounded-xl p-3 border border-slate-200/80 space-y-1">
                    <h4 className="font-bold text-slate-950 text-xs flex items-center space-x-1.5 text-blue-900">
                      <span className="w-1.5 h-1.5 rounded-full bg-blue-600"></span>
                      <span>4. Mandatory Compliance</span>
                    </h4>
                    <p className="text-slate-600 pl-3">
                      Both parties must strictly adhere to platform guidelines (GPS verification, lay-date accuracy, Water Float Test refund policies).
                    </p>
                  </div>
                </div>

                {/* Modal Footer */}
                <div className="p-3 border-t border-slate-100 bg-slate-50/80 rounded-b-3xl flex items-center space-x-2 shrink-0">
                  <button
                    type="button"
                    onClick={() => {
                      setAgreedToTerms(true);
                      setShowLegalModal(false);
                    }}
                    className="w-full py-2.5 bg-emerald-800 hover:bg-emerald-900 text-white rounded-xl font-bold text-xs shadow-md transition-all flex items-center justify-center space-x-1.5 cursor-pointer"
                  >
                    <Check className="w-3.5 h-3.5 text-emerald-300" />
                    <span>I Agree & Accept Terms</span>
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* Android Home Bar */}
          <div className="h-4 flex items-center justify-center pb-1">
            <div className="w-28 h-1 bg-slate-400 rounded-full"></div>
          </div>
        </div>
      </div>
    </div>
  );
};
