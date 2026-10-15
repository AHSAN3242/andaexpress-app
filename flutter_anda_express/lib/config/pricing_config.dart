/// AndaExpress Centralized Financial & Logistics Configuration
/// Contains all platform fee tiers, commuter fare formulas, cargo capacities,
/// and escrow/security thresholds for farm-fresh egg and live poultry distribution.

library pricing_config;

/// Cargo category for AndaExpress commuter transit
enum CargoCategory {
  eggs, // Maximum limit: 30 Trays, Rate: ₹30/tray (10% discount for >= 10 trays)
  livePoultry, // Maximum limit: 15 Birds, Rate: ₹50/bird (10% discount for >= 5 birds)
  quails, // Maximum limit: 30 Birds, Rate: ₹5/bird (5% discount only if > 20 birds)
}

/// Official Commuter Cargo Limits as mandated by AndaExpress
class CommuterCargoLimits {
  static const int maxEggTrays = 30; // Max: 30 Trays
  static const int maxLiveBirds = 15; // Max: 15 Birds (Chicken/Duck)
  static const int maxLivePoultryBirds = 15; // Alias for compatibility
  static const int maxQuails = 30; // Max: 30 Birds
  static const int maxQuailBirds = 30; // Alias for compatibility
}

/// Centralized Financial & Operating Constants for AndaExpress
class PricingConfig {
  // ============================================================================
  // 1. COMMUTER CARGO CAPACITIES (Transit Safety & Regulatory Limits)
  // ============================================================================
  static const int maxEggTrays = 30; // 30 Trays (900 eggs)
  static const int maxLiveBirds = 15; // 15 Birds (Live Broiler / Kadaknath / Desi)
  static const int maxQuails = 30; // 30 Quail Birds

  // ============================================================================
  // 2. COMMUTER FARE RATES & FORMULAS (Paras -> Akola Passenger Transit)
  // ============================================================================
  /// Fresh Egg Tray Base Fare
  static const double freshEggTrayFare = 30.0; // ₹30.00 per tray
  static const int eggBulkDiscountThresholdTrays = 10;
  static const double eggBulkDiscountPercent = 10.0; // 10% discount for >= 10 trays

  /// Live Poultry Base Fare
  static const double liveBirdFare = 50.0; // ₹50.00 per bird
  static const int liveBirdBulkDiscountThreshold = 5;
  static const double liveBirdBulkDiscountPercent = 10.0; // 10% discount for >= 5 birds

  /// Quail Base Fare
  static const double quailFare = 5.0; // ₹5.00 per bird
  static const int quailBulkDiscountThreshold = 20;
  static const double quailBulkDiscountPercent = 5.0; // 5% discount only if > 20 birds

  /// Separate / Distinct Buyer policy: always standard rate, no bulk discount
  static const double distinctBuyerDiscount = 0.0; // Always full base fare

  // ============================================================================
  // 3. BULK PLATFORM FEE ARCHITECTURE (Seller Prepaid Wallet Deduction)
  // ============================================================================
  /// Fresh Eggs Platform Fee Architecture (Single Buyer Volume):
  /// - 1 to 30 Trays (1 to 900 eggs): Flat ₹1.00 per egg (₹30.00 per tray)
  /// - 31 to 50 Trays (930 to 1,500 eggs): Flat ₹0.50 (50 paise) per egg (₹15.00 per tray)
  /// - Above 50 Trays (> 1,500 eggs, unlimited): Flat ₹0.15 (15 paise) per egg (₹4.50 per tray)
  static const double eggTier1PerEgg = 1.00;
  static const double eggTier1PerTray = 30.00;
  static const int eggTier1MaxTrays = 30;

  static const double eggTier2PerEgg = 0.50;
  static const double eggTier2PerTray = 15.00;
  static const int eggTier2MaxTrays = 50;

  static const double eggTier3PerEgg = 0.15;
  static const double eggTier3PerTray = 4.50;

  /// Live Poultry Bulk Platform Fee Architecture:
  /// - 1 to 2 birds: Flat ₹10.00
  /// - 3 to 5 birds: Flat ₹20.00
  /// - 6 to 15 birds: Flat ₹40.00
  /// - 16 to 50 birds: Flat ₹5.00 per bird
  /// - 51 to 100 birds: Flat ₹3.00 per bird
  /// - 101 to 500 birds: Flat ₹1.00 per bird
  /// - Above 500 birds: Flat ₹0.50 per bird
  static const double poultryRetailTier1Flat = 10.00; // 1-2 birds
  static const double poultryRetailTier2Flat = 20.00; // 3-5 birds
  static const double poultryRetailTier3Flat = 40.00; // 6-15 birds

  static const double poultryBulkTier1PerBird = 5.00; // 16-50 birds
  static const double poultryBulkTier2PerBird = 3.00; // 51-100 birds
  static const double poultryBulkTier3PerBird = 1.00; // 101-500 birds
  static const double poultryBulkTier4PerBird = 0.50; // > 500 birds

  // ============================================================================
  // 4. ESCROW, WALLET & LOGISTICS SETTLEMENT SECURITY
  // ============================================================================
  /// Minimum seller prepaid wallet deposit required to publish listings
  static const double minSellerWalletDeposit = 50.0;

  /// Farmer escrow settlement window hours
  static const int farmerSettlementWindowHours = 12;

  /// City Hub Shop holding fee for missed direct handover
  static const double cityHubDropFee = 5.0;

  /// Handover countdown window at Akola Bus Stand
  static const int commuterHandoverWindowSeconds = 120; // 2 minutes
}

/// Calculation breakdown for Commuter Delivery Fare
class CommuterFareResult {
  final double grossAmount;
  final double discountPercentage;
  final double discountAmount;
  final double netFare;
  final double baseRate;
  final String ruleExplanation;

  const CommuterFareResult({
    required this.grossAmount,
    required this.discountPercentage,
    required this.discountAmount,
    required this.netFare,
    required this.baseRate,
    required this.ruleExplanation,
  });
}

/// Exact Delivery Fare Calculation Engine
class CommuterFareCalculator {
  /// Base rates referencing centralized configuration
  static const double eggBaseRatePerTray = PricingConfig.freshEggTrayFare;
  static const double livePoultryBaseRatePerBird = PricingConfig.liveBirdFare;
  static const double quailBaseRatePerBird = PricingConfig.quailFare;

  /// Calculate exact fare and return calculation breakdown
  static CommuterFareResult calculate({
    required CargoCategory category,
    required int quantity,
    bool isDistinctBuyer = false,
  }) {
    double baseRate;
    double discountPercentage = 0.0;
    String ruleExplanation;

    switch (category) {
      case CargoCategory.quails:
        baseRate = PricingConfig.quailFare;
        if (!isDistinctBuyer && quantity > PricingConfig.quailBulkDiscountThreshold) {
          discountPercentage = PricingConfig.quailBulkDiscountPercent; // 5% discount only if quantity > 20
          ruleExplanation = '₹${PricingConfig.quailFare.toStringAsFixed(0)}/पक्षी • >${PricingConfig.quailBulkDiscountThreshold} पक्षियों पर ${PricingConfig.quailBulkDiscountPercent.toStringAsFixed(0)}% छूट';
        } else if (isDistinctBuyer) {
          ruleExplanation = '₹${PricingConfig.quailFare.toStringAsFixed(0)}/पक्षी • अलग खरीदार (मानक दर, कोई छूट नहीं)';
        } else {
          ruleExplanation = '₹${PricingConfig.quailFare.toStringAsFixed(0)}/पक्षी • मानक दर (<=${PricingConfig.quailBulkDiscountThreshold} पक्षी)';
        }
        break;

      case CargoCategory.eggs:
        baseRate = PricingConfig.freshEggTrayFare;
        if (!isDistinctBuyer && quantity >= PricingConfig.eggBulkDiscountThresholdTrays) {
          discountPercentage = PricingConfig.eggBulkDiscountPercent; // 10% discount for orders >= 10 trays
          ruleExplanation = '₹${PricingConfig.freshEggTrayFare.toStringAsFixed(0)}/ट्रे • >=${PricingConfig.eggBulkDiscountThresholdTrays} ट्रे पर ${PricingConfig.eggBulkDiscountPercent.toStringAsFixed(0)}% छूट';
        } else if (isDistinctBuyer) {
          ruleExplanation = '₹${PricingConfig.freshEggTrayFare.toStringAsFixed(0)}/ट्रे • अलग खरीदार (मानक दर, कोई छूट नहीं)';
        } else {
          ruleExplanation = '₹${PricingConfig.freshEggTrayFare.toStringAsFixed(0)}/ट्रे • मानक दर (<${PricingConfig.eggBulkDiscountThresholdTrays} ट्रे)';
        }
        break;

      case CargoCategory.livePoultry:
        baseRate = PricingConfig.liveBirdFare;
        if (!isDistinctBuyer && quantity >= PricingConfig.liveBirdBulkDiscountThreshold) {
          discountPercentage = PricingConfig.liveBirdBulkDiscountPercent; // 10% discount for orders >= 5 birds
          ruleExplanation = '₹${PricingConfig.liveBirdFare.toStringAsFixed(0)}/पक्षी • >=${PricingConfig.liveBirdBulkDiscountThreshold} पक्षियों पर ${PricingConfig.liveBirdBulkDiscountPercent.toStringAsFixed(0)}% छूट';
        } else if (isDistinctBuyer) {
          ruleExplanation = '₹${PricingConfig.liveBirdFare.toStringAsFixed(0)}/पक्षी • अलग खरीदार (मानक दर, कोई छूट नहीं)';
        } else {
          ruleExplanation = '₹${PricingConfig.liveBirdFare.toStringAsFixed(0)}/पक्षी • मानक दर (<${PricingConfig.liveBirdBulkDiscountThreshold} पक्षी)';
        }
        break;
    }

    final double grossAmount = baseRate * quantity;
    final double discountAmount = grossAmount * (discountPercentage / 100.0);
    final double netFare = grossAmount - discountAmount;

    return CommuterFareResult(
      grossAmount: grossAmount,
      discountPercentage: discountPercentage,
      discountAmount: discountAmount,
      netFare: netFare,
      baseRate: baseRate,
      ruleExplanation: ruleExplanation,
    );
  }
}

/// Platform Fee Result Model
class PlatformFeeResult {
  final String categoryName;
  final int quantity;
  final String quantityUnit;
  final double feePerUnit;
  final String unitRateExplanation;
  final double totalFee;
  final String tierTitle;
  final String tierBadge;

  const PlatformFeeResult({
    required this.categoryName,
    required this.quantity,
    required this.quantityUnit,
    required this.feePerUnit,
    required this.unitRateExplanation,
    required this.totalFee,
    required this.tierTitle,
    required this.tierBadge,
  });
}

/// Official AndaExpress Platform Fee Engine
class PlatformFeeEngine {
  /// 1. Refined Fresh Eggs Platform Fee Architecture (Single Buyer Volume)
  /// - 1 to 30 Trays (1 to 900 eggs): Flat ₹1.00 per egg (₹30.00 per tray)
  /// - 31 to 50 Trays (930 to 1,500 eggs): Flat ₹0.50 (50 paise) per egg (₹15.00 per tray)
  /// - Above 50 Trays (> 1,500 eggs, unlimited volume): Flat ₹0.15 (15 paise) per egg (₹4.50 per tray)
  static PlatformFeeResult calculateEggFee(int trays) {
    final int safeTrays = trays < 1 ? 1 : trays;
    final int eggCount = safeTrays * 30;
    double feePerEgg;
    double feePerTray;
    String tierTitle;
    String tierBadge;

    if (safeTrays <= PricingConfig.eggTier1MaxTrays) {
      feePerEgg = PricingConfig.eggTier1PerEgg;
      feePerTray = PricingConfig.eggTier1PerTray;
      tierTitle = '1 से 30 ट्रे (1 to 900 eggs): Flat ₹${feePerEgg.toStringAsFixed(2)}/अंडा (₹${feePerTray.toStringAsFixed(2)}/ट्रे)';
      tierBadge = 'Tier 1 (₹${feePerTray.toStringAsFixed(0)}/ट्रे)';
    } else if (safeTrays <= PricingConfig.eggTier2MaxTrays) {
      feePerEgg = PricingConfig.eggTier2PerEgg;
      feePerTray = PricingConfig.eggTier2PerTray;
      tierTitle = '31 से 50 ट्रे (930 to 1,500 eggs): Flat ₹${feePerEgg.toStringAsFixed(2)} (50p)/अंडा (₹${feePerTray.toStringAsFixed(2)}/ट्रे)';
      tierBadge = 'Tier 2 (₹${feePerTray.toStringAsFixed(0)}/ट्रे)';
    } else {
      feePerEgg = PricingConfig.eggTier3PerEgg;
      feePerTray = PricingConfig.eggTier3PerTray;
      tierTitle = '50 ट्रे से अधिक (>1,500 eggs): Flat ₹${feePerEgg.toStringAsFixed(2)} (15p)/अंडा (₹${feePerTray.toStringAsFixed(2)}/ट्रे)';
      tierBadge = 'Bulk Tier 3 (₹${feePerTray.toStringAsFixed(2)}/ट्रे)';
    }

    final double totalFee = safeTrays * feePerTray;

    return PlatformFeeResult(
      categoryName: 'ताज़ा अंडे (Fresh Eggs)',
      quantity: safeTrays,
      quantityUnit: 'ट्रे ($eggCount अंडे)',
      feePerUnit: feePerTray,
      unitRateExplanation: '₹${feePerEgg.toStringAsFixed(2)}/अंडा (₹${feePerTray.toStringAsFixed(2)}/ट्रे)',
      totalFee: totalFee,
      tierTitle: tierTitle,
      tierBadge: tierBadge,
    );
  }

  /// 2. Live Poultry Bulk Platform Fee Architecture
  /// - 1 to 15 birds: Standard retail tiers (1-2 birds: ₹10, 3-5 birds: ₹20, 6-15 birds: ₹40)
  /// - 16 to 50 birds: Flat ₹5.00 per bird
  /// - 51 to 100 birds: Flat ₹3.00 per bird
  /// - 101 to 500 birds: Flat ₹1.00 per bird
  /// - Above 500 birds: Flat ₹0.50 (50 paise) per bird
  static PlatformFeeResult calculateLivePoultryFee(int birds) {
    final int safeBirds = birds < 1 ? 1 : birds;
    double totalFee;
    double feePerBird;
    String tierTitle;
    String tierBadge;

    if (safeBirds <= 2) {
      totalFee = PricingConfig.poultryRetailTier1Flat;
      feePerBird = totalFee / safeBirds;
      tierTitle = '1 से 2 पक्षी: Standard Retail Tier (Flat ₹${PricingConfig.poultryRetailTier1Flat.toStringAsFixed(0)})';
      tierBadge = 'Retail Tier 1 (₹${PricingConfig.poultryRetailTier1Flat.toStringAsFixed(0)})';
    } else if (safeBirds <= 5) {
      totalFee = PricingConfig.poultryRetailTier2Flat;
      feePerBird = totalFee / safeBirds;
      tierTitle = '3 से 5 पक्षी: Standard Retail Tier (Flat ₹${PricingConfig.poultryRetailTier2Flat.toStringAsFixed(0)})';
      tierBadge = 'Retail Tier 2 (₹${PricingConfig.poultryRetailTier2Flat.toStringAsFixed(0)})';
    } else if (safeBirds <= 15) {
      totalFee = PricingConfig.poultryRetailTier3Flat;
      feePerBird = totalFee / safeBirds;
      tierTitle = '6 से 15 पक्षी: Standard Retail Tier (Flat ₹${PricingConfig.poultryRetailTier3Flat.toStringAsFixed(0)})';
      tierBadge = 'Retail Tier 3 (₹${PricingConfig.poultryRetailTier3Flat.toStringAsFixed(0)})';
    } else if (safeBirds <= 50) {
      feePerBird = PricingConfig.poultryBulkTier1PerBird;
      totalFee = safeBirds * feePerBird;
      tierTitle = '16 से 50 पक्षी: Flat ₹${feePerBird.toStringAsFixed(2)} प्रति पक्षी';
      tierBadge = 'Bulk Tier 1 (₹${feePerBird.toStringAsFixed(0)}/bird)';
    } else if (safeBirds <= 100) {
      feePerBird = PricingConfig.poultryBulkTier2PerBird;
      totalFee = safeBirds * feePerBird;
      tierTitle = '51 से 100 पक्षी: Flat ₹${feePerBird.toStringAsFixed(2)} प्रति पक्षी';
      tierBadge = 'Bulk Tier 2 (₹${feePerBird.toStringAsFixed(0)}/bird)';
    } else if (safeBirds <= 500) {
      feePerBird = PricingConfig.poultryBulkTier3PerBird;
      totalFee = safeBirds * feePerBird;
      tierTitle = '101 से 500 पक्षी: Flat ₹${feePerBird.toStringAsFixed(2)} प्रति पक्षी';
      tierBadge = 'Commercial Bulk (₹${feePerBird.toStringAsFixed(0)}/bird)';
    } else {
      feePerBird = PricingConfig.poultryBulkTier4PerBird;
      totalFee = safeBirds * feePerBird;
      tierTitle = '500 पक्षी से अधिक: Flat ₹${feePerBird.toStringAsFixed(2)} (50 paise) प्रति पक्षी';
      tierBadge = 'Mega Volume (50p/bird)';
    }

    return PlatformFeeResult(
      categoryName: 'लाइव पोल्ट्री (Live Poultry)',
      quantity: safeBirds,
      quantityUnit: 'पक्षी (Birds)',
      feePerUnit: feePerBird,
      unitRateExplanation: '₹${feePerBird.toStringAsFixed(2)}/पक्षी',
      totalFee: totalFee,
      tierTitle: tierTitle,
      tierBadge: tierBadge,
    );
  }
}
