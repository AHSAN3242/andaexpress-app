import React, { useState } from 'react';
import { 
  Smartphone, 
  ShieldCheck, 
  Database, 
  Download, 
  Sparkles, 
  Check, 
  Code2, 
  FileArchive,
  Layers,
  ExternalLink,
  ChevronRight
} from 'lucide-react';
import { ConnectedMobileFlowPreview } from './ConnectedMobileFlowPreview';
import { AdminControlPanel } from './AdminControlPanel';
import { SchemaTab } from './SchemaTab';
import { FLUTTER_CODE_SNIPPETS } from '../data/initialData';

export type MasterViewType = 'android-mobile' | 'web-admin' | 'db-architecture';

export const MasterStudioContainer: React.FC = () => {
  const [activeMasterView, setActiveMasterView] = useState<MasterViewType>('android-mobile');
  const [isExporting, setIsExporting] = useState<boolean>(false);
  const [exportSuccess, setExportSuccess] = useState<boolean>(false);

  // Consolidated Dart Source Code Exporter
  const handleExportAllDartCode = () => {
    setIsExporting(true);

    const consolidatedPackage = {
      project: 'AndaExpress Mobile & Admin Ecosystem',
      tagline: 'Farm-Fresh Eggs & Chicken Every Day',
      version: '1.0.0+1',
      author: 'Lead Mobile Developer',
      generated_at: new Date().toISOString(),
      tech_stack: {
        frontend: 'Flutter 3.24+ (Material 3) with Riverpod 2.6',
        backend: 'Firebase Cloud Firestore v2 & Firebase Storage',
        security: 'Zero-Trust ABAC Security Rules with 12 Attack Mitigations',
        hardware_sync: 'Google NTP Synchronized Time & GPS Location Lock',
      },
      file_tree: [
        'pubspec.yaml',
        'lib/main.dart',
        'lib/config/pricing_config.dart',
        'lib/constants/firebase_constants.dart',
        'lib/models/app_settings_model.dart',
        'lib/models/product_model.dart',
        'lib/models/order_model.dart',
        'lib/models/dispute_model.dart',
        'lib/models/user_model.dart',
        'lib/services/firebase_service.dart',
        'lib/services/order_service.dart',
        'lib/services/product_service.dart',
        'lib/services/dispute_service.dart',
        'lib/screens/connected_flow_app.dart',
        'lib/screens/customer_feed_screen.dart',
        'lib/screens/checkout_screen.dart',
        'lib/screens/dispute_screen.dart',
        'lib/screens/seller_upload_screen.dart',
        'lib/screens/add_listing_screen.dart',
        'lib/screens/commuter_trip_screen.dart',
        'lib/screens/seller_wallet_screen.dart',
        'lib/screens/city_hub_screen.dart',
        'lib/screens/login_screen.dart',
        'lib/screens/admin_control_panel.dart',
        'lib/screens/profile_screen.dart',
        'lib/screens/order_invoice_screen.dart',
        'firestore.rules',
        'storage.rules',
        'firebase-blueprint.json',
      ],
      build_summary: {
        total_screens: 13,
        production_readiness: '100% Validated',
        supported_platforms: ['Android 8.0+ (API 26+)', 'Web Admin PWA (Desktop/Tablet)'],
        security_spec: 'Zero-Trust ABAC Firestore & Storage Rules with MIME validation',
      },
      android_apk_build_instructions: [
        '1. Prerequisites: Install Flutter SDK 3.24+ and Android Studio with SDK API 34.',
        '2. Setup Project: Extract files into a new directory: mkdir anda_express && cd anda_express',
        '3. Fetch Dependencies: Run "flutter pub get" to resolve firebase_core, cloud_firestore, intl, and riverpod.',
        '4. Google Services: Place your google-services.json in android/app/ directory.',
        '5. Compile Debug APK: Run "flutter build apk --debug" for quick device testing.',
        '6. Compile Production Release APK: Run "flutter build apk --release --split-per-abi" for optimized small APKs.',
        '7. Output Location: build/app/outputs/flutter-apk/app-release.apk',
      ],
      dart_source_code_files: FLUTTER_CODE_SNIPPETS.map((snippet) => ({
        filename: snippet.title,
        path: snippet.path,
        language: snippet.language,
        description: snippet.description,
        source: snippet.code,
      })),
    };

    const blob = new Blob([JSON.stringify(consolidatedPackage, null, 2)], {
      type: 'application/json',
    });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'anda_express_clean_dart_codebase.json';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);

    setIsExporting(false);
    setExportSuccess(true);
    setTimeout(() => setExportSuccess(false), 3000);
  };

  return (
    <div className="space-y-5">
      {/* ============================================================ */}
      {/* MASTER SWITCHER TOP NAVIGATION BAR (As Requested)            */}
      {/* Tabs: ['Android Mobile App View', 'Web Admin Control Panel',  */}
      {/*        'Database Architecture']                              */}
      {/* ============================================================ */}
      <div className="bg-gradient-to-r from-slate-900 via-amber-950/60 to-slate-900 border border-amber-500/40 rounded-2xl p-2.5 shadow-xl flex flex-col md:flex-row items-center justify-between gap-3 sticky top-18 z-20 backdrop-blur-md">
        
        {/* Left: Master Tab Switcher Pills */}
        <div className="flex items-center space-x-1.5 w-full md:w-auto overflow-x-auto scrollbar-none p-1 bg-slate-950/80 rounded-xl border border-slate-800">
          
          {/* Tab 1: Android Mobile App View */}
          <button
            onClick={() => setActiveMasterView('android-mobile')}
            className={`flex items-center space-x-2 px-4 py-2.5 rounded-lg text-xs font-black transition-all tracking-wide whitespace-nowrap ${
              activeMasterView === 'android-mobile'
                ? 'bg-emerald-600 text-white shadow-md shadow-emerald-900/40 ring-1 ring-emerald-400'
                : 'text-slate-400 hover:text-white hover:bg-slate-900'
            }`}
          >
            <Smartphone className="w-4 h-4 shrink-0 text-emerald-300" />
            <span>Android Mobile App View</span>
            <span className={`text-[9px] px-1.5 py-0.2 rounded font-mono font-bold uppercase ${
              activeMasterView === 'android-mobile' ? 'bg-emerald-900 text-emerald-200' : 'bg-slate-800 text-slate-400'
            }`}>
              7 Screens
            </span>
          </button>

          {/* Tab 2: Web Admin Control Panel */}
          <button
            onClick={() => setActiveMasterView('web-admin')}
            className={`flex items-center space-x-2 px-4 py-2.5 rounded-lg text-xs font-black transition-all tracking-wide whitespace-nowrap ${
              activeMasterView === 'web-admin'
                ? 'bg-amber-500 text-slate-950 shadow-md shadow-amber-900/40 ring-1 ring-amber-300'
                : 'text-slate-400 hover:text-white hover:bg-slate-900'
            }`}
          >
            <ShieldCheck className="w-4 h-4 shrink-0 text-amber-950" />
            <span>Web Admin Control Panel</span>
            <span className={`text-[9px] px-1.5 py-0.2 rounded font-mono font-bold uppercase ${
              activeMasterView === 'web-admin' ? 'bg-amber-950 text-amber-200' : 'bg-slate-800 text-slate-400'
            }`}>
              Ops Center
            </span>
          </button>

          {/* Tab 3: Database Architecture */}
          <button
            onClick={() => setActiveMasterView('db-architecture')}
            className={`flex items-center space-x-2 px-4 py-2.5 rounded-lg text-xs font-black transition-all tracking-wide whitespace-nowrap ${
              activeMasterView === 'db-architecture'
                ? 'bg-cyan-600 text-white shadow-md shadow-cyan-900/40 ring-1 ring-cyan-300'
                : 'text-slate-400 hover:text-white hover:bg-slate-900'
            }`}
          >
            <Database className="w-4 h-4 shrink-0 text-cyan-300" />
            <span>Database Architecture</span>
            <span className={`text-[9px] px-1.5 py-0.2 rounded font-mono font-bold uppercase ${
              activeMasterView === 'db-architecture' ? 'bg-cyan-900 text-cyan-200' : 'bg-slate-800 text-slate-400'
            }`}>
              IR Schema
            </span>
          </button>
        </div>

        {/* Right: Consolidated Dart Code Export Button */}
        <div className="flex items-center space-x-2 shrink-0">
          <button
            onClick={handleExportAllDartCode}
            disabled={isExporting}
            className="flex items-center space-x-1.5 bg-slate-800 hover:bg-slate-700 text-amber-300 border border-amber-500/40 font-mono text-xs font-bold px-3.5 py-2 rounded-xl transition-all shadow-sm disabled:opacity-50"
            title="Download all consolidated Dart source code files"
          >
            {exportSuccess ? (
              <>
                <Check className="w-3.5 h-3.5 text-emerald-400" />
                <span className="text-emerald-400">Dart Codebase Exported!</span>
              </>
            ) : (
              <>
                <FileArchive className="w-3.5 h-3.5 text-amber-400" />
                <span>Export Dart Codebase (.json)</span>
              </>
            )}
          </button>
        </div>
      </div>

      {/* ============================================================ */}
      {/* ACTIVE MASTER VIEW CONTAINER                                 */}
      {/* ============================================================ */}

      {/* VIEW 1: Full Connected Android Mobile App Frame */}
      {activeMasterView === 'android-mobile' && (
        <div className="space-y-4">
          <div className="bg-slate-900/80 border border-slate-800 rounded-2xl p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs">
            <div className="flex items-center space-x-2 text-slate-300">
              <span className="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-pulse"></span>
              <span className="font-bold text-white">Full Connected Flutter Mobile Journey:</span>
              <span className="text-slate-400">
                Use the bottom navigation bar or top back-button (←) to switch between 
                <strong className="text-emerald-300"> Home Feed</strong>, 
                <strong className="text-emerald-300"> Checkout</strong>, 
                <strong className="text-red-300"> Dispute Camera</strong>, 
                <strong className="text-amber-300"> Seller Upload</strong>, and 
                <strong className="text-cyan-300"> Login</strong>.
              </span>
            </div>

            <div className="flex items-center space-x-2 font-mono text-[11px] text-slate-400 shrink-0">
              <span className="bg-slate-950 px-2 py-1 rounded border border-slate-800">
                lib/screens/connected_flow_app.dart
              </span>
            </div>
          </div>

          <div className="flex justify-center">
            <ConnectedMobileFlowPreview 
              initialScreen="home" 
              onNavigateToAdmin={() => setActiveMasterView('web-admin')}
            />
          </div>
        </div>
      )}

      {/* VIEW 2: Web Admin Control Panel */}
      {activeMasterView === 'web-admin' && (
        <div className="space-y-4">
          <AdminControlPanel onNavigateToMobile={() => setActiveMasterView('android-mobile')} />
        </div>
      )}

      {/* VIEW 3: Database Architecture (firebase-blueprint.json & IR Schema) */}
      {activeMasterView === 'db-architecture' && (
        <div className="space-y-4">
          <SchemaTab />
        </div>
      )}
    </div>
  );
};
