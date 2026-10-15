import React from 'react';
import { Database, ShieldCheck, Calculator, Egg, Code2, QrCode, Smartphone, Layers } from 'lucide-react';

export type TabType = 'master-suite' | 'mobile-login' | 'admin-panel' | 'schema' | 'fee-calculator' | 'float-test' | 'security' | 'flutter-code' | 'traceability';

interface NavbarProps {
  activeTab: TabType;
  setActiveTab: (tab: TabType) => void;
}

export const Navbar: React.FC<NavbarProps> = ({ activeTab, setActiveTab }) => {
  const navItems: { id: TabType; label: string; icon: React.ReactNode; badge?: string }[] = [
    { id: 'master-suite', label: 'Master Switcher', icon: <Layers className="w-4 h-4" />, badge: '3-in-1 Preview' },
    { id: 'mobile-login', label: 'Android Mobile App', icon: <Smartphone className="w-4 h-4" />, badge: '5 Screens' },
    { id: 'admin-panel', label: 'Web Admin Panel', icon: <ShieldCheck className="w-4 h-4" />, badge: 'Web Ops' },
    { id: 'schema', label: 'Database Architecture', icon: <Database className="w-4 h-4" />, badge: 'IR Schema' },
    { id: 'flutter-code', label: 'Consolidated Dart Code', icon: <Code2 className="w-4 h-4" />, badge: 'Download' },
    { id: 'fee-calculator', label: 'Platform Fee Engine', icon: <Calculator className="w-4 h-4" /> },
    { id: 'float-test', label: 'Float Test Lab', icon: <Egg className="w-4 h-4" /> },
    { id: 'security', label: 'Security Rules Audit', icon: <ShieldCheck className="w-4 h-4" /> },
    { id: 'traceability', label: 'Batch Trace & Catalog', icon: <QrCode className="w-4 h-4" /> },
  ];

  return (
    <header className="bg-amber-950 text-amber-50 border-b border-amber-800/60 sticky top-0 z-30 shadow-md">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo & Tagline */}
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-400 via-amber-500 to-amber-600 flex items-center justify-center shadow-lg shadow-amber-500/20 text-slate-950 font-black text-xl">
              🥚
            </div>
            <div>
              <div className="flex items-center space-x-2">
                <span className="font-extrabold text-lg text-white tracking-tight">AndaExpress</span>
                <span className="text-[10px] font-semibold uppercase tracking-wider bg-amber-500/20 text-amber-300 px-2 py-0.5 rounded border border-amber-400/30">
                  Lead Architect Studio
                </span>
              </div>
              <p className="text-xs text-amber-200/80 font-medium">Farm-Fresh Eggs & Chicken Every Day • Flutter + Firebase</p>
            </div>
          </div>

          {/* Environment Status */}
          <div className="hidden md:flex items-center space-x-3 text-xs">
            <div className="flex items-center space-x-1.5 bg-emerald-950/80 text-emerald-300 border border-emerald-700/50 px-2.5 py-1 rounded-full">
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
              <span className="font-mono font-medium">Firestore v2 • Enterprise Mode</span>
            </div>
            <div className="bg-amber-900/60 text-amber-200 border border-amber-700/50 px-2.5 py-1 rounded-full font-mono">
              Flutter 3.24+ • Riverpod 2.6
            </div>
          </div>
        </div>

        {/* Tab Navigation */}
        <div className="flex space-x-1 overflow-x-auto pb-1 pt-1 scrollbar-none border-t border-amber-900/40">
          {navItems.map((item) => {
            const isActive = activeTab === item.id;
            return (
              <button
                key={item.id}
                onClick={() => setActiveTab(item.id)}
                className={`flex items-center space-x-2 px-3.5 py-2 text-xs font-semibold rounded-lg transition-all duration-150 whitespace-nowrap ${
                  isActive
                    ? 'bg-amber-500 text-slate-950 shadow-sm font-bold'
                    : 'text-amber-200 hover:text-white hover:bg-amber-900/50'
                }`}
              >
                {item.icon}
                <span>{item.label}</span>
                {item.badge && (
                  <span
                    className={`text-[9px] px-1.5 py-0.5 rounded font-bold uppercase tracking-wider ${
                      isActive ? 'bg-amber-700 text-amber-100' : 'bg-amber-950 text-amber-400 border border-amber-800'
                    }`}
                  >
                    {item.badge}
                  </span>
                )}
              </button>
            );
          })}
        </div>
      </div>
    </header>
  );
};
