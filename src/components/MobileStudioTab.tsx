import React, { useState } from 'react';
import { ConnectedMobileFlowPreview, MobileNavScreen } from './ConnectedMobileFlowPreview';
import { 
  Smartphone, 
  Code2, 
  Layers, 
  CheckCircle2, 
  Globe2, 
  Copy, 
  Check, 
  Sparkles, 
  ShieldCheck, 
  Palette, 
  FileCode, 
  Download, 
  Camera, 
  QrCode, 
  Upload, 
  Lock, 
  Clock, 
  FileCheck2,
  ShoppingBag,
  AlertTriangle,
  Store,
  Truck,
  ArrowLeft,
  Wallet,
  KeyRound,
  Bus
} from 'lucide-react';

export const MobileStudioTab: React.FC = () => {
  const [activeScreen, setActiveScreen] = useState<MobileNavScreen>('home');
  const [activeSubTab, setActiveSubTab] = useState<'preview' | 'dart-code'>('preview');
  const [copiedCode, setCopiedCode] = useState(false);

  const dartCode = `import 'package:flutter/material.dart';

/// Top-Level Screen Tabs in AndaExpress
enum MobileScreenTab { customerHome, checkout, dispute, sellerUpload, login }

class AndaExpressConnectedFlowApp extends StatefulWidget {
  const AndaExpressConnectedFlowApp({super.key});
  @override
  State<AndaExpressConnectedFlowApp> createState() => _AndaExpressConnectedFlowAppState();
}

class _AndaExpressConnectedFlowAppState extends State<AndaExpressConnectedFlowApp> {
  MobileScreenTab _currentTab = MobileScreenTab.customerHome;
  final List<MobileScreenTab> _history = [];

  static const Color primaryGreen = Color(0xFF1B5E20);

  void _navigateTo(MobileScreenTab tab) {
    setState(() {
      _history.add(_currentTab);
      _currentTab = tab;
    });
  }

  void _handleBack() {
    if (_history.isNotEmpty) {
      setState(() => _currentTab = _history.removeLast());
    } else {
      _navigateTo(MobileScreenTab.customerHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        leading: _currentTab != MobileScreenTab.customerHome
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _handleBack,
                tooltip: 'Back',
              )
            : const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('🥚', style: TextStyle(fontSize: 20)),
              ),
        title: Text(_getTitleForTab(_currentTab)),
      ),
      body: _buildScreenForTab(_currentTab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab.index,
        onTap: (index) => _navigateTo(MobileScreenTab.values[index]),
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Checkout'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Dispute'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Seller Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Login'),
        ],
      ),
    );
  }
}`;

  const handleCopyCode = () => {
    navigator.clipboard.writeText(dartCode);
    setCopiedCode(true);
    setTimeout(() => setCopiedCode(false), 2000);
  };

  return (
    <div className="space-y-6">
      {/* Top Banner */}
      <div className="bg-gradient-to-r from-emerald-950 via-slate-900 to-slate-900 p-6 rounded-2xl border border-emerald-800/40 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold uppercase tracking-wider text-emerald-400 bg-emerald-500/10 px-2 py-0.5 rounded border border-emerald-500/30">
              Connected Flutter Navigation Flow
            </span>
            <span className="text-xs font-mono text-amber-300">Android Back-Button (←) & Bottom Bar</span>
          </div>
          <h2 className="text-xl font-bold text-white mt-1">
            AndaExpress Full Customer & Seller Mobile Journey
          </h2>
          <p className="text-sm text-slate-300 mt-1 max-w-2xl">
            Live interactive navigation connecting Customer Feed, Dynamic Firebase Slabs Checkout, Strict Water-Float Dispute Camera, and Anti-Fraud Seller Upload.
          </p>
        </div>

        {/* View Mode & Code Copy */}
        <div className="flex items-center space-x-2">
          <div className="flex items-center space-x-1 bg-slate-900 border border-slate-800 p-1 rounded-xl">
            <button
              onClick={() => setActiveSubTab('preview')}
              className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-all ${
                activeSubTab === 'preview'
                  ? 'bg-emerald-600 text-white shadow-xs'
                  : 'text-slate-400 hover:text-white'
              }`}
            >
              Interactive Simulator
            </button>
            <button
              onClick={() => setActiveSubTab('dart-code')}
              className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-all ${
                activeSubTab === 'dart-code'
                  ? 'bg-emerald-600 text-white shadow-xs'
                  : 'text-slate-400 hover:text-white'
              }`}
            >
              Flutter Dart Source
            </button>
          </div>
        </div>
      </div>

      {/* Main Studio Area */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        {/* Left Side: Navigation Architecture & Feature Pillars */}
        <div className="lg:col-span-6 space-y-4">
          
          {/* Quick Jump Bar for Lead Reviewer */}
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 shadow-sm space-y-2.5">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-white uppercase tracking-wider flex items-center space-x-1.5">
                <Smartphone className="w-3.5 h-3.5 text-emerald-400" />
                <span>Quick Screen Jump (or use device bottom bar):</span>
              </span>
              <span className="text-[10px] font-mono text-emerald-400 bg-emerald-950 px-2 py-0.5 rounded border border-emerald-800">
                Active: {activeScreen.toUpperCase()}
              </span>
            </div>

            <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-7 gap-1.5">
              <button
                onClick={() => setActiveScreen('home')}
                className={`p-2 rounded-xl border text-[11px] font-bold transition-all ${
                  activeScreen === 'home'
                    ? 'bg-emerald-600 text-white border-emerald-400 shadow-sm'
                    : 'bg-slate-950 text-slate-400 border-slate-800 hover:text-white'
                }`}
              >
                1. Home Feed
              </button>

              <button
                onClick={() => setActiveScreen('checkout')}
                className={`p-2 rounded-xl border text-[11px] font-bold transition-all ${
                  activeScreen === 'checkout'
                    ? 'bg-emerald-600 text-white border-emerald-400 shadow-sm'
                    : 'bg-slate-950 text-slate-400 border-slate-800 hover:text-white'
                }`}
              >
                2. Checkout
              </button>

              <button
                onClick={() => setActiveScreen('dispute')}
                className={`p-2 rounded-xl border text-[11px] font-bold transition-all ${
                  activeScreen === 'dispute'
                    ? 'bg-red-600 text-white border-red-400 shadow-sm'
                    : 'bg-slate-950 text-slate-400 border-slate-800 hover:text-white'
                }`}
              >
                3. Dispute
              </button>

              <button
                onClick={() => setActiveScreen('seller-upload')}
                className={`p-2 rounded-xl border text-[11px] font-bold transition-all ${
                  activeScreen === 'seller-upload'
                    ? 'bg-amber-600 text-white border-amber-400 shadow-sm'
                    : 'bg-slate-950 text-slate-400 border-slate-800 hover:text-white'
                }`}
              >
                4. Seller Batch
              </button>

              <button
                onClick={() => setActiveScreen('commuter-trip')}
                className={`p-2 rounded-xl border text-[11px] font-bold transition-all ${
                  activeScreen === 'commuter-trip'
                    ? 'bg-blue-600 text-white border-blue-400 shadow-sm'
                    : 'bg-slate-950 text-slate-400 border-slate-800 hover:text-white'
                }`}
              >
                5. Commuter
              </button>

              <button
                onClick={() => setActiveScreen('seller-wallet')}
                className={`p-2 rounded-xl border text-[11px] font-bold transition-all ${
                  activeScreen === 'seller-wallet'
                    ? 'bg-emerald-700 text-white border-emerald-400 shadow-sm'
                    : 'bg-slate-950 text-slate-400 border-slate-800 hover:text-white'
                }`}
              >
                6. Wallet & Sec 79
              </button>

              <button
                onClick={() => setActiveScreen('hub-shop')}
                className={`p-2 rounded-xl border text-[11px] font-bold transition-all ${
                  activeScreen === 'hub-shop'
                    ? 'bg-purple-600 text-white border-purple-400 shadow-sm'
                    : 'bg-slate-950 text-slate-400 border-slate-800 hover:text-white'
                }`}
              >
                7. City Hub Shop
              </button>
            </div>
          </div>

          {/* Connected Flow Architecture Highlights */}
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-4">
            <h3 className="text-sm font-bold text-white uppercase tracking-wider flex items-center space-x-2">
              <Layers className="w-4 h-4 text-emerald-400" />
              <span>Mobile User Journey Highlights</span>
            </h3>

            <div className="space-y-3 text-xs">
              {/* Pillar 1: Top App Bar Back Button & Bottom Nav */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-emerald-400 font-bold">
                  <ArrowLeft className="w-3.5 h-3.5" />
                  <span>Top App Bar Back Button (←) & Bottom Navigation</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  Preserves stack history so buyers can navigate from Home → Cart → Checkout and press (←) back to browse more batches without losing state.
                </p>
              </div>

              {/* Pillar 2: 4-Party Real-Time Interconnection & Zero-Cost In-App OTP */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-amber-400 font-bold">
                  <KeyRound className="w-3.5 h-3.5" />
                  <span>4-Party Real-Time State Sync & Zero-Cost Delivery OTP</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  Synchronizes shared order state across Farmer, Commuter, Buyer, and City Hub. The 4-digit handshake OTP is strictly locked on Buyer's screen until the farmer confirms direct UPI payment. Commuter handover or City Hub fallback drops automatically deduct the ₹2 platform fee from the seller's prepaid wallet.
                </p>
              </div>

              {/* Pillar 3: Shop Hub Custody Transfer */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-purple-400 font-bold">
                  <Store className="w-3.5 h-3.5" />
                  <span>City Hub Shop Custody Transfer (+₹5 Shop Handling Fee)</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  When commuter 2-minute bus stand countdown expires or commuter drops eggs at Shrinath Dairy, custody immediately shifts to the City Hub Shop screen. The buyer's destination dynamically changes to the hub address, and the hub operator enters the unlocked OTP to finish delivery.
                </p>
              </div>

              {/* Pillar 4: Customer Feed */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-cyan-400 font-bold">
                  <ShieldCheck className="w-3.5 h-3.5" />
                  <span>Customer Feed with GPS Distance & Float Test Guide</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  Renders nearby farms within 2.8 km, lay dates (guaranteeing fresh eggs within 24h of lay), and an in-app educational modal explaining why floating eggs indicate air pocket expansion.
                </p>
              </div>

              {/* Pillar 5: Dynamic Checkout */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-emerald-400 font-bold">
                  <ShoppingBag className="w-3.5 h-3.5" />
                  <span>Dynamic Support Fees from Firebase app_settings</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  Queries active admin fee slabs and calculates the exact platform fee transparently. Allows selecting Self-Pickup (Free) or Cold-Chain Courier (+₹40).
                </p>
              </div>

              {/* Pillar 6: Strict Dispute Float Camera */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-red-400 font-bold">
                  <AlertTriangle className="w-3.5 h-3.5" />
                  <span>Strict Water Float-Test Live Camera Shutter</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  Requires buyers to submerge the suspected bad egg in a bowl of water and capture a live photograph of the floating egg before refund claims can be submitted.
                </p>
              </div>

              {/* Pillar 7: Seller Prepaid Wallet & IT Act Safe Harbor */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-emerald-400 font-bold">
                  <Wallet className="w-3.5 h-3.5" />
                  <span>Seller Prepaid Wallet & Section 79 Intermediary Safe Harbor</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  Automates dynamic deduction of platform fee based on refined bulk micro-tiers upon successful delivery or hub drop. Features UPI top-up (+₹200, +₹500, +₹1,000), detailed transaction ledger, and IT Act 2000 Sec 79 safe harbor legal disclaimer.
                </p>
              </div>

              {/* Pillar 8: Commuter Cargo Capacity Limits & Delivery Fare Engine */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-blue-400 font-bold">
                  <Bus className="w-3.5 h-3.5" />
                  <span>Cargo Limits & Delivery Fare Calculation Engine</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  Enforces maximum commuter cargo limits: Eggs (30 Trays max), Live Poultry (15 Birds max), and Quails (30 Birds max). Calculates exact delivery fares with tiered volume discounts: Quails @ ₹5/bird (5% discount if &gt; 20), Eggs @ ₹30/tray (10% discount if &gt;= 10), Live Poultry @ ₹50/bird (10% discount if &gt;= 5), and standard rate with no discount for distinct buyers.
                </p>
              </div>

              {/* Pillar 9: Refined Bulk Micro-Tiers Platform Fee Engine & Advance Token vs COD */}
              <div className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 space-y-1">
                <div className="flex items-center space-x-2 text-amber-400 font-bold">
                  <ShieldCheck className="w-3.5 h-3.5" />
                  <span>Refined Bulk Micro-Tiers & Flexible Payment (50% Token vs COD)</span>
                </div>
                <p className="text-slate-300 text-[11px]">
                  Refined Fresh Eggs micro-tiers: 1-30 trays (₹1.00/egg = ₹30/tray), 31-50 trays (₹0.50/egg = ₹15/tray), and &gt;50 trays (₹0.15/egg = ₹4.50/tray). Live Poultry bulk tiers: 1-15 birds (₹10/₹20/₹40 retail), 16-50 birds (₹5/bird), 51-100 birds (₹3/bird), 101-500 birds (₹1/bird), and &gt;500 birds (₹0.50/bird). Includes farmer order policy toggle (50% Advance Token vs 100% COD), mandatory Commuter Pre-Pickup Buyer Call Gate, and tamper-evident numbered leg-seals with certified scale watermark.
                </p>
              </div>
            </div>
          </div>

          {/* Source Code Paths */}
          <div className="p-4 rounded-2xl bg-slate-900 border border-slate-800 text-xs space-y-2">
            <div className="font-bold text-slate-200 flex items-center space-x-2">
              <FileCode className="w-4 h-4 text-emerald-400" />
              <span>Flutter Implementation Source Files:</span>
            </div>
            <div className="space-y-1 font-mono text-[11px]">
              <code className="block bg-slate-950 text-emerald-300 p-1.5 rounded-lg border border-slate-800">
                /flutter_anda_express/lib/screens/connected_flow_app.dart
              </code>
              <code className="block bg-slate-950 text-purple-300 p-1.5 rounded-lg border border-slate-800">
                /flutter_anda_express/lib/screens/city_hub_screen.dart
              </code>
              <code className="block bg-slate-950 text-blue-300 p-1.5 rounded-lg border border-slate-800">
                /flutter_anda_express/lib/screens/commuter_trip_screen.dart
              </code>
              <code className="block bg-slate-950 text-amber-300 p-1.5 rounded-lg border border-slate-800">
                /flutter_anda_express/lib/screens/seller_wallet_screen.dart
              </code>
            </div>
          </div>
        </div>

        {/* Right Side: Interactive Mobile Frame or Code Viewer */}
        <div className="lg:col-span-6 flex flex-col items-center justify-center">
          {activeSubTab === 'preview' ? (
            <div className="space-y-3 flex flex-col items-center">
              <div className="text-xs font-mono text-slate-400 flex items-center space-x-2">
                <Smartphone className="w-3.5 h-3.5 text-emerald-400" />
                <span>Interactive Connected Flow Simulator</span>
              </div>
              
              {/* Connected Flow Preview */}
              <ConnectedMobileFlowPreview
                initialScreen={activeScreen}
                onScreenChange={(scr) => setActiveScreen(scr)}
              />
            </div>
          ) : (
            <div className="w-full bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden shadow-sm flex flex-col">
              <div className="p-4 bg-slate-950/70 border-b border-slate-800 flex items-center justify-between">
                <div>
                  <span className="font-mono text-xs font-bold text-amber-400">
                    lib/screens/connected_flow_app.dart
                  </span>
                  <div className="text-[11px] text-slate-400">
                    StatefulWidget with Bottom Navigation Bar & Top App Bar back stack
                  </div>
                </div>

                <button
                  onClick={handleCopyCode}
                  className="flex items-center space-x-1.5 bg-slate-800 hover:bg-slate-700 text-slate-200 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all border border-slate-700"
                >
                  {copiedCode ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
                  <span>{copiedCode ? 'Copied Dart' : 'Copy Dart'}</span>
                </button>
              </div>

              <pre className="p-4 bg-slate-950 font-mono text-xs overflow-x-auto max-h-[640px] scrollbar-thin text-slate-200 leading-relaxed">
                <code>{dartCode}</code>
              </pre>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
