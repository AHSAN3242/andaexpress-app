import React, { createContext, useContext, useState, ReactNode } from 'react';
import { PricingConfig as InitialPricingConfig } from '../config/pricingConfig';

export interface DynamicPricingState {
  freshEggTrayFare: number;
  liveBirdFare: number;
  quailFare: number;
  eggTier1PerEgg: number;
  eggTier2PerEgg: number;
  eggTier3PerEgg: number;
  tier1Active: boolean;
  tier2Active: boolean;
  tier3Active: boolean;
}

export interface CommuterDisputeItem {
  disputeId: string;
  orderId: string;
  commuterName: string;
  commuterPhone: string;
  farmerName: string;
  farmerUid: string;
  fareAmount: number;
  hoursElapsed: number;
  itemSummary: string;
  route: string;
  handshakeOtp: string;
  status: 'pending_escrow_deduction' | 'escrow_settled';
  settledAt?: string;
  txnId?: string;
}

export interface AntiFraudShipmentItem {
  tagNumber: string;
  batchId: string;
  orderId: string;
  breed: string;
  birdsCount: number;
  scaleWeightPerBird: string;
  totalWeight: string;
  gpsWatermark: string;
  legSealNumber: string;
  photoProofUrl: string;
  scalePhotoUrl: string;
  status: 'verified' | 'audit_cleared' | 'flagged';
  remarks: string;
}

export interface EscrowLogItem {
  id: string;
  disputeId: string;
  orderId: string;
  farmerName: string;
  commuterName: string;
  amount: number;
  timestamp: string;
  note: string;
}

interface AdminOpsContextType {
  pricing: DynamicPricingState;
  updatePricing: (updates: Partial<DynamicPricingState>) => void;
  resetPricing: () => void;
  commuterDisputes: CommuterDisputeItem[];
  authorizeWalletEscrowDeduction: (disputeId: string) => { success: boolean; amount: number; message: string };
  antiFraudShipments: AntiFraudShipmentItem[];
  verifyShipment: (tagNumber: string, status: 'verified' | 'audit_cleared' | 'flagged') => void;
  escrowLogs: EscrowLogItem[];
  farmerWalletBalance: number;
  updateFarmerWalletBalance: (newBalance: number) => void;
  toastMessage: string | null;
  setToastMessage: (msg: string | null) => void;
}

const initialPricing: DynamicPricingState = {
  freshEggTrayFare: InitialPricingConfig.freshEggTrayFare, // 30.0
  liveBirdFare: InitialPricingConfig.liveBirdFare, // 50.0
  quailFare: InitialPricingConfig.quailFare, // 5.0
  eggTier1PerEgg: InitialPricingConfig.eggTier1PerEgg, // 1.00
  eggTier2PerEgg: InitialPricingConfig.eggTier2PerEgg, // 0.50
  eggTier3PerEgg: InitialPricingConfig.eggTier3PerEgg, // 0.15
  tier1Active: true,
  tier2Active: true,
  tier3Active: true,
};

const initialCommuterDisputes: CommuterDisputeItem[] = [
  {
    disputeId: 'DISP-COMM-842',
    orderId: 'ORD-AKL-842',
    commuterName: 'Santosh Gawande',
    commuterPhone: '+91 94221 88301',
    farmerName: 'Chhabra Organic Poultry Farms',
    farmerUid: 'usr_seller_chhabra',
    fareAmount: 324.0, // 12 trays @ ₹30 - 10% bulk discount
    hoursElapsed: 14.5, // > 12 hours settlement window
    itemSummary: 'देसी फ्री-रेंज अंडे (12 Trays • 360 eggs)',
    route: 'Paras Depot ➡️ Akola Bus Stand (Gate 1)',
    handshakeOtp: '4821',
    status: 'pending_escrow_deduction',
  },
  {
    disputeId: 'DISP-COMM-903',
    orderId: 'ORD-AKL-903',
    commuterName: 'Ganesh Rathod',
    commuterPhone: '+91 98220 11922',
    farmerName: 'Punjab Pure Desi Fowls',
    farmerUid: 'usr_seller_punjab',
    fareAmount: 270.0, // 6 live birds @ ₹50 - 10% discount
    hoursElapsed: 16.2, // > 12 hours settlement window
    itemSummary: 'कड़कनाथ लाइव चिकन (6 Birds • Tag #AND-9102)',
    route: 'Paras Depot ➡️ Akola Stand (Gate 2)',
    handshakeOtp: '7392',
    status: 'pending_escrow_deduction',
  },
  {
    disputeId: 'DISP-COMM-709',
    orderId: 'ORD-AKL-709',
    commuterName: 'Kailash Tayade',
    commuterPhone: '+91 97654 33211',
    farmerName: 'Chhabra Organic Poultry Farms',
    farmerUid: 'usr_seller_chhabra',
    fareAmount: 118.75, // 25 quails @ ₹5 - 5% discount
    hoursElapsed: 13.0, // > 12 hours settlement window
    itemSummary: 'बटेर पक्षी (25 Quail Birds • Tag #AND-7320)',
    route: 'Paras Depot ➡️ Akola City Hub',
    handshakeOtp: '5814',
    status: 'pending_escrow_deduction',
  },
];

const initialAntiFraudShipments: AntiFraudShipmentItem[] = [
  {
    tagNumber: 'AND-9102',
    batchId: '#BATCH-AKL-9102',
    orderId: 'ORD-AKL-903',
    breed: 'शुद्ध कड़कनाथ (Kadaknath Pure Black Meat)',
    birdsCount: 6,
    scaleWeightPerBird: '1.65 kg / bird (Certified DigiScale #DS-42)',
    totalWeight: '9.90 kg Net Certified',
    gpsWatermark: 'LAT: 20.7002° N | LON: 77.0082° E • Paras Farm Depot • 2026-10-14 06:15 IST',
    legSealNumber: 'SEAL-MH-30-7492',
    photoProofUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=600&q=80',
    scalePhotoUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
    status: 'verified',
    remarks: 'Numbered tamper-evident leg seals intact. Certified scale watermark confirms 1.65kg avg.',
  },
  {
    tagNumber: 'AND-8419',
    batchId: '#BATCH-AKL-8419',
    orderId: 'ORD-LIV-8419',
    breed: 'देसी फ्री-रेंज असील (Aseel Country Fowl)',
    birdsCount: 12,
    scaleWeightPerBird: '2.10 kg / bird (Certified DigiScale #DS-18)',
    totalWeight: '25.20 kg Net Certified',
    gpsWatermark: 'LAT: 20.7015° N | LON: 77.0094° E • Paras Outskirts • 2026-10-13 18:40 IST',
    legSealNumber: 'SEAL-MH-30-8419',
    photoProofUrl: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=600&q=80',
    scalePhotoUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
    status: 'verified',
    remarks: 'High-resolution photo proof matches certified scale display. Anti-swap seal verified.',
  },
  {
    tagNumber: 'AND-7320',
    batchId: '#BATCH-AKL-7320',
    orderId: 'ORD-LIV-7320',
    breed: 'लाइव फार्म ब्रॉयलर (Commercial Live Broiler)',
    birdsCount: 25,
    scaleWeightPerBird: '1.80 kg / bird (Certified DigiScale #DS-09)',
    totalWeight: '45.00 kg Net Certified',
    gpsWatermark: 'LAT: 20.6998° N | LON: 77.0071° E • Paras Highway • 2026-10-13 11:20 IST',
    legSealNumber: 'SEAL-MH-30-7320',
    photoProofUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=600&q=80',
    scalePhotoUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
    status: 'audit_cleared',
    remarks: 'Commercial bulk dispatch. Leg seal chain validated at Akola Bus Stand checkpoint.',
  },
  {
    tagNumber: 'AND-6504',
    batchId: '#BATCH-AKL-6504',
    orderId: 'ORD-LIV-6504',
    breed: 'देसी वनराजा (Desi Vanaraja Dual-Purpose)',
    birdsCount: 15,
    scaleWeightPerBird: '1.95 kg / bird (Certified DigiScale #DS-27)',
    totalWeight: '29.25 kg Net Certified',
    gpsWatermark: 'LAT: 20.7020° N | LON: 77.0105° E • Paras Farm Belt • 2026-10-12 16:10 IST',
    legSealNumber: 'SEAL-MH-30-6504',
    photoProofUrl: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=600&q=80',
    scalePhotoUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
    status: 'verified',
    remarks: 'Tamper proof leg-seal confirmed by daily commuter prior to bus stand departure.',
  },
];

const AdminOpsContext = createContext<AdminOpsContextType | undefined>(undefined);

export const AdminOpsProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [pricing, setPricing] = useState<DynamicPricingState>(initialPricing);
  const [commuterDisputes, setCommuterDisputes] = useState<CommuterDisputeItem[]>(initialCommuterDisputes);
  const [antiFraudShipments, setAntiFraudShipments] = useState<AntiFraudShipmentItem[]>(initialAntiFraudShipments);
  const [escrowLogs, setEscrowLogs] = useState<EscrowLogItem[]>([]);
  const [farmerWalletBalance, setFarmerWalletBalance] = useState<number>(1250.0);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const updatePricing = (updates: Partial<DynamicPricingState>) => {
    setPricing((prev) => ({ ...prev, ...updates }));
    setToastMessage('Pricing & Fare Slab configuration updated successfully in real-time!');
    setTimeout(() => setToastMessage(null), 3000);
  };

  const resetPricing = () => {
    setPricing(initialPricing);
    setToastMessage('Pricing reset to default official AndaExpress values.');
    setTimeout(() => setToastMessage(null), 3000);
  };

  const authorizeWalletEscrowDeduction = (disputeId: string) => {
    const target = commuterDisputes.find((d) => d.disputeId === disputeId);
    if (!target) return { success: false, amount: 0, message: 'Dispute not found' };
    if (target.status === 'escrow_settled') {
      return { success: false, amount: target.fareAmount, message: 'Dispute already settled.' };
    }

    const fare = target.fareAmount;
    const newBalance = Math.max(0, +(farmerWalletBalance - fare).toFixed(2));
    setFarmerWalletBalance(newBalance);

    const nowStr = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    const txnId = `ESCROW-TXN-${Math.floor(1000 + Math.random() * 9000)}`;

    setCommuterDisputes((prev) =>
      prev.map((d) =>
        d.disputeId === disputeId
          ? {
              ...d,
              status: 'escrow_settled',
              settledAt: nowStr,
              txnId,
            }
          : d
      )
    );

    const newLog: EscrowLogItem = {
      id: txnId,
      disputeId,
      orderId: target.orderId,
      farmerName: target.farmerName,
      commuterName: target.commuterName,
      amount: fare,
      timestamp: nowStr,
      note: `Escrow Auto-Deduction (${target.hoursElapsed}h elapsed > 12h window): ₹${fare.toFixed(2)} debited from Farmer to Commuter ${target.commuterName}.`,
    };

    setEscrowLogs((prev) => [newLog, ...prev]);

    const msg = `Authorized! ₹${fare.toFixed(2)} auto-deducted from ${target.farmerName} and credited to Commuter ${target.commuterName}.`;
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 4000);

    return { success: true, amount: fare, message: msg };
  };

  const verifyShipment = (tagNumber: string, status: 'verified' | 'audit_cleared' | 'flagged') => {
    setAntiFraudShipments((prev) =>
      prev.map((s) => (s.tagNumber === tagNumber ? { ...s, status } : s))
    );
    setToastMessage(`Shipment ${tagNumber} status updated to ${status.toUpperCase()}.`);
    setTimeout(() => setToastMessage(null), 3000);
  };

  return (
    <AdminOpsContext.Provider
      value={{
        pricing,
        updatePricing,
        resetPricing,
        commuterDisputes,
        authorizeWalletEscrowDeduction,
        antiFraudShipments,
        verifyShipment,
        escrowLogs,
        farmerWalletBalance,
        updateFarmerWalletBalance: setFarmerWalletBalance,
        toastMessage,
        setToastMessage,
      }}
    >
      {children}
    </AdminOpsContext.Provider>
  );
};

export const useAdminOps = () => {
  const context = useContext(AdminOpsContext);
  if (!context) {
    throw new Error('useAdminOps must be used within an AdminOpsProvider');
  }
  return context;
};
