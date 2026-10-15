import React, { useState, useEffect } from 'react';
import { 
  Camera, 
  ShieldCheck, 
  MapPin, 
  Clock, 
  Calendar, 
  Check, 
  AlertTriangle, 
  RefreshCw, 
  Upload, 
  QrCode, 
  Sparkles, 
  FileCheck2,
  Signal,
  Wifi,
  Battery,
  Layers,
  Info,
  CheckCircle2,
  Lock
} from 'lucide-react';

interface SellerUploadProps {
  onBatchPublished?: (batchData: any) => void;
}

export const MobileSellerUploadPreview: React.FC<SellerUploadProps> = ({ onBatchPublished }) => {
  // 1. Dynamic 4-digit Daily Unique Batch Code generated from server (e.g. #EGG-842)
  const [batchCode] = useState<string>(() => {
    const randomDigits = Math.floor(800 + Math.random() * 199);
    return `#EGG-${randomDigits}`;
  });

  // Form Fields
  const [category, setCategory] = useState<'Eggs' | 'Chicken'>('Eggs');
  const [subType, setSubType] = useState<string>('Desi');
  const [quantity, setQuantity] = useState<number>(30);
  const [price, setPrice] = useState<number>(360);

  // Lay Date and Expiry Date
  const today = new Date();
  const layDateStr = today.toISOString().split('T')[0];
  const expiryDate = new Date(today);
  expiryDate.setDate(today.getDate() + 21);
  const expiryDateStr = expiryDate.toISOString().split('T')[0];

  // Camera Integration: Live Camera ONLY (Gallery completely disabled)
  const [isCapturing, setIsCapturing] = useState<boolean>(false);
  const [hasCapturedPhoto, setHasCapturedPhoto] = useState<boolean>(true);
  const [ntpWatermark, setNtpWatermark] = useState<string>('');
  const [gpsWatermark, setGpsWatermark] = useState<string>('LAT: 28.2492° N | LON: 77.0620° E (±1.8m)');

  // Farmer Academy Agreement Checkbox
  const [agreedToAcademy, setAgreedToAcademy] = useState<boolean>(false);
  const [isPublishing, setIsPublishing] = useState<boolean>(false);
  const [showSuccessToast, setShowSuccessToast] = useState<boolean>(false);

  // Initialize simulated Google NTP Server timestamp
  useEffect(() => {
    updateNtpTimestamp();
  }, []);

  const updateNtpTimestamp = () => {
    const now = new Date();
    const formatted = `${now.getUTCFullYear()}-${String(now.getUTCMonth() + 1).padStart(2, '0')}-${String(now.getUTCDate()).padStart(2, '0')} ${String(now.getUTCHours()).padStart(2, '0')}:${String(now.getUTCMinutes()).padStart(2, '0')}:${String(now.getUTCSeconds()).padStart(2, '0')} UTC [Google NTP Synced]`;
    setNtpWatermark(formatted);
  };

  const handleTriggerLiveCamera = () => {
    setIsCapturing(true);
    setHasCapturedPhoto(false);

    // Simulate hardware shutter + Google NTP Server sync + GPS lock
    setTimeout(() => {
      updateNtpTimestamp();
      setGpsWatermark('LAT: 28.2492° N | LON: 77.0620° E (±1.8m)');
      setIsCapturing(false);
      setHasCapturedPhoto(true);
    }, 1200);
  };

  const handlePublish = (e: React.FormEvent) => {
    e.preventDefault();
    if (!hasCapturedPhoto) return;
    if (!agreedToAcademy) return;

    setIsPublishing(true);

    setTimeout(() => {
      setIsPublishing(false);
      setShowSuccessToast(true);

      if (onBatchPublished) {
        onBatchPublished({
          batchCode,
          category,
          subType,
          quantity,
          price,
          layDate: layDateStr,
          expiryDate: expiryDateStr,
          ntpWatermark,
          gpsWatermark,
        });
      }

      setTimeout(() => setShowSuccessToast(false), 3500);
    }, 900);
  };

  return (
    <div className="flex flex-col items-center justify-center p-2">
      {/* Mobile Device Mockup Frame */}
      <div className="relative w-[340px] sm:w-[375px] h-[760px] bg-slate-950 rounded-[48px] p-3 shadow-2xl ring-1 ring-slate-800 border-[7px] border-slate-900 flex flex-col overflow-hidden">
        
        {/* Device Notch & Sensors */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-36 h-6 bg-slate-900 rounded-b-2xl z-30 flex items-center justify-center">
          <div className="w-10 h-1 bg-slate-700 rounded-full mb-1"></div>
          <div className="w-2.5 h-2.5 rounded-full bg-slate-800 ml-2 mb-1 border border-slate-700"></div>
        </div>

        {/* Mobile Screen Surface */}
        <div className="w-full h-full bg-slate-50 rounded-[40px] overflow-hidden flex flex-col relative text-slate-900 shadow-inner">
          
          {/* Status Bar */}
          <div className="h-10 pt-2 px-6 flex items-center justify-between text-[11px] font-semibold text-slate-800 bg-white z-20 border-b border-slate-100">
            <span>9:41</span>
            <div className="flex items-center space-x-1.5 text-slate-700">
              <Signal className="w-3 h-3" />
              <Wifi className="w-3 h-3" />
              <Battery className="w-3.5 h-3.5 fill-current" />
            </div>
          </div>

          {/* App Header */}
          <div className="bg-[#1B5E20] text-white px-4 py-2.5 flex items-center justify-between shadow-xs">
            <div className="flex items-center space-x-2">
              <div className="w-6 h-6 rounded-lg bg-amber-400 text-slate-950 flex items-center justify-center font-bold text-xs">
                🌾
              </div>
              <div>
                <h2 className="text-xs font-bold leading-tight">नया फार्म बैच अपलोड</h2>
                <p className="text-[9px] text-emerald-200">Seller Live Batch Publishing</p>
              </div>
            </div>

            {/* Dynamic Batch Badge */}
            <div className="flex items-center space-x-1 bg-amber-400 text-slate-950 font-black px-2 py-0.5 rounded-lg text-[11px] shadow-xs">
              <QrCode className="w-3 h-3" />
              <span className="font-mono">{batchCode}</span>
            </div>
          </div>

          {/* Scrollable Form Body */}
          <div className="flex-1 overflow-y-auto px-4 py-3 space-y-3.5 scrollbar-none text-xs">
            
            {/* 1. Dynamic 4-digit Daily Unique Batch Code Anti-Fraud Card */}
            <div className="bg-amber-50 border border-amber-300 rounded-xl p-2.5 flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <div className="w-7 h-7 rounded-lg bg-amber-200/80 flex items-center justify-center text-amber-900">
                  <ShieldCheck className="w-4 h-4" />
                </div>
                <div>
                  <div className="font-bold text-[11px] text-amber-950 flex items-center space-x-1">
                    <span>दैनिक 4-अंकीय यूनिक बैच कोड</span>
                  </div>
                  <div className="text-[9px] text-amber-800">
                    सर्वर द्वारा प्रमाणित कोड: ट्रे पर स्टैम्प करना अनिवार्य है
                  </div>
                </div>
              </div>
              <span className="font-mono font-black text-sm text-amber-900 bg-white px-2 py-0.5 rounded border border-amber-300">
                {batchCode}
              </span>
            </div>

            {/* 2. Category Selection (Eggs / Chicken) */}
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-700">1. श्रेणी (Category):</label>
              <div className="grid grid-cols-2 gap-2">
                <button
                  type="button"
                  onClick={() => {
                    setCategory('Eggs');
                    setSubType('Desi');
                  }}
                  className={`py-2 px-3 rounded-xl border text-center font-bold transition-all flex items-center justify-center space-x-1.5 ${
                    category === 'Eggs'
                      ? 'bg-white border-[#1B5E20] text-[#1B5E20] shadow-xs ring-1 ring-[#1B5E20]'
                      : 'bg-white/60 border-slate-200 text-slate-600'
                  }`}
                >
                  <span className="text-base">🥚</span>
                  <span>अंडे (Eggs)</span>
                </button>

                <button
                  type="button"
                  onClick={() => {
                    setCategory('Chicken');
                    setSubType('Broiler');
                  }}
                  className={`py-2 px-3 rounded-xl border text-center font-bold transition-all flex items-center justify-center space-x-1.5 ${
                    category === 'Chicken'
                      ? 'bg-white border-[#1B5E20] text-[#1B5E20] shadow-xs ring-1 ring-[#1B5E20]'
                      : 'bg-white/60 border-slate-200 text-slate-600'
                  }`}
                >
                  <span className="text-base">🐔</span>
                  <span>चिकन (Chicken)</span>
                </button>
              </div>
            </div>

            {/* 3. Sub-type (Desi / Layer / Organic / Kadaknath) */}
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-700">2. नस्ल / उप-प्रकार (Sub-type):</label>
              <select
                value={subType}
                onChange={(e) => setSubType(e.target.value)}
                className="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs font-semibold text-slate-800 focus:outline-none focus:border-[#1B5E20]"
              >
                {category === 'Eggs' ? (
                  <>
                    <option value="Desi">देसी अंडे (Desi Brown Country Eggs)</option>
                    <option value="Layer">लेयर / टेबल अंडे (Commercial White Layer)</option>
                    <option value="Organic">ऑर्गेनिक फ्री-रेंज (Organic Free-Range)</option>
                    <option value="Kadaknath">कड़कनाथ काला अंडा (Kadaknath Black)</option>
                  </>
                ) : (
                  <>
                    <option value="Broiler">ब्रॉयलर जीवित पक्षी (Live Broiler)</option>
                    <option value="DesiCountry">देसी मुर्गा / मुर्गी (Desi Country Fowl)</option>
                    <option value="KadaknathPure">कड़कनाथ शुद्ध नस्ल (Kadaknath Pure Breed)</option>
                  </>
                )}
              </select>
            </div>

            {/* 4. Quantity and Price */}
            <div className="grid grid-cols-2 gap-2">
              <div className="space-y-1">
                <label className="text-[11px] font-bold text-slate-700">3. मात्रा (Quantity):</label>
                <div className="relative">
                  <input
                    type="number"
                    value={quantity}
                    onChange={(e) => setQuantity(Number(e.target.value))}
                    className="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs font-bold text-slate-900 focus:outline-none focus:border-[#1B5E20]"
                  />
                  <span className="absolute right-2.5 top-1/2 -translate-y-1/2 text-[10px] text-slate-400 font-medium">
                    {category === 'Eggs' ? 'ट्रे (Trays)' : 'पक्षी'}
                  </span>
                </div>
              </div>

              <div className="space-y-1">
                <label className="text-[11px] font-bold text-slate-700">4. मूल्य (Price in ₹):</label>
                <div className="relative">
                  <span className="absolute left-3 top-1/2 -translate-y-1/2 text-xs font-bold text-slate-500">₹</span>
                  <input
                    type="number"
                    value={price}
                    onChange={(e) => setPrice(Number(e.target.value))}
                    className="w-full bg-white border border-slate-300 rounded-xl pl-7 pr-3 py-2 text-xs font-bold text-slate-900 focus:outline-none focus:border-[#1B5E20]"
                  />
                </div>
              </div>
            </div>

            {/* 5. Lay Date and Expiry Date */}
            <div className="grid grid-cols-2 gap-2">
              <div className="space-y-1">
                <label className="text-[10px] font-bold text-slate-700">5. Lay Date (अंडे देने की तारीख):</label>
                <div className="bg-white border border-slate-300 rounded-xl p-2 flex items-center space-x-1.5 text-[11px] font-semibold text-slate-800">
                  <Calendar className="w-3.5 h-3.5 text-[#1B5E20]" />
                  <span>{layDateStr}</span>
                </div>
              </div>

              <div className="space-y-1">
                <label className="text-[10px] font-bold text-slate-700">6. Expiry Date (समाप्ति तारीख):</label>
                <div className="bg-red-50 border border-red-200 rounded-xl p-2 flex items-center space-x-1.5 text-[11px] font-bold text-red-700">
                  <Clock className="w-3.5 h-3.5 text-red-500" />
                  <span>{expiryDateStr}</span>
                </div>
              </div>
            </div>

            {/* 6. CAMERA INTEGRATION: Live Camera Only (Gallery Completely Disabled) */}
            <div className="space-y-1 pt-1">
              <div className="flex items-center justify-between">
                <label className="text-[11px] font-bold text-slate-800 flex items-center space-x-1">
                  <Camera className="w-3.5 h-3.5 text-[#1B5E20]" />
                  <span>लाइव कैमरा फोटो (Live Camera Only)</span>
                </label>
                <span className="text-[9px] font-bold text-red-600 bg-red-50 px-1.5 py-0.2 rounded border border-red-200 flex items-center space-x-0.5">
                  <Lock className="w-2.5 h-2.5" />
                  <span>Gallery Blocked</span>
                </span>
              </div>

              {/* Camera Frame with Watermarks */}
              <div className="relative w-full h-44 bg-black rounded-2xl overflow-hidden border-2 border-[#1B5E20] shadow-md flex items-center justify-center">
                {isCapturing ? (
                  <div className="flex flex-col items-center justify-center text-white space-y-2">
                    <RefreshCw className="w-6 h-6 text-amber-400 animate-spin" />
                    <span className="text-[10px] font-mono text-emerald-300">Google NTP Server Syncing...</span>
                  </div>
                ) : hasCapturedPhoto ? (
                  <>
                    <img
                      src="https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80"
                      alt="Farm Eggs Live Capture"
                      className="w-full h-full object-cover"
                    />

                    {/* Top Watermark Badge: Server Batch Code */}
                    <div className="absolute top-2 left-2 bg-amber-400 text-slate-950 font-black px-2 py-0.5 rounded text-[10px] shadow-md">
                      BATCH: {batchCode}
                    </div>

                    {/* Live Shutter Retake Button */}
                    <button
                      type="button"
                      onClick={handleTriggerLiveCamera}
                      className="absolute top-2 right-2 bg-black/75 hover:bg-black text-white text-[9px] font-bold px-2 py-1 rounded-md border border-white/30 flex items-center space-x-1 backdrop-blur-xs"
                    >
                      <Camera className="w-3 h-3 text-amber-300" />
                      <span>Retake (Live)</span>
                    </button>

                    {/* Bottom Auto-Watermarked Overlay: Google NTP Time + GPS Lat/Long */}
                    <div className="absolute bottom-0 inset-x-0 bg-black/85 backdrop-blur-xs p-2 text-[9px] font-mono leading-tight space-y-0.5 border-t border-white/20">
                      <div className="flex items-center space-x-1 text-emerald-400 font-bold">
                        <Clock className="w-3 h-3 text-emerald-400 shrink-0" />
                        <span className="truncate">{ntpWatermark}</span>
                      </div>
                      <div className="flex items-center space-x-1 text-amber-300 font-bold">
                        <MapPin className="w-3 h-3 text-amber-400 shrink-0" />
                        <span className="truncate">{gpsWatermark}</span>
                      </div>
                    </div>
                  </>
                ) : (
                  <div className="flex flex-col items-center text-center p-3 text-white space-y-2">
                    <Camera className="w-8 h-8 text-white/80" />
                    <span className="text-[11px] font-bold">कैमरे से सीधे फोटो लें</span>
                    <button
                      type="button"
                      onClick={handleTriggerLiveCamera}
                      className="bg-[#1B5E20] hover:bg-[#2E7D32] text-white px-3 py-1.5 rounded-xl font-bold text-xs flex items-center space-x-1"
                    >
                      <Camera className="w-3.5 h-3.5" />
                      <span>ओपन लाइव कैमरा</span>
                    </button>
                  </div>
                )}
              </div>
            </div>

            {/* 7. Farmer Academy Agreement Checkbox (Exact Hindi String) */}
            <div className={`p-2.5 rounded-xl border transition-all ${
              agreedToAcademy ? 'bg-emerald-50/80 border-emerald-300' : 'bg-white border-slate-300'
            }`}>
              <label className="flex items-start space-x-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={agreedToAcademy}
                  onChange={(e) => setAgreedToAcademy(e.target.checked)}
                  className="mt-0.5 w-4 h-4 rounded text-[#1B5E20] accent-[#1B5E20] focus:ring-0 cursor-pointer"
                />
                <div className="text-[11px] leading-tight">
                  <span className="font-bold text-slate-900 block">
                    'मैंने डेट स्टैम्पिंग और सुरक्षित पैकिंग गाइड समझ ली है'
                  </span>
                  <span className="text-[9px] text-slate-500 block mt-0.5">
                    (I understand the egg collection date stamping and bio-secure packaging rules)
                  </span>
                </div>
              </label>
            </div>

            {/* 8. Action Button */}
            <button
              type="button"
              disabled={isPublishing || !hasCapturedPhoto || !agreedToAcademy}
              onClick={handlePublish}
              className="w-full py-3 rounded-xl bg-[#1B5E20] hover:bg-[#2E7D32] text-white font-black text-xs transition-all shadow-md shadow-[#1B5E20]/20 flex items-center justify-center space-x-2 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              {isPublishing ? (
                <RefreshCw className="w-4 h-4 animate-spin" />
              ) : (
                <>
                  <Upload className="w-3.5 h-3.5" />
                  <span>बैच प्रकाशित करें ({batchCode})</span>
                </>
              )}
            </button>

            {/* Anti-fraud disclaimer */}
            <p className="text-[9px] text-slate-400 text-center leading-tight pb-2">
              AndaExpress Anti-Fraud System • Google NTP Server Authenticated • GPS Verified
            </p>
          </div>

          {/* Success Overlay Notification */}
          {showSuccessToast && (
            <div className="absolute inset-0 bg-emerald-950/90 backdrop-blur-xs z-50 flex flex-col items-center justify-center p-6 text-white text-center animate-fadeIn">
              <div className="w-14 h-14 rounded-full bg-emerald-500/20 border-2 border-emerald-400 flex items-center justify-center mb-3">
                <CheckCircle2 className="w-8 h-8 text-emerald-400" />
              </div>
              <h3 className="text-base font-bold">बैच सफलतापूर्वक प्रकाशित हुआ!</h3>
              <p className="text-xs text-emerald-200 mt-1 max-w-[210px]">
                Batch <strong>{batchCode}</strong> is now live on AndaExpress fresh catalog with verified Google NTP timestamp.
              </p>
              <div className="mt-3 px-3 py-1 bg-emerald-800/90 rounded-full text-[10px] font-mono text-amber-300">
                Stock: {quantity} Trays • ₹{price} / tray
              </div>
            </div>
          )}

          {/* Android Home Bar */}
          <div className="h-4 flex items-center justify-center pb-1 bg-slate-50">
            <div className="w-28 h-1 bg-slate-400 rounded-full"></div>
          </div>
        </div>
      </div>
    </div>
  );
};
