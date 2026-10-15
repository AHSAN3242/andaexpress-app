/**
 * AndaExpress Centralized Financial & Logistics Configuration (TypeScript / React)
 * Mirrors flutter_anda_express/lib/config/pricing_config.dart
 */

export interface CommuterCargoLimitsConfig {
  maxEggTrays: number;
  maxLiveBirds: number;
  maxQuails: number;
}

export interface PlatformFeeResultType {
  categoryName: string;
  quantity: number;
  quantityUnit: string;
  feePerUnit: number;
  unitRateExplanation: string;
  totalFee: number;
  tierTitle: string;
  tierBadge: string;
}

export interface CommuterFareResultType {
  grossAmount: number;
  discountPercentage: number;
  discountAmount: number;
  netFare: number;
  baseRate: number;
  ruleExplanation: string;
}

export const PricingConfig = {
  // 1. Commuter Cargo Capacities
  maxEggTrays: 30, // 30 Trays (900 eggs)
  maxLiveBirds: 15, // 15 Birds
  maxQuails: 30, // 30 Birds

  // 2. Commuter Fare Rates & Discounts
  freshEggTrayFare: 30.0, // ₹30/tray
  eggBulkDiscountThresholdTrays: 10,
  eggBulkDiscountPercent: 10.0, // 10% discount for >= 10 trays

  liveBirdFare: 50.0, // ₹50/bird
  liveBirdBulkDiscountThreshold: 5,
  liveBirdBulkDiscountPercent: 10.0, // 10% discount for >= 5 birds

  quailFare: 5.0, // ₹5/bird
  quailBulkDiscountThreshold: 20,
  quailBulkDiscountPercent: 5.0, // 5% discount only if > 20 birds

  distinctBuyerDiscount: 0.0, // Standard rate for distinct buyers

  // 3. Platform Fee Architecture (Eggs)
  eggTier1PerEgg: 1.00,
  eggTier1PerTray: 30.00,
  eggTier1MaxTrays: 30,

  eggTier2PerEgg: 0.50,
  eggTier2PerTray: 15.00,
  eggTier2MaxTrays: 50,

  eggTier3PerEgg: 0.15,
  eggTier3PerTray: 4.50,

  // Live Poultry Bulk Platform Fee
  poultryRetailTier1Flat: 10.00, // 1-2 birds
  poultryRetailTier2Flat: 20.00, // 3-5 birds
  poultryRetailTier3Flat: 40.00, // 6-15 birds

  poultryBulkTier1PerBird: 5.00, // 16-50 birds
  poultryBulkTier2PerBird: 3.00, // 51-100 birds
  poultryBulkTier3PerBird: 1.00, // 101-500 birds
  poultryBulkTier4PerBird: 0.50, // > 500 birds

  // 4. Escrow & Security
  minSellerWalletDeposit: 50.0,
  farmerSettlementWindowHours: 12,
  cityHubDropFee: 5.0,
  commuterHandoverWindowSeconds: 120, // 2 minutes
} as const;

export class CommuterFareCalculator {
  static calculate(category: 'eggs' | 'livePoultry' | 'quails', quantity: number, isDistinctBuyer = false): CommuterFareResultType {
    let baseRate: number;
    let discountPercentage = 0.0;
    let ruleExplanation = '';

    switch (category) {
      case 'quails':
        baseRate = PricingConfig.quailFare;
        if (!isDistinctBuyer && quantity > PricingConfig.quailBulkDiscountThreshold) {
          discountPercentage = PricingConfig.quailBulkDiscountPercent;
          ruleExplanation = `₹${PricingConfig.quailFare}/पक्षी • >${PricingConfig.quailBulkDiscountThreshold} पक्षियों पर ${PricingConfig.quailBulkDiscountPercent}% छूट`;
        } else if (isDistinctBuyer) {
          ruleExplanation = `₹${PricingConfig.quailFare}/पक्षी • अलग खरीदार (मानक दर, कोई छूट नहीं)`;
        } else {
          ruleExplanation = `₹${PricingConfig.quailFare}/पक्षी • मानक दर (<=${PricingConfig.quailBulkDiscountThreshold} पक्षी)`;
        }
        break;

      case 'eggs':
        baseRate = PricingConfig.freshEggTrayFare;
        if (!isDistinctBuyer && quantity >= PricingConfig.eggBulkDiscountThresholdTrays) {
          discountPercentage = PricingConfig.eggBulkDiscountPercent;
          ruleExplanation = `₹${PricingConfig.freshEggTrayFare}/ट्रे • >=${PricingConfig.eggBulkDiscountThresholdTrays} ट्रे पर ${PricingConfig.eggBulkDiscountPercent}% छूट`;
        } else if (isDistinctBuyer) {
          ruleExplanation = `₹${PricingConfig.freshEggTrayFare}/ट्रे • अलग खरीदार (मानक दर, कोई छूट नहीं)`;
        } else {
          ruleExplanation = `₹${PricingConfig.freshEggTrayFare}/ट्रे • मानक दर (<${PricingConfig.eggBulkDiscountThresholdTrays} ट्रे)`;
        }
        break;

      case 'livePoultry':
        baseRate = PricingConfig.liveBirdFare;
        if (!isDistinctBuyer && quantity >= PricingConfig.liveBirdBulkDiscountThreshold) {
          discountPercentage = PricingConfig.liveBirdBulkDiscountPercent;
          ruleExplanation = `₹${PricingConfig.liveBirdFare}/पक्षी • >=${PricingConfig.liveBirdBulkDiscountThreshold} पक्षियों पर ${PricingConfig.liveBirdBulkDiscountPercent}% छूट`;
        } else if (isDistinctBuyer) {
          ruleExplanation = `₹${PricingConfig.liveBirdFare}/पक्षी • अलग खरीदार (मानक दर, कोई छूट नहीं)`;
        } else {
          ruleExplanation = `₹${PricingConfig.liveBirdFare}/पक्षी • मानक दर (<${PricingConfig.liveBirdBulkDiscountThreshold} पक्षी)`;
        }
        break;
    }

    const grossAmount = baseRate * quantity;
    const discountAmount = grossAmount * (discountPercentage / 100.0);
    const netFare = grossAmount - discountAmount;

    return {
      grossAmount,
      discountPercentage,
      discountAmount,
      netFare,
      baseRate,
      ruleExplanation,
    };
  }
}

export class PlatformFeeEngine {
  static calculateEggFee(trays: number): PlatformFeeResultType {
    const safeTrays = trays < 1 ? 1 : trays;
    const eggCount = safeTrays * 30;
    let feePerEgg: number;
    let feePerTray: number;
    let tierTitle: string;
    let tierBadge: string;

    if (safeTrays <= PricingConfig.eggTier1MaxTrays) {
      feePerEgg = PricingConfig.eggTier1PerEgg;
      feePerTray = PricingConfig.eggTier1PerTray;
      tierTitle = `1 से 30 ट्रे (1 to 900 eggs): Flat ₹${feePerEgg.toFixed(2)}/अंडा (₹${feePerTray.toFixed(2)}/ट्रे)`;
      tierBadge = `Tier 1 (₹${feePerTray.toFixed(0)}/ट्रे)`;
    } else if (safeTrays <= PricingConfig.eggTier2MaxTrays) {
      feePerEgg = PricingConfig.eggTier2PerEgg;
      feePerTray = PricingConfig.eggTier2PerTray;
      tierTitle = `31 से 50 ट्रे (930 to 1,500 eggs): Flat ₹${feePerEgg.toFixed(2)} (50p)/अंडा (₹${feePerTray.toFixed(2)}/ट्रे)`;
      tierBadge = `Tier 2 (₹${feePerTray.toFixed(0)}/ट्रे)`;
    } else {
      feePerEgg = PricingConfig.eggTier3PerEgg;
      feePerTray = PricingConfig.eggTier3PerTray;
      tierTitle = `50 ट्रे से अधिक (>1,500 eggs): Flat ₹${feePerEgg.toFixed(2)} (15p)/अंडा (₹${feePerTray.toFixed(2)}/ट्रे)`;
      tierBadge = `Bulk Tier 3 (₹${feePerTray.toFixed(2)}/ट्रे)`;
    }

    const totalFee = safeTrays * feePerTray;

    return {
      categoryName: 'ताज़ा अंडे (Fresh Eggs)',
      quantity: safeTrays,
      quantityUnit: `ट्रे (${eggCount} अंडे)`,
      feePerUnit: feePerTray,
      unitRateExplanation: `₹${feePerEgg.toFixed(2)}/अंडा (₹${feePerTray.toFixed(2)}/ट्रे)`,
      totalFee,
      tierTitle,
      tierBadge,
    };
  }

  static calculateLivePoultryFee(birds: number): PlatformFeeResultType {
    const safeBirds = birds < 1 ? 1 : birds;
    let totalFee: number;
    let feePerBird: number;
    let tierTitle: string;
    let tierBadge: string;

    if (safeBirds <= 2) {
      totalFee = PricingConfig.poultryRetailTier1Flat;
      feePerBird = totalFee / safeBirds;
      tierTitle = `1 से 2 पक्षी: Standard Retail Tier (Flat ₹${PricingConfig.poultryRetailTier1Flat.toFixed(0)})`;
      tierBadge = `Retail Tier 1 (₹${PricingConfig.poultryRetailTier1Flat.toFixed(0)})`;
    } else if (safeBirds <= 5) {
      totalFee = PricingConfig.poultryRetailTier2Flat;
      feePerBird = totalFee / safeBirds;
      tierTitle = `3 से 5 पक्षी: Standard Retail Tier (Flat ₹${PricingConfig.poultryRetailTier2Flat.toFixed(0)})`;
      tierBadge = `Retail Tier 2 (₹${PricingConfig.poultryRetailTier2Flat.toFixed(0)})`;
    } else if (safeBirds <= 15) {
      totalFee = PricingConfig.poultryRetailTier3Flat;
      feePerBird = totalFee / safeBirds;
      tierTitle = `6 से 15 पक्षी: Standard Retail Tier (Flat ₹${PricingConfig.poultryRetailTier3Flat.toFixed(0)})`;
      tierBadge = `Retail Tier 3 (₹${PricingConfig.poultryRetailTier3Flat.toFixed(0)})`;
    } else if (safeBirds <= 50) {
      feePerBird = PricingConfig.poultryBulkTier1PerBird;
      totalFee = safeBirds * feePerBird;
      tierTitle = `16 से 50 पक्षी: Flat ₹${feePerBird.toFixed(2)} प्रति पक्षी`;
      tierBadge = `Bulk Tier 1 (₹${feePerBird.toFixed(0)}/bird)`;
    } else if (safeBirds <= 100) {
      feePerBird = PricingConfig.poultryBulkTier2PerBird;
      totalFee = safeBirds * feePerBird;
      tierTitle = `51 से 100 पक्षी: Flat ₹${feePerBird.toFixed(2)} प्रति पक्षी`;
      tierBadge = `Bulk Tier 2 (₹${feePerBird.toFixed(0)}/bird)`;
    } else if (safeBirds <= 500) {
      feePerBird = PricingConfig.poultryBulkTier3PerBird;
      totalFee = safeBirds * feePerBird;
      tierTitle = `101 से 500 पक्षी: Flat ₹${feePerBird.toFixed(2)} प्रति पक्षी`;
      tierBadge = `Commercial Bulk (₹${feePerBird.toFixed(0)}/bird)`;
    } else {
      feePerBird = PricingConfig.poultryBulkTier4PerBird;
      totalFee = safeBirds * feePerBird;
      tierTitle = `500 पक्षी से अधिक: Flat ₹${feePerBird.toFixed(2)} (50 paise) प्रति पक्षी`;
      tierBadge = 'Mega Volume (50p/bird)';
    }

    return {
      categoryName: 'लाइव पोल्ट्री (Live Poultry)',
      quantity: safeBirds,
      quantityUnit: 'पक्षी (Birds)',
      feePerUnit: feePerBird,
      unitRateExplanation: `₹${feePerBird.toFixed(2)}/पक्षी`,
      totalFee,
      tierTitle,
      tierBadge,
    };
  }
}
