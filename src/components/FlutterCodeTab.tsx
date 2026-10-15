import React, { useState } from 'react';
import { Code2, Copy, Check, Download, FileText, Folder, Terminal, Sparkles } from 'lucide-react';
import { FLUTTER_CODE_SNIPPETS } from '../data/initialData';

export const FlutterCodeTab: React.FC = () => {
  const [selectedFile, setSelectedFile] = useState(FLUTTER_CODE_SNIPPETS[1]); // Default to app_settings_model
  const [copied, setCopied] = useState(false);
  const [downloaded, setDownloaded] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(selectedFile.code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleDownloadAll = () => {
    const bundle = {
      project: 'AndaExpress Mobile (Flutter + Firebase)',
      version: '1.0.0',
      timestamp: new Date().toISOString(),
      architecture: 'Clean Architecture with Riverpod & Offline Firestore Persistence',
      files: FLUTTER_CODE_SNIPPETS.map((f) => ({
        path: f.path,
        content: f.code,
      })),
    };

    const blob = new Blob([JSON.stringify(bundle, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'anda_express_flutter_codebase.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    setDownloaded(true);
    setTimeout(() => setDownloaded(false), 2500);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-gradient-to-r from-amber-950 via-slate-900 to-slate-900 p-6 rounded-2xl border border-amber-800/40 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold uppercase tracking-wider text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded border border-amber-500/30">
              Modular Dart 3 Codebase
            </span>
            <span className="text-xs font-mono text-cyan-300">Flutter 3.24+ • Riverpod 2.6</span>
          </div>
          <h2 className="text-xl font-bold text-white mt-1">Clean Modular Flutter Architecture</h2>
          <p className="text-sm text-slate-300 mt-1 max-w-2xl">
            Production-ready Dart entities, Firestore serializers, atomic transaction order services, and water-bowl float test dispute handlers.
          </p>
        </div>

        <div className="flex items-center space-x-3 shrink-0">
          <button
            onClick={handleCopy}
            className="flex items-center space-x-2 bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold px-4 py-2 rounded-xl text-xs border border-slate-700 transition-all"
          >
            {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
            <span>{copied ? 'Copied File!' : 'Copy Active File'}</span>
          </button>
          <button
            onClick={handleDownloadAll}
            className="flex items-center space-x-2 bg-amber-500 hover:bg-amber-400 text-slate-950 font-bold px-4 py-2 rounded-xl text-xs transition-all shadow-md"
          >
            <Download className="w-3.5 h-3.5" />
            <span>{downloaded ? 'Downloaded Bundle!' : 'Export All Flutter Code'}</span>
          </button>
        </div>
      </div>

      {/* Code Browser Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left: File Tree */}
        <div className="lg:col-span-4 bg-slate-900 border border-slate-800 rounded-2xl p-4 shadow-sm space-y-3">
          <div className="flex items-center justify-between pb-2 border-b border-slate-800">
            <div className="flex items-center space-x-2">
              <Folder className="w-4 h-4 text-amber-400" />
              <h3 className="text-xs font-bold text-white uppercase tracking-wider">Project Files</h3>
            </div>
            <span className="text-[10px] font-mono text-slate-400">{FLUTTER_CODE_SNIPPETS.length} files</span>
          </div>

          <div className="space-y-1">
            {FLUTTER_CODE_SNIPPETS.map((file) => {
              const isSelected = selectedFile.path === file.path;
              return (
                <button
                  key={file.path}
                  onClick={() => setSelectedFile(file)}
                  className={`w-full text-left px-3 py-2.5 rounded-xl transition-all flex items-center justify-between text-xs font-mono ${
                    isSelected
                      ? 'bg-amber-500/20 text-amber-300 font-bold border border-amber-500/60 shadow-sm'
                      : 'text-slate-300 hover:bg-slate-800/60 hover:text-white'
                  }`}
                >
                  <div className="flex items-center space-x-2 truncate">
                    <FileText className={`w-3.5 h-3.5 shrink-0 ${isSelected ? 'text-amber-400' : 'text-slate-500'}`} />
                    <span className="truncate">{file.path}</span>
                  </div>
                  <span className="text-[9px] uppercase px-1.5 py-0.5 rounded bg-slate-950 text-slate-400">
                    {file.language}
                  </span>
                </button>
              );
            })}
          </div>

          {/* Architecture Checklist */}
          <div className="pt-4 border-t border-slate-800 space-y-2 text-xs">
            <div className="font-semibold text-slate-300 flex items-center space-x-1.5">
              <Sparkles className="w-3.5 h-3.5 text-amber-400" />
              <span>Architectural Highlights:</span>
            </div>
            <ul className="text-[11px] text-slate-400 space-y-1.5 list-disc pl-4">
              <li><strong>Type-Safe Firestore Converters:</strong> Native handling of <code className="text-amber-300">GeoPoint</code> and server <code className="text-amber-300">Timestamp</code>.</li>
              <li><strong>Dynamic Fee Calculator:</strong> Device-side matching of <code className="text-amber-300">PlatformFeeSlab</code> array with zero latency.</li>
              <li><strong>Atomic Stock Protection:</strong> <code className="text-amber-300">runTransaction</code> guarantees no two buyers can buy the last egg tray.</li>
              <li><strong>Proof Validation Gate:</strong> Enforces float-test image upload to Firebase Storage before creating dispute doc.</li>
            </ul>
          </div>
        </div>

        {/* Right: Code Viewer */}
        <div className="lg:col-span-8 bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden shadow-sm flex flex-col">
          <div className="p-4 bg-slate-950/70 border-b border-slate-800 flex items-center justify-between">
            <div className="space-y-0.5">
              <div className="flex items-center space-x-2">
                <span className="font-mono text-sm font-bold text-amber-400">{selectedFile.path}</span>
                <span className="text-[10px] bg-slate-800 text-slate-300 px-2 py-0.5 rounded font-mono uppercase">
                  {selectedFile.language}
                </span>
              </div>
              <p className="text-xs text-slate-400">{selectedFile.description}</p>
            </div>

            <button
              onClick={handleCopy}
              className="flex items-center space-x-1.5 bg-slate-800 hover:bg-slate-700 text-slate-200 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all border border-slate-700 shrink-0"
            >
              {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
              <span>{copied ? 'Copied' : 'Copy'}</span>
            </button>
          </div>

          <div className="p-4 bg-slate-950 font-mono text-xs overflow-x-auto max-h-[600px] scrollbar-thin flex-1 text-slate-200">
            <pre className="leading-relaxed">
              <code>{selectedFile.code}</code>
            </pre>
          </div>
        </div>
      </div>
    </div>
  );
};
