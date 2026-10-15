import React, { useState } from 'react';
import { 
  ShieldCheck, 
  Calculator, 
  TrendingUp, 
  Users, 
  AlertTriangle, 
  CheckCircle2, 
  XCircle, 
  Save, 
  RefreshCw, 
  Clock, 
  MapPin, 
  Camera, 
  DollarSign, 
  Sparkles, 
  Lock, 
  Unlock, 
  Eye, 
  Sliders, 
  BarChart3,
  Layers,
  ArrowRight,
  Info,
  Scale,
  Truck,
  Phone,
  Check,
  FileText,
  BadgeAlert,
  ArrowUpRight,
  Egg,
  Tag,
  KeyRound,
  Smartphone
} from 'lucide-react';
import { DEFAULT_APP_SETTINGS, MOCK_PRODUCTS, MOCK_DISPUTES, MOCK_USERS } from '../data/initialData';
import { PlatformFeeSlab, DisputeEntity } from '../types';
import { useAdminOps } from '../context/AdminOpsContext';

interface AdminControlPanelProps {
  onNavigateToMobile?: () => void;
}

export const AdminControlPanel: React.FC<AdminControlPanelProps> = ({ onNavigateToMobile }) => {
  const { 
    pricing, 
    updatePricing, 
    resetPricing, 
    commuterDisputes, 
    authorizeWalletEscrowDeduction, 
    antiFraudShipments, 
    verifyShipment, 
    escrowLogs,
    farmerWalletBalance,
    toastMessage 
  } = useAdminOps();

  // Active Sub-Module Tab
  const [activeAdminModule, setActiveAdminModule] = useState<'dispute-desk' | 'pricing-controller' | 'anti-fraud' | 'float-audit' | 'seller-strikes'>('dispute-desk');

  // Dynamic Pricing Local Form Inputs
  const [eggBaseFareInput, setEggBaseFareInput] = useState<number>(pricing.freshEggTrayFare);
  const [liveBirdFareInput, setLiveBirdFareInput] = useState<number>(pricing.liveBirdFare);
  const [quailFareInput, setQuailFareInput] = useState<number>(pricing.quailFare);
  const [tier1RateInput, setTier1RateInput] = useState<number>(pricing.eggTier1PerEgg);
  const [tier2RateInput, setTier2RateInput] = useState<number>(pricing.eggTier2PerEgg);
  const [tier3RateInput, setTier3RateInput] = useState<number>(pricing.eggTier3PerEgg);
  const [tier1Active, setTier1Active] = useState<boolean>(pricing.tier1Active ?? true);
  const [tier2Active, setTier2Active] = useState<boolean>(pricing.tier2Active ?? true);
  const [tier3Active, setTier3Active] = useState<boolean>(pricing.tier3Active ?? true);
  const [hasSavedPricing, setHasSavedPricing] = useState<boolean>(false);

  // Selected Anti-Fraud Shipment for Modal / Inspector
  const [selectedTagNumber, setSelectedTagNumber] = useState<string>(antiFraudShipments[0]?.tagNumber || 'AND-9102');

  // Float-Test Disputes
  const [floatDisputes, setFloatDisputes] = useState<DisputeEntity[]>(MOCK_DISPUTES);
  const [selectedFloatDisputeId, setSelectedFloatDisputeId] = useState<string>(MOCK_DISPUTES[0].dispute_id);
  const [auditRemarks, setAuditRemarks] = useState<string>('Verified water bowl float test photo clearly confirms egg floating on water. Full refund issued.');
  const [floatAdjudicationSuccess, setFloatAdjudicationSuccess] = useState<string | null>(null);

  // 3-Strike Seller Management
  const [sellers, setSellers] = useState([
    {
      uid: 'usr_seller_chhabra',
      name: 'Chhabra Organic Poultry Farms',
      location: 'Paras Belt, Akola Outskirts, MH',
      strikes: 1,
      status: 'active',
      ordersFulfilled: 342,
      qualityScore: 98.4,
      joinedDate: '15 Aug 2026',
    },
    {
      uid: 'usr_seller_punjab',
      name: 'Punjab Pure Desi Fowls',
      location: 'Ambala Farm Belt, Punjab',
      strikes: 2,
      status: 'active',
      ordersFulfilled: 189,
      qualityScore: 94.1,
      joinedDate: '20 Jul 2026',
    },
    {
      uid: 'usr_seller_mehsana',
      name: 'Gujarat Golden Hen Breeders',
      location: 'Mehsana District, Gujarat',
      strikes: 3,
      status: 'blacklisted',
      ordersFulfilled: 74,
      qualityScore: 82.0,
      joinedDate: '02 Jun 2026',
    },
  ]);

  const activeFloatDispute = floatDisputes.find((d) => d.dispute_id === selectedFloatDisputeId) || floatDisputes[0];
  const relatedProduct = MOCK_PRODUCTS[0];
  const activeShipment = antiFraudShipments.find((s) => s.tagNumber === selectedTagNumber) || antiFraudShipments[0];

  // Handler: Save Dynamic Pricing Form to Context & Applet
  const handleApplyPricingChanges = () => {
    updatePricing({
      freshEggTrayFare: eggBaseFareInput,
      liveBirdFare: liveBirdFareInput,
      quailFare: quailFareInput,
      eggTier1PerEgg: tier1RateInput,
      eggTier2PerEgg: tier2RateInput,
      eggTier3PerEgg: tier3RateInput,
      tier1Active,
      tier2Active,
      tier3Active,
    });
    setHasSavedPricing(true);
    setTimeout(() => setHasSavedPricing(false), 3000);
  };

  const handleResetToDefaults = () => {
    resetPricing();
    setEggBaseFareInput(30.0);
    setLiveBirdFareInput(50.0);
    setQuailFareInput(5.0);
    setTier1RateInput(1.00);
    setTier2RateInput(0.50);
    setTier3RateInput(0.15);
    setTier1Active(true);
    setTier2Active(true);
    setTier3Active(true);
  };

  // Float Dispute Adjudication
  const handleAdjudicateFloatDispute = (decision: 'resolved_refund' | 'rejected') => {
    setFloatDisputes((prev) =>
      prev.map((d) => {
        if (d.dispute_id === selectedFloatDisputeId) {
          return {
            ...d,
            status: decision,
            admin_remarks: auditRemarks,
            updated_at: new Date().toISOString(),
          };
        }
        return d;
      })
    );

    setFloatAdjudicationSuccess(
      decision === 'resolved_refund'
        ? `Claim ${selectedFloatDisputeId} Approved! 100% refund initiated to buyer wallet.`
        : `Claim ${selectedFloatDisputeId} Rejected. Reason logged into ledger.`
    );
    setTimeout(() => setFloatAdjudicationSuccess(null), 3500);
  };

  // Seller Strikes
  const addStrike = (sellerUid: string) => {
    setSellers((prev) =>
      prev.map((s) => {
        if (s.uid === sellerUid) {
          const newStrikes = Math.min(3, s.strikes + 1);
          return {
            ...s,
            strikes: newStrikes,
            status: newStrikes >= 3 ? 'blacklisted' : s.status,
          };
        }
        return s;
      })
    );
  };

  const toggleSellerStatus = (sellerUid: string) => {
    setSellers((prev) =>
      prev.map((s) => {
        if (s.uid === sellerUid) {
          const newStatus = s.status === 'active' ? 'blacklisted' : 'active';
          return { ...s, status: newStatus };
        }
        return s;
      })
    );
  };

  const pendingDisputesCount = commuterDisputes.filter(d => d.status === 'pending_escrow_deduction').length;

  return (
    <div className="space-y-6">
      {/* Toast Alert */}
      {toastMessage && (
        <div className="fixed top-20 right-6 z-50 bg-emerald-950 border border-emerald-500 text-emerald-200 px-4 py-3 rounded-xl shadow-2xl flex items-center space-x-3 text-xs font-bold animate-in fade-in slide-in-from-top-2">
          <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0" />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Top Banner & Navigation Header */}
      <div className="bg-gradient-to-r from-slate-900 via-amber-950/70 to-slate-900 p-6 rounded-2xl border border-amber-500/40 shadow-xl flex flex-col lg:flex-row items-start lg:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold uppercase tracking-wider text-amber-300 bg-amber-500/20 px-2.5 py-0.5 rounded border border-amber-400/30">
              Web Admin Control Panel • Live Operations
            </span>
            <span className="text-xs font-mono text-emerald-400 bg-emerald-950 px-2 py-0.5 rounded border border-emerald-800">
              Auto-Escrow: Active
            </span>
          </div>
          <h2 className="text-2xl font-black text-white mt-1.5 flex items-center space-x-2">
            <span>AndaExpress Platform Governance Suite</span>
          </h2>
          <p className="text-xs text-slate-300 mt-1 max-w-2xl leading-relaxed">
            Centralized operations engine for Commuter Dispute Resolution (12h auto-escrow), Live Pricing & Bulk Micro-Tier configuration, and Anti-Fraud Live Poultry Shipments Audit.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-2.5">
          {onNavigateToMobile && (
            <button
              onClick={onNavigateToMobile}
              className="px-3.5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-black shadow-md flex items-center justify-center space-x-2 transition-all hover:scale-102"
            >
              <Smartphone className="w-4 h-4" />
              <span>View Live in Mobile App Preview ➡️</span>
            </button>
          )}

          <div className="bg-slate-950 border border-slate-800 px-3 py-2 rounded-xl text-xs font-mono flex items-center space-x-2">
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-pulse"></span>
            <div>
              <div className="text-[10px] text-slate-400">Farmer Wallet Pool</div>
              <div className="text-white font-bold">₹{farmerWalletBalance.toFixed(2)}</div>
            </div>
          </div>
        </div>
      </div>

      {/* Admin Module Switcher Tabs */}
      <div className="flex items-center space-x-2 overflow-x-auto scrollbar-none p-1.5 bg-slate-900 border border-slate-800 rounded-2xl shadow-inner">
        <button
          onClick={() => setActiveAdminModule('dispute-desk')}
          className={`flex items-center space-x-2 px-4 py-2.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap ${
            activeAdminModule === 'dispute-desk'
              ? 'bg-amber-500 text-slate-950 shadow-md ring-1 ring-amber-300'
              : 'text-slate-400 hover:text-white hover:bg-slate-800/60'
          }`}
        >
          <BadgeAlert className="w-4 h-4" />
          <span>A. Commuter Fare & Dispute Resolution Desk</span>
          {pendingDisputesCount > 0 && (
            <span className={`text-[10px] px-1.5 py-0.5 rounded-full font-black ${
              activeAdminModule === 'dispute-desk' ? 'bg-amber-950 text-amber-200' : 'bg-red-600 text-white animate-pulse'
            }`}>
              {pendingDisputesCount} Active
            </span>
          )}
        </button>

        <button
          onClick={() => setActiveAdminModule('pricing-controller')}
          className={`flex items-center space-x-2 px-4 py-2.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap ${
            activeAdminModule === 'pricing-controller'
              ? 'bg-amber-500 text-slate-950 shadow-md ring-1 ring-amber-300'
              : 'text-slate-400 hover:text-white hover:bg-slate-800/60'
          }`}
        >
          <Calculator className="w-4 h-4" />
          <span>B. Dynamic Pricing & Slab Controller</span>
        </button>

        <button
          onClick={() => setActiveAdminModule('anti-fraud')}
          className={`flex items-center space-x-2 px-4 py-2.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap ${
            activeAdminModule === 'anti-fraud'
              ? 'bg-amber-500 text-slate-950 shadow-md ring-1 ring-amber-300'
              : 'text-slate-400 hover:text-white hover:bg-slate-800/60'
          }`}
        >
          <Scale className="w-4 h-4" />
          <span>C. Anti-Fraud Audit Log</span>
          <span className="text-[10px] px-1.5 py-0.5 rounded-full bg-slate-800 text-slate-400 font-mono">
            {antiFraudShipments.length} Ships
          </span>
        </button>

        <button
          onClick={() => setActiveAdminModule('float-audit')}
          className={`flex items-center space-x-2 px-3.5 py-2.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap ${
            activeAdminModule === 'float-audit'
              ? 'bg-cyan-600 text-white shadow-md ring-1 ring-cyan-300'
              : 'text-slate-400 hover:text-white hover:bg-slate-800/60'
          }`}
        >
          <Egg className="w-4 h-4" />
          <span>Float Test Claims</span>
        </button>

        <button
          onClick={() => setActiveAdminModule('seller-strikes')}
          className={`flex items-center space-x-2 px-3.5 py-2.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap ${
            activeAdminModule === 'seller-strikes'
              ? 'bg-purple-600 text-white shadow-md ring-1 ring-purple-300'
              : 'text-slate-400 hover:text-white hover:bg-slate-800/60'
          }`}
        >
          <Users className="w-4 h-4" />
          <span>Seller 3-Strike Governance</span>
        </button>
      </div>

      {/* ========================================================================= */}
      {/* MODULE A: COMMUTER FARE & DISPUTE RESOLUTION DESK                         */}
      {/* ========================================================================= */}
      {activeAdminModule === 'dispute-desk' && (
        <div className="space-y-6">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-4">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between pb-3 border-b border-slate-800 gap-2">
              <div className="flex items-center space-x-2">
                <div className="w-8 h-8 rounded-lg bg-amber-500/20 border border-amber-500/40 flex items-center justify-center text-amber-400">
                  <BadgeAlert className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="text-sm font-bold text-white uppercase tracking-wider">
                    Commuter Delivery Disputes Desk (Past 12-Hour Threshold)
                  </h3>
                  <p className="text-[11px] text-slate-400">
                    Daily commuters who successfully completed Paras ➡️ Akola handovers but remain unpaid past the 12-hour statutory farmer settlement window.
                  </p>
                </div>
              </div>

              <div className="flex items-center space-x-2 text-xs">
                <span className="bg-red-950 text-red-300 border border-red-800 px-2.5 py-1 rounded-lg font-mono font-bold">
                  {pendingDisputesCount} Unsettled Claims
                </span>
                <span className="bg-emerald-950 text-emerald-300 border border-emerald-800 px-2.5 py-1 rounded-lg font-mono font-bold">
                  {commuterDisputes.filter(d => d.status === 'escrow_settled').length} Settled
                </span>
              </div>
            </div>

            {/* List of Commuter Disputes */}
            <div className="grid grid-cols-1 gap-4">
              {commuterDisputes.map((dispute) => {
                const isPending = dispute.status === 'pending_escrow_deduction';
                return (
                  <div
                    key={dispute.disputeId}
                    className={`rounded-2xl p-5 border transition-all ${
                      isPending
                        ? 'bg-slate-950/90 border-amber-500/50 shadow-md'
                        : 'bg-slate-950/50 border-slate-800/80 opacity-80'
                    }`}
                  >
                    <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-4">
                      {/* Left: Dispute Meta & Parties */}
                      <div className="space-y-2 flex-1">
                        <div className="flex flex-wrap items-center gap-2">
                          <span className="font-mono font-bold text-xs bg-slate-900 text-amber-400 border border-amber-500/30 px-2 py-0.5 rounded">
                            {dispute.disputeId}
                          </span>
                          <span className="font-mono text-xs text-slate-300 bg-slate-900 px-2 py-0.5 rounded border border-slate-800">
                            Order: {dispute.orderId}
                          </span>
                          <span className={`text-[10px] font-black uppercase px-2 py-0.5 rounded flex items-center space-x-1 ${
                            isPending
                              ? 'bg-red-950 text-red-300 border border-red-700 animate-pulse'
                              : 'bg-emerald-950 text-emerald-300 border border-emerald-700'
                          }`}>
                            <Clock className="w-3 h-3" />
                            <span>
                              {isPending 
                                ? `${dispute.hoursElapsed}h Elapsed (>12h Escrow Breach)` 
                                : `Escrow Settled ✓ (${dispute.settledAt})`}
                            </span>
                          </span>
                        </div>

                        <div className="text-sm font-bold text-white">
                          {dispute.itemSummary}
                        </div>

                        {/* Commuter & Farmer Grid */}
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs pt-1">
                          <div className="bg-slate-900/90 p-2.5 rounded-xl border border-slate-800 space-y-1">
                            <span className="text-[10px] text-blue-400 uppercase font-bold tracking-wider block">
                              🚌 Daily Commuter (Aggrieved Party)
                            </span>
                            <div className="font-bold text-white">{dispute.commuterName}</div>
                            <div className="text-[11px] text-slate-400 flex items-center space-x-1">
                              <Phone className="w-3 h-3 text-emerald-400" />
                              <span className="font-mono">{dispute.commuterPhone}</span>
                            </div>
                            <div className="text-[10px] text-slate-400 font-mono">
                              Route: {dispute.route}
                            </div>
                          </div>

                          <div className="bg-slate-900/90 p-2.5 rounded-xl border border-slate-800 space-y-1">
                            <span className="text-[10px] text-amber-400 uppercase font-bold tracking-wider block">
                              🧑‍🌾 Farmer / Vendor (Unpaid Debtor)
                            </span>
                            <div className="font-bold text-white">{dispute.farmerName}</div>
                            <div className="text-[11px] text-slate-400 font-mono">
                              ID: {dispute.farmerUid}
                            </div>
                            <div className="text-[10px] text-emerald-300 font-mono">
                              Farmer Prepaid Balance: ₹{farmerWalletBalance.toFixed(2)}
                            </div>
                          </div>
                        </div>

                        {/* OTP Verification & Custody Proof */}
                        <div className="flex items-center space-x-3 text-[11px] text-slate-400 pt-1 font-mono">
                          <span className="flex items-center space-x-1 text-emerald-400">
                            <KeyRound className="w-3.5 h-3.5" />
                            <span>Handshake OTP Verified: #{dispute.handshakeOtp}</span>
                          </span>
                          <span>•</span>
                          <span className="text-slate-300">Transit: 100% Completed</span>
                          {dispute.txnId && (
                            <>
                              <span>•</span>
                              <span className="text-cyan-400">Ref: {dispute.txnId}</span>
                            </>
                          )}
                        </div>
                      </div>

                      {/* Right: Fare Amount & Action Button */}
                      <div className="flex flex-col items-start lg:items-end justify-between self-stretch shrink-0 lg:pl-4 lg:border-l border-slate-800 space-y-3 min-w-[200px]">
                        <div>
                          <span className="text-[10px] text-slate-400 uppercase font-bold tracking-wider block">
                            Unpaid Delivery Fare
                          </span>
                          <div className="text-2xl font-black font-mono text-emerald-400">
                            ₹{dispute.fareAmount.toFixed(2)}
                          </div>
                          <span className="text-[10px] text-slate-400">
                            Guaranteed via Platform Escrow
                          </span>
                        </div>

                        {isPending ? (
                          <button
                            type="button"
                            onClick={() => authorizeWalletEscrowDeduction(dispute.disputeId)}
                            className="w-full py-2.5 px-4 bg-gradient-to-r from-amber-500 to-amber-600 hover:from-amber-400 hover:to-amber-500 text-slate-950 font-black rounded-xl text-xs shadow-lg shadow-amber-900/30 transition-all flex items-center justify-center space-x-2 active:scale-98"
                          >
                            <ShieldCheck className="w-4 h-4 text-slate-950" />
                            <span>Authorize Wallet Escrow Deduction</span>
                          </button>
                        ) : (
                          <div className="w-full py-2 px-3 bg-emerald-950/80 border border-emerald-700 text-emerald-300 rounded-xl text-center text-xs font-bold flex items-center justify-center space-x-1.5">
                            <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                            <span>Escrow Settled • Commuter Paid</span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>

            {/* Escrow Audit Ledger */}
            {escrowLogs.length > 0 && (
              <div className="pt-4 border-t border-slate-800 space-y-2">
                <div className="flex items-center justify-between text-xs font-bold text-white">
                  <span className="flex items-center space-x-1.5">
                    <FileText className="w-4 h-4 text-amber-400" />
                    <span>Real-Time Escrow Deduction Ledger</span>
                  </span>
                  <span className="text-[10px] text-slate-400 font-mono">
                    {escrowLogs.length} Auto-Deductions Executed
                  </span>
                </div>

                <div className="space-y-1.5">
                  {escrowLogs.map((log) => (
                    <div
                      key={log.id}
                      className="p-2.5 rounded-xl bg-slate-950 border border-emerald-800/40 text-xs flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 text-slate-300 font-mono"
                    >
                      <div>
                        <span className="text-emerald-400 font-bold">{log.id}</span>
                        <span className="text-slate-500"> • </span>
                        <span>Order: {log.orderId}</span>
                        <span className="text-slate-500"> • </span>
                        <span className="text-white">{log.note}</span>
                      </div>
                      <div className="text-emerald-400 font-bold font-mono">
                        -₹{log.amount.toFixed(2)}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODULE B: DYNAMIC PRICING & SLAB CONTROLLER                                */}
      {/* ========================================================================= */}
      {activeAdminModule === 'pricing-controller' && (
        <div className="space-y-6">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-5">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between pb-3 border-b border-slate-800 gap-2">
              <div className="flex items-center space-x-2">
                <div className="w-8 h-8 rounded-lg bg-amber-500/20 border border-amber-500/40 flex items-center justify-center text-amber-400">
                  <Calculator className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="text-sm font-bold text-white uppercase tracking-wider">
                    Dynamic Pricing & Bulk Micro-Tier Controller
                  </h3>
                  <p className="text-[11px] text-slate-400">
                    Live input controls linked directly to <code className="text-amber-300">lib/config/pricing_config.dart</code>. Edits immediately propagate to Mobile Farmer, Commuter, and Buyer screens.
                  </p>
                </div>
              </div>

              <div className="flex items-center space-x-2">
                <button
                  type="button"
                  onClick={handleResetToDefaults}
                  className="px-3 py-1.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-bold border border-slate-700 transition-all"
                >
                  Reset Defaults
                </button>
                <button
                  type="button"
                  onClick={handleApplyPricingChanges}
                  className="px-4 py-1.5 rounded-xl bg-amber-500 hover:bg-amber-400 text-slate-950 text-xs font-black shadow-md flex items-center space-x-1.5 transition-all active:scale-98"
                >
                  <Save className="w-3.5 h-3.5" />
                  <span>Apply & Sync Across Mobile Views</span>
                </button>
              </div>
            </div>

            {/* Notification on Save */}
            {hasSavedPricing && (
              <div className="p-3 bg-emerald-950/80 border border-emerald-600 rounded-xl text-xs text-emerald-300 font-bold flex items-center space-x-2">
                <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                <span>Pricing configuration updated and synchronized with all mobile views!</span>
              </div>
            )}

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {/* 1. COMMUTER FARE CONTROLLER */}
              <div className="bg-slate-950 rounded-2xl p-4 border border-slate-800 space-y-4">
                <div className="flex items-center justify-between pb-2 border-b border-slate-800">
                  <span className="text-xs font-bold text-white uppercase tracking-wider flex items-center space-x-2">
                    <Truck className="w-4 h-4 text-amber-400" />
                    <span>1. Commuter Fare Base Rates (Paras ➡️ Akola)</span>
                  </span>
                  <span className="text-[10px] text-slate-400 font-mono">
                    commuter_trip_screen.dart
                  </span>
                </div>

                <div className="space-y-3">
                  {/* Control 1: Fresh Egg Tray Fare */}
                  <div className="p-3 rounded-xl bg-slate-900 border border-slate-800 flex items-center justify-between gap-3">
                    <div>
                      <div className="text-xs font-bold text-white flex items-center space-x-1.5">
                        <span>🥚 ताज़ा अंडे (Egg Tray Base Fare)</span>
                      </div>
                      <div className="text-[10.5px] text-slate-400">
                        Default: ₹30.00 • 10% discount for orders $\ge 10$ trays
                      </div>
                    </div>

                    <div className="flex items-center space-x-1.5">
                      <span className="text-amber-400 font-bold text-sm">₹</span>
                      <input
                        type="number"
                        step="1"
                        value={eggBaseFareInput}
                        onChange={(e) => setEggBaseFareInput(Number(e.target.value))}
                        className="w-16 bg-slate-950 border border-amber-500/50 rounded-lg px-2 py-1 text-white font-mono font-bold text-center text-sm focus:outline-none focus:ring-1 focus:ring-amber-400"
                      />
                      <span className="text-xs text-slate-400 font-medium">/ tray</span>
                    </div>
                  </div>

                  {/* Control 2: Live Bird Base Fare */}
                  <div className="p-3 rounded-xl bg-slate-900 border border-slate-800 flex items-center justify-between gap-3">
                    <div>
                      <div className="text-xs font-bold text-white flex items-center space-x-1.5">
                        <span>🐔 लाइव पोल्ट्री (Live Bird Base Fare)</span>
                      </div>
                      <div className="text-[10.5px] text-slate-400">
                        Default: ₹50.00 • 10% discount for orders $\ge 5$ birds
                      </div>
                    </div>

                    <div className="flex items-center space-x-1.5">
                      <span className="text-amber-400 font-bold text-sm">₹</span>
                      <input
                        type="number"
                        step="1"
                        value={liveBirdFareInput}
                        onChange={(e) => setLiveBirdFareInput(Number(e.target.value))}
                        className="w-16 bg-slate-950 border border-amber-500/50 rounded-lg px-2 py-1 text-white font-mono font-bold text-center text-sm focus:outline-none focus:ring-1 focus:ring-amber-400"
                      />
                      <span className="text-xs text-slate-400 font-medium">/ bird</span>
                    </div>
                  </div>

                  {/* Control 3: Quail Base Fare */}
                  <div className="p-3 rounded-xl bg-slate-900 border border-slate-800 flex items-center justify-between gap-3">
                    <div>
                      <div className="text-xs font-bold text-white flex items-center space-x-1.5">
                        <span>🐦 बटेर पक्षी (Quail Base Fare)</span>
                      </div>
                      <div className="text-[10.5px] text-slate-400">
                        Default: ₹5.00 • 5% discount only if quantity &gt; 20
                      </div>
                    </div>

                    <div className="flex items-center space-x-1.5">
                      <span className="text-amber-400 font-bold text-sm">₹</span>
                      <input
                        type="number"
                        step="0.5"
                        value={quailFareInput}
                        onChange={(e) => setQuailFareInput(Number(e.target.value))}
                        className="w-16 bg-slate-950 border border-amber-500/50 rounded-lg px-2 py-1 text-white font-mono font-bold text-center text-sm focus:outline-none focus:ring-1 focus:ring-amber-400"
                      />
                      <span className="text-xs text-slate-400 font-medium">/ bird</span>
                    </div>
                  </div>
                </div>
              </div>

              {/* 2. BULK MICRO-TIER PLATFORM FEE CONTROLLER */}
              <div className="bg-slate-950 rounded-2xl p-4 border border-slate-800 space-y-4">
                <div className="flex items-center justify-between pb-2 border-b border-slate-800">
                  <span className="text-xs font-bold text-white uppercase tracking-wider flex items-center space-x-2">
                    <Layers className="w-4 h-4 text-emerald-400" />
                    <span>2. Bulk Platform Fee Tiers (Fresh Eggs)</span>
                  </span>
                  <span className="text-[10px] text-slate-400 font-mono">
                    seller_wallet_screen.dart
                  </span>
                </div>

                <div className="space-y-3 text-xs">
                  {/* Tier 1 */}
                  <div className={`p-3 rounded-xl border transition-all space-y-2 ${tier1Active ? 'bg-slate-900 border-slate-800' : 'bg-slate-950/60 border-slate-900 opacity-60'}`}>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <button
                          type="button"
                          onClick={() => setTier1Active(!tier1Active)}
                          className={`px-2 py-0.5 rounded text-[10px] font-bold transition-all flex items-center space-x-1 ${
                            tier1Active
                              ? 'bg-emerald-950 text-emerald-300 border border-emerald-600'
                              : 'bg-slate-800 text-slate-400 border border-slate-700'
                          }`}
                        >
                          <span className={`w-1.5 h-1.5 rounded-full ${tier1Active ? 'bg-emerald-400' : 'bg-slate-500'}`}></span>
                          <span>{tier1Active ? 'Tier Active' : 'Off'}</span>
                        </button>
                        <div className="font-bold text-white">Tier 1: 1 to 30 Trays (1 to 900 Eggs)</div>
                      </div>
                      <span className="text-[10px] font-mono text-emerald-400 font-bold">
                        ₹{(tier1RateInput * 30).toFixed(2)}/tray
                      </span>
                    </div>
                    <div className="flex items-center justify-between gap-3 text-slate-300">
                      <span className="text-[11px] text-slate-400">Per Egg Facilitation Fee (Base ₹1.00):</span>
                      <div className="flex items-center space-x-1.5">
                        <span className="text-amber-400 font-bold">₹</span>
                        <input
                          type="number"
                          step="0.05"
                          value={tier1RateInput}
                          onChange={(e) => setTier1RateInput(Number(e.target.value))}
                          className="w-16 bg-slate-950 border border-slate-700 rounded px-2 py-0.5 text-white font-mono font-bold text-center"
                        />
                        <span className="text-slate-400">/ egg</span>
                      </div>
                    </div>
                  </div>

                  {/* Tier 2 */}
                  <div className={`p-3 rounded-xl border transition-all space-y-2 ${tier2Active ? 'bg-slate-900 border-slate-800' : 'bg-slate-950/60 border-slate-900 opacity-60'}`}>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <button
                          type="button"
                          onClick={() => setTier2Active(!tier2Active)}
                          className={`px-2 py-0.5 rounded text-[10px] font-bold transition-all flex items-center space-x-1 ${
                            tier2Active
                              ? 'bg-emerald-950 text-emerald-300 border border-emerald-600'
                              : 'bg-slate-800 text-slate-400 border border-slate-700'
                          }`}
                        >
                          <span className={`w-1.5 h-1.5 rounded-full ${tier2Active ? 'bg-emerald-400' : 'bg-slate-500'}`}></span>
                          <span>{tier2Active ? 'Tier Active' : 'Off'}</span>
                        </button>
                        <div className="font-bold text-white">Tier 2: 31 to 50 Trays (930 to 1,500 Eggs)</div>
                      </div>
                      <span className="text-[10px] font-mono text-emerald-400 font-bold">
                        ₹{(tier2RateInput * 30).toFixed(2)}/tray
                      </span>
                    </div>
                    <div className="flex items-center justify-between gap-3 text-slate-300">
                      <span className="text-[11px] text-slate-400">Per Egg Facilitation Fee (50 paise):</span>
                      <div className="flex items-center space-x-1.5">
                        <span className="text-amber-400 font-bold">₹</span>
                        <input
                          type="number"
                          step="0.05"
                          value={tier2RateInput}
                          onChange={(e) => setTier2RateInput(Number(e.target.value))}
                          className="w-16 bg-slate-950 border border-slate-700 rounded px-2 py-0.5 text-white font-mono font-bold text-center"
                        />
                        <span className="text-slate-400">/ egg</span>
                      </div>
                    </div>
                  </div>

                  {/* Tier 3 */}
                  <div className={`p-3 rounded-xl border transition-all space-y-2 ${tier3Active ? 'bg-slate-900 border-slate-800' : 'bg-slate-950/60 border-slate-900 opacity-60'}`}>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <button
                          type="button"
                          onClick={() => setTier3Active(!tier3Active)}
                          className={`px-2 py-0.5 rounded text-[10px] font-bold transition-all flex items-center space-x-1 ${
                            tier3Active
                              ? 'bg-emerald-950 text-emerald-300 border border-emerald-600'
                              : 'bg-slate-800 text-slate-400 border border-slate-700'
                          }`}
                        >
                          <span className={`w-1.5 h-1.5 rounded-full ${tier3Active ? 'bg-emerald-400' : 'bg-slate-500'}`}></span>
                          <span>{tier3Active ? 'Tier Active' : 'Off'}</span>
                        </button>
                        <div className="font-bold text-white">Bulk Tier 3: Above 50 Trays (&gt;1,500 Eggs)</div>
                      </div>
                      <span className="text-[10px] font-mono text-emerald-400 font-bold">
                        ₹{(tier3RateInput * 30).toFixed(2)}/tray
                      </span>
                    </div>
                    <div className="flex items-center justify-between gap-3 text-slate-300">
                      <span className="text-[11px] text-slate-400">Per Egg Facilitation Fee (15 paise):</span>
                      <div className="flex items-center space-x-1.5">
                        <span className="text-amber-400 font-bold">₹</span>
                        <input
                          type="number"
                          step="0.01"
                          value={tier3RateInput}
                          onChange={(e) => setTier3RateInput(Number(e.target.value))}
                          className="w-16 bg-slate-950 border border-slate-700 rounded px-2 py-0.5 text-white font-mono font-bold text-center"
                        />
                        <span className="text-slate-400">/ egg</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Real-Time Formula Verification Card */}
            <div className="p-4 rounded-xl bg-slate-950 border border-slate-800 space-y-2 text-xs">
              <div className="flex items-center justify-between font-bold text-white">
                <span className="flex items-center space-x-2">
                  <Sparkles className="w-4 h-4 text-amber-400" />
                  <span>Real-Time Formula Live Calculation Check (Sample 12-Tray Order)</span>
                </span>
                <span className="text-emerald-400 font-mono font-bold">Formula OK</span>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-3 text-slate-300 pt-1 font-mono text-[11px]">
                <div className="bg-slate-900 p-2.5 rounded-lg border border-slate-800">
                  <div className="text-slate-500">Commuter Delivery Gross:</div>
                  <div className="text-white font-bold">12 trays × ₹{eggBaseFareInput.toFixed(2)} = ₹{(12 * eggBaseFareInput).toFixed(2)}</div>
                </div>
                <div className="bg-slate-900 p-2.5 rounded-lg border border-slate-800">
                  <div className="text-slate-500">10% Bulk Discount ($\ge 10$ trays):</div>
                  <div className="text-amber-400 font-bold">-₹{(12 * eggBaseFareInput * 0.1).toFixed(2)} (Net: ₹{(12 * eggBaseFareInput * 0.9).toFixed(2)})</div>
                </div>
                <div className="bg-slate-900 p-2.5 rounded-lg border border-slate-800">
                  <div className="text-slate-500">Platform Facilitation Fee (Tier 1):</div>
                  <div className="text-emerald-400 font-bold">12 trays × ₹{(tier1RateInput * 30).toFixed(2)} = ₹{(12 * tier1RateInput * 30).toFixed(2)}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODULE C: ANTI-FRAUD AUDIT LOG                                            */}
      {/* ========================================================================= */}
      {activeAdminModule === 'anti-fraud' && (
        <div className="space-y-6">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-4">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between pb-3 border-b border-slate-800 gap-2">
              <div className="flex items-center space-x-2">
                <div className="w-8 h-8 rounded-lg bg-red-500/20 border border-red-500/40 flex items-center justify-center text-red-400">
                  <Scale className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="text-sm font-bold text-white uppercase tracking-wider">
                    Anti-Fraud Live Bird Shipments & Scale Audit Log
                  </h3>
                  <p className="text-[11px] text-slate-400">
                    Audit registered live poultry batches using tamper-evident numbered leg-seals, certified scale weight photos, and GPS coordinates to prevent specimen substitution in transit.
                  </p>
                </div>
              </div>

              <span className="text-xs font-mono text-emerald-400 bg-emerald-950 px-2.5 py-1 rounded-lg border border-emerald-800">
                100% Watermark Verified
              </span>
            </div>

            {/* Audit Log Table */}
            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs">
                <thead className="bg-slate-950 text-slate-400 uppercase tracking-wider text-[10px] font-semibold border-b border-slate-800">
                  <tr>
                    <th className="px-3.5 py-3">Tag # & Batch</th>
                    <th className="px-3.5 py-3">Breed & Count</th>
                    <th className="px-3.5 py-3">Certified Scale Weight</th>
                    <th className="px-3.5 py-3">Leg-Seal Number</th>
                    <th className="px-3.5 py-3">GPS Watermark</th>
                    <th className="px-3.5 py-3">Audit Status</th>
                    <th className="px-3.5 py-3 text-right">Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/60 font-mono">
                  {antiFraudShipments.map((shipment) => {
                    const isSelected = selectedTagNumber === shipment.tagNumber;
                    return (
                      <tr 
                        key={shipment.tagNumber} 
                        className={`hover:bg-slate-800/40 transition-colors cursor-pointer ${
                          isSelected ? 'bg-slate-800/50 ring-1 ring-amber-500/40' : ''
                        }`}
                        onClick={() => setSelectedTagNumber(shipment.tagNumber)}
                      >
                        <td className="px-3.5 py-3">
                          <div className="font-bold text-amber-400 flex items-center space-x-1">
                            <Tag className="w-3 h-3" />
                            <span>{shipment.tagNumber}</span>
                          </div>
                          <div className="text-[10px] text-slate-400">{shipment.batchId}</div>
                        </td>

                        <td className="px-3.5 py-3 font-sans">
                          <div className="font-bold text-white text-xs">{shipment.breed}</div>
                          <div className="text-[10.5px] text-slate-400 font-mono">{shipment.birdsCount} Birds Shipment</div>
                        </td>

                        <td className="px-3.5 py-3">
                          <div className="text-emerald-400 font-bold">{shipment.scaleWeightPerBird}</div>
                          <div className="text-[10px] text-slate-400">Total: {shipment.totalWeight}</div>
                        </td>

                        <td className="px-3.5 py-3">
                          <span className="bg-red-950 text-red-300 border border-red-700 px-2 py-0.5 rounded text-[10px] font-bold">
                            {shipment.legSealNumber}
                          </span>
                        </td>

                        <td className="px-3.5 py-3 text-[10px] text-slate-400 max-w-[200px] truncate">
                          {shipment.gpsWatermark}
                        </td>

                        <td className="px-3.5 py-3">
                          <span className={`px-2 py-0.5 rounded text-[10px] font-bold uppercase ${
                            shipment.status === 'verified'
                              ? 'bg-emerald-950 text-emerald-300 border border-emerald-700'
                              : shipment.status === 'audit_cleared'
                              ? 'bg-blue-950 text-blue-300 border border-blue-700'
                              : 'bg-red-950 text-red-300 border border-red-700'
                          }`}>
                            {shipment.status === 'verified' ? '✓ Verified OK' : 'Cleared'}
                          </span>
                        </td>

                        <td className="px-3.5 py-3 text-right">
                          <button
                            type="button"
                            onClick={(e) => {
                              e.stopPropagation();
                              setSelectedTagNumber(shipment.tagNumber);
                            }}
                            className="px-2.5 py-1 bg-slate-800 hover:bg-slate-700 text-white rounded-lg text-[10px] font-bold border border-slate-700"
                          >
                            Inspect Proof
                          </button>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>

            {/* Detailed Inspector Card for Selected Shipment */}
            {activeShipment && (
              <div className="mt-4 p-4 rounded-2xl bg-slate-950 border border-slate-800 space-y-3">
                <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between pb-2 border-b border-slate-800 gap-2">
                  <div className="flex items-center space-x-2">
                    <Eye className="w-4 h-4 text-cyan-400" />
                    <span className="text-xs font-bold text-white uppercase tracking-wider">
                      Shipment Inspector: #{activeShipment.tagNumber} ({activeShipment.breed})
                    </span>
                  </div>

                  <div className="flex items-center space-x-2">
                    <button
                      type="button"
                      onClick={() => verifyShipment(activeShipment.tagNumber, 'verified')}
                      className="px-2.5 py-1 bg-emerald-950 text-emerald-300 border border-emerald-700 hover:bg-emerald-900 rounded-lg text-xs font-bold"
                    >
                      ✓ Mark Verified
                    </button>
                    <button
                      type="button"
                      onClick={() => verifyShipment(activeShipment.tagNumber, 'audit_cleared')}
                      className="px-2.5 py-1 bg-blue-950 text-blue-300 border border-blue-700 hover:bg-blue-900 rounded-lg text-xs font-bold"
                    >
                      Audit Cleared
                    </button>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
                  {/* Photo Proof 1: Certified Digital Scale Proof */}
                  <div className="space-y-1.5">
                    <div className="flex justify-between items-center text-[11px] font-bold text-emerald-400">
                      <span>1. Certified DigiScale Weight Proof</span>
                      <span className="font-mono text-slate-400">{activeShipment.scaleWeightPerBird}</span>
                    </div>
                    <div className="relative h-44 rounded-xl overflow-hidden border border-emerald-600/50 bg-black">
                      <img 
                        src={activeShipment.scalePhotoUrl} 
                        alt="Scale proof" 
                        className="w-full h-full object-cover" 
                      />
                      <div className="absolute bottom-0 inset-x-0 bg-black/90 p-2 text-[10px] font-mono text-emerald-300">
                        <div>WEIGHT: {activeShipment.totalWeight} ({activeShipment.birdsCount} Birds)</div>
                        <div className="text-slate-300">{activeShipment.gpsWatermark}</div>
                      </div>
                    </div>
                  </div>

                  {/* Photo Proof 2: Live Specimen & Leg Seal Proof */}
                  <div className="space-y-1.5">
                    <div className="flex justify-between items-center text-[11px] font-bold text-amber-400">
                      <span>2. Specimen & Numbered Leg-Seal Verification</span>
                      <span className="font-mono text-red-400">{activeShipment.legSealNumber}</span>
                    </div>
                    <div className="relative h-44 rounded-xl overflow-hidden border border-amber-600/50 bg-black">
                      <img 
                        src={activeShipment.photoProofUrl} 
                        alt="Leg seal proof" 
                        className="w-full h-full object-cover" 
                      />
                      <div className="absolute top-2 right-2 bg-red-600 text-white text-[9px] font-black px-2 py-0.5 rounded font-mono">
                        SEAL LOCKED: {activeShipment.legSealNumber}
                      </div>
                      <div className="absolute bottom-0 inset-x-0 bg-black/90 p-2 text-[10px] font-mono text-cyan-300">
                        <div>TAG: {activeShipment.tagNumber} • {activeShipment.batchId}</div>
                        <div className="text-slate-300">{activeShipment.remarks}</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODULE D: FLOAT TEST AUDIT LAB                                            */}
      {/* ========================================================================= */}
      {activeAdminModule === 'float-audit' && (
        <div className="space-y-6">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between pb-2 border-b border-slate-800">
              <div className="flex items-center space-x-2">
                <Egg className="w-4 h-4 text-cyan-400" />
                <h3 className="text-sm font-bold text-white uppercase tracking-wider">
                  Dispute Auditor: Side-by-Side Float Test Proof Comparison
                </h3>
              </div>
              <span className="text-[10px] font-mono text-amber-400 bg-amber-950 px-2 py-0.5 rounded border border-amber-800">
                Ticket: {activeFloatDispute.dispute_id}
              </span>
            </div>

            {/* Ticket Meta */}
            <div className="grid grid-cols-3 gap-2 p-2.5 rounded-xl bg-slate-950 border border-slate-800 text-[11px]">
              <div>Order: <strong className="text-white font-mono">{activeFloatDispute.order_id}</strong></div>
              <div>Buyer: <strong className="text-white font-mono">{activeFloatDispute.buyer_id}</strong></div>
              <div>Status: <strong className="text-amber-400 uppercase">{activeFloatDispute.status}</strong></div>
            </div>

            {/* Side-by-Side Photo Comparison */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
              <div className="space-y-1.5">
                <span className="font-bold text-emerald-400 flex items-center space-x-1 text-[11px]">
                  <Camera className="w-3.5 h-3.5 text-emerald-400" />
                  <span>1. Seller's Original Farm GPS Photo</span>
                </span>
                <div className="relative h-44 rounded-xl overflow-hidden border border-emerald-700/60 bg-black">
                  <img src={relatedProduct.photo_url} alt="Seller Original" className="w-full h-full object-cover" />
                  <div className="absolute bottom-0 inset-x-0 bg-black/85 p-1.5 text-[9px] font-mono text-emerald-300">
                    <div>BATCH: {relatedProduct.unique_batch_code}</div>
                    <div>GPS: 20.7002° N, 77.0082° E (Paras Farm Stamped)</div>
                  </div>
                </div>
              </div>

              <div className="space-y-1.5">
                <span className="font-bold text-red-400 flex items-center space-x-1 text-[11px]">
                  <AlertTriangle className="w-3.5 h-3.5 text-red-400" />
                  <span>2. Buyer's "Water Float Test" Photo</span>
                </span>
                <div className="relative h-44 rounded-xl overflow-hidden border border-red-600/80 bg-black">
                  <img src={activeFloatDispute.float_test_proof_photo_url} alt="Buyer Float Proof" className="w-full h-full object-cover" />
                  <div className="absolute top-1.5 right-1.5 bg-red-600 text-white font-black text-[9px] px-1.5 py-0.2 rounded">
                    FLOAT TEST FAILED
                  </div>
                  <div className="absolute bottom-0 inset-x-0 bg-black/85 p-1.5 text-[9px] font-mono text-cyan-300">
                    <div>PROOF: Horizontal Float on Water Bowl Surface</div>
                    <div className="text-red-300">Density &lt; 1.0 g/cm³ (Spoiled Air Sac Expanded)</div>
                  </div>
                </div>
              </div>
            </div>

            {/* Adjudication Box */}
            <div className="p-3.5 rounded-xl bg-slate-950 border border-slate-800 space-y-2.5 text-xs">
              <label className="text-[11px] font-bold text-slate-300 block">
                Official Admin Finding & Audit Remarks:
              </label>
              <input 
                type="text" 
                value={auditRemarks}
                onChange={(e) => setAuditRemarks(e.target.value)}
                className="w-full bg-slate-900 border border-slate-700 rounded-lg p-2 text-white font-mono text-xs focus:outline-none focus:border-amber-500"
              />

              <div className="flex items-center justify-end space-x-2 pt-1">
                <button
                  type="button"
                  onClick={() => handleAdjudicateFloatDispute('rejected')}
                  className="px-3 py-1.5 rounded-lg bg-red-950 text-red-300 border border-red-800 hover:bg-red-900 font-bold text-xs"
                >
                  Reject Claim (Inconclusive)
                </button>
                <button
                  type="button"
                  onClick={() => handleAdjudicateFloatDispute('resolved_refund')}
                  className="px-4 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-slate-950 font-black text-xs shadow-md flex items-center space-x-1"
                >
                  <CheckCircle2 className="w-3.5 h-3.5" />
                  <span>Approve 100% Refund (₹362)</span>
                </button>
              </div>

              {floatAdjudicationSuccess && (
                <div className="p-2 bg-emerald-950/80 border border-emerald-700 text-emerald-300 rounded-lg text-xs font-semibold">
                  {floatAdjudicationSuccess}
                </div>
              )}
            </div>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODULE E: SELLER 3-STRIKE GOVERNANCE                                      */}
      {/* ========================================================================= */}
      {activeAdminModule === 'seller-strikes' && (
        <div className="space-y-6">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between pb-2 border-b border-slate-800">
              <div className="flex items-center space-x-2">
                <Users className="w-4 h-4 text-purple-400" />
                <h3 className="text-sm font-bold text-white uppercase tracking-wider">
                  Seller 3-Strike Quality Governance
                </h3>
              </div>
              <span className="text-xs text-slate-400">
                3 Strikes = Automatic Catalog Suspension
              </span>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs">
                <thead className="bg-slate-950/80 text-slate-400 uppercase tracking-wider text-[10px] font-semibold border-b border-slate-800">
                  <tr>
                    <th className="px-4 py-3">Seller Name & Farm Belt</th>
                    <th className="px-4 py-3">Fulfilled Orders</th>
                    <th className="px-4 py-3">Freshness Rating</th>
                    <th className="px-4 py-3">3-Strike Policy Indicator</th>
                    <th className="px-4 py-3">Platform Status</th>
                    <th className="px-4 py-3 text-right">Admin Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/60">
                  {sellers.map((seller) => (
                    <tr key={seller.uid} className="hover:bg-slate-800/30 transition-colors">
                      <td className="px-4 py-3.5">
                        <div className="font-bold text-white text-xs">{seller.name}</div>
                        <div className="text-[10px] text-slate-400 flex items-center space-x-1 mt-0.5">
                          <MapPin className="w-3 h-3 text-cyan-400 shrink-0" />
                          <span>{seller.location}</span>
                        </div>
                      </td>

                      <td className="px-4 py-3.5 font-mono text-slate-200">
                        {seller.ordersFulfilled} Trays
                      </td>

                      <td className="px-4 py-3.5">
                        <span className="text-emerald-400 font-bold font-mono">
                          {seller.qualityScore}% Fresh
                        </span>
                      </td>

                      <td className="px-4 py-3.5">
                        <div className="flex items-center space-x-1.5">
                          {[1, 2, 3].map((strikeIndex) => (
                            <div
                              key={strikeIndex}
                              className={`w-5 h-5 rounded-full flex items-center justify-center font-bold text-[10px] ${
                                strikeIndex <= seller.strikes
                                  ? 'bg-red-600 text-white shadow-xs'
                                  : 'bg-slate-800 text-slate-500 border border-slate-700'
                              }`}
                            >
                              {strikeIndex <= seller.strikes ? '!' : strikeIndex}
                            </div>
                          ))}
                          <span className="text-[10px] text-slate-400 ml-1">
                            ({seller.strikes}/3 Strikes)
                          </span>
                        </div>
                      </td>

                      <td className="px-4 py-3.5">
                        {seller.status === 'active' ? (
                          <span className="bg-emerald-950 text-emerald-300 border border-emerald-800/80 px-2 py-0.5 rounded text-[10px] font-bold">
                            ACTIVE VENDOR
                          </span>
                        ) : (
                          <span className="bg-red-950 text-red-300 border border-red-800/80 px-2 py-0.5 rounded text-[10px] font-bold">
                            BLACKLISTED
                          </span>
                        )}
                      </td>

                      <td className="px-4 py-3.5 text-right space-x-2">
                        <button
                          type="button"
                          onClick={() => addStrike(seller.uid)}
                          className="px-2 py-1 bg-amber-950/70 hover:bg-amber-900 text-amber-300 border border-amber-800 rounded font-semibold text-[10px]"
                        >
                          + Issue Strike
                        </button>
                        <button
                          type="button"
                          onClick={() => toggleSellerStatus(seller.uid)}
                          className={`px-2.5 py-1 rounded font-bold text-[10px] transition-all ${
                            seller.status === 'active'
                              ? 'bg-red-950 text-red-300 border border-red-800 hover:bg-red-900'
                              : 'bg-emerald-950 text-emerald-300 border border-emerald-800 hover:bg-emerald-900'
                          }`}
                        >
                          {seller.status === 'active' ? 'Block / Blacklist' : 'Reactivate'}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
