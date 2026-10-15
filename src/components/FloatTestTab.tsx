import React, { useState } from 'react';
import { Egg, Camera, AlertTriangle, CheckCircle2, Shield, Upload, RefreshCw, Info, FileCheck2 } from 'lucide-react';
import { DisputeEntity } from '../types';
import { MOCK_DISPUTES, MOCK_ORDERS } from '../data/initialData';

export const FloatTestTab: React.FC = () => {
  const [eggAgeDays, setEggAgeDays] = useState<number>(4);
  const [disputesList, setDisputesList] = useState<DisputeEntity[]>(MOCK_DISPUTES);
  const [isFilingDispute, setIsFilingDispute] = useState<boolean>(false);
  const [newReason, setNewReason] = useState<string>('Egg floated immediately to the top of water bowl during float test, indicating decomposed air sac.');
  const [proofUrl, setProofUrl] = useState<string>('https://images.unsplash.com/photo-1587486913049-53fc88980cfc?auto=format&fit=crop&w=600&q=80');
  const [submissionFeedback, setSubmissionFeedback] = useState<string | null>(null);

  // Determine float stage
  let stageTitle = 'Super Fresh (Day 0-7)';
  let stageDescription = 'Egg lies horizontally flat at the bottom of the water bowl. Small air pocket (< 3mm). 100% prime farm fresh.';
  let stageStatus = 'SAFE & PRIME';
  let badgeColor = 'bg-emerald-950 text-emerald-300 border-emerald-700/60';
  let eggRotation = 0; // degrees
  let eggVerticalPosition = 82; // percentage from top (bottom of bowl)
  let isFloating = false;

  if (eggAgeDays <= 7) {
    stageTitle = 'Super Fresh (Day 0-7)';
    stageDescription = 'Egg sinks completely to the bottom and rests flat horizontally. Air cell is tiny. Ideal for poaching, frying, and baking.';
    stageStatus = 'PRIME FRESH';
    badgeColor = 'bg-emerald-950 text-emerald-300 border-emerald-700';
    eggRotation = 0;
    eggVerticalPosition = 82;
  } else if (eggAgeDays <= 14) {
    stageTitle = 'Good / Moderate (Day 8-14)';
    stageDescription = 'Egg rests at the bottom but tilts slightly upward. Moisture has begun evaporating, expanding the blunt-end air pocket.';
    stageStatus = 'GOOD (USE SOON)';
    badgeColor = 'bg-amber-950 text-amber-300 border-amber-700';
    eggRotation = 35;
    eggVerticalPosition = 75;
  } else if (eggAgeDays <= 21) {
    stageTitle = 'Aging (Day 15-21)';
    stageDescription = 'Egg stands vertically upright on its pointed end at the bottom. Air pocket is large. Must be cooked thoroughly (great for hard boiling).';
    stageStatus = 'AGED (BOIL ONLY)';
    badgeColor = 'bg-orange-950 text-orange-300 border-orange-700';
    eggRotation = 85;
    eggVerticalPosition = 68;
  } else {
    stageTitle = 'Spoiled / Failed (Day 22+)';
    stageDescription = 'Egg floats directly to the water surface! Density has dropped below 1.0 g/cm³ due to bacterial gas accumulation. DO NOT CONSUME.';
    stageStatus = 'FAILED FLOAT TEST (SPOILED)';
    badgeColor = 'bg-red-950 text-red-300 border-red-700';
    eggRotation = 15;
    eggVerticalPosition = 18; // floating near top surface
    isFloating = true;
  }

  const handleFileDispute = (e: React.FormEvent) => {
    e.preventDefault();
    if (!proofUrl.trim()) {
      setSubmissionFeedback('Error: float_test_proof_photo_url cannot be empty under Firestore Security Rules.');
      return;
    }

    const newDispute: DisputeEntity = {
      dispute_id: `disp_andx_${Math.floor(1000 + Math.random() * 9000)}`,
      order_id: 'ord_sample_902',
      buyer_id: 'usr_buyer_rahul',
      seller_id: 'usr_seller_punjab',
      reason: newReason,
      float_test_proof_photo_url: proofUrl,
      status: 'opened',
      admin_remarks: '',
      created_at: new Date().toISOString(),
    };

    setDisputesList([newDispute, ...disputesList]);
    setSubmissionFeedback(`Success! Dispute ${newDispute.dispute_id} created and dispatched to Admin review.`);
    setIsFilingDispute(false);
  };

  const handleAdminAdjudicate = (disputeId: string, status: 'resolved_refund' | 'rejected') => {
    setDisputesList((prev) =>
      prev.map((d) =>
        d.dispute_id === disputeId
          ? {
              ...d,
              status,
              admin_remarks:
                status === 'resolved_refund'
                  ? 'Admin Verified: Float test photograph clearly confirms egg floating on water. Full refund issued to buyer wallet.'
                  : 'Admin Rejected: Proof photo inconclusive or does not match batch date.',
              updated_at: new Date().toISOString(),
            }
          : d
      )
    );
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-gradient-to-r from-amber-950 via-slate-900 to-slate-900 p-6 rounded-2xl border border-amber-800/40 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold uppercase tracking-wider text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded border border-amber-500/30">
              Freshness Science & Guarantee
            </span>
            <span className="text-xs font-mono text-cyan-400">/disputes/&#123;disputeId&#125;</span>
          </div>
          <h2 className="text-xl font-bold text-white mt-1">Water Bowl Float-Test Laboratory & Dispute Engine</h2>
          <p className="text-sm text-slate-300 mt-1 max-w-2xl">
            Eggshells have ~17,000 microscopic pores. As an egg ages, moisture evaporates and is replaced by air and bacterial gases. The Float Test provides undeniable visual proof of spoiled eggs.
          </p>
        </div>

        <button
          onClick={() => setIsFilingDispute(true)}
          className="flex items-center space-x-2 bg-amber-500 hover:bg-amber-400 text-slate-950 font-bold px-4 py-2 rounded-xl text-xs transition-all shadow-md shrink-0"
        >
          <Camera className="w-4 h-4" />
          <span>File Float-Test Dispute</span>
        </button>
      </div>

      {submissionFeedback && (
        <div className="p-3 rounded-xl bg-emerald-950/80 border border-emerald-700 text-xs text-emerald-200 flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0" />
            <span>{submissionFeedback}</span>
          </div>
          <button onClick={() => setSubmissionFeedback(null)} className="text-emerald-400 font-bold">×</button>
        </div>
      )}

      {/* Interactive Water Bowl Physics Sandbox */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left: Water Bowl Visualizer */}
        <div className="lg:col-span-6 bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-sm flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center space-x-2">
                <Egg className="w-4 h-4 text-amber-400" />
                <h3 className="text-sm font-bold text-white uppercase tracking-wider">Water Bowl Float Chamber</h3>
              </div>
              <span className={`text-[10px] font-bold px-2 py-0.5 rounded border uppercase ${badgeColor}`}>
                {stageStatus}
              </span>
            </div>

            {/* The Water Bowl Graphics */}
            <div className="relative w-full h-64 rounded-2xl bg-gradient-to-b from-sky-950/20 via-sky-900/40 to-cyan-950/70 border-2 border-sky-600/40 overflow-hidden shadow-inner flex items-center justify-center">
              {/* Water surface line */}
              <div className="absolute top-8 left-0 right-0 h-0.5 bg-cyan-400/60 shadow-[0_0_8px_rgba(34,211,238,0.5)]"></div>
              <div className="absolute top-2 right-3 text-[10px] font-mono text-cyan-300 font-semibold">
                Water Surface Line (1.00 g/cm³)
              </div>

              {/* Bowl floor */}
              <div className="absolute bottom-0 left-0 right-0 h-4 bg-slate-950/80 border-t border-sky-800/40"></div>

              {/* Floating Egg Element with dynamic positioning & rotation */}
              <div
                className="absolute transition-all duration-700 ease-out flex flex-col items-center cursor-pointer"
                style={{
                  top: `${eggVerticalPosition}%`,
                  transform: `translate(-50%, -50%) rotate(${eggRotation}deg)`,
                  left: '50%',
                }}
              >
                <div
                  className={`w-14 h-20 rounded-[50%_50%_45%_45%] shadow-2xl transition-all duration-500 border-2 ${
                    isFloating
                      ? 'bg-gradient-to-t from-red-200 via-amber-100 to-amber-200 border-red-500 shadow-red-500/40 ring-4 ring-red-500/20'
                      : 'bg-gradient-to-t from-amber-200 via-amber-100 to-amber-300 border-amber-400/80 shadow-black/60'
                  }`}
                >
                  {/* Air Cell graphic indicator */}
                  <div
                    className={`w-full rounded-t-[50%] transition-all duration-500 ${
                      eggAgeDays > 21
                        ? 'h-8 bg-red-400/30'
                        : eggAgeDays > 14
                        ? 'h-5 bg-amber-400/30'
                        : 'h-2 bg-emerald-400/30'
                    }`}
                  ></div>
                </div>
                <span className="text-[9px] font-mono font-black text-slate-900 bg-white/90 px-1 rounded shadow -mt-2">
                  {eggAgeDays}d
                </span>
              </div>
            </div>

            {/* Stage Info */}
            <div className="mt-4 p-3 rounded-xl bg-slate-950/80 border border-slate-800">
              <div className="font-bold text-sm text-white">{stageTitle}</div>
              <p className="text-xs text-slate-300 mt-1 leading-relaxed">{stageDescription}</p>
            </div>
          </div>

          {/* Age Slider Controller */}
          <div className="mt-6 pt-4 border-t border-slate-800 space-y-2">
            <div className="flex items-center justify-between text-xs">
              <span className="text-slate-400 font-semibold">Simulate Days Since Farm Lay Date:</span>
              <span className="font-mono text-sm font-bold text-amber-400 bg-slate-950 px-2 py-0.5 rounded border border-slate-800">
                {eggAgeDays} Days Old
              </span>
            </div>
            <input
              type="range"
              min={0}
              max={30}
              step={1}
              value={eggAgeDays}
              onChange={(e) => setEggAgeDays(Number(e.target.value))}
              className="w-full accent-amber-500 cursor-pointer h-2 bg-slate-800 rounded-lg"
            />
            <div className="flex justify-between text-[10px] text-slate-500 font-mono">
              <span className="text-emerald-400">0d (Laid Today)</span>
              <span>7d (Fresh)</span>
              <span>14d (Tilt)</span>
              <span>21d (Stand)</span>
              <span className="text-red-400 font-bold">25d+ (Floats / Dispute!)</span>
            </div>

            {isFloating && (
              <div className="mt-3 p-3 rounded-xl bg-red-950/70 border border-red-700/80 text-xs text-red-200 flex items-center justify-between animate-pulse">
                <div className="flex items-center space-x-2">
                  <AlertTriangle className="w-4 h-4 text-red-400 shrink-0" />
                  <span>Egg floated! Eligible for instant 100% refund under AndaExpress guarantee.</span>
                </div>
                <button
                  onClick={() => setIsFilingDispute(true)}
                  className="bg-red-500 hover:bg-red-400 text-slate-950 font-bold px-2.5 py-1 rounded-lg text-[10px] shrink-0"
                >
                  Submit Photo Proof
                </button>
              </div>
            )}
          </div>
        </div>

        {/* Right: Active Disputes & Admin Adjudication */}
        <div className="lg:col-span-6 space-y-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <FileCheck2 className="w-4 h-4 text-amber-400" />
                <h3 className="text-sm font-bold text-white uppercase tracking-wider">Dispute Records & Proofs</h3>
              </div>
              <span className="text-xs text-slate-400">{disputesList.length} filed</span>
            </div>

            <div className="space-y-3">
              {disputesList.map((disp) => (
                <div
                  key={disp.dispute_id}
                  className="p-4 rounded-xl bg-slate-950/70 border border-slate-800 text-xs space-y-2.5"
                >
                  <div className="flex items-center justify-between">
                    <span className="font-mono text-amber-400 font-bold">/{disp.dispute_id}</span>
                    <span
                      className={`text-[9px] font-bold px-2 py-0.5 rounded border uppercase ${
                        disp.status === 'resolved_refund'
                          ? 'bg-emerald-950 text-emerald-300 border-emerald-700'
                          : disp.status === 'opened'
                          ? 'bg-amber-950 text-amber-300 border-amber-700'
                          : 'bg-red-950 text-red-300 border-red-700'
                      }`}
                    >
                      {disp.status.replace('_', ' ')}
                    </span>
                  </div>

                  <div className="grid grid-cols-2 gap-2 text-[11px] text-slate-400">
                    <div>Order: <strong className="text-white font-mono">{disp.order_id}</strong></div>
                    <div>Buyer: <strong className="text-white font-mono">{disp.buyer_id}</strong></div>
                  </div>

                  <div className="text-slate-200 text-xs">
                    <strong className="text-slate-400">Reason:</strong> {disp.reason}
                  </div>

                  {/* Photo Proof preview */}
                  <div className="p-2 rounded-lg bg-slate-900 border border-slate-800 flex items-center space-x-3">
                    <img
                      src={disp.float_test_proof_photo_url}
                      alt="Float Test Proof"
                      className="w-14 h-14 rounded-lg object-cover border border-slate-700 shrink-0"
                    />
                    <div className="text-[10px] text-slate-400 truncate">
                      <div className="font-semibold text-amber-300">Mandatory Proof Attached</div>
                      <div className="truncate font-mono">{disp.float_test_proof_photo_url}</div>
                      <div className="text-emerald-400 font-bold mt-0.5">Verified Water Bowl Photo</div>
                    </div>
                  </div>

                  {disp.admin_remarks && (
                    <div className="p-2 rounded-lg bg-amber-950/30 border border-amber-800/40 text-[11px] text-amber-200">
                      <strong className="text-amber-400">Admin Remarks:</strong> {disp.admin_remarks}
                    </div>
                  )}

                  {/* Admin Action Buttons if opened */}
                  {disp.status === 'opened' && (
                    <div className="pt-2 border-t border-slate-800 flex items-center justify-end space-x-2">
                      <span className="text-[10px] text-slate-400 mr-auto font-mono">Admin Action:</span>
                      <button
                        onClick={() => handleAdminAdjudicate(disp.dispute_id, 'rejected')}
                        className="px-2.5 py-1 rounded-lg bg-red-950 text-red-300 border border-red-800 hover:bg-red-900 font-bold text-[10px]"
                      >
                        Reject
                      </button>
                      <button
                        onClick={() => handleAdminAdjudicate(disp.dispute_id, 'resolved_refund')}
                        className="px-3 py-1 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-slate-950 font-bold text-[10px]"
                      >
                        Approve 100% Refund
                      </button>
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Dispute Modal */}
      {isFilingDispute && (
        <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-4">
            <div className="flex items-center justify-between border-b border-slate-800 pb-3">
              <div className="flex items-center space-x-2">
                <Camera className="w-5 h-5 text-amber-400" />
                <h3 className="font-bold text-white text-base">File Freshness Dispute Ticket</h3>
              </div>
              <button
                onClick={() => setIsFilingDispute(false)}
                className="text-slate-400 hover:text-white text-lg font-bold"
              >
                ×
              </button>
            </div>

            <form onSubmit={handleFileDispute} className="space-y-3 text-xs">
              <div>
                <label className="text-slate-400 font-semibold block mb-1">Target Delivered Order:</label>
                <select className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-white">
                  <option value="ord_sample_901">ord_sample_901 — Chhabra Organic Farms (Delivered 27 Sep)</option>
                  <option value="ord_sample_902">ord_sample_902 — Punjab Pure Desi Fowls (Delivered 29 Sep)</option>
                </select>
              </div>

              <div>
                <label className="text-slate-400 font-semibold block mb-1">Reason for Complaint:</label>
                <textarea
                  rows={3}
                  value={newReason}
                  onChange={(e) => setNewReason(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-white focus:outline-none focus:border-amber-500"
                  required
                />
              </div>

              <div>
                <label className="text-slate-400 font-semibold block mb-1">
                  Mandatory Float-Test Proof Photo URL (Storage URL):
                </label>
                <input
                  type="text"
                  value={proofUrl}
                  onChange={(e) => setProofUrl(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 font-mono text-amber-300 focus:outline-none focus:border-amber-500"
                  placeholder="https://firebasestorage.googleapis.com/..."
                  required
                />
                <span className="text-[10px] text-amber-400/80 block mt-1">
                  * Must be at least 10 characters as enforced by firestore.rules validation helper.
                </span>
              </div>

              <div className="pt-3 border-t border-slate-800 flex justify-end space-x-2">
                <button
                  type="button"
                  onClick={() => setIsFilingDispute(false)}
                  className="px-4 py-2 rounded-xl bg-slate-800 text-slate-300 hover:bg-slate-700 font-semibold"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-xl bg-amber-500 hover:bg-amber-400 text-slate-950 font-bold"
                >
                  Submit Dispute to Admin
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
