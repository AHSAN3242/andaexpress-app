import React, { useState } from 'react';
import { QrCode, Search, MapPin, Calendar, Clock, ShieldCheck, Egg, CheckCircle2, AlertCircle } from 'lucide-react';
import { MOCK_PRODUCTS } from '../data/initialData';
import { ProductEntity } from '../types';

export const BatchTraceTab: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState<string>('BATCH-2026-CHB-DESI-0928');
  const [selectedProduct, setSelectedProduct] = useState<ProductEntity | null>(MOCK_PRODUCTS[0]);
  const [eggTypeFilter, setEggTypeFilter] = useState<string>('all');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    const found = MOCK_PRODUCTS.find(
      (p) => p.unique_batch_code.toLowerCase().includes(searchQuery.trim().toLowerCase())
    );
    setSelectedProduct(found || null);
  };

  const filteredProducts = MOCK_PRODUCTS.filter((p) => {
    if (eggTypeFilter === 'all') return true;
    return p.egg_type === eggTypeFilter;
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-gradient-to-r from-amber-950 via-slate-900 to-slate-900 p-6 rounded-2xl border border-amber-800/40 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold uppercase tracking-wider text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded border border-amber-500/30">
              Farm-to-Fork Traceability
            </span>
            <span className="text-xs font-mono text-emerald-400">Unique Batch Lot Codes</span>
          </div>
          <h2 className="text-xl font-bold text-white mt-1">Batch Code Verifier & Farm Fresh Catalog</h2>
          <p className="text-sm text-slate-300 mt-1 max-w-2xl">
            Every tray of eggs sold on AndaExpress is laser-stamped or labelled with a unique batch code. Verify origin farm, collection lay date, and GPS coordinates.
          </p>
        </div>

        {/* Quick Batch Lookup Form */}
        <form onSubmit={handleSearch} className="flex items-center space-x-2 w-full md:w-auto">
          <div className="relative flex-1 md:w-72">
            <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Enter batch code (e.g. BATCH-2026-CHB)..."
              className="w-full pl-9 pr-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 font-mono"
            />
          </div>
          <button
            type="submit"
            className="px-4 py-2 bg-amber-500 hover:bg-amber-400 text-slate-950 font-bold rounded-xl text-xs transition-all shrink-0"
          >
            Trace Batch
          </button>
        </form>
      </div>

      {/* Selected Batch Inspection Certificate */}
      {selectedProduct ? (
        <div className="bg-slate-900 border border-amber-500/40 rounded-2xl p-6 shadow-xl relative overflow-hidden">
          <div className="absolute top-0 right-0 w-32 h-32 bg-amber-500/5 rounded-full blur-2xl pointer-events-none"></div>

          <div className="flex flex-col md:flex-row md:items-center justify-between pb-4 border-b border-slate-800 gap-3">
            <div>
              <div className="flex items-center space-x-2">
                <span className="text-[10px] font-mono font-bold bg-amber-500/20 text-amber-300 px-2.5 py-0.5 rounded border border-amber-500/40">
                  {selectedProduct.unique_batch_code}
                </span>
                <span className="text-xs bg-emerald-950 text-emerald-300 border border-emerald-800 px-2 py-0.5 rounded-full font-bold flex items-center space-x-1">
                  <ShieldCheck className="w-3 h-3 text-emerald-400" />
                  <span>Bio-Secure Certified Farm</span>
                </span>
              </div>
              <h3 className="text-lg font-bold text-white mt-1">
                {selectedProduct.farm_name || 'Verified AndaExpress Partner Farm'}
              </h3>
            </div>

            <div className="flex items-center space-x-4 text-xs">
              <div className="text-right">
                <span className="text-slate-400 text-[10px] block uppercase font-semibold">Lay Date:</span>
                <span className="font-mono text-emerald-400 font-bold">
                  {new Date(selectedProduct.lay_date).toLocaleDateString()} ({new Date(selectedProduct.lay_date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })})
                </span>
              </div>
              <div className="text-right">
                <span className="text-slate-400 text-[10px] block uppercase font-semibold">Freshness Score:</span>
                <span className="font-mono text-amber-300 font-black text-sm">
                  {Math.max(1, Math.round((new Date().getTime() - new Date(selectedProduct.lay_date).getTime()) / (1000 * 3600 * 24)))} Days Since Lay
                </span>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4 text-xs">
            <div className="p-3 rounded-xl bg-slate-950/70 border border-slate-800 space-y-1">
              <span className="text-[10px] text-slate-500 uppercase font-semibold block">Egg Type & Grading</span>
              <div className="font-bold text-white text-sm capitalize">{selectedProduct.egg_type} Eggs</div>
              <div className="text-slate-400 text-[11px]">Free from synthetic hormones</div>
            </div>

            <div className="p-3 rounded-xl bg-slate-950/70 border border-slate-800 space-y-1">
              <span className="text-[10px] text-slate-500 uppercase font-semibold block">Inventory & Pricing</span>
              <div className="font-bold text-amber-400 text-sm">₹{selectedProduct.price} / unit</div>
              <div className="text-slate-400 text-[11px]">{selectedProduct.stock} trays available</div>
            </div>

            <div className="p-3 rounded-xl bg-slate-950/70 border border-slate-800 space-y-1">
              <span className="text-[10px] text-slate-500 uppercase font-semibold block">Expiry Best-Before</span>
              <div className="font-bold text-white text-sm font-mono">
                {new Date(selectedProduct.expiry_date).toLocaleDateString()}
              </div>
              <div className="text-emerald-400 text-[11px]">21-day room temp shelf life</div>
            </div>

            <div className="p-3 rounded-xl bg-slate-950/70 border border-slate-800 space-y-1">
              <span className="text-[10px] text-slate-500 uppercase font-semibold block">Farm Origin GPS</span>
              <div className="font-bold text-cyan-300 font-mono flex items-center space-x-1">
                <MapPin className="w-3.5 h-3.5 text-cyan-400 shrink-0" />
                <span>{selectedProduct.gps_lat_long.latitude.toFixed(4)}, {selectedProduct.gps_lat_long.longitude.toFixed(4)}</span>
              </div>
              <div className="text-slate-400 text-[11px]">Radius courier eligibility: OK</div>
            </div>
          </div>
        </div>
      ) : (
        <div className="p-6 rounded-2xl bg-slate-900 border border-slate-800 text-center text-xs text-slate-400 space-y-2">
          <AlertCircle className="w-8 h-8 text-amber-400 mx-auto" />
          <div className="font-bold text-white text-sm">Batch Code Not Found</div>
          <p>Please check the code stamped on the carton or try selecting from the live catalog below.</p>
        </div>
      )}

      {/* Live Catalog Grid */}
      <div className="space-y-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div className="flex items-center space-x-2">
            <Egg className="w-4 h-4 text-amber-400" />
            <h3 className="text-sm font-bold text-white uppercase tracking-wider">Live Inventory Batches</h3>
          </div>

          {/* Filter Pills */}
          <div className="flex flex-wrap gap-1.5 text-xs">
            {['all', 'desi', 'kadaknath', 'broiler_table', 'quail', 'none'].map((type) => (
              <button
                key={type}
                onClick={() => setEggTypeFilter(type)}
                className={`px-3 py-1 rounded-lg border font-mono text-[11px] capitalize transition-all ${
                  eggTypeFilter === type
                    ? 'bg-amber-500 text-slate-950 font-bold border-amber-400'
                    : 'bg-slate-900 text-slate-400 border-slate-800 hover:text-white'
                }`}
              >
                {type === 'none' ? 'Chicken' : type}
              </button>
            ))}
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {filteredProducts.map((p) => {
            const isSelected = selectedProduct?.product_id === p.product_id;
            return (
              <div
                key={p.product_id}
                onClick={() => {
                  setSelectedProduct(p);
                  setSearchQuery(p.unique_batch_code);
                }}
                className={`rounded-2xl border p-4 transition-all cursor-pointer ${
                  isSelected
                    ? 'bg-amber-500/10 border-amber-500/80 shadow-md ring-1 ring-amber-400/40'
                    : 'bg-slate-900 border-slate-800 hover:border-slate-700'
                }`}
              >
                <div className="flex items-start justify-between">
                  <div>
                    <span className="text-[10px] font-mono text-amber-400 font-bold">{p.unique_batch_code}</span>
                    <h4 className="text-sm font-bold text-white mt-1 capitalize">
                      {p.egg_type !== 'none' ? `${p.egg_type} Eggs` : `${p.category} Meat`}
                    </h4>
                  </div>
                  <span className="text-sm font-black text-amber-400">₹{p.price}</span>
                </div>

                <div className="mt-3 space-y-1 text-xs text-slate-400">
                  <div className="flex items-center space-x-1.5">
                    <Calendar className="w-3.5 h-3.5 text-emerald-400" />
                    <span>Lay Date: <strong className="text-slate-200">{new Date(p.lay_date).toLocaleDateString()}</strong></span>
                  </div>
                  <div className="flex items-center space-x-1.5">
                    <MapPin className="w-3.5 h-3.5 text-cyan-400" />
                    <span className="truncate">{p.farm_name}</span>
                  </div>
                </div>

                <div className="mt-3 pt-3 border-t border-slate-800/80 flex items-center justify-between text-[11px]">
                  <span className="text-slate-400">Stock: <strong className="text-white">{p.stock} units</strong></span>
                  <span className="text-amber-400 font-semibold hover:underline">Inspect Batch →</span>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};
