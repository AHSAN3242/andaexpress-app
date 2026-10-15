import React, { useState } from 'react';
import { Calculator, ShoppingBag, Plus, Minus, Check, ArrowRight, ShieldAlert, Sliders, Truck, Store, CreditCard, Banknote } from 'lucide-react';
import { PlatformFeeSlab } from '../types';
import { DEFAULT_APP_SETTINGS, MOCK_PRODUCTS } from '../data/initialData';

export const FeeCalculatorTab: React.FC = () => {
  const [slabs, setSlabs] = useState<PlatformFeeSlab[]>(DEFAULT_APP_SETTINGS.platform_fee_slabs);
  const [isAdminMode, setIsAdminMode] = useState(false);
  const [cartItems, setCartItems] = useState<{ productId: string; title: string; price: number; quantity: number; eggType: string }[]>([
    { productId: 'prod_desi_egg_30', title: 'Farm Fresh Desi Brown Eggs (30-Egg Tray)', price: 360, quantity: 1, eggType: 'desi' },
    { productId: 'prod_kadaknath_egg_12', title: 'Pure Kadaknath Black Eggs (12-Pack)', price: 480, quantity: 1, eggType: 'kadaknath' },
  ]);
  const [orderType, setOrderType] = useState<'Pickup' | 'Courier'>('Courier');
  const [paymentMode, setPaymentMode] = useState<'upi' | 'cod' | 'card' | 'wallet'>('upi');
  const [sliderAmount, setSliderAmount] = useState<number>(840);

  // Calculate cart total
  const cartItemAmount = cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0);

  // Calculate fee from slabs
  const calculatePlatformFee = (amount: number): { fee: number; matchedSlabIndex: number } => {
    if (amount <= 0) return { fee: 0, matchedSlabIndex: -1 };
    for (let i = 0; i < slabs.length; i++) {
      const slab = slabs[i];
      if (amount >= slab.min && amount <= slab.max) {
        return { fee: slab.fee, matchedSlabIndex: i };
      }
    }
    return { fee: slabs[slabs.length - 1]?.fee || 10, matchedSlabIndex: slabs.length - 1 };
  };

  const { fee: currentCartFee, matchedSlabIndex: currentCartSlabIndex } = calculatePlatformFee(cartItemAmount);
  const { fee: sliderFee, matchedSlabIndex: sliderSlabIndex } = calculatePlatformFee(sliderAmount);

  const courierCharge = orderType === 'Courier' ? 40 : 0;
  const buyerGrandTotal = cartItemAmount + currentCartFee + courierCharge;
  const sellerNetPayout = cartItemAmount;

  const updateQuantity = (productId: string, delta: number) => {
    setCartItems((prev) =>
      prev
        .map((item) => {
          if (item.productId === productId) {
            const newQty = Math.max(0, item.quantity + delta);
            return { ...item, quantity: newQty };
          }
          return item;
        })
        .filter((item) => item.quantity > 0)
    );
  };

  const addProductToCart = (prod: (typeof MOCK_PRODUCTS)[0]) => {
    setCartItems((prev) => {
      const exists = prev.find((p) => p.productId === prod.product_id);
      if (exists) {
        return prev.map((p) => (p.productId === prod.product_id ? { ...p, quantity: p.quantity + 1 } : p));
      }
      return [
        ...prev,
        {
          productId: prod.product_id,
          title: `${prod.egg_type.toUpperCase()} - ${prod.category} (${prod.unique_batch_code.split('-')[2]})`,
          price: prod.price,
          quantity: 1,
          eggType: prod.egg_type,
        },
      ];
    });
  };

  // Mock order doc preview
  const sampleOrderDoc = {
    order_id: 'ord_andx_8941',
    buyer_id: 'usr_buyer_rahul',
    seller_id: 'usr_seller_chhabra',
    items: cartItems.map((item) => ({
      product_id: item.productId,
      title: item.title,
      egg_type: item.eggType,
      unit_price: item.price,
      quantity: item.quantity,
      subtotal: item.price * item.quantity,
    })),
    item_amount: cartItemAmount,
    platform_fee: currentCartFee,
    order_type: orderType,
    payment_mode: paymentMode,
    status: 'pending',
    network_timestamp: new Date().toISOString(),
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-gradient-to-r from-amber-950 via-slate-900 to-slate-900 p-6 rounded-2xl border border-amber-800/40 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold uppercase tracking-wider text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded border border-amber-500/30">
              Admin Managed Configuration
            </span>
            <span className="text-xs font-mono text-emerald-400">/app_settings/general</span>
          </div>
          <h2 className="text-xl font-bold text-white mt-1">Platform Fee Slab Engine & Checkout Simulator</h2>
          <p className="text-sm text-slate-300 mt-1 max-w-2xl">
            Simulate and verify AndaExpress's tiered fee structure: exactly ₹1 (0-100), ₹2 (101-500), ₹3 (501-1000), ₹5 (1001-2000), and ₹10 (2001-999999).
          </p>
        </div>

        <button
          onClick={() => setIsAdminMode(!isAdminMode)}
          className={`flex items-center space-x-2 px-4 py-2 rounded-xl text-xs font-bold transition-all border ${
            isAdminMode
              ? 'bg-red-950 text-red-200 border-red-700/80 shadow-red-900/30'
              : 'bg-slate-800 text-slate-200 border-slate-700 hover:bg-slate-700'
          }`}
        >
          <Sliders className="w-3.5 h-3.5" />
          <span>{isAdminMode ? 'Admin Slabs Editor: ACTIVE' : 'Switch to Admin Slab Editor'}</span>
        </button>
      </div>

      {/* Slabs Grid */}
      <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm">
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center space-x-2">
            <Calculator className="w-4 h-4 text-amber-400" />
            <h3 className="text-sm font-bold text-white uppercase tracking-wider">Active Platform Fee Slabs Array</h3>
          </div>
          <span className="text-xs text-slate-400">Stored at Firestore path <code className="text-amber-300">app_settings.general.platform_fee_slabs</code></span>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-5 gap-3">
          {slabs.map((slab, idx) => {
            const isCartMatch = idx === currentCartSlabIndex;
            return (
              <div
                key={idx}
                className={`p-4 rounded-xl border transition-all ${
                  isCartMatch
                    ? 'bg-amber-500/15 border-amber-400 ring-2 ring-amber-400/40 shadow-lg'
                    : 'bg-slate-950/60 border-slate-800 text-slate-300'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span className="text-[10px] font-mono font-bold text-slate-400 uppercase">Tier {idx + 1}</span>
                  {isCartMatch && (
                    <span className="text-[9px] bg-amber-500 text-slate-950 px-1.5 py-0.5 rounded font-black uppercase">
                      Cart Match
                    </span>
                  )}
                </div>
                <div className="mt-2">
                  <div className="text-lg font-black text-amber-400">₹{slab.fee}</div>
                  <div className="text-xs font-mono text-slate-300 mt-0.5">
                    ₹{slab.min.toLocaleString()} — ₹{slab.max.toLocaleString()}
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Dynamic Amount Slider */}
        <div className="mt-5 p-4 rounded-xl bg-slate-950/80 border border-slate-800 space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-slate-300 font-semibold">Test Cart Amount Slider:</span>
            <div className="flex items-center space-x-3">
              <span className="font-mono text-base font-bold text-white">₹{sliderAmount.toLocaleString()}</span>
              <span className="bg-emerald-950 text-emerald-300 font-bold px-2 py-0.5 rounded text-xs border border-emerald-800/60">
                Calculated Fee: ₹{sliderFee} (Tier {sliderSlabIndex + 1})
              </span>
            </div>
          </div>
          <input
            type="range"
            min={0}
            max={3000}
            step={25}
            value={sliderAmount}
            onChange={(e) => setSliderAmount(Number(e.target.value))}
            className="w-full accent-amber-500 cursor-pointer h-2 bg-slate-800 rounded-lg"
          />
          <div className="flex justify-between text-[10px] text-slate-500 font-mono">
            <span>₹0 (Fee: ₹1)</span>
            <span>₹100 (Fee: ₹1)</span>
            <span>₹500 (Fee: ₹2)</span>
            <span>₹1,000 (Fee: ₹3)</span>
            <span>₹2,000 (Fee: ₹5)</span>
            <span>₹3,000+ (Fee: ₹10)</span>
          </div>
        </div>
      </div>

      {/* Interactive Cart & Checkout Simulator */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left: Cart items & Quick Catalog */}
        <div className="lg:col-span-7 space-y-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <ShoppingBag className="w-4 h-4 text-amber-400" />
                <h3 className="text-sm font-bold text-white uppercase tracking-wider">Simulated Buyer Cart</h3>
              </div>
              <span className="text-xs text-slate-400">{cartItems.length} items</span>
            </div>

            {cartItems.length === 0 ? (
              <div className="text-center py-8 text-slate-500 text-xs">
                Your cart is empty. Click below to add farm fresh batches.
              </div>
            ) : (
              <div className="space-y-2">
                {cartItems.map((item) => (
                  <div
                    key={item.productId}
                    className="flex items-center justify-between p-3 rounded-xl bg-slate-950/70 border border-slate-800 text-xs"
                  >
                    <div>
                      <div className="font-semibold text-white">{item.title}</div>
                      <div className="text-slate-400 font-mono text-[11px]">
                        ₹{item.price} each • Subtotal: <strong className="text-amber-300">₹{item.price * item.quantity}</strong>
                      </div>
                    </div>

                    <div className="flex items-center space-x-2">
                      <button
                        onClick={() => updateQuantity(item.productId, -1)}
                        className="w-7 h-7 rounded-lg bg-slate-800 hover:bg-slate-700 flex items-center justify-center text-slate-300 transition-colors"
                      >
                        <Minus className="w-3 h-3" />
                      </button>
                      <span className="w-6 text-center font-mono font-bold text-white">{item.quantity}</span>
                      <button
                        onClick={() => updateQuantity(item.productId, 1)}
                        className="w-7 h-7 rounded-lg bg-slate-800 hover:bg-slate-700 flex items-center justify-center text-slate-300 transition-colors"
                      >
                        <Plus className="w-3 h-3" />
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}

            {/* Quick Add Products */}
            <div className="pt-2">
              <div className="text-[11px] font-semibold text-slate-400 uppercase tracking-wider mb-2">
                Quick Add Farm Batches:
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                {MOCK_PRODUCTS.slice(0, 4).map((p) => (
                  <button
                    key={p.product_id}
                    onClick={() => addProductToCart(p)}
                    className="p-2.5 rounded-xl bg-slate-950/50 hover:bg-amber-950/30 border border-slate-800 hover:border-amber-700/60 text-left transition-all flex items-center justify-between"
                  >
                    <div>
                      <div className="font-bold text-xs text-slate-200">
                        {p.egg_type !== 'none' ? `${p.egg_type.toUpperCase()} Eggs` : p.category.toUpperCase()}
                      </div>
                      <div className="text-[10px] text-slate-400">₹{p.price} / unit</div>
                    </div>
                    <span className="text-[10px] bg-amber-500/20 text-amber-300 border border-amber-500/30 px-2 py-0.5 rounded font-bold">
                      + Add
                    </span>
                  </button>
                ))}
              </div>
            </div>
          </div>
        </div>

        {/* Right: Checkout Breakdown & Firestore Payload */}
        <div className="lg:col-span-5 space-y-4">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm space-y-4">
            <h3 className="text-sm font-bold text-white uppercase tracking-wider">Order Ledger Summary</h3>

            {/* Order Type Toggle */}
            <div className="space-y-1.5">
              <label className="text-xs text-slate-400 font-semibold">Fulfillment Mode (order_type):</label>
              <div className="grid grid-cols-2 gap-2">
                <button
                  onClick={() => setOrderType('Courier')}
                  className={`p-2.5 rounded-xl border text-xs font-semibold flex items-center justify-center space-x-2 transition-all ${
                    orderType === 'Courier'
                      ? 'bg-amber-500 text-slate-950 font-bold border-amber-400 shadow-md'
                      : 'bg-slate-950 text-slate-300 border-slate-800'
                  }`}
                >
                  <Truck className="w-3.5 h-3.5" />
                  <span>Courier (+₹40)</span>
                </button>
                <button
                  onClick={() => setOrderType('Pickup')}
                  className={`p-2.5 rounded-xl border text-xs font-semibold flex items-center justify-center space-x-2 transition-all ${
                    orderType === 'Pickup'
                      ? 'bg-amber-500 text-slate-950 font-bold border-amber-400 shadow-md'
                      : 'bg-slate-950 text-slate-300 border-slate-800'
                  }`}
                >
                  <Store className="w-3.5 h-3.5" />
                  <span>Farm Pickup (Free)</span>
                </button>
              </div>
            </div>

            {/* Payment Mode */}
            <div className="space-y-1.5">
              <label className="text-xs text-slate-400 font-semibold">Payment Mode:</label>
              <div className="grid grid-cols-4 gap-1 text-xs">
                {(['upi', 'cod', 'card', 'wallet'] as const).map((mode) => (
                  <button
                    key={mode}
                    onClick={() => setPaymentMode(mode)}
                    className={`py-1.5 px-2 rounded-lg border font-mono uppercase text-[10px] text-center transition-all ${
                      paymentMode === mode
                        ? 'bg-emerald-950 text-emerald-300 border-emerald-600 font-bold'
                        : 'bg-slate-950 text-slate-400 border-slate-800'
                    }`}
                  >
                    {mode}
                  </button>
                ))}
              </div>
            </div>

            {/* Calculation Table */}
            <div className="space-y-2 pt-2 border-t border-slate-800 text-xs">
              <div className="flex justify-between text-slate-300">
                <span>Gross Item Amount (item_amount):</span>
                <span className="font-mono font-bold text-white">₹{cartItemAmount.toLocaleString()}</span>
              </div>
              <div className="flex justify-between text-amber-300 font-semibold bg-amber-500/10 p-2 rounded-lg border border-amber-500/20">
                <span className="flex items-center space-x-1">
                  <span>Platform Fee (Slab Tier {currentCartSlabIndex + 1}):</span>
                </span>
                <span className="font-mono font-bold text-amber-400">+ ₹{currentCartFee}</span>
              </div>
              {orderType === 'Courier' && (
                <div className="flex justify-between text-slate-400">
                  <span>Cold-Chain Courier:</span>
                  <span className="font-mono">+ ₹{courierCharge}</span>
                </div>
              )}
              <div className="pt-2 border-t border-slate-800 flex justify-between items-baseline">
                <span className="text-sm font-bold text-white">Buyer Total:</span>
                <span className="text-lg font-black text-emerald-400 font-mono">₹{buyerGrandTotal.toLocaleString()}</span>
              </div>
              <div className="flex justify-between text-[11px] text-slate-400 bg-slate-950 p-2 rounded-lg border border-slate-800">
                <span>Farmer Seller Net Payout:</span>
                <span className="font-mono font-bold text-white">₹{sellerNetPayout.toLocaleString()}</span>
              </div>
            </div>
          </div>

          {/* Firestore JSON Payload Preview */}
          <div className="bg-slate-950 border border-slate-800 rounded-2xl p-4 shadow-sm">
            <div className="flex items-center justify-between mb-2">
              <span className="text-[10px] font-mono text-slate-400 uppercase font-bold">
                Firestore Document: /orders/{sampleOrderDoc.order_id}
              </span>
              <span className="text-[9px] bg-emerald-950 text-emerald-300 px-1.5 py-0.5 rounded border border-emerald-800/60 font-bold">
                Ready for Write
              </span>
            </div>
            <pre className="text-[10px] font-mono text-amber-200/90 bg-slate-900/90 p-3 rounded-xl overflow-x-auto max-h-48 scrollbar-thin">
              {JSON.stringify(sampleOrderDoc, null, 2)}
            </pre>
          </div>
        </div>
      </div>
    </div>
  );
};
