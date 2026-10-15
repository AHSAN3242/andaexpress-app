import React, { useState } from 'react';
import { Navbar, TabType } from './components/Navbar';
import { MasterStudioContainer } from './components/MasterStudioContainer';
import { AdminControlPanel } from './components/AdminControlPanel';
import { MobileStudioTab } from './components/MobileStudioTab';
import { SchemaTab } from './components/SchemaTab';
import { FeeCalculatorTab } from './components/FeeCalculatorTab';
import { FloatTestTab } from './components/FloatTestTab';
import { SecurityRulesTab } from './components/SecurityRulesTab';
import { FlutterCodeTab } from './components/FlutterCodeTab';
import { BatchTraceTab } from './components/BatchTraceTab';
import { Database, ShieldCheck, Calculator, Egg, Code2, QrCode, Sparkles, Layers } from 'lucide-react';
import { AdminOpsProvider } from './context/AdminOpsContext';

export default function App() {
  const [activeTab, setActiveTab] = useState<TabType>('master-suite');

  return (
    <AdminOpsProvider>
      <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-amber-500 selection:text-slate-950">
        {/* Top Navigation */}
        <Navbar activeTab={activeTab} setActiveTab={setActiveTab} />

        {/* Main Container */}
        <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
        {/* Quick Metric Bar */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          <div className="bg-slate-900/80 border border-slate-800/80 rounded-xl p-3.5 flex items-center space-x-3">
            <div className="w-9 h-9 rounded-lg bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400">
              <Sparkles className="w-4 h-4" />
            </div>
            <div>
              <div className="text-xs text-slate-400 font-medium">Ops & Mobile Suite</div>
              <div className="text-base font-bold text-white font-mono">Admin + Flutter Connected</div>
            </div>
          </div>

          <div className="bg-slate-900/80 border border-slate-800/80 rounded-xl p-3.5 flex items-center space-x-3">
            <div className="w-9 h-9 rounded-lg bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400">
              <Calculator className="w-4 h-4" />
            </div>
            <div>
              <div className="text-xs text-slate-400 font-medium">Platform Fee Tiers</div>
              <div className="text-base font-bold text-white font-mono">5 Admin Slabs Active</div>
            </div>
          </div>

          <div className="bg-slate-900/80 border border-slate-800/80 rounded-xl p-3.5 flex items-center space-x-3">
            <div className="w-9 h-9 rounded-lg bg-cyan-500/10 border border-cyan-500/30 flex items-center justify-center text-cyan-400">
              <Egg className="w-4 h-4" />
            </div>
            <div>
              <div className="text-xs text-slate-400 font-medium">Float-Test Proof Policy</div>
              <div className="text-base font-bold text-white font-mono">Mandatory Photo URL</div>
            </div>
          </div>

          <div className="bg-slate-900/80 border border-slate-800/80 rounded-xl p-3.5 flex items-center space-x-3">
            <div className="w-9 h-9 rounded-lg bg-purple-500/10 border border-purple-500/30 flex items-center justify-center text-purple-400">
              <ShieldCheck className="w-4 h-4" />
            </div>
            <div>
              <div className="text-xs text-slate-400 font-medium">Security Vectors</div>
              <div className="text-base font-bold text-emerald-400 font-mono">12 / 12 Hardened</div>
            </div>
          </div>
        </div>

        {/* Tab Views */}
        {activeTab === 'master-suite' && <MasterStudioContainer />}
        {activeTab === 'admin-panel' && <AdminControlPanel />}
        {activeTab === 'mobile-login' && <MobileStudioTab />}
        {activeTab === 'schema' && <SchemaTab />}
        {activeTab === 'fee-calculator' && <FeeCalculatorTab />}
        {activeTab === 'float-test' && <FloatTestTab />}
        {activeTab === 'security' && <SecurityRulesTab />}
        {activeTab === 'flutter-code' && <FlutterCodeTab />}
        {activeTab === 'traceability' && <BatchTraceTab />}
      </main>

      {/* Footer */}
      <footer className="border-t border-slate-800/80 bg-slate-950 py-6 text-xs text-slate-500 text-center">
        <div className="max-w-7xl mx-auto px-4 flex flex-col md:flex-row items-center justify-between gap-3">
          <div className="flex items-center space-x-2">
            <span className="font-bold text-slate-400">AndaExpress</span>
            <span>•</span>
            <span>Farm-Fresh Eggs & Chicken Every Day</span>
            <span>•</span>
            <span className="font-mono text-amber-400/90">Flutter + Firebase Lead Mobile Architecture</span>
          </div>

          <div className="flex items-center space-x-4 font-mono text-[11px]">
            <span className="text-slate-400">firebase-blueprint.json</span>
            <span>•</span>
            <span className="text-slate-400">firestore.rules</span>
            <span>•</span>
            <span className="text-slate-400">lib/models</span>
            <span>•</span>
            <span className="text-slate-400">lib/services</span>
          </div>
        </div>
      </footer>
    </div>
    </AdminOpsProvider>
  );
}
