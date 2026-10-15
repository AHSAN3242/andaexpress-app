import React, { useState } from 'react';
import { 
  ShoppingBag, 
  MapPin, 
  Calendar, 
  ShieldCheck, 
  Info, 
  Plus, 
  Minus, 
  ChevronRight, 
  Sparkles, 
  Egg, 
  Truck, 
  Store, 
  Camera, 
  CheckCircle2, 
  AlertTriangle, 
  Clock, 
  ArrowLeft, 
  CreditCard, 
  Lock, 
  RefreshCw,
  Search,
  SlidersHorizontal,
  Home,
  FileText,
  User,
  X,
  Scale,
  KeyRound,
  Wallet,
  PackageCheck,
  Check,
  UploadCloud,
  CheckCircle,
  Bus,
  Phone,
  MessageCircle,
  Timer,
  BellRing,
  Unlock,
  Users,
  QrCode,
  Building2,
  Package
} from 'lucide-react';
import { DEFAULT_APP_SETTINGS, MOCK_PRODUCTS } from '../data/initialData';
import { ProductEntity } from '../types';
import { PricingConfig, PlatformFeeEngine, CommuterFareCalculator } from '../config/pricingConfig';
import { useAdminOps } from '../context/AdminOpsContext';

export type MobileNavScreen = 'home' | 'checkout' | 'dispute' | 'seller-upload' | 'commuter-trip' | 'seller-wallet' | 'hub-shop' | 'login';
export type ActivePartyRole = 'farmer' | 'commuter' | 'buyer' | 'hub_shop';

interface ConnectedFlowProps {
  initialScreen?: MobileNavScreen;
  onScreenChange?: (screen: MobileNavScreen) => void;
  onNavigateToAdmin?: () => void;
}

export const ConnectedMobileFlowPreview: React.FC<ConnectedFlowProps> = ({ 
  initialScreen = 'home',
  onScreenChange,
  onNavigateToAdmin
}) => {
  const [currentScreen, setCurrentScreen] = useState<MobileNavScreen>(initialScreen);
  const [screenHistory, setScreenHistory] = useState<MobileNavScreen[]>([]);
  const adminOps = useAdminOps();
  const pricing = adminOps?.pricing || {
    freshEggTrayFare: PricingConfig.freshEggTrayFare,
    liveBirdFare: PricingConfig.liveBirdFare,
    quailFare: PricingConfig.quailFare,
    eggTier1PerEgg: PricingConfig.eggTier1PerEgg,
    eggTier2PerEgg: PricingConfig.eggTier2PerEgg,
    eggTier3PerEgg: PricingConfig.eggTier3PerEgg,
    tier1Active: true,
    tier2Active: true,
    tier3Active: true,
  };

  // Dynamic Product Catalog State (so listed egg batches appear in Customer Feed)
  const [productsList, setProductsList] = useState<ProductEntity[]>(MOCK_PRODUCTS);

  // Cart State for Customer Checkout
  const [cart, setCart] = useState<{ [productId: string]: number }>({
    'prod_desi_egg_30': 1,
    'prod_kadaknath_egg_12': 1,
  });
  const [orderType, setOrderType] = useState<'Courier' | 'Pickup'>('Courier');
  const [paymentMode, setPaymentMode] = useState<'upi' | 'cod'>('upi');
  const [orderPlacedSuccess, setOrderPlacedSuccess] = useState<boolean>(false);

  // Water Float Test Info Modal State (Customer Feed)
  const [showFloatModal, setShowFloatModal] = useState<boolean>(false);

  // Dispute Screen State (Strict Float Test Live Camera Only)
  const [disputeOrderId, setDisputeOrderId] = useState<string>('ord_sample_901');
  const [disputeReason, setDisputeReason] = useState<string>('अंडा पानी में तैर रहा है (Failed float test: egg floated horizontally to the surface).');
  const [isDisputeCapturing, setIsDisputeCapturing] = useState<boolean>(false);
  const [hasDisputeProof, setHasDisputeProof] = useState<boolean>(true);
  const [disputeSubmitted, setDisputeSubmitted] = useState<boolean>(false);

  // Login Screen State with Strict Legal Terms & Conditions Gate
  const [loginPhone, setLoginPhone] = useState<string>('9811223344');
  const [loginOtp, setLoginOtp] = useState<string>('');
  const [loginOtpSent, setLoginOtpSent] = useState<boolean>(false);
  const [loginRole, setLoginRole] = useState<'buyer' | 'seller'>('buyer');
  const [loginAgreedToTerms, setLoginAgreedToTerms] = useState<boolean>(false);
  const [showLoginLegalModal, setShowLoginLegalModal] = useState<boolean>(false);
  const [loginLegalModalTitle, setLoginLegalModalTitle] = useState<string>('Terms & Conditions and Privacy Policy');
  const [loginSuccessToast, setLoginSuccessToast] = useState<boolean>(false);

  // Farmer Listing & Dispatch Screen State (Dual Category: Fresh Eggs vs Live Poultry)
  const [listingCategory, setListingCategory] = useState<'fresh_eggs' | 'live_poultry'>('fresh_eggs');
  
  // Eggs Batch State
  const [listingVariety, setListingVariety] = useState<'desi' | 'kadaknath' | 'broiler_table'>('desi');
  const [listingTrays, setListingTrays] = useState<number>(30);
  const [listingPricePerTray, setListingPricePerTray] = useState<number>(360);
  
  // Live Poultry Batch State
  const [listingPoultryBreed, setListingPoultryBreed] = useState<'kadaknath_pure' | 'desi_country_fowl' | 'live_broiler'>('kadaknath_pure');
  const [listingBirdsCount, setListingBirdsCount] = useState<number>(25);
  const [listingBirdWeight, setListingBirdWeight] = useState<number>(1.6);
  const [listingPricePerBird, setListingPricePerBird] = useState<number>(650);
  const [listingLegSealNumber, setListingLegSealNumber] = useState<string>('SEAL-MH-30-7492');
  const [hasScalePhoto, setHasScalePhoto] = useState<boolean>(true);
  const [scalePhotoVerified, setScalePhotoVerified] = useState<boolean>(true);
  const [isScaleCapturing, setIsScaleCapturing] = useState<boolean>(false);

  // Flexible Advance Token vs Full COD (Farmer's Option)
  const [listingPaymentPolicy, setListingPaymentPolicy] = useState<'advance_token_50' | 'full_cod_100'>('advance_token_50');

  // Delivery Mode & Commuter Dispatch
  const [listingDeliveryMode, setListingDeliveryMode] = useState<'farm_pickup' | 'commuter_delivery'>('farm_pickup');
  const [listingCommuterFee, setListingCommuterFee] = useState<number>(28);
  const [isListingCapturing, setIsListingCapturing] = useState<boolean>(false);
  const [hasListingPhoto, setHasListingPhoto] = useState<boolean>(true);
  const [listingTimestamp, setListingTimestamp] = useState<string>('2026-10-12 10:15:30 IST');
  const [listingGpsTag, setListingGpsTag] = useState<string>('LAT: 20.7002° N | LON: 77.0082° E (Paras - Akola Belt)');
  const [listingBatchCode, setListingBatchCode] = useState<string>('#BATCH-AKL-842');
  const [listingOrderRef, setListingOrderRef] = useState<string>('ORD-PARAS-842');
  const [listingCloudinaryUrl, setListingCloudinaryUrl] = useState<string>('https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=800&q=80');

  // =========================================================================
  // OFFICIAL ANDAEXPRESS PLATFORM FEE ENGINE (BULK MICRO-TIERS)
  // =========================================================================
  // 1. Refined Fresh Eggs Platform Fee Architecture (Single Buyer Volume):
  //    - 1 to 30 Trays (1 to 900 eggs): Flat ₹1.00 per egg (₹30.00 per tray)
  //    - 31 to 50 Trays (930 to 1,500 eggs): Flat ₹0.50 (50 paise) per egg (₹15.00 per tray)
  //    - Above 50 Trays (> 1,500 eggs, unlimited volume): Flat ₹0.15 (15 paise) per egg (₹4.50 per tray)
  const calculateEggPlatformFee = (trays: number) => {
    const safeTrays = Math.max(1, trays);
    const eggCount = safeTrays * 30;
    let feePerEgg = pricing.eggTier1PerEgg;
    let tierTitle = 'Tier 1: 1 to 30 Trays';

    if (safeTrays > 50 && pricing.tier3Active) {
      feePerEgg = pricing.eggTier3PerEgg;
      tierTitle = 'Bulk Tier 3: Above 50 Trays (>1,500 Eggs)';
    } else if (safeTrays > 30 && pricing.tier2Active) {
      feePerEgg = pricing.eggTier2PerEgg;
      tierTitle = 'Tier 2: 31 to 50 Trays (930 to 1,500 Eggs)';
    } else {
      feePerEgg = pricing.eggTier1PerEgg;
      tierTitle = 'Tier 1: 1 to 30 Trays (1 to 900 Eggs)';
    }

    const feePerTray = feePerEgg * 30;
    const totalFee = +(safeTrays * feePerTray).toFixed(2);
    return {
      categoryName: 'ताज़ा अंडे (Fresh Eggs)',
      quantity: safeTrays,
      eggCount,
      feePerEgg,
      feePerTray,
      totalFee,
      tierTitle,
      tierBadge: `₹${feePerEgg.toFixed(2)}/अंडा (₹${feePerTray.toFixed(2)}/ट्रे)`,
      unitRateExplanation: `${safeTrays} ट्रे × 30 अंडे = ${eggCount} अंडे @ ₹${feePerEgg.toFixed(2)} = ₹${totalFee.toFixed(2)}`,
    };
  };

  const calculatePoultryPlatformFee = (birds: number) => {
    const res = PlatformFeeEngine.calculateLivePoultryFee(birds);
    return {
      categoryName: res.categoryName,
      quantity: res.quantity,
      feePerBird: res.feePerUnit,
      totalFee: res.totalFee,
      tierTitle: res.tierTitle,
      tierBadge: res.tierBadge,
      unitRateExplanation: res.unitRateExplanation,
    };
  };

  // Seller Prepaid Wallet & Legal Intermediary State (lib/screens/seller_wallet_screen.dart)
  interface WalletTransactionItem {
    id: string;
    orderId: string;
    title: string;
    amount: number;
    balanceAfter: number;
    timestamp: string;
    note: string;
    isDeduction: boolean;
  }

  const [localSellerWallet, setLocalSellerWallet] = useState<number>(1250.0);
  const sellerPrepaidWallet = adminOps ? adminOps.farmerWalletBalance : localSellerWallet;

  const setSellerPrepaidWallet = (valOrFn: number | ((prev: number) => number)) => {
    const current = adminOps ? adminOps.farmerWalletBalance : localSellerWallet;
    const nextVal = typeof valOrFn === 'function' ? valOrFn(current) : valOrFn;
    if (adminOps) {
      adminOps.updateFarmerWalletBalance(nextVal);
    } else {
      setLocalSellerWallet(nextVal);
    }
  };
  const [walletCalcCategory, setWalletCalcCategory] = useState<'fresh_eggs' | 'live_poultry'>('fresh_eggs');
  const [walletCalcTrays, setWalletCalcTrays] = useState<number>(30);
  const [walletCalcBirds, setWalletCalcBirds] = useState<number>(25);
  const [selectedTopUpAmount, setSelectedTopUpAmount] = useState<number>(500);
  const [showUpiModal, setShowUpiModal] = useState<boolean>(false);
  const [isSafeHarborExpanded, setIsSafeHarborExpanded] = useState<boolean>(false);
  const [walletSuccessToast, setWalletSuccessToast] = useState<{ show: boolean; message: string }>({ show: false, message: '' });
  const [walletTransactions, setWalletTransactions] = useState<WalletTransactionItem[]>([
    {
      id: 'TXN-904',
      orderId: 'ORD-AKL-842',
      title: 'अंडे प्लेटफ़ॉर्म शुल्क (Tier 1: 12 Trays)',
      amount: -360.0,
      balanceAfter: 1250.0,
      timestamp: 'आज, 10:15 AM',
      note: 'Tier 1: 12 Trays @ ₹1.00/अंडा (₹30.00/ट्रे) • Delivered Handover',
      isDeduction: true,
    },
    {
      id: 'TXN-903',
      orderId: 'ORD-BULK-712',
      title: 'अंडे प्लेटफ़ॉर्म शुल्क (Tier 2: 40 Trays)',
      amount: -600.0,
      balanceAfter: 1610.0,
      timestamp: 'कल, 02:40 PM',
      note: 'Tier 2: 40 Trays @ ₹0.50/अंडा (₹15.00/ट्रे) • Delivered to Bakery',
      isDeduction: true,
    },
    {
      id: 'TXN-902',
      orderId: 'RECHARGE-UPI',
      title: 'UPI प्रीपेड वॉलेट टॉप-अप (PhonePe)',
      amount: 1000.0,
      balanceAfter: 2210.0,
      timestamp: '10 Oct, 02:15 PM',
      note: 'Instant Top-up via ICICI VPA Gateway (andaexpress@icici)',
      isDeduction: false,
    },
    {
      id: 'TXN-901',
      orderId: 'ORD-LIV-518',
      title: 'लाइव पोल्ट्री शुल्क (Bulk Tier 1: 25 Birds)',
      amount: -125.0,
      balanceAfter: 1210.0,
      timestamp: '09 Oct, 11:20 AM',
      note: 'Bulk Tier 1: 25 Birds @ ₹5.00/पक्षी • Leg-Seal #MH-30-7492 verified',
      isDeduction: true,
    },
    {
      id: 'TXN-900',
      orderId: 'ORD-EGG-601',
      title: 'अंडे प्लेटफ़ॉर्म शुल्क (Tier 3: 60 Trays Bulk)',
      amount: -270.0,
      balanceAfter: 1335.0,
      timestamp: '08 Oct, 04:30 PM',
      note: 'Tier 3 Bulk: 60 Trays (>1500 eggs) @ ₹0.15/अंडा (₹4.50/ट्रे)',
      isDeduction: true,
    },
  ]);

  const deductPlatformFee = (
    orderId: string, 
    customFeeOrIsHubDrop?: number | boolean, 
    customTitle?: string, 
    customNote?: string
  ) => {
    let feeToDeduct = 360.0; // Default sample batch: 12 trays @ ₹30/tray = ₹360 (Tier 1: ₹1.00/egg)
    let isHubDrop = false;

    if (typeof customFeeOrIsHubDrop === 'number') {
      feeToDeduct = customFeeOrIsHubDrop;
    } else if (typeof customFeeOrIsHubDrop === 'boolean') {
      isHubDrop = customFeeOrIsHubDrop;
      feeToDeduct = isHubDrop ? 360.0 : 360.0;
    }

    setSellerPrepaidWallet((prev) => {
      const newBal = Math.max(0, +(prev - feeToDeduct).toFixed(2));
      const newTxn: WalletTransactionItem = {
        id: `TXN-${Math.floor(905 + Math.random() * 95)}`,
        orderId: orderId,
        title: customTitle || (isHubDrop ? 'हब ड्रॉप प्लेटफ़ॉर्म शुल्क (Tier 1)' : 'सफल डिलीवरी प्लेटफ़ॉर्म शुल्क (Tier 1)'),
        amount: -feeToDeduct,
        balanceAfter: newBal,
        timestamp: 'अभी (Just now)',
        note: customNote || (isHubDrop
          ? `Order dropped at City Hub (+₹5 handling, ₹${feeToDeduct} platform fee deducted)`
          : `Order delivered to buyer (Bulk Micro-Tier: ₹${feeToDeduct} deducted)`),
        isDeduction: true,
      };
      setWalletTransactions((prevTxns) => [newTxn, ...prevTxns]);
      return newBal;
    });
  };

  const processUpiRecharge = (amount: number) => {
    const newBal = +(sellerPrepaidWallet + amount).toFixed(2);
    setSellerPrepaidWallet(newBal);
    const newTxn: WalletTransactionItem = {
      id: `TXN-${Math.floor(900 + Math.random() * 99)}`,
      orderId: 'RECHARGE-UPI',
      title: 'UPI प्रीपेड वॉलेट टॉप-अप',
      amount: amount,
      balanceAfter: newBal,
      timestamp: 'अभी (Just now)',
      note: 'Instant Top-up via UPI VPA (andaexpress@icici)',
      isDeduction: false,
    };
    setWalletTransactions((prevTxns) => [newTxn, ...prevTxns]);
    setShowUpiModal(false);
    setWalletSuccessToast({
      show: true,
      message: `वॉलेट में ₹${amount} सफलतापूर्वक जोड़े गए! नया बैलेंस: ₹${newBal.toFixed(2)}`,
    });
    setTimeout(() => {
      setWalletSuccessToast({ show: false, message: '' });
    }, 3500);
  };
  const [batchPublishedSuccess, setBatchPublishedSuccess] = useState<boolean>(false);
  const [lastPublishedBatch, setLastPublishedBatch] = useState<any>(null);

  const handleListingCameraShutter = () => {
    setIsListingCapturing(true);
    setHasListingPhoto(false);
    setTimeout(() => {
      const now = new Date();
      const timeStr = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')} IST`;
      const randomDigits = Math.floor(800 + Math.random() * 199);
      setListingBatchCode(`#BATCH-AKL-${randomDigits}`);
      setListingOrderRef(`ORD-PARAS-${randomDigits}`);
      setListingTimestamp(timeStr);
      setListingGpsTag('LAT: 20.7002° N | LON: 77.0082° E (Paras - Akola Belt)');
      setIsListingCapturing(false);
      setHasListingPhoto(true);
    }, 1100);
  };

  const handlePublishEggBatch = () => {
    if (!hasListingPhoto) return;
    const newProductId = `prod_batch_${Date.now()}`;
    const newProduct: ProductEntity = {
      product_id: newProductId,
      seller_id: 'usr_seller_paras',
      farm_name: 'Paras Village Organic Poultry (Paras to Akola)',
      category: 'eggs',
      egg_type: listingVariety,
      price: listingPricePerTray,
      stock: listingTrays,
      lay_date: new Date().toISOString(),
      expiry_date: new Date(Date.now() + 21 * 24 * 60 * 60 * 1000).toISOString(),
      unique_batch_code: listingBatchCode,
      photo_url: listingCloudinaryUrl,
      network_timestamp: new Date().toISOString(),
      gps_lat_long: { latitude: 20.7002, longitude: 77.0082 },
    };

    setProductsList((prev) => [newProduct, ...prev]);
    setLastPublishedBatch({
      batchCode: listingBatchCode,
      orderRef: listingOrderRef,
      variety: listingVariety,
      trays: listingTrays,
      pricePerTray: listingPricePerTray,
      totalValue: listingTrays * listingPricePerTray,
      deliveryMode: listingDeliveryMode,
      deliveryFee: listingDeliveryMode === 'farm_pickup' ? 0 : listingCommuterFee,
      cloudinaryUrl: listingCloudinaryUrl,
    });
    setBatchPublishedSuccess(true);
    setTimeout(() => {
      setBatchPublishedSuccess(false);
      navigateTo('home');
    }, 2400);
  };

  // Commuter Trip & Dispatch Controller State
  const [commuterTripStarted, setCommuterTripStarted] = useState<boolean>(false);
  const [commuterDepartureTime, setCommuterDepartureTime] = useState<string>('10:30 AM');
  const [arrivedAtBusStand, setArrivedAtBusStand] = useState<boolean>(false);
  const [countdownSeconds, setCountdownSeconds] = useState<number>(120);
  const [isCountdownRunning, setIsCountdownRunning] = useState<boolean>(false);
  const [commuterAlertToast, setCommuterAlertToast] = useState<{ show: boolean; title: string; desc: string; type: 'fcm' | 'whatsapp' | 'call' | 'hub' | 'delivered' }>({
    show: false,
    title: '',
    desc: '',
    type: 'fcm',
  });

  interface CommuterParcelState {
    orderId: string;
    buyerName: string;
    buyerPhone: string;
    eggSummary: string;
    category: 'eggs' | 'live_poultry' | 'quails';
    quantity: number;
    isDistinctBuyer?: boolean;
    pickupCode: string;
    baseRate: number;
    discountPercent: number;
    commuterFee: number;
    parcelAmount: number;
    status: 'assigned' | 'in_transit' | 'arrived' | 'delivered' | 'dropped_at_hub';
    hubShop?: string;
    extraFee?: number;
  }

  // 4-Party Synchronized Real-Time Order Lifecycle State
  interface SharedParcelCustodyState {
    orderId: string;
    buyerName: string;
    buyerPhone: string;
    eggSummary: string;
    category: 'eggs' | 'live_poultry' | 'quails';
    quantity: number;
    pickupCode: string; // Zero-cost 4-digit code (e.g. '4821')
    trays: number;
    price: number;
    commuterFee: number;
    hubFee: number;
    paymentStatus: 'unpaid' | 'confirmed_to_farmer_upi';
    isOtpUnlocked: boolean;
    status: 'payment_pending' | 'in_transit' | 'arrived_stand' | 'dropped_at_hub' | 'delivered';
    custody: 'farmer' | 'commuter' | 'hub_shop' | 'buyer';
    destinationAddress: string;
    hubShopName: string;
    hubShopAddress: string;
    updatedAt: string;
  }

  const [activePartyRole, setActivePartyRole] = useState<ActivePartyRole>('buyer');
  const [sharedParcel, setSharedParcel] = useState<SharedParcelCustodyState>({
    orderId: 'ORD-AKL-842',
    buyerName: 'Rahul Sharma (राहुल शर्मा)',
    buyerPhone: '+91 98112 23344',
    eggSummary: 'देसी फ्री-रेंज अंडे (12 Trays)',
    category: 'eggs',
    quantity: 12,
    trays: 12,
    price: 4320,
    commuterFee: 324, // 12 trays @ ₹30 - 10% bulk discount (>=10 trays) = ₹324
    hubFee: 5,
    pickupCode: '4821',
    paymentStatus: 'unpaid',
    isOtpUnlocked: false,
    status: 'payment_pending',
    custody: 'farmer',
    destinationAddress: 'अकोला बस स्टैंड (2-मिनट हैंडशेक हैंडओवर)',
    hubShopName: 'श्रीनाथ डेयरी व सिटी हब (Shrinath Dairy & City Hub)',
    hubShopAddress: 'अकोला बस स्टैंड गेट नं. 2, मुख्य सड़क, अकोला',
    updatedAt: '10:15 AM IST',
  });
  const [hubOtpInput, setHubOtpInput] = useState<string>('');
  const [syncToast, setSyncToast] = useState<{ show: boolean; title: string; desc: string; type: 'success' | 'info' | 'warning' }>({
    show: false,
    title: '',
    desc: '',
    type: 'info',
  });

  const [commuterParcels, setCommuterParcels] = useState<CommuterParcelState[]>([
    {
      orderId: 'ORD-AKL-842',
      buyerName: 'Rahul Sharma',
      buyerPhone: '+91 98112 23344',
      eggSummary: 'देसी फ्री-रेंज अंडे (12 Trays)',
      category: 'eggs',
      quantity: 12,
      baseRate: 30,
      discountPercent: 10, // 10% discount for orders >= 10 trays (12 * 30 = 360 - 36 = 324)
      pickupCode: '4821',
      commuterFee: 324,
      parcelAmount: 4320,
      status: 'assigned',
    },
    {
      orderId: 'ORD-AKL-903',
      buyerName: 'Pooja Deshmukh',
      buyerPhone: '+91 98223 34455',
      eggSummary: 'कड़कनाथ लाइव चिकन (6 Birds)',
      category: 'live_poultry',
      quantity: 6,
      baseRate: 50,
      discountPercent: 10, // 10% discount for orders >= 5 birds (6 * 50 = 300 - 30 = 270)
      pickupCode: '7392',
      commuterFee: 270,
      parcelAmount: 3600,
      status: 'assigned',
    },
    {
      orderId: 'ORD-AKL-915',
      buyerName: 'Amit Verma',
      buyerPhone: '+91 98334 45566',
      eggSummary: 'बटेर पक्षी (25 Quail Birds)',
      category: 'quails',
      quantity: 25,
      baseRate: 5,
      discountPercent: 5, // 5% discount only if quantity > 20 (25 * 5 = 125 - 6.25 = 118.75)
      pickupCode: '5814',
      commuterFee: 118.75,
      parcelAmount: 1875,
      status: 'assigned',
    },
    {
      orderId: 'ORD-AKL-920',
      buyerName: 'Sunita Patil (अलग खरीदार)',
      buyerPhone: '+91 98445 56677',
      eggSummary: 'ऑर्गेनिक ब्राउन अंडे (4 Trays)',
      category: 'eggs',
      quantity: 4,
      isDistinctBuyer: true,
      baseRate: 30,
      discountPercent: 0, // Distinct buyers: standard rate, no discount (4 * 30 = 120)
      pickupCode: '3190',
      commuterFee: 120,
      parcelAmount: 1440,
      status: 'assigned',
    },
  ]);

  // Dynamically update commuter trip parcels and shared parcel when Admin updates pricing
  React.useEffect(() => {
    setCommuterParcels((prev) =>
      prev.map((p) => {
        if (p.category === 'eggs') {
          const rate = pricing.freshEggTrayFare;
          const disc = p.isDistinctBuyer ? 0 : (p.quantity >= 10 ? 10 : 0);
          const fee = +(p.quantity * rate * (1 - disc / 100)).toFixed(2);
          return { ...p, baseRate: rate, discountPercent: disc, commuterFee: fee };
        } else if (p.category === 'live_poultry') {
          const rate = pricing.liveBirdFare;
          const disc = p.quantity >= 5 ? 10 : 0;
          const fee = +(p.quantity * rate * (1 - disc / 100)).toFixed(2);
          return { ...p, baseRate: rate, discountPercent: disc, commuterFee: fee };
        } else if (p.category === 'quails') {
          const rate = pricing.quailFare;
          const disc = p.quantity > 20 ? 5 : 0;
          const fee = +(p.quantity * rate * (1 - disc / 100)).toFixed(2);
          return { ...p, baseRate: rate, discountPercent: disc, commuterFee: fee };
        }
        return p;
      })
    );

    setSharedParcel((prev) => {
      const rate = pricing.freshEggTrayFare;
      const disc = prev.quantity >= 10 ? 10 : 0;
      const fee = +(prev.quantity * rate * (1 - disc / 100)).toFixed(2);
      return { ...prev, commuterFee: fee };
    });
  }, [pricing.freshEggTrayFare, pricing.liveBirdFare, pricing.quailFare]);

  // 1. Zero-Cost In-App Delivery OTP: Unlock when payment is confirmed into Farmer UPI
  const handleSimulatePaymentConfirmed = () => {
    setSharedParcel((prev) => ({
      ...prev,
      paymentStatus: 'confirmed_to_farmer_upi',
      isOtpUnlocked: true,
      status: prev.status === 'payment_pending' ? 'in_transit' : prev.status,
      custody: prev.custody === 'farmer' ? 'commuter' : prev.custody,
      updatedAt: 'अभी (Just now)',
    }));
    setCommuterParcels((prev) =>
      prev.map((p) => (p.orderId === 'ORD-AKL-842' ? { ...p, status: 'in_transit' } : p))
    );
    setSyncToast({
      show: true,
      title: '✓ किसान UPI भुगतान सत्यापित!',
      desc: '₹360 किसान खाते में जमा हुए। खरीदार स्क्रीन पर 4-अंकीय हैंडशेक OTP (4821) हरा बैज लेकर अनलॉक हुआ। शून्य-लागत इन-ऐप सुरक्षा सक्रिय।',
      type: 'success',
    });
    setTimeout(() => setSyncToast((t) => ({ ...t, show: false })), 4200);
  };

  // 2. Commuter Drop at City Hub Shop -> Immediate Custody Transfer to Hub Shop
  const handleTransferToCityHubShop = () => {
    setSharedParcel((prev) => ({
      ...prev,
      status: 'dropped_at_hub',
      custody: 'hub_shop',
      destinationAddress: 'श्रीनाथ डेयरी व सिटी हब, अकोला बस स्टैंड गेट 2 (Shrinath Dairy)',
      updatedAt: 'अभी (Just now)',
    }));
    setCommuterParcels((prev) =>
      prev.map((p) =>
        p.orderId === 'ORD-AKL-842'
          ? {
              ...p,
              status: 'dropped_at_hub',
              hubShop: 'श्रीनाथ डेयरी व सिटी हब (अकोला बस स्टैंड गेट 2)',
              extraFee: 5,
            }
          : p
      )
    );
    deductPlatformFee('ORD-AKL-842', true);
    setSyncToast({
      show: true,
      title: '🏢 कस्टडी ट्रांसफर • सिटी हब दुकान पर सुरक्षित जमा!',
      desc: 'कम्यूटर से कस्टडी श्रीनाथ डेयरी को ट्रांसफर हुई। खरीदार का गंतव्य पता स्वतः हब दुकान में बदला (+₹5 शुल्क)। विक्रेता वॉलेट से ₹2 प्लेटफ़ॉर्म शुल्क कटा।',
      type: 'info',
    });
    setTimeout(() => setSyncToast((t) => ({ ...t, show: false })), 4200);
  };

  // 3. City Hub Shop or Direct Handover OTP Verification -> Delivery Finished
  const handleVerifyDeliveryOtp = (customCode?: string) => {
    const code = customCode || hubOtpInput;
    if (code.trim() === sharedParcel.pickupCode) {
      setSharedParcel((prev) => ({
        ...prev,
        status: 'delivered',
        custody: 'buyer',
        updatedAt: 'अभी (Just now)',
      }));
      setCommuterParcels((prev) =>
        prev.map((p) => (p.orderId === 'ORD-AKL-842' ? { ...p, status: 'delivered' } : p))
      );
      if (sharedParcel.status !== 'dropped_at_hub') {
        deductPlatformFee('ORD-AKL-842', false);
      }
      setHubOtpInput('');
      setSyncToast({
        show: true,
        title: '🎉 OTP 4821 सत्यापित • हैंडओवर संपन्न!',
        desc: 'अंडे सुरक्षित रूप से खरीदार राहुल शर्मा को सौंपे गए। 4-पक्षीय सिंक में कस्टडी अब खरीदार के पास है। हब दुकान का ₹5 हैंडलिंग शुल्क प्राप्त हुआ।',
        type: 'success',
      });
      setTimeout(() => setSyncToast((t) => ({ ...t, show: false })), 4500);
    } else {
      setSyncToast({
        show: true,
        title: '⚠️ अमान्य OTP कोड',
        desc: `दर्ज किया गया कोड "${code}" मेल नहीं खाता। खरीदार के स्क्रीन पर अनलॉक्ड OTP 4821 देखें।`,
        type: 'warning',
      });
      setTimeout(() => setSyncToast((t) => ({ ...t, show: false })), 3500);
    }
  };

  // 4. Reset Simulation
  const handleResetSimulation = () => {
    setSharedParcel({
      orderId: 'ORD-AKL-842',
      buyerName: 'Rahul Sharma (राहुल शर्मा)',
      buyerPhone: '+91 98112 23344',
      eggSummary: 'देसी फ्री-रेंज अंडे (12 Trays)',
      category: 'eggs',
      quantity: 12,
      trays: 12,
      price: 4320,
      commuterFee: 324,
      hubFee: 5,
      pickupCode: '4821',
      paymentStatus: 'unpaid',
      isOtpUnlocked: false,
      status: 'payment_pending',
      custody: 'farmer',
      destinationAddress: 'अकोला बस स्टैंड (2-मिनट हैंडशेक हैंडओवर)',
      hubShopName: 'श्रीनाथ डेयरी व सिटी हब (Shrinath Dairy & City Hub)',
      hubShopAddress: 'अकोला बस स्टैंड गेट नं. 2, मुख्य सड़क, अकोला',
      updatedAt: '10:15 AM IST',
    });
    setCommuterParcels((prev) =>
      prev.map((p) =>
        p.orderId === 'ORD-AKL-842'
          ? { ...p, status: 'assigned', hubShop: undefined, extraFee: undefined }
          : p
      )
    );
    setHubOtpInput('');
    setSyncToast({
      show: true,
      title: '🔄 सिमुलेशन रीसेट किया गया',
      desc: '4-पक्षीय ऑर्डर प्रारंभिक स्थिति (भुगतान लंबित, OTP लॉक, फार्म कस्टडी) में वापस आ गया।',
      type: 'info',
    });
    setTimeout(() => setSyncToast((t) => ({ ...t, show: false })), 3000);
  };

  // 2-Minute Handover Countdown Timer Effect
  React.useEffect(() => {
    let interval: any = null;
    if (isCountdownRunning && countdownSeconds > 0) {
      interval = setInterval(() => {
        setCountdownSeconds((prev) => {
          if (prev <= 1) {
            setIsCountdownRunning(false);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [isCountdownRunning, countdownSeconds]);

  // Button 1: Start Trip & Send Loud Alert (FCM)
  const handleStartCommuterTrip = () => {
    setCommuterTripStarted(true);
    const now = new Date();
    const timeStr = `${String(now.getHours() % 12 || 12).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')} ${now.getHours() >= 12 ? 'PM' : 'AM'}`;
    setCommuterDepartureTime(timeStr);
    setCommuterParcels((prev) =>
      prev.map((p) => (p.status === 'assigned' ? { ...p, status: 'in_transit' } : p))
    );
    setCommuterAlertToast({
      show: true,
      title: 'यात्रा शुरू • लाउड FCM अलर्ट प्रसारित!',
      desc: 'खरीदारों के डिवाइस पर उच्च प्राथमिकता वाला अलर्ट बजा: "कम्यूटर पारस से प्रस्थान कर चुका है। अकोला बस स्टैंड पर 30 मिनट में पहुंचेंगे।"',
      type: 'fcm',
    });
    setTimeout(() => {
      setCommuterAlertToast((t) => ({ ...t, show: false }));
    }, 3800);
  };

  // Button 2: 1-Tap WhatsApp Alert
  const handleSendWhatsAppAlert = (parcel: CommuterParcelState) => {
    const msg = `Hello ${parcel.buyerName}, AndaExpress commuter is arriving at Akola bus stand in 30 mins. Please be ready with your code: ${parcel.pickupCode} (Order: ${parcel.orderId})`;
    if (navigator.clipboard) {
      navigator.clipboard.writeText(msg);
    }
    setCommuterAlertToast({
      show: true,
      title: `WhatsApp अलर्ट भेजा गया (${parcel.buyerName})`,
      desc: `Pre-filled message: "${msg}" (क्लिपबोर्ड पर कॉपी हुआ व WhatsApp ट्रिगर सक्रिय)`,
      type: 'whatsapp',
    });
    setTimeout(() => {
      setCommuterAlertToast((t) => ({ ...t, show: false }));
    }, 3500);
  };

  // Button 3: 1-Tap Direct Call
  const handleDirectPhoneCall = (parcel: CommuterParcelState) => {
    setCommuterAlertToast({
      show: true,
      title: `डायरेक्ट कॉल डायल किया गया`,
      desc: `Calling ${parcel.buyerName} at ${parcel.buyerPhone} (tel: intent dispatched for immediate bus stand coordination)...`,
      type: 'call',
    });
    setTimeout(() => {
      setCommuterAlertToast((t) => ({ ...t, show: false }));
    }, 3200);
  };

  // Toggle: Arrived at Akola Bus Stand (Starts 2-minute timer)
  const handleToggleBusStandArrival = (arrived: boolean) => {
    setArrivedAtBusStand(arrived);
    if (arrived) {
      setCommuterParcels((prev) =>
        prev.map((p) => (p.status === 'in_transit' ? { ...p, status: 'arrived' } : p))
      );
      setCountdownSeconds(120);
      setIsCountdownRunning(true);
      setCommuterAlertToast({
        show: true,
        title: 'अकोला बस स्टैंड आगमन दर्ज!',
        desc: 'हैंडशेक हैंडओवर हेतु 2-मिनट का काउंटडाउन टाइमर शुरू हो गया है। खरीदार से 4-अंकीय कोड लें या हब दुकान पर छोड़ें।',
        type: 'fcm',
      });
      setTimeout(() => {
        setCommuterAlertToast((t) => ({ ...t, show: false }));
      }, 3500);
    } else {
      setIsCountdownRunning(false);
      setCountdownSeconds(120);
    }
  };

  // Direct Handshake Handover with 4-Digit Code
  const handleVerifyHandshake = (orderId: string) => {
    const parcel = commuterParcels.find((p) => p.orderId === orderId);
    if (!parcel) return;
    setCommuterParcels((prev) =>
      prev.map((p) => (p.orderId === orderId ? { ...p, status: 'delivered' } : p))
    );
    if (orderId === 'ORD-AKL-842') {
      setSharedParcel((prev) => ({
        ...prev,
        status: 'delivered',
        custody: 'buyer',
        updatedAt: 'अभी (Handover)',
      }));
    }
    // Dynamic platform fee deduction of ₹2.00 upon delivery
    deductPlatformFee(orderId, false);
    setCommuterAlertToast({
      show: true,
      title: `हैंडशेक सफल! (कोड ${parcel.pickupCode})`,
      desc: `ऑर्डर ${parcel.orderId} खरीदार ${parcel.buyerName} को सौंपा गया। कम्यूटर डिलीवरी शुल्क ₹${parcel.commuterFee} नकद/UPI द्वारा प्राप्त। विक्रेता वॉलेट से ₹2 प्लेटफ़ॉर्म शुल्क कटा।`,
      type: 'delivered',
    });
    setTimeout(() => {
      setCommuterAlertToast((t) => ({ ...t, show: false }));
    }, 3800);
  };

  // Fallback: Drop at City Hub Shop
  const handleDropAtCityHubShop = (orderId: string) => {
    const parcel = commuterParcels.find((p) => p.orderId === orderId);
    if (!parcel) return;
    setCommuterParcels((prev) =>
      prev.map((p) =>
        p.orderId === orderId
          ? {
              ...p,
              status: 'dropped_at_hub',
              hubShop: 'श्रीनाथ डेयरी व सिटी हब (अकोला बस स्टैंड गेट 2)',
              extraFee: 5,
            }
          : p
      )
    );
    if (orderId === 'ORD-AKL-842') {
      setSharedParcel((prev) => ({
        ...prev,
        status: 'dropped_at_hub',
        custody: 'hub_shop',
        destinationAddress: 'श्रीनाथ डेयरी व सिटी हब, अकोला बस स्टैंड गेट 2 (Shrinath Dairy)',
        updatedAt: 'अभी (Transferred)',
      }));
    }
    // Dynamic platform fee deduction of ₹2.00 upon hub drop
    deductPlatformFee(orderId, true);
    setCommuterAlertToast({
      show: true,
      title: `सिटी हब दुकान पर छोड़ा गया (सुरक्षित ड्रॉप)`,
      desc: `पार्सल श्रीनाथ डेयरी पर रखा गया (+₹5 दुकान शुल्क खरीदार देय)। खरीदार को SMS भेजा गया। विक्रेता वॉलेट से ₹2 प्लेटफ़ॉर्म शुल्क कटा।`,
      type: 'hub',
    });
    setTimeout(() => {
      setCommuterAlertToast((t) => ({ ...t, show: false }));
    }, 4200);
  };

  // Dynamic Platform Fee Calculation from Admin Slabs
  const calculateCartTotal = () => {
    let itemTotal = 0;
    Object.entries(cart).forEach(([prodId, qty]) => {
      const prod = productsList.find((p) => p.product_id === prodId);
      if (prod) {
        itemTotal += prod.price * qty;
      }
    });

    let platformFee = 10;
    const slabs = DEFAULT_APP_SETTINGS.platform_fee_slabs;
    for (const slab of slabs) {
      if (itemTotal >= slab.min && itemTotal <= slab.max) {
        platformFee = slab.fee;
        break;
      }
    }

    const courierCharge = orderType === 'Courier' ? 40 : 0;
    const grandTotal = itemTotal + platformFee + courierCharge;

    return { itemTotal, platformFee, courierCharge, grandTotal };
  };

  const { itemTotal, platformFee, courierCharge, grandTotal } = calculateCartTotal();
  const totalCartCount = Object.values(cart).reduce((sum, q) => sum + q, 0);

  const navigateTo = (newScreen: MobileNavScreen) => {
    setScreenHistory((prev) => [...prev, currentScreen]);
    setCurrentScreen(newScreen);
    onScreenChange?.(newScreen);
  };

  const handleBack = () => {
    if (screenHistory.length > 0) {
      const prev = screenHistory[screenHistory.length - 1];
      setScreenHistory((h) => h.slice(0, h.length - 1));
      setCurrentScreen(prev);
      onScreenChange?.(prev);
    } else {
      navigateTo('home');
    }
  };

  const updateCartQty = (prodId: string, delta: number) => {
    setCart((prev) => {
      const next = { ...prev };
      const current = next[prodId] || 0;
      const updated = current + delta;
      if (updated <= 0) {
        delete next[prodId];
      } else {
        next[prodId] = updated;
      }
      return next;
    });
  };

  const handleDisputeShutter = () => {
    setIsDisputeCapturing(true);
    setHasDisputeProof(false);
    setTimeout(() => {
      setIsDisputeCapturing(false);
      setHasDisputeProof(true);
    }, 1100);
  };

  return (
    <div className="flex flex-col items-center justify-center p-2 space-y-4">
      {/* 4-PARTY REAL-TIME INTERCONNECTION & SIMULATION CONTROLLER */}
      <div className="w-full max-w-[440px] bg-slate-900 border border-slate-800 rounded-3xl p-3.5 shadow-xl space-y-3">
        {/* Top Header & Role Switcher */}
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-1.5">
            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-ping"></span>
            <span className="text-[11px] font-bold text-white uppercase tracking-wider flex items-center space-x-1">
              <Users className="w-3.5 h-3.5 text-emerald-400" />
              <span>4-Party Real-Time Interconnection</span>
            </span>
          </div>
          <div className="flex items-center space-x-2">
            {onNavigateToAdmin && (
              <button
                type="button"
                onClick={onNavigateToAdmin}
                className="text-[10px] font-bold text-amber-300 bg-amber-950 hover:bg-amber-900 px-2 py-0.5 rounded-lg border border-amber-600/60 flex items-center space-x-1 transition-all shadow-xs"
                title="Switch to Web Admin Control Panel"
              >
                <ShieldCheck className="w-3 h-3 text-amber-400" />
                <span>Web Admin Desk ↗</span>
              </button>
            )}
            <span className="text-[10px] font-mono text-amber-300 bg-amber-950/80 px-2 py-0.5 rounded border border-amber-800">
              {sharedParcel.orderId}
            </span>
          </div>
        </div>

        {/* 4-Way Role Switcher Bar */}
        <div className="grid grid-cols-4 gap-1.5 p-1 bg-slate-950 rounded-2xl border border-slate-800">
          <button
            type="button"
            onClick={() => {
              setActivePartyRole('farmer');
              navigateTo('seller-upload');
            }}
            className={`py-1.5 px-1 rounded-xl text-[10px] font-bold transition-all flex flex-col items-center ${
              activePartyRole === 'farmer' || currentScreen === 'seller-upload' || currentScreen === 'seller-wallet'
                ? 'bg-amber-500 text-slate-950 font-black shadow-xs ring-1 ring-amber-300'
                : 'text-slate-400 hover:text-white'
            }`}
          >
            <span>🧑‍🌾 किसान</span>
            <span className="text-[8.5px] opacity-80">Farmer</span>
          </button>

          <button
            type="button"
            onClick={() => {
              setActivePartyRole('commuter');
              navigateTo('commuter-trip');
            }}
            className={`py-1.5 px-1 rounded-xl text-[10px] font-bold transition-all flex flex-col items-center ${
              activePartyRole === 'commuter' || currentScreen === 'commuter-trip'
                ? 'bg-blue-600 text-white font-black shadow-xs ring-1 ring-blue-300'
                : 'text-slate-400 hover:text-white'
            }`}
          >
            <span>🚌 कम्यूटर</span>
            <span className="text-[8.5px] opacity-80">Commuter</span>
          </button>

          <button
            type="button"
            onClick={() => {
              setActivePartyRole('buyer');
              navigateTo('home');
            }}
            className={`py-1.5 px-1 rounded-xl text-[10px] font-bold transition-all flex flex-col items-center ${
              activePartyRole === 'buyer' || currentScreen === 'home' || currentScreen === 'checkout'
                ? 'bg-emerald-600 text-white font-black shadow-xs ring-1 ring-emerald-300'
                : 'text-slate-400 hover:text-white'
            }`}
          >
            <span>🛒 खरीदार</span>
            <span className="text-[8.5px] opacity-80">Buyer OTP</span>
          </button>

          <button
            type="button"
            onClick={() => {
              setActivePartyRole('hub_shop');
              navigateTo('hub-shop');
            }}
            className={`py-1.5 px-1 rounded-xl text-[10px] font-bold transition-all flex flex-col items-center ${
              activePartyRole === 'hub_shop' || currentScreen === 'hub-shop'
                ? 'bg-purple-600 text-white font-black shadow-xs ring-1 ring-purple-300'
                : 'text-slate-400 hover:text-white'
            }`}
          >
            <span>🏪 सिटी हब</span>
            <span className="text-[8.5px] opacity-80">Hub Shop</span>
          </button>
        </div>

        {/* Real-Time Custody Flow Pipeline */}
        <div className="bg-slate-950/70 p-2 rounded-2xl border border-slate-800 space-y-1.5">
          <div className="flex items-center justify-between text-[10px]">
            <span className="text-slate-400 font-semibold">वर्तमान पार्सल कस्टडी (Active Custody):</span>
            <span className="font-bold text-amber-300 font-mono">
              {sharedParcel.custody === 'farmer' && '● Farmer Custody'}
              {sharedParcel.custody === 'commuter' && '● Commuter Transit'}
              {sharedParcel.custody === 'hub_shop' && '● City Hub Shop Custody'}
              {sharedParcel.custody === 'buyer' && '✓ Delivered to Buyer'}
            </span>
          </div>

          <div className="grid grid-cols-4 gap-1 text-[9px] text-center font-bold">
            <div className={`p-1 rounded-lg border transition-all ${
              sharedParcel.custody === 'farmer'
                ? 'bg-amber-500/20 text-amber-300 border-amber-500 ring-1 ring-amber-400'
                : 'bg-slate-900 text-slate-500 border-slate-800'
            }`}>
              1. Farmer
            </div>
            <div className={`p-1 rounded-lg border transition-all ${
              sharedParcel.custody === 'commuter'
                ? 'bg-blue-500/20 text-blue-300 border-blue-500 ring-1 ring-blue-400'
                : 'bg-slate-900 text-slate-500 border-slate-800'
            }`}>
              2. Commuter
            </div>
            <div className={`p-1 rounded-lg border transition-all ${
              sharedParcel.custody === 'hub_shop'
                ? 'bg-purple-500/20 text-purple-300 border-purple-500 ring-1 ring-purple-400'
                : 'bg-slate-900 text-slate-500 border-slate-800'
            }`}>
              3. City Hub
            </div>
            <div className={`p-1 rounded-lg border transition-all ${
              sharedParcel.custody === 'buyer'
                ? 'bg-emerald-500/20 text-emerald-300 border-emerald-500 ring-1 ring-emerald-400'
                : 'bg-slate-900 text-slate-500 border-slate-800'
            }`}>
              4. Delivered
            </div>
          </div>
        </div>

        {/* Live Simulation Controls */}
        <div className="space-y-1.5">
          <div className="text-[10px] font-bold text-slate-300 flex items-center justify-between">
            <span className="flex items-center space-x-1">
              <Sparkles className="w-3 h-3 text-amber-400" />
              <span>सिमुलेशन कंट्रोल्स (Simulation Controls):</span>
            </span>
            <button
              type="button"
              onClick={handleResetSimulation}
              className="text-[9.5px] text-slate-400 hover:text-amber-300 flex items-center space-x-0.5 underline"
            >
              <RefreshCw className="w-2.5 h-2.5" />
              <span>रीसेट</span>
            </button>
          </div>

          <div className="grid grid-cols-2 gap-1.5">
            {/* Button 1: Simulate Payment Confirmed */}
            <button
              type="button"
              onClick={handleSimulatePaymentConfirmed}
              className={`p-2 rounded-xl text-[10px] font-bold border transition-all flex items-center justify-center space-x-1 ${
                sharedParcel.isOtpUnlocked
                  ? 'bg-emerald-950/80 text-emerald-300 border-emerald-600/60 opacity-80'
                  : 'bg-emerald-600 hover:bg-emerald-500 text-white border-emerald-400 shadow-sm'
              }`}
            >
              {sharedParcel.isOtpUnlocked ? (
                <>
                  <Check className="w-3 h-3 text-emerald-300" />
                  <span>✓ UPI Paid (OTP Unlocked)</span>
                </>
              ) : (
                <>
                  <Unlock className="w-3 h-3 text-amber-300" />
                  <span>Simulate Payment Confirmed</span>
                </>
              )}
            </button>

            {/* Button 2: Drop at City Hub Shop */}
            <button
              type="button"
              onClick={handleTransferToCityHubShop}
              className={`p-2 rounded-xl text-[10px] font-bold border transition-all flex items-center justify-center space-x-1 ${
                sharedParcel.status === 'dropped_at_hub'
                  ? 'bg-purple-950/80 text-purple-300 border-purple-600/60 opacity-80'
                  : 'bg-slate-800 hover:bg-slate-700 text-white border-slate-700'
              }`}
            >
              <Store className="w-3 h-3 text-amber-400" />
              <span>{sharedParcel.status === 'dropped_at_hub' ? '✓ Dropped at Hub Shop' : 'Drop at City Hub (+₹5)'}</span>
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Device Frame */}
      <div className="relative w-[340px] sm:w-[375px] h-[780px] bg-slate-950 rounded-[48px] p-3 shadow-2xl ring-1 ring-slate-800 border-[7px] border-slate-900 flex flex-col overflow-hidden">
        
        {/* Device Notch & Sensors */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-36 h-6 bg-slate-900 rounded-b-2xl z-40 flex items-center justify-center">
          <div className="w-10 h-1 bg-slate-700 rounded-full mb-1"></div>
          <div className="w-2.5 h-2.5 rounded-full bg-slate-800 ml-2 mb-1 border border-slate-700"></div>
        </div>

        {/* Mobile Screen Surface */}
        <div className="w-full h-full bg-slate-50 rounded-[40px] overflow-hidden flex flex-col relative text-slate-900 shadow-inner">
          
          {/* Status Bar */}
          <div className="h-10 pt-2 px-6 flex items-center justify-between text-[11px] font-semibold text-slate-800 bg-white z-30 border-b border-slate-100">
            <span>9:41</span>
            <div className="flex items-center space-x-1.5 text-slate-700">
              <span className="text-[10px] font-bold text-[#1B5E20]">4G+</span>
              <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
          </div>

          {/* Top App Bar with Dynamic Back Button (←) */}
          <div className="bg-[#1B5E20] text-white px-3.5 py-2.5 flex items-center justify-between shadow-xs z-20">
            <div className="flex items-center space-x-2">
              {currentScreen !== 'home' ? (
                <button
                  type="button"
                  onClick={handleBack}
                  className="w-7 h-7 rounded-lg bg-emerald-900/60 hover:bg-emerald-900 flex items-center justify-center text-white transition-colors"
                  title="Back to previous screen"
                >
                  <ArrowLeft className="w-4 h-4" />
                </button>
              ) : (
                <div className="w-7 h-7 rounded-lg bg-amber-400 text-slate-950 flex items-center justify-center font-bold text-xs">
                  🥚
                </div>
              )}

              <div>
                <h2 className="text-xs font-bold leading-tight">
                  {currentScreen === 'home' && 'ताज़ा फार्म कैटलॉग'}
                  {currentScreen === 'checkout' && 'डायनेमिक चेकआउट (Checkout)'}
                  {currentScreen === 'dispute' && 'फ्लोट-टेस्ट विवाद क्लेम'}
                  {currentScreen === 'seller-upload' && 'नया बैच व डिस्पैच (Seller Batch)'}
                  {currentScreen === 'commuter-trip' && 'कम्यूटर ट्रिप व डिस्पैच'}
                  {currentScreen === 'seller-wallet' && 'विक्रेता प्रीपेड वॉलेट'}
                  {currentScreen === 'hub-shop' && 'सिटी हब दुकान व कस्टडी'}
                  {currentScreen === 'login' && 'मोबाइल लॉगिन'}
                </h2>
                <p className="text-[9px] text-emerald-200">
                  {currentScreen === 'home' && 'Nearby Farms • GPS Verified'}
                  {currentScreen === 'checkout' && 'Transparent Support Slabs'}
                  {currentScreen === 'dispute' && 'Strict Proof of Floating Egg'}
                  {currentScreen === 'seller-upload' && 'Paras to Akola • Proof Watermarked'}
                  {currentScreen === 'commuter-trip' && 'Paras ➡️ Akola • Anti-Bypass Controller'}
                  {currentScreen === 'seller-wallet' && '₹2 Safe Harbor • IT Act 2000 Sec 79'}
                  {currentScreen === 'hub-shop' && 'Shrinath Dairy • Safe Egg Cooling'}
                  {currentScreen === 'login' && 'AndaExpress Secure Access'}
                </p>
              </div>
            </div>

            {/* Top Bar Actions */}
            <div className="flex items-center space-x-1.5">
              {/* Dedicated City Hub Shortcut Button */}
              <button
                type="button"
                onClick={() => navigateTo('hub-shop')}
                className={`p-1.5 rounded-lg border font-bold text-xs flex items-center space-x-1 transition-all ${
                  currentScreen === 'hub-shop'
                    ? 'bg-amber-400 text-slate-950 border-amber-300 shadow-xs ring-1 ring-amber-300'
                    : 'bg-emerald-900/80 text-amber-300 border-amber-400/40 hover:bg-emerald-900'
                }`}
                title="सिटी हब दुकान व कस्टडी (City Hub Shop)"
              >
                <Store className="w-3.5 h-3.5" />
                <span className="text-[10px]">हब</span>
                {sharedParcel.custody === 'hub_shop' && (
                  <span className="w-2 h-2 rounded-full bg-amber-400 animate-pulse"></span>
                )}
              </button>

              {/* Dedicated Seller Wallet Top Button */}
              <button
                type="button"
                onClick={() => navigateTo('seller-wallet')}
                className={`p-1.5 rounded-lg border font-bold text-xs flex items-center space-x-1 transition-all ${
                  currentScreen === 'seller-wallet'
                    ? 'bg-amber-400 text-slate-950 border-amber-300 shadow-xs ring-1 ring-amber-300'
                    : 'bg-emerald-900/80 text-amber-300 border-amber-400/40 hover:bg-emerald-900'
                }`}
                title="विक्रेता प्रीपेड वॉलेट व सेफ हार्बर (Seller Wallet)"
              >
                <Wallet className="w-3.5 h-3.5" />
                <span className="text-[10px]">₹{sellerPrepaidWallet.toFixed(0)}</span>
              </button>

              {/* Dedicated Commuter Shortcut Button */}
              <button
                type="button"
                onClick={() => navigateTo('commuter-trip')}
                className={`p-1.5 rounded-lg border font-bold text-xs flex items-center space-x-1 transition-all ${
                  currentScreen === 'commuter-trip'
                    ? 'bg-amber-400 text-slate-950 border-amber-300 shadow-xs'
                    : 'bg-emerald-900/80 text-amber-300 border-amber-400/40 hover:bg-emerald-900'
                }`}
                title="Commuter Trip & Dispatch Controller (Paras ➡️ Akola)"
              >
                <Bus className="w-3.5 h-3.5" />
                <span className="text-[10px]">कम्यूटर</span>
              </button>

              {currentScreen === 'home' && (
                <>
                  <button
                    type="button"
                    onClick={() => setShowFloatModal(true)}
                    className="flex items-center space-x-1 bg-cyan-900/80 text-cyan-200 border border-cyan-400/40 text-[9px] font-bold px-1.5 py-1 rounded-lg"
                    title="Water Float Test Freshness Guide"
                  >
                    <Info className="w-3 h-3 text-cyan-300" />
                  </button>
                  <button
                    type="button"
                    onClick={() => navigateTo('checkout')}
                    className="relative p-1.5 rounded-lg bg-amber-400 text-slate-950 font-bold"
                  >
                    <ShoppingBag className="w-3.5 h-3.5" />
                    {totalCartCount > 0 && (
                      <span className="absolute -top-1 -right-1 bg-red-600 text-white rounded-full w-4 h-4 flex items-center justify-center text-[9px] font-black">
                        {totalCartCount}
                      </span>
                    )}
                  </button>
                </>
              )}
            </div>
          </div>

          {/* MAIN SCREEN BODY SWITCHER */}
          <div className="flex-1 overflow-y-auto pb-16 scrollbar-none text-xs">
            
            {/* 1. CUSTOMER HOME FEED SCREEN */}
            {currentScreen === 'home' && (
              <div className="p-3.5 space-y-3.5">
                {/* Location Banner with GPS Distance */}
                <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-2.5 flex items-center justify-between">
                  <div className="flex items-center space-x-2">
                    <div className="w-7 h-7 rounded-lg bg-[#1B5E20] text-white flex items-center justify-center">
                      <MapPin className="w-4 h-4" />
                    </div>
                    <div>
                      <div className="font-bold text-[11px] text-[#1B5E20]">आपके नज़दीकी फार्म (Nearby Farms)</div>
                      <div className="text-[9px] text-slate-600">डिलीवरी दायरा: 2.8 km • 45 मिनट के भीतर डिलीवरी</div>
                    </div>
                  </div>
                  <span className="text-[9px] bg-emerald-100 text-emerald-800 font-bold px-1.5 py-0.5 rounded">
                    GPS Locked
                  </span>
                </div>

                {/* ZERO-COST IN-APP DELIVERY OTP & CUSTODY TRACKER (Buyer Screen) */}
                <div className={`rounded-2xl p-3.5 border shadow-xs transition-all space-y-2.5 ${
                  sharedParcel.status === 'delivered'
                    ? 'bg-emerald-50/70 border-emerald-400 ring-1 ring-emerald-300'
                    : sharedParcel.status === 'dropped_at_hub'
                    ? 'bg-purple-50/70 border-purple-400 ring-1 ring-purple-300'
                    : 'bg-white border-slate-200'
                }`}>
                  {/* Order & Custody Header */}
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="flex items-center space-x-1.5">
                        <span className="text-xs font-black text-slate-900">{sharedParcel.orderId}</span>
                        <span className="text-[9px] bg-slate-100 text-slate-700 px-1.5 py-0.5 rounded font-mono font-bold">
                          ₹{sharedParcel.price}
                        </span>
                      </div>
                      <div className="text-[10px] text-slate-600 mt-0.5 font-medium">
                        {sharedParcel.eggSummary}
                      </div>
                    </div>

                    {/* Active Custody Badge */}
                    <span className={`text-[9px] font-black px-2 py-0.5 rounded-full border flex items-center space-x-1 ${
                      sharedParcel.custody === 'buyer'
                        ? 'bg-emerald-100 text-emerald-900 border-emerald-400'
                        : sharedParcel.custody === 'hub_shop'
                        ? 'bg-purple-100 text-purple-900 border-purple-400'
                        : sharedParcel.custody === 'commuter'
                        ? 'bg-blue-100 text-blue-900 border-blue-400'
                        : 'bg-amber-100 text-amber-900 border-amber-400'
                    }`}>
                      <span>
                        {sharedParcel.custody === 'buyer' && '✓ आपके पास (Delivered)'}
                        {sharedParcel.custody === 'hub_shop' && '🏢 सिटी हब दुकान (Hub Custody)'}
                        {sharedParcel.custody === 'commuter' && '🚚 कम्यूटर के पास (In Transit)'}
                        {sharedParcel.custody === 'farmer' && '🧑‍🌾 फार्म पर (Packing)'}
                      </span>
                    </span>
                  </div>

                  {/* Dynamically Updated Pickup Location */}
                  <div className={`p-2 rounded-xl text-[10px] border flex items-start space-x-1.5 ${
                    sharedParcel.status === 'dropped_at_hub'
                      ? 'bg-purple-100/60 border-purple-300 text-purple-950 font-medium'
                      : 'bg-slate-50 border-slate-200 text-slate-700'
                  }`}>
                    <MapPin className={`w-3.5 h-3.5 shrink-0 mt-0.5 ${
                      sharedParcel.status === 'dropped_at_hub' ? 'text-purple-700' : 'text-emerald-700'
                    }`} />
                    <div className="leading-tight">
                      <strong className="block font-bold">
                        {sharedParcel.status === 'dropped_at_hub' ? 'अद्यतित पिकअप स्थान (Hub Shop Dropped):' : 'डिलीवरी स्थान:'}
                      </strong>
                      <span>{sharedParcel.destinationAddress}</span>
                      {sharedParcel.status === 'dropped_at_hub' && (
                        <span className="block text-[9px] text-purple-800 font-bold mt-0.5">
                          +₹5 हब केयर व कूलिंग शुल्क देय (खरीदार दुकान पर चुकाएं)
                        </span>
                      )}
                    </div>
                  </div>

                  {/* ZERO-COST IN-APP HANDSHAKE OTP CARD */}
                  <div className={`rounded-xl p-3 border transition-all ${
                    sharedParcel.isOtpUnlocked
                      ? 'bg-emerald-950 text-white border-emerald-500 shadow-md'
                      : 'bg-slate-900 text-white border-slate-700 shadow-xs'
                  }`}>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-1.5">
                        {sharedParcel.isOtpUnlocked ? (
                          <Unlock className="w-4 h-4 text-emerald-400" />
                        ) : (
                          <Lock className="w-4 h-4 text-amber-400" />
                        )}
                        <span className="text-[11px] font-bold">
                          {sharedParcel.isOtpUnlocked
                            ? 'शून्य-लागत इन-ऐप हैंडशेक OTP'
                            : 'हैंडशेक OTP सुरक्षित रूप से लॉक है'}
                        </span>
                      </div>

                      {sharedParcel.isOtpUnlocked ? (
                        <span className="text-[9px] font-black bg-emerald-500/20 text-emerald-300 border border-emerald-400/40 px-1.5 py-0.5 rounded">
                          ✓ UPI Confirmed
                        </span>
                      ) : (
                        <span className="text-[9px] font-bold bg-amber-500/20 text-amber-300 border border-amber-400/40 px-1.5 py-0.5 rounded">
                          🔒 Locked
                        </span>
                      )}
                    </div>

                    {/* Unlocked OTP Display or Locked Notice */}
                    {sharedParcel.isOtpUnlocked ? (
                      <div className="pt-2 text-center space-y-1">
                        <div className="text-[9.5px] text-emerald-200">
                          कम्यूटर या हब संचालक को यह 4-अंकीय कोड दिखाएं:
                        </div>
                        <div className="inline-flex items-center space-x-2 bg-emerald-900/90 border border-emerald-400/60 px-4 py-1.5 rounded-xl shadow-inner">
                          <span className="text-xl font-mono font-black tracking-widest text-emerald-300">
                            {sharedParcel.pickupCode}
                          </span>
                          <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                        </div>
                        <p className="text-[8.5px] text-emerald-300/80">
                          {sharedParcel.status === 'dropped_at_hub'
                            ? 'श्रीनाथ डेयरी संचालक को OTP बताएं व ₹5 दुकान शुल्क दें'
                            : 'अकोला बस स्टैंड पर कम्यूटर को 2-मिनट में यह कोड दें'}
                        </p>
                      </div>
                    ) : (
                      <div className="pt-2 space-y-2">
                        <p className="text-[10px] text-slate-300 leading-tight">
                          सुरक्षा गेट: किसान के सीधे UPI खाते में भुगतान पुष्टि होने पर ही OTP स्वतः प्रदर्शित होगा। कोई SMS गेटवे खर्च नहीं (Zero Cost In-App).
                        </p>
                        <button
                          type="button"
                          onClick={handleSimulatePaymentConfirmed}
                          className="w-full py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-[10px] flex items-center justify-center space-x-1 shadow-sm transition-all"
                        >
                          <Unlock className="w-3 h-3 text-amber-300" />
                          <span>⚡ Simulate Payment Confirmed (OTP अनलॉक करें)</span>
                        </button>
                      </div>
                    )}
                  </div>
                </div>

                {/* Commuter Route Direct Dispatch Banner */}
                <div 
                  onClick={() => navigateTo('commuter-trip')}
                  className="bg-gradient-to-r from-blue-900 to-indigo-950 text-white p-2.5 rounded-xl border border-blue-700/60 flex items-center justify-between cursor-pointer hover:brightness-105 transition-all shadow-xs"
                >
                  <div className="flex items-center space-x-2.5">
                    <div className="w-8 h-8 rounded-lg bg-amber-400 text-slate-950 flex items-center justify-center font-bold">
                      <Bus className="w-4.5 h-4.5" />
                    </div>
                    <div>
                      <div className="text-[11px] font-bold flex items-center space-x-1.5">
                        <span>दैनिक कम्यूटर रूट (Paras ➡️ Akola)</span>
                        <span className="text-[9px] bg-amber-400 text-slate-950 px-1 rounded font-black">₹25-₹30 Fee</span>
                      </div>
                      <div className="text-[9px] text-blue-200">
                        {commuterTripStarted ? '🟢 कम्यूटर ऑन-रूट है' : '🕒 10:30 AM प्रस्थान'} • लाउड अलर्ट व 2-मिनट हैंडशेक कंट्रोलर
                      </div>
                    </div>
                  </div>
                  <ChevronRight className="w-4 h-4 text-amber-300 shrink-0" />
                </div>

                {/* Freshness Water Float Guarantee Card */}
                <div 
                  onClick={() => setShowFloatModal(true)}
                  className="bg-gradient-to-r from-cyan-900 to-sky-950 text-white p-3 rounded-2xl cursor-pointer shadow-sm hover:brightness-105 transition-all flex items-center justify-between"
                >
                  <div className="flex items-center space-x-2.5">
                    <div className="w-9 h-9 rounded-xl bg-cyan-400/20 border border-cyan-400/40 flex items-center justify-center text-lg">
                      💧
                    </div>
                    <div>
                      <div className="font-bold text-xs flex items-center space-x-1">
                        <span>100% वाटर फ्लोट टेस्ट गारंटी</span>
                        <Sparkles className="w-3 h-3 text-cyan-300" />
                      </div>
                      <div className="text-[9.5px] text-cyan-200">
                        अंडा तैरने पर तुरंत 100% रिफंड • गाइड देखने के लिए टैप करें
                      </div>
                    </div>
                  </div>
                  <ChevronRight className="w-4 h-4 text-cyan-300 shrink-0" />
                </div>

                {/* Feed Header */}
                <div className="flex items-center justify-between pt-1">
                  <span className="font-bold text-slate-800 text-xs uppercase tracking-wider">
                    ताज़ा कलेक्शन लॉट (Fresh Batches)
                  </span>
                  <span className="text-[10px] text-slate-500 font-mono">
                    {productsList.length} Farms Online
                  </span>
                </div>

                {/* Product Batches List */}
                <div className="space-y-3">
                  {productsList.map((prod) => {
                    const qtyInCart = cart[prod.product_id] || 0;
                    return (
                      <div 
                        key={prod.product_id}
                        className="bg-white rounded-2xl border border-slate-200 p-3 shadow-xs hover:border-emerald-300 transition-all space-y-2.5"
                      >
                        <div className="flex space-x-3">
                          {/* Photo with Verified Badge */}
                          <div className="relative w-20 h-20 rounded-xl overflow-hidden shrink-0 bg-slate-100">
                            <img 
                              src={prod.photo_url} 
                              alt={prod.egg_type} 
                              className="w-full h-full object-cover"
                            />
                            <span className="absolute bottom-1 left-1 bg-black/75 text-[8px] font-mono text-amber-300 px-1 rounded">
                              {prod.unique_batch_code.split('-')[2] || '#EGG'}
                            </span>
                          </div>

                          {/* Details */}
                          <div className="flex-1 space-y-1">
                            <div className="flex items-start justify-between">
                              <h4 className="font-bold text-xs text-slate-900 leading-tight">
                                {prod.egg_type !== 'none' ? `${prod.egg_type.toUpperCase()} Eggs` : 'Fresh Chicken'}
                              </h4>
                              <span className="font-black text-xs text-[#1B5E20]">
                                ₹{prod.price}
                              </span>
                            </div>

                            <p className="text-[10px] text-slate-500 font-medium truncate">
                              {prod.farm_name}
                            </p>

                            <div className="flex items-center space-x-2 text-[9px] text-slate-600">
                              <span className="flex items-center text-emerald-800 font-bold bg-emerald-50 px-1.5 py-0.5 rounded">
                                <ShieldCheck className="w-2.5 h-2.5 mr-0.5 text-emerald-600" />
                                Verified Fresh
                              </span>
                              <span className="flex items-center">
                                <MapPin className="w-2.5 h-2.5 mr-0.5 text-cyan-600" />
                                1.4 km दूर
                              </span>
                            </div>

                            {/* Lay Date Badge */}
                            <div className="text-[9px] text-slate-500 flex items-center space-x-1 pt-0.5">
                              <Calendar className="w-2.5 h-2.5 text-amber-600" />
                              <span>Lay Date: <strong className="text-slate-800">{new Date(prod.lay_date).toLocaleDateString()} (24h Fresh)</strong></span>
                            </div>
                          </div>
                        </div>

                        {/* Add to Cart Footer */}
                        <div className="flex items-center justify-between pt-1 border-t border-slate-100">
                          <span className="text-[10px] text-slate-500 font-mono">
                            स्टॉक: <strong>{prod.stock} ट्रे उपलब्ध</strong>
                          </span>

                          {qtyInCart > 0 ? (
                            <div className="flex items-center space-x-2 bg-emerald-50 border border-emerald-300 px-2 py-0.5 rounded-lg">
                              <button 
                                onClick={() => updateCartQty(prod.product_id, -1)}
                                className="w-5 h-5 rounded bg-white text-slate-800 flex items-center justify-center font-bold text-xs shadow-xs"
                              >
                                -
                              </button>
                              <span className="font-bold text-xs text-emerald-950 font-mono">{qtyInCart}</span>
                              <button 
                                onClick={() => updateCartQty(prod.product_id, 1)}
                                className="w-5 h-5 rounded bg-white text-slate-800 flex items-center justify-center font-bold text-xs shadow-xs"
                              >
                                +
                              </button>
                            </div>
                          ) : (
                            <button
                              onClick={() => updateCartQty(prod.product_id, 1)}
                              className="bg-[#1B5E20] hover:bg-[#2E7D32] text-white px-3 py-1 rounded-lg font-bold text-[10px] flex items-center space-x-1"
                            >
                              <Plus className="w-3 h-3" />
                              <span>कार्ट में जोड़ें</span>
                            </button>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>

                {/* Floating Bottom Checkout Banner */}
                {totalCartCount > 0 && (
                  <div className="pt-2">
                    <button
                      onClick={() => navigateTo('checkout')}
                      className="w-full bg-[#1B5E20] text-white p-3 rounded-xl font-bold flex items-center justify-between shadow-lg shadow-[#1B5E20]/20"
                    >
                      <div className="flex items-center space-x-2">
                        <span className="bg-amber-400 text-slate-950 px-2 py-0.5 rounded-lg text-xs font-black">
                          {totalCartCount} Items
                        </span>
                        <span className="text-xs">चेकआउट की ओर बढ़ें</span>
                      </div>
                      <span className="font-mono text-sm">₹{grandTotal} →</span>
                    </button>
                  </div>
                )}
              </div>
            )}

            {/* 2. DYNAMIC CHECKOUT SCREEN */}
            {currentScreen === 'checkout' && (
              <div className="p-3.5 space-y-3.5">
                {/* Fulfillment Mode Toggle (Self-Pickup vs Courier) */}
                <div className="space-y-1">
                  <label className="text-[11px] font-bold text-slate-700">1. डिलीवरी मोड चुनें (Fulfillment Mode):</label>
                  <div className="grid grid-cols-2 gap-2">
                    <button
                      type="button"
                      onClick={() => setOrderType('Courier')}
                      className={`p-2.5 rounded-xl border text-center transition-all flex items-center justify-center space-x-1.5 ${
                        orderType === 'Courier'
                          ? 'bg-white border-[#1B5E20] text-[#1B5E20] font-bold ring-1.5 ring-[#1B5E20] shadow-xs'
                          : 'bg-slate-100 border-slate-200 text-slate-600'
                      }`}
                    >
                      <Truck className="w-4 h-4" />
                      <div className="text-left">
                        <div className="text-xs">कूरियर डिलीवरी</div>
                        <div className="text-[9px] text-slate-500 font-normal">+₹40 (Cold-Chain)</div>
                      </div>
                    </button>

                    <button
                      type="button"
                      onClick={() => setOrderType('Pickup')}
                      className={`p-2.5 rounded-xl border text-center transition-all flex items-center justify-center space-x-1.5 ${
                        orderType === 'Pickup'
                          ? 'bg-white border-[#1B5E20] text-[#1B5E20] font-bold ring-1.5 ring-[#1B5E20] shadow-xs'
                          : 'bg-slate-100 border-slate-200 text-slate-600'
                      }`}
                    >
                      <Store className="w-4 h-4" />
                      <div className="text-left">
                        <div className="text-xs">फार्म से पिकअप</div>
                        <div className="text-[9px] text-emerald-600 font-normal">निःशुल्क (Free)</div>
                      </div>
                    </button>
                  </div>
                </div>

                {/* Items in Cart Review */}
                <div className="bg-white rounded-xl border border-slate-200 p-3 space-y-2">
                  <div className="flex items-center justify-between pb-1 border-b border-slate-100 font-bold text-[11px] text-slate-700">
                    <span>चुने गए अंडे / चिकन</span>
                    <button 
                      onClick={() => navigateTo('home')}
                      className="text-[10px] text-[#1B5E20] hover:underline"
                    >
                      + और जोड़ें
                    </button>
                  </div>

                  {Object.entries(cart).map(([prodId, qty]) => {
                    const prod = MOCK_PRODUCTS.find((p) => p.product_id === prodId);
                    if (!prod) return null;
                    return (
                      <div key={prodId} className="flex items-center justify-between text-xs py-1">
                        <div>
                          <div className="font-semibold text-slate-800">{prod.egg_type.toUpperCase()} Eggs</div>
                          <div className="text-[10px] text-slate-400">₹{prod.price} × {qty}</div>
                        </div>
                        <div className="font-mono font-bold text-slate-900">₹{prod.price * qty}</div>
                      </div>
                    );
                  })}
                </div>

                {/* DYNAMIC PRICE BREAKDOWN (Firebase app_settings Slabs) */}
                <div className="bg-white rounded-xl border border-slate-200 p-3 space-y-2 shadow-xs">
                  <div className="font-bold text-[11px] text-slate-800 flex items-center justify-between pb-1 border-b border-slate-100">
                    <span>पारदर्शी मूल्य विवरण (Dynamic Slabs)</span>
                    <span className="text-[9px] text-amber-700 bg-amber-50 px-1.5 py-0.5 rounded font-mono font-bold">
                      Firebase Settings
                    </span>
                  </div>

                  <div className="space-y-1.5 text-slate-600 text-xs">
                    <div className="flex justify-between">
                      <span>उत्पाद कुल (Item Total):</span>
                      <span className="font-mono font-bold text-slate-900">₹{itemTotal}</span>
                    </div>

                    {/* Platform Support Fee from Admin Slabs */}
                    <div className="flex justify-between text-[#1B5E20] bg-emerald-50/80 p-1.5 rounded-lg border border-emerald-200/60 font-semibold">
                      <div className="flex items-center space-x-1">
                        <span>प्लेटफ़ॉर्म सपोर्ट शुल्क (Support Fee):</span>
                        <Info className="w-3 h-3 text-emerald-700" />
                      </div>
                      <span className="font-mono font-bold">+₹{platformFee}</span>
                    </div>

                    <div className="flex justify-between">
                      <span>डिलीवरी शुल्क ({orderType}):</span>
                      <span className="font-mono">{courierCharge === 0 ? 'मुफ़्त (Free)' : `+₹${courierCharge}`}</span>
                    </div>

                    <div className="pt-2 border-t border-slate-200 flex justify-between items-baseline font-bold">
                      <span className="text-slate-900 text-sm">कुल भुगतान (Grand Total):</span>
                      <span className="text-base text-[#1B5E20] font-mono font-black">₹{grandTotal}</span>
                    </div>
                  </div>
                </div>

                {/* Payment Tender Selector */}
                <div className="space-y-1">
                  <label className="text-[11px] font-bold text-slate-700">2. भुगतान विधि (Payment Mode):</label>
                  <div className="grid grid-cols-2 gap-2">
                    <button
                      type="button"
                      onClick={() => setPaymentMode('upi')}
                      className={`p-2 rounded-xl border text-center font-bold text-xs transition-all ${
                        paymentMode === 'upi' ? 'bg-emerald-50 border-[#1B5E20] text-[#1B5E20] ring-1 ring-[#1B5E20]' : 'bg-white border-slate-200'
                      }`}
                    >
                      UPI / QR Code
                    </button>
                    <button
                      type="button"
                      onClick={() => setPaymentMode('cod')}
                      className={`p-2 rounded-xl border text-center font-bold text-xs transition-all ${
                        paymentMode === 'cod' ? 'bg-emerald-50 border-[#1B5E20] text-[#1B5E20] ring-1 ring-[#1B5E20]' : 'bg-white border-slate-200'
                      }`}
                    >
                      Cash on Delivery
                    </button>
                  </div>
                </div>

                {/* Commit Order Button */}
                <button
                  type="button"
                  onClick={() => {
                    setOrderPlacedSuccess(true);
                    setTimeout(() => setOrderPlacedSuccess(false), 3000);
                  }}
                  className="w-full py-3.5 rounded-xl bg-[#1B5E20] hover:bg-[#2E7D32] text-white font-black text-xs shadow-md transition-all flex items-center justify-center space-x-2"
                >
                  <Lock className="w-3.5 h-3.5" />
                  <span>ऑर्डर कन्फर्म करें (Pay ₹{grandTotal})</span>
                </button>
              </div>
            )}

            {/* 3. STRICT DISPUTE SCREEN (MANDATORY FLOAT TEST PROOF) */}
            {currentScreen === 'dispute' && (
              <div className="p-3.5 space-y-3.5">
                {/* Dispute Policy Card */}
                <div className="bg-red-50 border border-red-200 rounded-xl p-3 space-y-1 text-xs">
                  <div className="flex items-center space-x-2 font-bold text-red-800">
                    <AlertTriangle className="w-4 h-4 text-red-600 shrink-0" />
                    <span>कड़ा फ्लोट-टेस्ट नियम (Strict Float-Test Policy)</span>
                  </div>
                  <p className="text-[11px] text-red-700 leading-tight">
                    खराब या बासी अंडे का रिफंड पाने के लिए खरीदार को पानी की कटोरी में तैरते हुए अंडे की <strong>लाइव कैमरा फोटो</strong> अपलोड करना अनिवार्य है।
                  </p>
                </div>

                {/* Target Order Selection */}
                <div className="space-y-1">
                  <label className="text-[11px] font-bold text-slate-700">1. संबंधित डिलीवर ऑर्डर (Order ID):</label>
                  <select 
                    value={disputeOrderId}
                    onChange={(e) => setDisputeOrderId(e.target.value)}
                    className="w-full bg-white border border-slate-300 rounded-xl p-2 font-mono text-xs font-bold"
                  >
                    <option value="ord_sample_901">ord_sample_901 — Chhabra Organic Farms (₹362)</option>
                    <option value="ord_sample_902">ord_sample_902 — Punjab Pure Desi Fowls (₹963)</option>
                  </select>
                </div>

                {/* Complaint Reason */}
                <div className="space-y-1">
                  <label className="text-[11px] font-bold text-slate-700">2. शिकायत का विवरण (Reason):</label>
                  <textarea
                    rows={2}
                    value={disputeReason}
                    onChange={(e) => setDisputeReason(e.target.value)}
                    className="w-full bg-white border border-slate-300 rounded-xl p-2 text-xs focus:outline-none focus:border-red-500"
                  />
                </div>

                {/* MANDATORY LIVE WATER FLOAT TEST CAMERA */}
                <div className="space-y-1">
                  <div className="flex items-center justify-between">
                    <label className="text-[11px] font-bold text-slate-800 flex items-center space-x-1">
                      <Camera className="w-3.5 h-3.5 text-red-600" />
                      <span>3. फ्लोट-टेस्ट लाइव फोटो (Egg in Water Bowl):</span>
                    </label>
                    <span className="text-[9px] font-bold text-red-600 bg-red-100 px-1 rounded">
                      Mandatory Live Shutter
                    </span>
                  </div>

                  {/* Camera Frame Preview */}
                  <div className="relative w-full h-44 bg-black rounded-2xl overflow-hidden border-2 border-red-500 shadow-sm flex items-center justify-center">
                    {isDisputeCapturing ? (
                      <div className="flex flex-col items-center justify-center text-white space-y-1.5">
                        <RefreshCw className="w-6 h-6 text-amber-400 animate-spin" />
                        <span className="text-[10px] font-mono text-cyan-300">Locking Water Surface GPS & Time...</span>
                      </div>
                    ) : hasDisputeProof ? (
                      <>
                        <img 
                          src="https://images.unsplash.com/photo-1587486913049-53fc88980cfc?auto=format&fit=crop&w=600&q=80" 
                          alt="Egg floating in water bowl" 
                          className="w-full h-full object-cover"
                        />
                        <div className="absolute top-2 left-2 bg-red-600 text-white font-black text-[9px] px-2 py-0.5 rounded shadow">
                          EGG FLOATING DETECTED
                        </div>

                        <button
                          type="button"
                          onClick={handleDisputeShutter}
                          className="absolute top-2 right-2 bg-black/75 hover:bg-black text-white text-[9px] font-bold px-2 py-1 rounded border border-white/30 flex items-center space-x-1"
                        >
                          <Camera className="w-3 h-3 text-red-300" />
                          <span>Retake Proof</span>
                        </button>

                        <div className="absolute bottom-0 inset-x-0 bg-black/85 p-2 text-[9px] font-mono text-cyan-300 space-y-0.5">
                          <div>PROOF: Water Bowl Float Test • Air Sac Depleted</div>
                          <div className="text-amber-300">ORDER: {disputeOrderId} • Timestamp Synced</div>
                        </div>
                      </>
                    ) : (
                      <div className="flex flex-col items-center space-y-2 text-white">
                        <Camera className="w-8 h-8 text-white/80" />
                        <button
                          type="button"
                          onClick={handleDisputeShutter}
                          className="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-xl font-bold text-xs"
                        >
                          ओपन कैमरा (फोटो खींचें)
                        </button>
                      </div>
                    )}
                  </div>
                </div>

                {/* Submit Dispute Button */}
                <button
                  type="button"
                  disabled={!hasDisputeProof}
                  onClick={() => {
                    setDisputeSubmitted(true);
                    setTimeout(() => setDisputeSubmitted(false), 3500);
                  }}
                  className="w-full py-3 rounded-xl bg-red-600 hover:bg-red-700 text-white font-black text-xs shadow-md transition-all flex items-center justify-center space-x-1.5 disabled:opacity-50"
                >
                  <ShieldCheck className="w-3.5 h-3.5" />
                  <span>रिफंड हेतु क्लेम सबमिट करें (Submit Claim)</span>
                </button>
              </div>
            )}

            {/* 4. FARMER LISTING & DISPATCH SCREEN (lib/screens/add_listing_screen.dart) */}
            {currentScreen === 'seller-upload' && (
              <div className="p-3.5 space-y-3.5 animate-fadeIn">
                {/* Batch Header Bar */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3 shadow-xs flex items-center justify-between">
                  <div>
                    <div className="text-[10px] text-slate-400 uppercase font-bold tracking-wider">
                      दैनिक बैच आईडी (Daily Unique Batch)
                    </div>
                    <div className="text-sm font-black text-[#1B5E20] font-mono flex items-center space-x-1.5">
                      <span>{listingBatchCode}</span>
                      <span className="text-[9px] bg-emerald-50 text-emerald-700 font-bold px-1.5 py-0.2 rounded border border-emerald-200">
                        Active
                      </span>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className="text-[9px] font-mono text-amber-700 bg-amber-50 px-2 py-0.5 rounded border border-amber-200 font-bold">
                      Ref: {listingOrderRef}
                    </span>
                    <div className="text-[9px] text-slate-400 mt-0.5">Prepaid: ₹{sellerPrepaidWallet}</div>
                  </div>
                </div>
                {/* 4-PARTY REAL-TIME INCOMING ORDER & DIRECT UPI CONFIRMATION */}
                <div className={`p-3 rounded-2xl border shadow-xs space-y-2 transition-all ${
                  sharedParcel.paymentStatus === 'confirmed_to_farmer_upi'
                    ? 'bg-emerald-50/70 border-emerald-400 ring-1 ring-emerald-300'
                    : 'bg-amber-50/70 border-amber-400 ring-1 ring-amber-300'
                }`}>
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="flex items-center space-x-1.5">
                        <span className="text-[10px] font-bold text-slate-500 uppercase tracking-wider">
                          लाइव ऑर्डर (Incoming Order)
                        </span>
                        <span className="font-mono font-bold text-xs text-slate-900">{sharedParcel.orderId}</span>
                      </div>
                      <div className="text-[11px] font-bold text-slate-800 mt-0.5">
                        {sharedParcel.buyerName} • ₹{sharedParcel.price}
                      </div>
                      <div className="text-[9.5px] text-slate-500">{sharedParcel.eggSummary}</div>
                    </div>

                    <span className={`text-[9px] font-black px-2 py-0.5 rounded-full border ${
                      sharedParcel.paymentStatus === 'confirmed_to_farmer_upi'
                        ? 'bg-emerald-100 text-emerald-900 border-emerald-400'
                        : 'bg-amber-100 text-amber-900 border-amber-400'
                    }`}>
                      {sharedParcel.paymentStatus === 'confirmed_to_farmer_upi'
                        ? '✓ UPI Received'
                        : '● UPI Pending'}
                    </span>
                  </div>

                  {/* Payment Confirmation Action */}
                  {sharedParcel.paymentStatus === 'unpaid' ? (
                    <div className="pt-1 space-y-1.5">
                      <p className="text-[10px] text-amber-900 leading-tight">
                        खरीदार राहुल शर्मा से ₹360 का सीधा UPI भुगतान प्राप्त होने पर नीचे बटन दबाएं ताकि खरीदार का 4-अंकीय हैंडशेक OTP अनलॉक हो सके:
                      </p>
                      <button
                        type="button"
                        onClick={handleSimulatePaymentConfirmed}
                        className="w-full py-2 bg-[#1B5E20] hover:bg-emerald-900 text-white rounded-xl font-bold text-[11px] flex items-center justify-center space-x-1.5 shadow-sm transition-all"
                      >
                        <Check className="w-3.5 h-3.5 text-amber-300" />
                        <span>✓ ₹360 प्राप्त हुए (Confirm UPI & Unlock Buyer OTP)</span>
                      </button>
                    </div>
                  ) : (
                    <div className="pt-1 flex items-center justify-between text-[10px] bg-emerald-100/70 p-2 rounded-xl border border-emerald-300 text-emerald-950 font-bold">
                      <div className="flex items-center space-x-1.5">
                        <CheckCircle2 className="w-4 h-4 text-emerald-700" />
                        <span>₹360 सीधे UPI में प्राप्त • खरीदार OTP (4821) सक्रिय</span>
                      </div>
                      <span className="text-[9px] bg-emerald-900 text-white px-2 py-0.5 rounded font-mono">
                        Custody: {sharedParcel.custody.toUpperCase()}
                      </span>
                    </div>
                  )}

                  {/* Wallet Platform Fee Link */}
                  <div className="flex items-center justify-between pt-1 border-t border-slate-200/60 text-[10px]">
                    <span className="text-slate-600">प्रीपेड वॉलेट बैलेंस:</span>
                    <button
                      type="button"
                      onClick={() => navigateTo('seller-wallet')}
                      className="text-emerald-800 font-bold hover:underline flex items-center space-x-1"
                    >
                      <Wallet className="w-3 h-3" />
                      <span>₹{sellerPrepaidWallet.toFixed(2)} (माइक्रो-टियर अनुसार कटौती)</span>
                    </button>
                  </div>
                </div>

                {/* DUAL CATEGORY SWITCHER (EGGS VS LIVE POULTRY) */}
                <div className="bg-white border border-slate-200 rounded-2xl p-1.5 shadow-xs">
                  <div className="grid grid-cols-2 gap-1.5">
                    <button
                      type="button"
                      onClick={() => setListingCategory('fresh_eggs')}
                      className={`py-2 px-3 rounded-xl font-bold text-xs flex items-center justify-center space-x-2 transition-all ${
                        listingCategory === 'fresh_eggs'
                          ? 'bg-[#1B5E20] text-white shadow-sm ring-1 ring-[#1B5E20]'
                          : 'bg-slate-50 text-slate-700 hover:bg-slate-100'
                      }`}
                    >
                      <span className="text-sm">🥚</span>
                      <span>ताज़ा अंडे (Fresh Eggs)</span>
                    </button>
                    <button
                      type="button"
                      onClick={() => setListingCategory('live_poultry')}
                      className={`py-2 px-3 rounded-xl font-bold text-xs flex items-center justify-center space-x-2 transition-all ${
                        listingCategory === 'live_poultry'
                          ? 'bg-[#B91C1C] text-white shadow-sm ring-1 ring-[#B91C1C]'
                          : 'bg-slate-50 text-slate-700 hover:bg-slate-100'
                      }`}
                    >
                      <span className="text-sm">🐔</span>
                      <span>लाइव पोल्ट्री (Live Poultry)</span>
                    </button>
                  </div>
                </div>

                {/* 1. CAMERA CAPTURE WITH PROOF WATERMARK & SCALE PHOTO */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3 shadow-xs space-y-2">
                  <div className="flex items-center justify-between">
                    <label className="text-[11px] font-bold text-slate-800 flex items-center space-x-1.5">
                      <Camera className="w-3.5 h-3.5 text-emerald-700" />
                      <span>
                        {listingCategory === 'fresh_eggs'
                          ? '1. ताज़गी प्रमाण फोटो (Live Shutter & Watermark)'
                          : '1. लाइव पोल्ट्री व तराजू फोटो वाटरमार्क (Certified Scale Proof)'}
                      </span>
                    </label>
                    <span className="text-[9px] bg-red-100 text-red-700 font-bold px-1.5 py-0.2 rounded">
                      Live Shutter Only
                    </span>
                  </div>

                  {/* Camera Frame Preview with Overlay */}
                  <div className="relative w-full h-44 bg-slate-950 rounded-2xl overflow-hidden border border-slate-300 shadow-inner flex items-center justify-center">
                    {isListingCapturing || isScaleCapturing ? (
                      <div className="flex flex-col items-center justify-center text-white space-y-2">
                        <RefreshCw className="w-7 h-7 text-amber-400 animate-spin" />
                        <span className="text-[10px] font-mono text-cyan-300">
                          {isScaleCapturing ? 'Locking Digital Scale Proof...' : 'Locking Paras GPS & Stamping Time...'}
                        </span>
                        <span className="text-[9px] text-slate-400">Uploading to Cloudinary unsigned preset...</span>
                      </div>
                    ) : hasListingPhoto ? (
                      <>
                        <img 
                          src={listingCategory === 'fresh_eggs' ? listingCloudinaryUrl : 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=800&q=80'} 
                          alt="Batch Proof" 
                          className="w-full h-full object-cover"
                        />
                        <div className={`absolute top-2 left-2 text-white font-black text-[9px] px-2 py-0.5 rounded shadow flex items-center space-x-1 ${listingCategory === 'fresh_eggs' ? 'bg-[#1B5E20]' : 'bg-[#B91C1C]'}`}>
                          <Check className="w-2.5 h-2.5" />
                          <span>{listingCategory === 'fresh_eggs' ? `PROVEN FRESH • ${listingBatchCode}` : `LIVE CERTIFIED • ${listingBatchCode}`}</span>
                        </div>

                        {listingCategory === 'live_poultry' && (
                          <div className="absolute top-2 right-2 bg-amber-500 text-slate-950 text-[9px] font-black px-2 py-0.5 rounded flex items-center space-x-1 shadow">
                            <Scale className="w-2.5 h-2.5" />
                            <span>SCALE OK • {listingBirdWeight} kg/bird</span>
                          </div>
                        )}

                        {/* Stamped Watermark Bar on Image */}
                        <div className="absolute bottom-0 inset-x-0 bg-slate-950/90 p-2 text-[9px] font-mono text-slate-200 border-t border-slate-800 space-y-0.5">
                          <div className="flex justify-between items-center text-cyan-300">
                            <span>AndaExpress • {listingOrderRef}</span>
                            <span className="text-amber-300 font-bold">200 OK Cloudinary</span>
                          </div>
                          <div className="text-amber-200 font-semibold truncate">समय: {listingTimestamp}</div>
                          <div className="text-cyan-200 font-semibold truncate">स्थान: {listingGpsTag}</div>
                          {listingCategory === 'live_poultry' && (
                            <div className="text-emerald-300 font-semibold truncate">लेग-सील: {listingLegSealNumber} (एंटी-टैम्पर)</div>
                          )}
                        </div>
                      </>
                    ) : (
                      <div className="flex flex-col items-center space-y-2 text-white p-4 text-center">
                        <Camera className="w-8 h-8 text-slate-400" />
                        <p className="text-[11px] text-slate-300">
                          {listingCategory === 'fresh_eggs' ? 'अंडों की ताज़गी साबित करने हेतु लाइव फोटो खींचें' : 'लाइव पक्षी व फार्म वातावरण की लाइव फोटो लें'}
                        </p>
                        <button
                          type="button"
                          onClick={handleListingCameraShutter}
                          className="bg-[#1B5E20] hover:bg-[#2E7D32] text-white px-3 py-1.5 rounded-xl font-bold text-xs"
                        >
                          ओपन कैमरा (फोटो खींचें)
                        </button>
                      </div>
                    )}
                  </div>

                  {/* Dual Camera Buttons */}
                  <div className="grid grid-cols-2 gap-2">
                    <button
                      type="button"
                      onClick={handleListingCameraShutter}
                      disabled={isListingCapturing}
                      className="py-2 bg-emerald-50 hover:bg-emerald-100 text-[#1B5E20] border border-emerald-300 rounded-xl font-bold text-[11px] flex items-center justify-center space-x-1.5 transition-all"
                    >
                      <Camera className="w-3.5 h-3.5" />
                      <span>{hasListingPhoto ? 'फोटो दोबारा लें' : 'लाइव फोटो लें'}</span>
                    </button>
                    {listingCategory === 'live_poultry' ? (
                      <button
                        type="button"
                        onClick={() => {
                          setIsScaleCapturing(true);
                          setTimeout(() => {
                            setIsScaleCapturing(false);
                            setScalePhotoVerified(true);
                          }, 800);
                        }}
                        disabled={isScaleCapturing}
                        className="py-2 bg-red-50 hover:bg-red-100 text-[#B91C1C] border border-red-300 rounded-xl font-bold text-[11px] flex items-center justify-center space-x-1.5 transition-all"
                      >
                        <Scale className="w-3.5 h-3.5" />
                        <span>{scalePhotoVerified ? 'तराजू फोटो OK ✓' : 'तराजू फोटो लें'}</span>
                      </button>
                    ) : (
                      <div className="bg-slate-50 border border-slate-200 rounded-xl p-1.5 flex items-center justify-center text-[10px] font-mono text-emerald-800 font-bold">
                        Cloudinary 200 OK
                      </div>
                    )}
                  </div>
                </div>

                {/* 2. BATCH DETAILS & DUAL CATEGORY INPUTS */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3 shadow-xs space-y-3">
                  <label className="text-[11px] font-bold text-slate-800 flex items-center space-x-1.5">
                    {listingCategory === 'fresh_eggs' ? (
                      <Egg className="w-3.5 h-3.5 text-amber-700" />
                    ) : (
                      <span className="text-sm">🐔</span>
                    )}
                    <span>
                      {listingCategory === 'fresh_eggs'
                        ? '2. अंडे बैच विवरण (Egg Variety, Trays & Price)'
                        : '2. लाइव पोल्ट्री विवरण (Poultry Breed & Weight)'}
                    </span>
                  </label>

                  {listingCategory === 'fresh_eggs' ? (
                    <>
                      {/* Variety Chips */}
                      <div className="space-y-1">
                        <span className="text-[10px] font-semibold text-slate-600">अंडे की किस्म (Variety):</span>
                        <div className="grid grid-cols-3 gap-1.5">
                          <button
                            type="button"
                            onClick={() => setListingVariety('desi')}
                            className={`p-2 rounded-xl text-center text-[10px] font-bold transition-all border ${
                              listingVariety === 'desi'
                                ? 'bg-[#1B5E20] text-white border-[#1B5E20] shadow-xs'
                                : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                            }`}
                          >
                            <div>देसी (Desi)</div>
                            <div className="text-[8px] opacity-80">फ्री-रेंज</div>
                          </button>

                          <button
                            type="button"
                            onClick={() => setListingVariety('kadaknath')}
                            className={`p-2 rounded-xl text-center text-[10px] font-bold transition-all border ${
                              listingVariety === 'kadaknath'
                                ? 'bg-[#1B5E20] text-white border-[#1B5E20] shadow-xs'
                                : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                            }`}
                          >
                            <div>कड़कनाथ</div>
                            <div className="text-[8px] opacity-80">ब्लैक हर्बल</div>
                          </button>

                          <button
                            type="button"
                            onClick={() => setListingVariety('broiler_table')}
                            className={`p-2 rounded-xl text-center text-[10px] font-bold transition-all border ${
                              listingVariety === 'broiler_table'
                                ? 'bg-[#1B5E20] text-white border-[#1B5E20] shadow-xs'
                                : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                            }`}
                          >
                            <div>ब्रोइलर</div>
                            <div className="text-[8px] opacity-80">टेबल अंडे</div>
                          </button>
                        </div>
                      </div>

                      {/* Trays & Price */}
                      <div className="grid grid-cols-2 gap-2.5 pt-1">
                        <div className="space-y-1">
                          <span className="text-[10px] font-semibold text-slate-600">उपलब्ध ट्रे (Trays):</span>
                          <div className="flex items-center justify-between border border-slate-200 rounded-xl p-1 bg-slate-50">
                            <button
                              type="button"
                              onClick={() => setListingTrays(Math.max(5, listingTrays - 5))}
                              className="w-7 h-7 rounded-lg bg-white border border-slate-300 flex items-center justify-center font-bold text-slate-700 hover:bg-slate-100"
                            >
                              <Minus className="w-3 h-3" />
                            </button>
                            <span className="font-bold text-xs font-mono text-slate-900">{listingTrays}</span>
                            <button
                              type="button"
                              onClick={() => setListingTrays(listingTrays + 5)}
                              className="w-7 h-7 rounded-lg bg-white border border-slate-300 flex items-center justify-center font-bold text-slate-700 hover:bg-slate-100"
                            >
                              <Plus className="w-3 h-3" />
                            </button>
                          </div>
                          <div className="text-[9px] text-slate-500 text-center font-mono">
                            = {listingTrays * 30} कुल अंडे
                          </div>
                        </div>

                        <div className="space-y-1">
                          <span className="text-[10px] font-semibold text-slate-600">मूल्य प्रति ट्रे (₹):</span>
                          <div className="relative">
                            <span className="absolute left-2.5 top-2 text-xs font-bold text-slate-400">₹</span>
                            <input
                              type="number"
                              value={listingPricePerTray}
                              onChange={(e) => setListingPricePerTray(Number(e.target.value) || 0)}
                              className="w-full bg-slate-50 border border-slate-200 rounded-xl py-1.5 pl-6 pr-2 text-xs font-bold font-mono text-slate-900 focus:outline-none focus:border-[#1B5E20]"
                            />
                          </div>
                          <div className="text-[9px] text-slate-500 text-center font-mono">
                            ≈ ₹{(listingPricePerTray / 30).toFixed(1)} / अंडा
                          </div>
                        </div>
                      </div>

                      {/* Total Value Calculation Bar */}
                      <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-xs">
                        <span className="font-semibold text-slate-700">कुल बैच मूल्य (Total Value):</span>
                        <span className="font-black text-[#1B5E20] font-mono text-sm">
                          ₹{(listingTrays * listingPricePerTray).toLocaleString('en-IN')}
                        </span>
                      </div>
                    </>
                  ) : (
                    <>
                      {/* Live Poultry Breeds */}
                      <div className="space-y-1">
                        <span className="text-[10px] font-semibold text-slate-600">पोल्ट्री नस्ल (Poultry Breed):</span>
                        <div className="grid grid-cols-3 gap-1.5">
                          <button
                            type="button"
                            onClick={() => setListingPoultryBreed('kadaknath_pure')}
                            className={`p-2 rounded-xl text-center text-[10px] font-bold transition-all border ${
                              listingPoultryBreed === 'kadaknath_pure'
                                ? 'bg-[#B91C1C] text-white border-[#B91C1C] shadow-xs'
                                : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                            }`}
                          >
                            <div>कड़कनाथ</div>
                            <div className="text-[8px] opacity-80">शुद्ध ब्लैक</div>
                          </button>

                          <button
                            type="button"
                            onClick={() => setListingPoultryBreed('desi_country_fowl')}
                            className={`p-2 rounded-xl text-center text-[10px] font-bold transition-all border ${
                              listingPoultryBreed === 'desi_country_fowl'
                                ? 'bg-[#B91C1C] text-white border-[#B91C1C] shadow-xs'
                                : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                            }`}
                          >
                            <div>देसी मुर्गा</div>
                            <div className="text-[8px] opacity-80">Country Fowl</div>
                          </button>

                          <button
                            type="button"
                            onClick={() => setListingPoultryBreed('live_broiler')}
                            className={`p-2 rounded-xl text-center text-[10px] font-bold transition-all border ${
                              listingPoultryBreed === 'live_broiler'
                                ? 'bg-[#B91C1C] text-white border-[#B91C1C] shadow-xs'
                                : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                            }`}
                          >
                            <div>ब्रॉयलर</div>
                            <div className="text-[8px] opacity-80">लाइव फार्म</div>
                          </button>
                        </div>
                      </div>

                      {/* Birds Count & Price */}
                      <div className="grid grid-cols-2 gap-2.5 pt-1">
                        <div className="space-y-1">
                          <span className="text-[10px] font-semibold text-slate-600">पक्षी संख्या (Birds):</span>
                          <div className="flex items-center justify-between border border-slate-200 rounded-xl p-1 bg-slate-50">
                            <button
                              type="button"
                              onClick={() => setListingBirdsCount(Math.max(5, listingBirdsCount - 5))}
                              className="w-7 h-7 rounded-lg bg-white border border-slate-300 flex items-center justify-center font-bold text-slate-700 hover:bg-slate-100"
                            >
                              <Minus className="w-3 h-3" />
                            </button>
                            <span className="font-bold text-xs font-mono text-slate-900">{listingBirdsCount}</span>
                            <button
                              type="button"
                              onClick={() => setListingBirdsCount(listingBirdsCount + 5)}
                              className="w-7 h-7 rounded-lg bg-white border border-slate-300 flex items-center justify-center font-bold text-slate-700 hover:bg-slate-100"
                            >
                              <Plus className="w-3 h-3" />
                            </button>
                          </div>
                          <div className="text-[9px] text-slate-500 text-center font-mono">
                            औसत वजन: {listingBirdWeight} किग्रा/पक्षी
                          </div>
                        </div>

                        <div className="space-y-1">
                          <span className="text-[10px] font-semibold text-slate-600">मूल्य प्रति पक्षी (₹):</span>
                          <div className="relative">
                            <span className="absolute left-2.5 top-2 text-xs font-bold text-slate-400">₹</span>
                            <input
                              type="number"
                              value={listingPricePerBird}
                              onChange={(e) => setListingPricePerBird(Number(e.target.value) || 0)}
                              className="w-full bg-slate-50 border border-slate-200 rounded-xl py-1.5 pl-6 pr-2 text-xs font-bold font-mono text-slate-900 focus:outline-none focus:border-[#B91C1C]"
                            />
                          </div>
                          <div className="text-[9px] text-slate-500 text-center font-mono">
                            ≈ ₹{(listingPricePerBird / listingBirdWeight).toFixed(0)} / किग्रा
                          </div>
                        </div>
                      </div>

                      {/* Numbered Leg-Seal Anti-Tamper Verification Tag */}
                      <div className="bg-red-50 border border-red-200 rounded-xl p-2.5 space-y-1">
                        <div className="flex items-center space-x-1.5 text-red-900 font-bold text-[10.5px]">
                          <Lock className="w-3.5 h-3.5 text-[#B91C1C]" />
                          <span>टैम्पर-प्रूफ लेग-सील सत्यापन (Numbered Leg-Seal):</span>
                        </div>
                        <input
                          type="text"
                          value={listingLegSealNumber}
                          onChange={(e) => setListingLegSealNumber(e.target.value)}
                          className="w-full bg-white border border-red-300 rounded-lg px-2.5 py-1 text-xs font-mono font-bold text-red-950 focus:outline-none"
                        />
                        <p className="text-[9.5px] text-red-800 leading-tight">
                          प्रत्येक लाइव पक्षी पर इस सील नंबर का टैग बांधें ताकि रास्ते में अदला-बदली न हो।
                        </p>
                      </div>

                      {/* Total Value Calculation Bar */}
                      <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-xs">
                        <span className="font-semibold text-slate-700">कुल बैच मूल्य (Total Value):</span>
                        <span className="font-black text-[#B91C1C] font-mono text-sm">
                          ₹{(listingBirdsCount * listingPricePerBird).toLocaleString('en-IN')}
                        </span>
                      </div>
                    </>
                  )}
                </div>

                {/* 3. DELIVERY MODE SELECTION */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3 shadow-xs space-y-2">
                  <label className="text-[11px] font-bold text-slate-800 flex items-center space-x-1.5">
                    <Truck className="w-3.5 h-3.5 text-[#1B5E20]" />
                    <span>3. डिलीवरी मोड का चयन (Delivery Mode Selection)</span>
                  </label>

                  {/* Option A: Farm Self-Pickup */}
                  <div 
                    onClick={() => setListingDeliveryMode('farm_pickup')}
                    className={`p-2.5 rounded-xl border cursor-pointer transition-all ${
                      listingDeliveryMode === 'farm_pickup'
                        ? 'bg-emerald-50/80 border-[#1B5E20] ring-1 ring-[#1B5E20]'
                        : 'bg-white border-slate-200 hover:border-slate-300'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <div className={`w-4 h-4 rounded-full border flex items-center justify-center ${
                          listingDeliveryMode === 'farm_pickup' ? 'border-[#1B5E20] bg-[#1B5E20]' : 'border-slate-400'
                        }`}>
                          {listingDeliveryMode === 'farm_pickup' && <div className="w-1.5 h-1.5 rounded-full bg-white" />}
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900">
                            फार्म से स्वयं उठाएं (Farm Self-Pickup)
                          </div>
                          <div className="text-[10px] text-slate-500">
                            ग्राहक सीधे आपके फार्म गेट से आर्डर उठाएंगे।
                          </div>
                        </div>
                      </div>
                      <span className="text-[10px] font-black text-emerald-800 bg-emerald-100 px-2 py-0.5 rounded font-mono">
                        ₹0 Delivery
                      </span>
                    </div>
                  </div>

                  {/* Option B: Daily Commuter Delivery (Paras to Akola) */}
                  <div 
                    onClick={() => setListingDeliveryMode('commuter_delivery')}
                    className={`p-2.5 rounded-xl border cursor-pointer transition-all ${
                      listingDeliveryMode === 'commuter_delivery'
                        ? 'bg-amber-50/80 border-amber-600 ring-1 ring-amber-600'
                        : 'bg-white border-slate-200 hover:border-slate-300'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <div className={`w-4 h-4 rounded-full border flex items-center justify-center ${
                          listingDeliveryMode === 'commuter_delivery' ? 'border-amber-600 bg-amber-600' : 'border-slate-400'
                        }`}>
                          {listingDeliveryMode === 'commuter_delivery' && <div className="w-1.5 h-1.5 rounded-full bg-white" />}
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900">
                            कम्यूटर डिलीवरी (Daily Commuter Delivery)
                          </div>
                          <div className="text-[10px] text-slate-500">
                            Paras to Akola दैनिक बस/ट्रेन यात्री द्वारा त्वरित डिलीवरी।
                          </div>
                        </div>
                      </div>
                      <span className="text-[10px] font-black text-amber-900 bg-amber-100 px-2 py-0.5 rounded font-mono">
                        ₹{listingCommuterFee} Fee
                      </span>
                    </div>
                  </div>
                </div>

                {/* 4. FLEXIBLE ADVANCE TOKEN VS FULL COD (FARMER'S OPTION) */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3 shadow-xs space-y-2.5">
                  <label className="text-[11px] font-bold text-slate-800 flex items-center space-x-1.5">
                    <CreditCard className="w-3.5 h-3.5 text-blue-800" />
                    <span>4. अग्रिम टोकन बनाम सीओडी (Payment Configuration)</span>
                  </label>

                  <div className="space-y-2">
                    {/* Option 1: Require 50% Advance Token */}
                    <div
                      onClick={() => setListingPaymentPolicy('advance_token_50')}
                      className={`p-2.5 rounded-xl border cursor-pointer transition-all ${
                        listingPaymentPolicy === 'advance_token_50'
                          ? 'bg-blue-50/80 border-blue-600 ring-1 ring-blue-600'
                          : 'bg-white border-slate-200 hover:border-slate-300'
                      }`}
                    >
                      <div className="flex items-start space-x-2">
                        <div className={`w-4 h-4 mt-0.5 rounded-full border flex items-center justify-center shrink-0 ${
                          listingPaymentPolicy === 'advance_token_50' ? 'border-blue-600 bg-blue-600' : 'border-slate-400'
                        }`}>
                          {listingPaymentPolicy === 'advance_token_50' && <div className="w-1.5 h-1.5 rounded-full bg-white" />}
                        </div>
                        <div className="space-y-0.5">
                          <div className="text-xs font-bold text-slate-900">
                            Require 50% Advance Token (50% यूपीआई अग्रिम)
                          </div>
                          <div className="text-[10px] text-slate-500 leading-tight">
                            खरीदार कम्यूटर डिस्पैच से पहले 50% यूपीआई किसान को देंगे। शेष 50% डिलीवरी पर।
                          </div>
                        </div>
                      </div>
                    </div>

                    {/* Option 2: Allow 100% Cash/UPI on Delivery (COD) */}
                    <div
                      onClick={() => setListingPaymentPolicy('full_cod_100')}
                      className={`p-2.5 rounded-xl border cursor-pointer transition-all ${
                        listingPaymentPolicy === 'full_cod_100'
                          ? 'bg-blue-50/80 border-blue-600 ring-1 ring-blue-600'
                          : 'bg-white border-slate-200 hover:border-slate-300'
                      }`}
                    >
                      <div className="flex items-start space-x-2">
                        <div className={`w-4 h-4 mt-0.5 rounded-full border flex items-center justify-center shrink-0 ${
                          listingPaymentPolicy === 'full_cod_100' ? 'border-blue-600 bg-blue-600' : 'border-slate-400'
                        }`}>
                          {listingPaymentPolicy === 'full_cod_100' && <div className="w-1.5 h-1.5 rounded-full bg-white" />}
                        </div>
                        <div className="space-y-0.5">
                          <div className="text-xs font-bold text-slate-900">
                            Allow 100% Cash/UPI on Delivery (100% सीओडी)
                          </div>
                          <div className="text-[10px] text-slate-500 leading-tight">
                            खरीदार डिलीवरी व हैंडशेक के समय पूरा 100% भुगतान करेंगे।
                          </div>
                        </div>
                      </div>
                    </div>

                    {/* Mandatory Commuter Pre-Pickup Buyer Call Gate Requirement */}
                    <div className="bg-blue-900/10 border border-blue-200 rounded-xl p-2.5 flex items-start space-x-2 text-[10px] text-blue-950 font-medium">
                      <Phone className="w-4 h-4 text-blue-800 shrink-0 mt-0.5" />
                      <div className="leading-snug">
                        <strong className="text-blue-900 block font-bold">कम्यूटर प्री-पिकअप कॉल गेट अनिवार्य है:</strong>
                        फार्म से माल लोड करने से पहले कम्यूटर द्वारा खरीदार को कॉल करके उपस्थिति सुनिश्चित करना सख्त अनिवार्य है।
                      </div>
                    </div>
                  </div>
                </div>

                {/* 5. REFINED BULK MICRO-TIERS PLATFORM FEE PREVIEW CARD */}
                {(() => {
                  const feeData = listingCategory === 'fresh_eggs'
                    ? calculateEggPlatformFee(listingTrays)
                    : calculatePoultryPlatformFee(listingBirdsCount);

                  return (
                    <div className="bg-amber-50 border border-amber-300 rounded-2xl p-3 shadow-xs space-y-2.5">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-2 text-amber-950 font-bold text-xs">
                          <ShieldCheck className="w-4 h-4 text-amber-700 shrink-0" />
                          <span>प्लेटफ़ॉर्म शुल्क (Bulk Micro-Tiers)</span>
                        </div>
                        <span className="text-[9.5px] font-black bg-amber-200/90 text-amber-950 border border-amber-400 px-2 py-0.5 rounded-full font-mono">
                          {feeData.tierBadge}
                        </span>
                      </div>

                      <div className="bg-white/80 border border-amber-200 rounded-xl p-2.5 space-y-1">
                        <div className="text-[10.5px] font-bold text-amber-950">
                          {feeData.tierTitle}
                        </div>
                        <div className="text-[10px] text-amber-900 flex items-center justify-between">
                          <span>लागू दर: <strong>{feeData.unitRateExplanation}</strong></span>
                          <span>कुल शुल्क: <strong className="font-mono text-emerald-800 text-xs">₹{feeData.totalFee.toFixed(2)}</strong></span>
                        </div>
                      </div>

                      <div className="pt-1 border-t border-amber-200/80 space-y-1 text-[10px]">
                        <div className="flex items-center justify-between text-amber-800">
                          <span>विक्रेता प्रीपेड वॉलेट शेष:</span>
                          <span className="font-mono font-bold text-amber-950">₹{sellerPrepaidWallet.toFixed(2)}</span>
                        </div>
                        <div className="flex items-center justify-between text-amber-800">
                          <span>सफल डिलीवरी पर कटौती (माइक्रो-टियर):</span>
                          <span className="font-mono font-bold text-emerald-800">-₹{feeData.totalFee.toFixed(2)} (Only on Delivery)</span>
                        </div>
                      </div>

                      <button
                        type="button"
                        onClick={() => navigateTo('seller-wallet')}
                        className="w-full py-1.5 px-2 bg-amber-800 hover:bg-amber-900 text-white rounded-lg text-[10px] font-bold flex items-center justify-center space-x-1.5 shadow-xs transition-all"
                      >
                        <Wallet className="w-3 h-3 text-amber-300" />
                        <span>प्रीपेड वॉलेट व सेफ हार्बर विवरण खोलें ➡️</span>
                      </button>
                    </div>
                  );
                })()}

                {/* SUBMIT BUTTON */}
                <button
                  type="button"
                  onClick={handlePublishEggBatch}
                  className={`w-full py-3.5 rounded-xl text-white font-black text-xs shadow-md transition-all flex items-center justify-center space-x-2 active:scale-98 ${
                    listingCategory === 'fresh_eggs' ? 'bg-[#1B5E20] hover:bg-[#2E7D32]' : 'bg-[#B91C1C] hover:bg-[#991B1B]'
                  }`}
                >
                  <PackageCheck className="w-4 h-4" />
                  <span>
                    {listingCategory === 'fresh_eggs' ? 'अंडा बैच प्रकाशित करें (Publish Egg Batch)' : 'लाइव पोल्ट्री बैच प्रकाशित करें (Publish Poultry)'}
                  </span>
                </button>
              </div>
            )}

            {/* 4.5. COMMUTER TRIP & DISPATCH CONTROLLER SCREEN (lib/screens/commuter_trip_screen.dart) */}
            {currentScreen === 'commuter-trip' && (
              <div className="p-3.5 space-y-3.5 animate-fadeIn">
                {/* 1. COMMUTER TRIP INITIATION CARD */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-xs space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2.5">
                      <div className="w-9 h-9 rounded-xl bg-blue-900 text-white flex items-center justify-center font-bold shadow-xs">
                        <Bus className="w-5 h-5 text-amber-300" />
                      </div>
                      <div>
                        <div className="text-xs font-black text-slate-900 leading-tight">
                          पारस ➡️ अकोला (Paras to Akola)
                        </div>
                        <div className="text-[10px] text-slate-500 font-medium">
                          कम्यूटर: संतोष गावंडे • बस MH-30-AK-4122
                        </div>
                      </div>
                    </div>
                    <span className={`text-[9px] font-bold px-2 py-0.5 rounded-full border ${
                      commuterTripStarted 
                        ? 'bg-emerald-50 text-emerald-800 border-emerald-300' 
                        : 'bg-amber-50 text-amber-800 border-amber-300'
                    }`}>
                      {commuterTripStarted ? '🟢 ऑन-रूट (In Transit)' : '🕒 प्रस्थान हेतु तैयार'}
                    </span>
                  </div>

                  {/* Route Timeline */}
                  <div className="bg-slate-50 rounded-xl p-2.5 border border-slate-200 grid grid-cols-2 gap-2 text-[10px]">
                    <div>
                      <span className="text-slate-400 block font-medium">प्रस्थान समय (Departure):</span>
                      <span className="font-mono font-bold text-slate-900">{commuterDepartureTime} (Paras Depot)</span>
                    </div>
                    <div className="text-right">
                      <span className="text-slate-400 block font-medium">गंतव्य (Destination):</span>
                      <span className="font-bold text-blue-900">अकोला बस स्टैंड (गेट 2)</span>
                    </div>
                  </div>

                  {/* Button 1: Start Trip & Send Loud Alert (FCM) */}
                  <button
                    type="button"
                    onClick={handleStartCommuterTrip}
                    disabled={commuterTripStarted}
                    className={`w-full py-3 rounded-xl font-bold text-xs shadow-md transition-all flex items-center justify-center space-x-2 ${
                      commuterTripStarted
                        ? 'bg-emerald-900/60 text-emerald-200 cursor-default'
                        : 'bg-[#1B5E20] hover:bg-[#2E7D32] text-white active:scale-98'
                    }`}
                  >
                    <BellRing className={`w-4 h-4 ${commuterTripStarted ? 'text-emerald-400' : 'animate-bounce text-amber-300'}`} />
                    <span>
                      {commuterTripStarted
                        ? '✓ यात्रा सक्रिय है • खरीदारों को अलर्ट भेजा गया'
                        : 'यात्रा शुरू / लाउड अलर्ट भेजें (Start Trip & Send Loud Alert)'}
                    </span>
                  </button>
                </div>

                {/* 3. BUS STAND 2-MINUTE ARRIVAL & HUB FAIL-SAFE TOGGLE */}
                <div className={`rounded-2xl p-3.5 border transition-all ${
                  arrivedAtBusStand 
                    ? 'bg-amber-50/80 border-amber-500 shadow-sm' 
                    : 'bg-white border-slate-200 shadow-xs'
                }`}>
                  <div className="flex items-center justify-between">
                    <div className="space-y-0.5">
                      <div className="text-xs font-bold text-slate-900 flex items-center space-x-1.5">
                        <MapPin className="w-3.5 h-3.5 text-amber-600" />
                        <span>अकोला बस स्टैंड आगमन टॉगल (Arrival Toggle)</span>
                      </div>
                      <p className="text-[10px] text-slate-500">
                        बस स्टैंड पहुंचने पर टॉगल करें • 2-मिनट हैंडशेक विंडो शुरू होगी
                      </p>
                    </div>

                    <label className="relative inline-flex items-center cursor-pointer">
                      <input 
                        type="checkbox" 
                        checked={arrivedAtBusStand} 
                        onChange={(e) => handleToggleBusStandArrival(e.target.checked)} 
                        className="sr-only peer"
                      />
                      <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-amber-600"></div>
                    </label>
                  </div>

                  {/* 2-Minute Digital Countdown HUD */}
                  {arrivedAtBusStand && (
                    <div className="mt-3 pt-3 border-t border-amber-200 space-y-2">
                      <div className="bg-slate-950 rounded-xl p-3 text-white flex items-center justify-between shadow-inner">
                        <div className="space-y-0.5">
                          <span className="text-[9px] text-amber-300 font-mono uppercase block">
                            हैंडशेक हैंडओवर विंडो (2-Min Timer):
                          </span>
                          <div className={`text-2xl font-black font-mono tracking-wider ${
                            countdownSeconds < 30 ? 'text-red-400 animate-pulse' : 'text-amber-400'
                          }`}>
                            {`${String(Math.floor(countdownSeconds / 60)).padStart(2, '0')}:${String(countdownSeconds % 60).padStart(2, '0')}`}
                          </div>
                        </div>

                        <div className="text-right space-y-1">
                          <span className={`text-[9px] font-black uppercase px-2 py-0.5 rounded ${
                            countdownSeconds < 30 
                              ? 'bg-red-900/90 text-red-200 border border-red-700' 
                              : 'bg-amber-900/90 text-amber-200 border border-amber-700'
                          }`}>
                            {countdownSeconds < 30 ? 'हब ड्रॉप का समय!' : 'हैंडओवर चालू'}
                          </span>
                          <div className="text-[8.5px] text-slate-400">बस छूटने से पहले हैंडओवर</div>
                        </div>
                      </div>
                    </div>
                  )}
                </div>

                {/* 2. MAXIMUM CARGO CAPACITY LIMITS (OFFICIAL ANDAEXPRESS LIMITS) */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-xs space-y-2.5">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-1.5 text-xs font-bold text-slate-900">
                      <Package className="w-4 h-4 text-blue-900" />
                      <span>अधिकतम कार्गो क्षमता सीमा (Cargo Capacity Limits)</span>
                    </div>
                    <span className="text-[9px] bg-blue-50 text-blue-900 font-bold px-2 py-0.5 rounded-full border border-blue-200">
                      बस सुरक्षा सीमा
                    </span>
                  </div>

                  <p className="text-[10px] text-slate-500">
                    कम्यूटर बस सुरक्षा दिशानिर्देश अनुसार प्रत्येक श्रेणी की अधिकतम वहन सीमा:
                  </p>

                  <div className="space-y-2 pt-1 text-[10.5px]">
                    {/* Limit 1: Eggs (30 Trays) */}
                    {(() => {
                      const eggTrays = commuterParcels
                        .filter((p) => p.category === 'eggs')
                        .reduce((sum, p) => sum + p.quantity, 0);
                      const percent = Math.min(100, Math.round((eggTrays / PricingConfig.maxEggTrays) * 100));
                      return (
                        <div className="space-y-1">
                          <div className="flex justify-between items-center">
                            <span className="font-semibold text-slate-700 flex items-center space-x-1">
                              <span>🥚 अंडे (Eggs):</span>
                            </span>
                            <span className="font-mono font-bold text-slate-900">
                              {eggTrays} / {PricingConfig.maxEggTrays} ट्रे (Max Limit: {PricingConfig.maxEggTrays} Trays) • {percent}%
                            </span>
                          </div>
                          <div className="w-full bg-slate-100 rounded-full h-2 overflow-hidden">
                            <div
                              className="bg-amber-500 h-2 rounded-full transition-all duration-300"
                              style={{ width: `${percent}%` }}
                            />
                          </div>
                        </div>
                      );
                    })()}

                    {/* Limit 2: Live Poultry (15 Birds) */}
                    {(() => {
                      const poultryBirds = commuterParcels
                        .filter((p) => p.category === 'live_poultry')
                        .reduce((sum, p) => sum + p.quantity, 0);
                      const percent = Math.min(100, Math.round((poultryBirds / PricingConfig.maxLiveBirds) * 100));
                      return (
                        <div className="space-y-1">
                          <div className="flex justify-between items-center">
                            <span className="font-semibold text-slate-700 flex items-center space-x-1">
                              <span>🐔 लाइव पोल्ट्री (Chicken/Duck):</span>
                            </span>
                            <span className="font-mono font-bold text-slate-900">
                              {poultryBirds} / {PricingConfig.maxLiveBirds} पक्षी (Max Limit: {PricingConfig.maxLiveBirds} Birds) • {percent}%
                            </span>
                          </div>
                          <div className="w-full bg-slate-100 rounded-full h-2 overflow-hidden">
                            <div
                              className="bg-red-500 h-2 rounded-full transition-all duration-300"
                              style={{ width: `${percent}%` }}
                            />
                          </div>
                        </div>
                      );
                    })()}

                    {/* Limit 3: Quails (30 Birds) */}
                    {(() => {
                      const quailBirds = commuterParcels
                        .filter((p) => p.category === 'quails')
                        .reduce((sum, p) => sum + p.quantity, 0);
                      const percent = Math.min(100, Math.round((quailBirds / PricingConfig.maxQuails) * 100));
                      return (
                        <div className="space-y-1">
                          <div className="flex justify-between items-center">
                            <span className="font-semibold text-slate-700 flex items-center space-x-1">
                              <span>🐦 बटेर (Quails):</span>
                            </span>
                            <span className="font-mono font-bold text-slate-900">
                              {quailBirds} / {PricingConfig.maxQuails} पक्षी (Max Limit: {PricingConfig.maxQuails} Birds) • {percent}%
                            </span>
                          </div>
                          <div className="w-full bg-slate-100 rounded-full h-2 overflow-hidden">
                            <div
                              className="bg-teal-500 h-2 rounded-full transition-all duration-300"
                              style={{ width: `${percent}%` }}
                            />
                          </div>
                        </div>
                      );
                    })()}
                  </div>
                </div>

                {/* 2.5. OFFICIAL DELIVERY FARE CALCULATION ENGINE & RULES */}
                <div className="bg-emerald-50/80 border border-emerald-300 rounded-2xl p-3.5 shadow-xs space-y-2">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-1.5 text-xs font-bold text-emerald-950">
                      <Sparkles className="w-4 h-4 text-emerald-700" />
                      <span>तय डिलीवरी किराया दरें व छूट नियम (Delivery Fare Engine)</span>
                    </div>
                    <span className="text-[9px] bg-emerald-200/60 text-emerald-900 font-bold px-1.5 py-0.5 rounded">
                      Standardized
                    </span>
                  </div>

                  <div className="grid grid-cols-1 gap-1.5 text-[10px]">
                    <div className="bg-white/80 p-2 rounded-xl border border-emerald-200/80 flex items-center justify-between">
                      <span className="font-semibold text-slate-800">
                        🐦 बटेर (Quails): <strong>₹5.00 प्रति पक्षी</strong>
                      </span>
                      <span className="text-emerald-800 font-bold bg-emerald-100 px-1.5 py-0.5 rounded">
                        मात्रा &gt; 20 होने पर 5% छूट
                      </span>
                    </div>

                    <div className="bg-white/80 p-2 rounded-xl border border-emerald-200/80 flex items-center justify-between">
                      <span className="font-semibold text-slate-800">
                        🥚 अंडे (Eggs): <strong>₹30.00 प्रति ट्रे</strong>
                      </span>
                      <span className="text-emerald-800 font-bold bg-emerald-100 px-1.5 py-0.5 rounded">
                        ऑर्डर &gt;= 10 ट्रे पर 10% छूट
                      </span>
                    </div>

                    <div className="bg-white/80 p-2 rounded-xl border border-emerald-200/80 flex items-center justify-between">
                      <span className="font-semibold text-slate-800">
                        🐔 लाइव पोल्ट्री: <strong>₹50.00 प्रति पक्षी</strong>
                      </span>
                      <span className="text-emerald-800 font-bold bg-emerald-100 px-1.5 py-0.5 rounded">
                        ऑर्डर &gt;= 5 पक्षी पर 10% छूट
                      </span>
                    </div>

                    <div className="bg-white/80 p-2 rounded-xl border border-emerald-200/80 flex items-center justify-between">
                      <span className="font-semibold text-slate-800">
                        👥 अलग खरीदार (Distinct Buyers):
                      </span>
                      <span className="text-indigo-800 font-bold bg-indigo-100 px-1.5 py-0.5 rounded">
                        मानक दर (कोई छूट नहीं)
                      </span>
                    </div>
                  </div>
                </div>

                {/* 3. ASSIGNED CARGO PARCELS (ANTI-BYPASS ALERT CONTROLLER) */}
                <div className="space-y-2.5">
                  <div className="flex items-center justify-between px-1">
                    <span className="text-xs font-bold text-slate-900">
                      असाइन किए गए कार्गो पार्सल ({commuterParcels.length} Parcels)
                    </span>
                    <span className="text-[10px] font-mono text-slate-500">
                      Paras ➡️ Akola Run
                    </span>
                  </div>

                  {commuterParcels.map((parcel) => {
                    const isDelivered = parcel.status === 'delivered';
                    const isHubDropped = parcel.status === 'dropped_at_hub';

                    return (
                      <div
                        key={parcel.orderId}
                        className={`bg-white rounded-2xl p-3.5 border shadow-xs transition-all space-y-2.5 ${
                          isDelivered
                            ? 'border-emerald-500 ring-1 ring-emerald-400 bg-emerald-50/20'
                            : isHubDropped
                            ? 'border-blue-500 ring-1 ring-blue-300 bg-blue-50/20'
                            : 'border-slate-200'
                        }`}
                      >
                        {/* Parcel Header */}
                        <div className="flex items-start justify-between">
                          <div>
                            <div className="flex items-center space-x-2">
                              <span className="text-xs font-bold text-slate-900">{parcel.buyerName}</span>
                              <span className="text-[9px] font-mono text-slate-500">({parcel.orderId})</span>
                              {parcel.isDistinctBuyer && (
                                <span className="text-[8.5px] bg-indigo-50 text-indigo-800 font-bold px-1.5 py-0.2 rounded border border-indigo-200">
                                  अलग खरीदार
                                </span>
                              )}
                            </div>
                            <div className="text-[10px] text-slate-600 mt-0.5 font-medium flex items-center space-x-1.5">
                              <span>{parcel.eggSummary}</span>
                              <span>•</span>
                              <span>मूल्य: ₹{parcel.parcelAmount}</span>
                            </div>
                          </div>

                          {/* 4-Digit Pickup/Delivery Code Badge */}
                          <div className="text-right">
                            <span className="text-[8px] text-slate-400 block uppercase font-bold">हैंडशेक कोड:</span>
                            <div className="bg-amber-400 text-slate-950 font-mono font-black text-xs px-2 py-0.5 rounded-lg shadow-xs tracking-wider inline-block">
                              {parcel.pickupCode}
                            </div>
                          </div>
                        </div>

                        {/* Status Alert Badge */}
                        <div className="flex items-center justify-between text-[10px] bg-slate-50 p-2 rounded-xl border border-slate-200">
                          <span className="text-slate-600">डिलीवरी स्थिति:</span>
                          <span className={`font-bold font-mono ${
                            isDelivered ? 'text-emerald-700' : isHubDropped ? 'text-blue-700' : 'text-amber-700'
                          }`}>
                            {isDelivered && '✓ हैंडशेक संपन्न (Delivered Direct)'}
                            {isHubDropped && '🏢 हब दुकान पर सुरक्षित जमा (Hub Dropped)'}
                            {!isDelivered && !isHubDropped && (arrivedAtBusStand ? '🕒 बस स्टैंड पर प्रतीक्षारत (At Stand)' : '🚚 रास्ते में (In Transit)')}
                          </span>
                        </div>

                        {/* City Hub Shop Notice if Dropped */}
                        {isHubDropped && (
                          <div className="bg-blue-50 border border-blue-200 rounded-xl p-2 space-y-1 text-[10px] text-blue-950">
                            <div className="font-bold flex items-center space-x-1 text-blue-900">
                              <Store className="w-3.5 h-3.5 text-blue-700" />
                              <span>{parcel.hubShop}</span>
                            </div>
                            <div className="text-[9.5px] text-blue-800">
                              +₹5 हब कीपिंग शुल्क खरीदार के बिल में जोड़ा गया। खरीदार किसी भी समय दुकान से ले सकते हैं।
                            </div>
                          </div>
                        )}

                        {/* Anti-Bypass Alert Action Buttons */}
                        {!isDelivered && !isHubDropped && (
                          <div className="space-y-2 pt-1">
                            {/* Buttons 2 & 3: WhatsApp & Direct Call */}
                            <div className="grid grid-cols-2 gap-2">
                              {/* Button 2: 1-Tap WhatsApp Alert */}
                              <button
                                type="button"
                                onClick={() => handleSendWhatsAppAlert(parcel)}
                                className="py-2 px-2.5 rounded-xl border border-emerald-500/80 bg-emerald-50 hover:bg-emerald-100 text-[#1B5E20] font-bold text-[10px] flex items-center justify-center space-x-1.5 transition-all shadow-2xs"
                              >
                                <MessageCircle className="w-3.5 h-3.5 text-emerald-600 shrink-0" />
                                <span>1-Tap WhatsApp अलर्ट</span>
                              </button>

                              {/* Button 3: 1-Tap Direct Call */}
                              <button
                                type="button"
                                onClick={() => handleDirectPhoneCall(parcel)}
                                className="py-2 px-2.5 rounded-xl border border-blue-500/80 bg-blue-50 hover:bg-blue-100 text-blue-900 font-bold text-[10px] flex items-center justify-center space-x-1.5 transition-all shadow-2xs"
                              >
                                <Phone className="w-3.5 h-3.5 text-blue-600 shrink-0" />
                                <span>1-Tap डायरेक्ट कॉल</span>
                              </button>
                            </div>

                            {/* Handover & Hub Fallback Buttons */}
                            <div className="grid grid-cols-12 gap-2 pt-0.5">
                              {/* Handshake Code Handover Button */}
                              <button
                                type="button"
                                onClick={() => handleVerifyHandshake(parcel.orderId)}
                                className={`col-span-7 py-2 rounded-xl font-bold text-[11px] shadow-sm flex items-center justify-center space-x-1.5 transition-all ${
                                  arrivedAtBusStand
                                    ? 'bg-[#1B5E20] hover:bg-[#2E7D32] text-white'
                                    : 'bg-slate-200 text-slate-500 cursor-not-allowed'
                                }`}
                              >
                                <Check className="w-3.5 h-3.5" />
                                <span>हैंडशेक कोड सत्यापित करें</span>
                              </button>

                              {/* Hub Fallback Button (Eggs only fallback) */}
                              {parcel.category === 'eggs' ? (
                                <button
                                  type="button"
                                  onClick={() => handleDropAtCityHubShop(parcel.orderId)}
                                  className="col-span-5 py-2 rounded-xl bg-slate-800 hover:bg-slate-900 text-white font-bold text-[10px] shadow-sm flex items-center justify-center space-x-1 transition-all"
                                >
                                  <Store className="w-3.5 h-3.5 text-amber-400" />
                                  <span>हब पर छोड़ें (+₹5)</span>
                                </button>
                              ) : (
                                <div className="col-span-5 py-2 bg-slate-100 text-slate-500 rounded-xl font-semibold text-[9.5px] flex items-center justify-center text-center">
                                  केवल डायरेक्ट डिलीवरी
                                </div>
                              )}
                            </div>
                          </div>
                        )}

                        {/* Commuter Earned Fee Breakdown */}
                        <div className="pt-1.5 border-t border-slate-100 flex items-center justify-between text-[10px]">
                          <div>
                            <span className="text-slate-500">डिलीवरी किराया (Fare): </span>
                            {parcel.discountPercent > 0 ? (
                              <span className="text-emerald-700 font-medium">
                                मूल: ₹{(parcel.baseRate * parcel.quantity).toFixed(0)} ({parcel.discountPercent}% छूट लागू)
                              </span>
                            ) : (
                              <span className="text-slate-500">
                                मानक दर @ ₹{parcel.baseRate}
                              </span>
                            )}
                          </div>
                          <span className="font-mono font-bold text-[#1B5E20] text-[11px]">
                            ₹{parcel.commuterFee.toFixed(2)} (नकद / UPI)
                          </span>
                        </div>
                      </div>
                    );
                  })}
                </div>

                {/* 4. FARE SETTLEMENT SUMMARY DISPLAY */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-xs space-y-2.5">
                  <div className="flex items-center space-x-2 text-xs font-bold text-slate-900">
                    <Wallet className="w-4 h-4 text-emerald-700" />
                    <span>कम्यूटर ट्रिप कमाई व किराया निपटान (Trip Earnings & Settlement)</span>
                  </div>

                  {(() => {
                    const totalTripEarnable = commuterParcels.reduce((sum, p) => sum + p.commuterFee, 0);
                    const collectedFees = commuterParcels
                      .filter((p) => p.status === 'delivered' || p.status === 'dropped_at_hub')
                      .reduce((sum, p) => sum + p.commuterFee, 0);
                    const pendingFees = totalTripEarnable - collectedFees;

                    return (
                      <div className="bg-emerald-50 rounded-xl p-3 border border-emerald-200 space-y-1.5 text-[11px]">
                        <div className="flex justify-between items-center text-slate-700">
                          <span>कुल ट्रिप डिलीवरी कमाई (Total Earnable):</span>
                          <span className="font-mono font-bold text-slate-900 text-xs">
                            ₹{totalTripEarnable.toFixed(2)}
                          </span>
                        </div>
                        <div className="flex justify-between items-center text-slate-700">
                          <span>सत्यापित व प्राप्त शुल्क (Collected):</span>
                          <span className="font-mono font-black text-[#1B5E20]">
                            ₹{collectedFees.toFixed(2)}
                          </span>
                        </div>
                        <div className="pt-1.5 border-t border-emerald-200/80 flex justify-between items-center text-emerald-950 font-bold">
                          <span>शेष प्राप्तव्य (Pending Collection):</span>
                          <span className="font-mono text-amber-800">
                            ₹{pendingFees.toFixed(2)}
                          </span>
                        </div>
                      </div>
                    );
                  })()}

                  <p className="text-[9.5px] text-slate-500 leading-tight">
                    • पारस से अकोला दैनिक कम्यूटर को प्रत्येक पार्सल पर निर्धारित दर अनुसार नकद या सीधे यूपीआई से भुगतान मिलता है। हब पर छोड़े गए अंडे पार्सल का ₹5 दुकान शुल्क खरीदार हब दुकान पर चुकाएंगे।
                  </p>
                </div>
              </div>
            )}

            {/* 5. LOGIN SCREEN (Interactive with Strict Legal Terms Gate) */}
            {currentScreen === 'login' && (
              <div className="p-4 space-y-3.5 animate-fadeIn">
                {/* Brand Header */}
                <div className="text-center pt-1 pb-2">
                  <div className="inline-flex w-12 h-12 rounded-2xl bg-gradient-to-br from-emerald-500/20 to-amber-500/20 border border-emerald-600/30 items-center justify-center text-2xl shadow-xs mb-1">
                    🥚
                  </div>
                  <h3 className="text-base font-black text-slate-900">AndaExpress Login</h3>
                  <p className="text-[11px] text-slate-500 font-medium">Farm-Fresh Eggs & Chicken Every Day</p>
                </div>

                {/* Role Switcher */}
                <div className="grid grid-cols-2 gap-2 bg-slate-100 p-1 rounded-xl text-xs font-bold">
                  <button
                    type="button"
                    onClick={() => setLoginRole('buyer')}
                    className={`py-1.5 rounded-lg transition-all ${
                      loginRole === 'buyer'
                        ? 'bg-white text-emerald-900 shadow-xs ring-1 ring-emerald-600'
                        : 'text-slate-500 hover:text-slate-900'
                    }`}
                  >
                    I want to Buy
                  </button>
                  <button
                    type="button"
                    onClick={() => setLoginRole('seller')}
                    className={`py-1.5 rounded-lg transition-all ${
                      loginRole === 'seller'
                        ? 'bg-white text-amber-900 shadow-xs ring-1 ring-amber-600'
                        : 'text-slate-500 hover:text-slate-900'
                    }`}
                  >
                    I want to Sell
                  </button>
                </div>

                {/* Phone Input */}
                <div className="space-y-1">
                  <label className="text-[11px] font-bold text-slate-700 flex justify-between">
                    <span>Mobile Number</span>
                    {loginOtpSent && (
                      <button
                        type="button"
                        onClick={() => setLoginOtpSent(false)}
                        className="text-emerald-700 font-bold hover:underline"
                      >
                        Change
                      </button>
                    )}
                  </label>
                  <div className="flex items-center rounded-xl border border-slate-300 overflow-hidden bg-white shadow-xs focus-within:border-emerald-600">
                    <div className="bg-emerald-50 px-2.5 py-2 border-r border-slate-200 text-xs font-bold text-emerald-900">
                      🇮🇳 +91
                    </div>
                    <input
                      type="tel"
                      maxLength={10}
                      disabled={loginOtpSent}
                      value={loginPhone}
                      onChange={(e) => setLoginPhone(e.target.value.replace(/\D/g, ''))}
                      placeholder="10-digit number"
                      className="w-full px-2.5 py-2 text-xs font-bold text-slate-900 focus:outline-none tracking-wide"
                    />
                  </div>
                </div>

                {/* OTP Input (When OTP is requested) */}
                {loginOtpSent && (
                  <div className="space-y-1 animate-fadeIn">
                    <label className="text-[11px] font-bold text-slate-700">
                      Enter 6-digit OTP sent to +91 {loginPhone}
                    </label>
                    <div className="relative">
                      <input
                        type="text"
                        maxLength={6}
                        value={loginOtp}
                        onChange={(e) => setLoginOtp(e.target.value.replace(/\D/g, ''))}
                        placeholder="• • • • • •"
                        className="w-full text-center py-2 px-3 rounded-xl border-2 border-emerald-600 text-base font-black tracking-[0.3em] text-emerald-900 focus:outline-none bg-emerald-50/30"
                      />
                    </div>
                    <div className="flex justify-between items-center text-[10px] text-slate-400 pt-0.5">
                      <span>Resend in 30s</span>
                      <span className="text-emerald-700 font-mono font-bold bg-emerald-100/60 px-1.5 py-0.2 rounded">
                        Demo OTP: 894210
                      </span>
                    </div>
                  </div>
                )}

                {/* Interactive Legal Terms & Conditions Gate */}
                {!loginOtpSent && (
                  <div className="bg-slate-50 border border-slate-200/90 rounded-xl p-2.5 space-y-1">
                    <label className="flex items-start space-x-2 cursor-pointer select-none">
                      <input
                        type="checkbox"
                        checked={loginAgreedToTerms}
                        onChange={(e) => setLoginAgreedToTerms(e.target.checked)}
                        className="mt-0.5 w-4 h-4 rounded text-emerald-700 border-slate-300 focus:ring-emerald-600 cursor-pointer accent-emerald-700 shrink-0"
                      />
                      <span className="text-[11px] leading-snug text-slate-700 font-medium">
                        I agree to the{' '}
                        <button
                          type="button"
                          onClick={(e) => {
                            e.preventDefault();
                            setLoginLegalModalTitle('Terms & Conditions');
                            setShowLoginLegalModal(true);
                          }}
                          className="text-emerald-800 font-bold underline underline-offset-2 hover:text-emerald-950"
                        >
                          Terms & Conditions
                        </button>{' '}
                        and{' '}
                        <button
                          type="button"
                          onClick={(e) => {
                            e.preventDefault();
                            setLoginLegalModalTitle('Privacy Policy');
                            setShowLoginLegalModal(true);
                          }}
                          className="text-emerald-800 font-bold underline underline-offset-2 hover:text-emerald-950"
                        >
                          Privacy Policy
                        </button>
                      </span>
                    </label>

                    {!loginAgreedToTerms && (
                      <div className="text-[10px] text-amber-700 font-semibold pl-6">
                        ⚠️ Check the box to activate Request OTP
                      </div>
                    )}
                  </div>
                )}

                {/* Primary Action Button (Strictly Disabled by default until checkbox is checked) */}
                <button
                  type="button"
                  disabled={loginOtpSent ? loginOtp.length < 6 : (loginPhone.length < 10 || !loginAgreedToTerms)}
                  onClick={() => {
                    if (!loginOtpSent) {
                      setLoginOtpSent(true);
                      setLoginOtp('894210');
                    } else {
                      setLoginSuccessToast(true);
                      setTimeout(() => {
                        setLoginSuccessToast(false);
                        navigateTo('home');
                      }, 1800);
                    }
                  }}
                  className="w-full py-2.5 rounded-xl bg-[#1B5E20] hover:bg-emerald-900 text-white font-bold text-xs shadow-md transition-all disabled:bg-slate-300 disabled:text-slate-500 disabled:shadow-none disabled:cursor-not-allowed flex items-center justify-center space-x-1.5"
                >
                  <span>{loginOtpSent ? 'Verify OTP & Continue' : 'Request OTP'}</span>
                  <ChevronRight className="w-3.5 h-3.5" />
                </button>
              </div>
            )}

            {/* 6. SELLER PREPAID WALLET & LEGAL INTERMEDIARY SCREEN (lib/screens/seller_wallet_screen.dart) */}
            {currentScreen === 'seller-wallet' && (
              <div className="p-3.5 space-y-3.5 animate-fadeIn">
                {/* 1. CURRENT BALANCE & DEDUCTION POLICY CARD */}
                <div className="bg-gradient-to-br from-[#1B5E20] via-emerald-800 to-emerald-950 text-white rounded-2xl p-4 shadow-md space-y-3 relative overflow-hidden">
                  <div className="absolute top-0 right-0 -mr-6 -mt-6 w-24 h-24 bg-white/5 rounded-full blur-xl pointer-events-none"></div>

                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2">
                      <div className="w-8 h-8 rounded-xl bg-amber-400/20 border border-amber-300/40 flex items-center justify-center text-amber-300">
                        <Wallet className="w-4 h-4" />
                      </div>
                      <div>
                        <div className="text-[11px] font-bold text-emerald-100">
                          उपलब्ध प्रीपेड बैलेंस (Prepaid Balance)
                        </div>
                        <div className="text-[9px] text-emerald-300 font-mono">
                          Farmer Account: usr_seller_chhabra
                        </div>
                      </div>
                    </div>
                    <span className={`text-[9px] font-black px-2 py-0.5 rounded-full border ${
                      sellerPrepaidWallet > 10
                        ? 'bg-emerald-900/90 text-emerald-200 border-emerald-600'
                        : 'bg-red-900/90 text-red-200 border-red-600'
                    }`}>
                      {sellerPrepaidWallet > 10 ? '● सक्रिय (Active)' : '● लो बैलेंस (Low)'}
                    </span>
                  </div>

                  {/* Large Balance Display */}
                  <div className="pt-1 flex items-baseline justify-between">
                    <div className="text-3xl font-black font-mono tracking-tight text-white flex items-baseline">
                      <span>₹{sellerPrepaidWallet.toFixed(2)}</span>
                    </div>
                    <span className="text-[10px] text-amber-300 font-bold bg-amber-950/60 border border-amber-500/40 px-2 py-0.5 rounded-lg">
                      Bulk Micro-Tiers
                    </span>
                  </div>

                  {/* Dynamic Deduction Policy Notice */}
                  <div className="bg-white/10 backdrop-blur-xs border border-white/15 rounded-xl p-2.5 flex items-start space-x-2 text-[10px] text-emerald-100">
                    <ShieldCheck className="w-4 h-4 text-amber-300 shrink-0 mt-0.5" />
                    <div className="leading-tight">
                      <strong className="text-amber-200 block font-bold">डायनेमिक डिडक्शन नियम:</strong>
                      प्लेटफ़ॉर्म सुविधा शुल्क <u>केवल तभी कटेगा</u> जब ऑर्डर की स्थिति <span className="font-mono text-white bg-black/30 px-1 rounded">'delivered'</span> या <span className="font-mono text-white bg-black/30 px-1 rounded">'dropped_at_hub'</span> में बदलेगी।
                    </div>
                  </div>
                </div>

                {/* 2. REFINED PLATFORM FEE ENGINE & ARCHITECTURE CARD */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-xs space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2">
                      <div className="w-8 h-8 rounded-xl bg-amber-100 text-amber-900 flex items-center justify-center font-bold">
                        <ShieldCheck className="w-4 h-4 text-amber-700" />
                      </div>
                      <div>
                        <h4 className="text-xs font-bold text-slate-900">
                          प्लेटफ़ॉर्म शुल्क इंजन (Bulk Micro-Tiers)
                        </h4>
                        <p className="text-[9.5px] text-slate-500 font-mono">Refined Micro-Tier Calculator</p>
                      </div>
                    </div>
                    <span className="text-[9px] bg-emerald-50 text-emerald-800 font-bold px-2 py-0.5 rounded-full border border-emerald-300">
                      Auto-Calculated
                    </span>
                  </div>

                  {/* Category Switcher for Calculator */}
                  <div className="grid grid-cols-2 gap-1.5 p-1 bg-slate-100 rounded-xl">
                    <button
                      type="button"
                      onClick={() => setWalletCalcCategory('fresh_eggs')}
                      className={`py-1.5 text-xs font-bold rounded-lg transition-all ${
                        walletCalcCategory === 'fresh_eggs'
                          ? 'bg-white text-[#1B5E20] shadow-xs'
                          : 'text-slate-600 hover:text-slate-900'
                      }`}
                    >
                      🥚 ताज़ा अंडे (Eggs)
                    </button>
                    <button
                      type="button"
                      onClick={() => setWalletCalcCategory('live_poultry')}
                      className={`py-1.5 text-xs font-bold rounded-lg transition-all ${
                        walletCalcCategory === 'live_poultry'
                          ? 'bg-white text-[#B91C1C] shadow-xs'
                          : 'text-slate-600 hover:text-slate-900'
                      }`}
                    >
                      🐔 लाइव पोल्ट्री (Poultry)
                    </button>
                  </div>

                  {/* Quantity Stepper & Tier Display */}
                  {walletCalcCategory === 'fresh_eggs' ? (
                    (() => {
                      const eggFee = calculateEggPlatformFee(walletCalcTrays);
                      return (
                        <div className="space-y-2.5">
                          {/* Trays Stepper */}
                          <div className="space-y-1">
                            <div className="flex justify-between items-center text-[10px]">
                              <span className="font-semibold text-slate-700">ट्रे मात्रा (1 tray = 30 eggs):</span>
                              <span className="font-mono text-slate-500">कुल अंडे: {eggFee.eggCount}</span>
                            </div>
                            <div className="flex items-center justify-between border border-slate-200 rounded-xl p-1 bg-slate-50">
                              <button
                                type="button"
                                onClick={() => setWalletCalcTrays(Math.max(5, walletCalcTrays - 5))}
                                className="w-7 h-7 rounded-lg bg-white border border-slate-300 flex items-center justify-center font-bold text-slate-700 hover:bg-slate-100"
                              >
                                <Minus className="w-3 h-3" />
                              </button>
                              <div className="text-center">
                                <span className="font-bold text-xs font-mono text-slate-900">{walletCalcTrays} ट्रे</span>
                                <span className="text-[9px] text-slate-400 block font-mono">({eggFee.eggCount} अंडे)</span>
                              </div>
                              <button
                                type="button"
                                onClick={() => setWalletCalcTrays(walletCalcTrays + 5)}
                                className="w-7 h-7 rounded-lg bg-white border border-slate-300 flex items-center justify-center font-bold text-slate-700 hover:bg-slate-100"
                              >
                                <Plus className="w-3 h-3" />
                              </button>
                            </div>
                          </div>

                          {/* Quick Volume Presets */}
                          <div className="grid grid-cols-3 gap-1.5">
                            {[12, 40, 60].map((t) => (
                              <button
                                key={t}
                                type="button"
                                onClick={() => setWalletCalcTrays(t)}
                                className={`py-1 text-[9.5px] font-bold rounded-lg border transition-all ${
                                  walletCalcTrays === t
                                    ? 'bg-emerald-800 text-white border-emerald-800'
                                    : 'bg-white text-slate-700 border-slate-200 hover:bg-slate-50'
                                }`}
                              >
                                {t} ट्रे {t <= 30 ? '(T1)' : t <= 50 ? '(T2)' : '(T3)'}
                              </button>
                            ))}
                          </div>

                          {/* Active Micro-Tier Rate Card */}
                          <div className="bg-amber-50/90 border border-amber-300 rounded-xl p-2.5 space-y-1.5">
                            <div className="flex items-center justify-between">
                              <span className="text-[10px] font-bold text-amber-950 flex items-center space-x-1">
                                <span>{eggFee.tierTitle}</span>
                              </span>
                              <span className="text-[9px] font-black bg-amber-200 text-amber-950 px-2 py-0.5 rounded-full font-mono border border-amber-300">
                                {eggFee.tierBadge}
                              </span>
                            </div>
                            <div className="flex justify-between items-center text-[10.5px] pt-0.5 border-t border-amber-200">
                              <span className="text-amber-900">लागू दर: <strong>{eggFee.unitRateExplanation}</strong></span>
                              <span className="text-emerald-900 font-mono font-black text-sm">
                                कुल शुल्क: ₹{eggFee.totalFee.toFixed(2)}
                              </span>
                            </div>
                          </div>

                          {/* Test Deduction Button */}
                          <button
                            type="button"
                            onClick={() => deductPlatformFee(
                              `ORD-AKL-${Math.floor(920 + Math.random() * 70)}`,
                              eggFee.totalFee,
                              `अंडे प्लेटफ़ॉर्म शुल्क (${eggFee.tierBadge}: ${walletCalcTrays} Trays)`,
                              `${eggFee.tierTitle} • ₹${eggFee.totalFee.toFixed(2)} deducted from prepaid balance`
                            )}
                            className="w-full py-2 bg-emerald-900 hover:bg-emerald-950 text-white rounded-xl text-[10.5px] font-bold flex items-center justify-center space-x-1.5 shadow-xs transition-all active:scale-98"
                          >
                            <Sparkles className="w-3.5 h-3.5 text-amber-300" />
                            <span>इस टियर की कटौती टेस्ट करें (-₹{eggFee.totalFee.toFixed(2)})</span>
                          </button>
                        </div>
                      );
                    })()
                  ) : (
                    (() => {
                      const poultryFee = calculatePoultryPlatformFee(walletCalcBirds);
                      return (
                        <div className="space-y-2.5">
                          {/* Birds Stepper */}
                          <div className="space-y-1">
                            <div className="flex justify-between items-center text-[10px]">
                              <span className="font-semibold text-slate-700">पक्षी संख्या (Live Birds):</span>
                              <span className="font-mono text-slate-500">चिकन / कड़कनाथ / बत्तख</span>
                            </div>
                            <div className="flex items-center justify-between border border-slate-200 rounded-xl p-1 bg-slate-50">
                              <button
                                type="button"
                                onClick={() => setWalletCalcBirds(Math.max(2, walletCalcBirds - 5))}
                                className="w-7 h-7 rounded-lg bg-white border border-slate-300 flex items-center justify-center font-bold text-slate-700 hover:bg-slate-100"
                              >
                                <Minus className="w-3 h-3" />
                              </button>
                              <div className="text-center">
                                <span className="font-bold text-xs font-mono text-slate-900">{walletCalcBirds} पक्षी</span>
                                <span className="text-[9px] text-slate-400 block font-mono">(Live Birds)</span>
                              </div>
                              <button
                                type="button"
                                onClick={() => setWalletCalcBirds(walletCalcBirds + 5)}
                                className="w-7 h-7 rounded-lg bg-white border border-slate-300 flex items-center justify-center font-bold text-slate-700 hover:bg-slate-100"
                              >
                                <Plus className="w-3 h-3" />
                              </button>
                            </div>
                          </div>

                          {/* Quick Presets */}
                          <div className="grid grid-cols-4 gap-1">
                            {[2, 10, 25, 75].map((b) => (
                              <button
                                key={b}
                                type="button"
                                onClick={() => setWalletCalcBirds(b)}
                                className={`py-1 text-[9px] font-bold rounded-lg border transition-all ${
                                  walletCalcBirds === b
                                    ? 'bg-red-800 text-white border-red-800'
                                    : 'bg-white text-slate-700 border-slate-200 hover:bg-slate-50'
                                }`}
                              >
                                {b} पक्षी
                              </button>
                            ))}
                          </div>

                          {/* Active Live Poultry Rate Card */}
                          <div className="bg-red-50/90 border border-red-200 rounded-xl p-2.5 space-y-1.5">
                            <div className="flex items-center justify-between">
                              <span className="text-[10px] font-bold text-red-950 flex items-center space-x-1">
                                <span>{poultryFee.tierTitle}</span>
                              </span>
                              <span className="text-[9px] font-black bg-red-100 text-red-950 px-2 py-0.5 rounded-full font-mono border border-red-300">
                                {poultryFee.tierBadge}
                              </span>
                            </div>
                            <div className="flex justify-between items-center text-[10.5px] pt-0.5 border-t border-red-200">
                              <span className="text-red-900">लागू दर: <strong>{poultryFee.unitRateExplanation}</strong></span>
                              <span className="text-red-950 font-mono font-black text-sm">
                                कुल शुल्क: ₹{poultryFee.totalFee.toFixed(2)}
                              </span>
                            </div>
                          </div>

                          {/* Test Deduction Button */}
                          <button
                            type="button"
                            onClick={() => deductPlatformFee(
                              `ORD-LIV-${Math.floor(500 + Math.random() * 70)}`,
                              poultryFee.totalFee,
                              `पोल्ट्री शुल्क (${poultryFee.tierBadge}: ${walletCalcBirds} Birds)`,
                              `${poultryFee.tierTitle} • ₹${poultryFee.totalFee.toFixed(2)} deducted from balance`
                            )}
                            className="w-full py-2 bg-red-800 hover:bg-red-900 text-white rounded-xl text-[10.5px] font-bold flex items-center justify-center space-x-1.5 shadow-xs transition-all active:scale-98"
                          >
                            <Sparkles className="w-3.5 h-3.5 text-amber-300" />
                            <span>इस टियर की कटौती टेस्ट करें (-₹{poultryFee.totalFee.toFixed(2)})</span>
                          </button>
                        </div>
                      );
                    })()
                  )}

                  {/* Architecture Reference Info Box */}
                  <div className="bg-slate-50 rounded-xl p-2.5 border border-slate-200 text-[9.5px] text-slate-600 space-y-1">
                    <div className="font-bold text-slate-800">आधिकारिक प्लेटफ़ॉर्म टियर संरचना:</div>
                    <div className="grid grid-cols-2 gap-1 text-[9px] text-slate-600">
                      <div>• अंडे 1-30 ट्रे: ₹1/अंडा (₹30/ट्रे)</div>
                      <div>• अंडे 31-50 ट्रे: ₹0.50/अंडा (₹15/ट्रे)</div>
                      <div>• अंडे &gt;50 ट्रे: ₹0.15/अंडा (₹4.50/ट्रे)</div>
                      <div>• पोल्ट्री 16-50: ₹5/पक्षी • &gt;500: ₹0.50</div>
                    </div>
                  </div>
                </div>

                {/* 3. SIMPLE UPI TOP-UP / RECHARGE (Chips + Quick Pay Button) */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-xs space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2">
                      <div className="w-7 h-7 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center font-bold">
                        ⚡
                      </div>
                      <div>
                        <h4 className="text-xs font-bold text-slate-900">
                          त्वरित UPI रिचार्ज (Quick Wallet Top-up)
                        </h4>
                        <p className="text-[9.5px] text-slate-500 font-mono">Instant ICICI VPA Gateway</p>
                      </div>
                    </div>
                    <span className="text-[9px] bg-slate-100 text-slate-700 font-mono font-bold px-2 py-0.5 rounded border border-slate-200">
                      0% Payment Fee
                    </span>
                  </div>

                  {/* Quick Recharge Chips: +₹200, +₹500, +₹1000 */}
                  <div className="space-y-1">
                    <span className="text-[10px] font-semibold text-slate-600">राशि चुनें (Recharge Chips):</span>
                    <div className="grid grid-cols-3 gap-2">
                      {[200, 500, 1000].map((amt) => {
                        const isSelected = selectedTopUpAmount === amt;
                        return (
                          <button
                            key={amt}
                            type="button"
                            onClick={() => setSelectedTopUpAmount(amt)}
                            className={`py-2 rounded-xl text-center text-xs font-bold font-mono transition-all border ${
                              isSelected
                                ? 'bg-[#1B5E20] text-white border-[#1B5E20] shadow-sm'
                                : 'bg-slate-50 text-slate-800 border-slate-200 hover:bg-slate-100'
                            }`}
                          >
                            +₹{amt}
                          </button>
                        );
                      })}
                    </div>
                  </div>

                  {/* Interactive UPI Pay Button */}
                  <button
                    type="button"
                    onClick={() => setShowUpiModal(true)}
                    className="w-full py-2.5 bg-[#1B5E20] hover:bg-emerald-900 text-white rounded-xl font-bold text-xs shadow-md transition-all flex items-center justify-center space-x-2 active:scale-98"
                  >
                    <CreditCard className="w-3.5 h-3.5 text-amber-300" />
                    <span>UPI से ₹{selectedTopUpAmount} रिचार्ज करें (Instant Top-up)</span>
                  </button>
                </div>

                {/* 3. INTERMEDIARY PLATFORM PROTECTION (IT ACT 2000, SEC 79) */}
                <div className="bg-amber-50/70 border border-amber-300 rounded-2xl overflow-hidden shadow-xs transition-all">
                  <button
                    type="button"
                    onClick={() => setIsSafeHarborExpanded(!isSafeHarborExpanded)}
                    className="w-full p-3.5 flex items-center justify-between text-left hover:bg-amber-100/50 transition-colors"
                  >
                    <div className="flex items-center space-x-2.5">
                      <div className="w-8 h-8 rounded-xl bg-amber-200/80 text-amber-900 flex items-center justify-center">
                        <Scale className="w-4 h-4" />
                      </div>
                      <div>
                        <div className="text-xs font-bold text-amber-950 flex items-center space-x-1.5">
                          <span>Platform Terms & Safe Harbor Disclosure</span>
                        </div>
                        <div className="text-[9.5px] text-amber-800 font-medium">
                          सूचना प्रौद्योगिकी अधिनियम 2000 (धारा 79) संरक्षण
                        </div>
                      </div>
                    </div>
                    <span className="text-amber-800 text-xs font-bold px-1.5 py-0.5 rounded bg-amber-200/60">
                      {isSafeHarborExpanded ? 'बंद करें ▲' : 'पढ़ें ▼'}
                    </span>
                  </button>

                  {/* Collapsible Content */}
                  {isSafeHarborExpanded && (
                    <div className="p-3.5 pt-0 space-y-2.5 text-[10.5px] text-amber-950 border-t border-amber-200/80 leading-relaxed bg-amber-50/90 animate-fadeIn">
                      <div className="bg-white/80 p-2.5 rounded-xl border border-amber-200 space-y-1">
                        <strong className="block text-emerald-900 font-bold">
                          • Intermediary Role & ₹2 Facilitation Fee (English):
                        </strong>
                        <p className="text-slate-700 leading-normal">
                          AndaExpress operates solely as a digital facilitator connecting poultry farmers, daily commuters, and buyers. The platform charges only a fixed ₹2 technology facilitation fee per successful order and does not produce, store, or own the poultry products.
                        </p>
                      </div>

                      <div className="bg-white/80 p-2.5 rounded-xl border border-amber-200 space-y-1">
                        <strong className="block text-amber-900 font-bold">
                          • डिजिटल मध्यस्थ स्थिति (हिंदी विवरण):
                        </strong>
                        <p className="text-slate-700 leading-normal">
                          AndaExpress केवल पोल्ट्री किसानों, कम्यूटर्स और खरीदारों को जोड़ने वाला डिजिटल मध्यस्थ (Intermediary) है। ऐप केवल ₹2 तकनीक सुविधा शुल्क लेता है और किसी भी उत्पाद का प्रत्यक्ष विक्रेता नहीं है। उत्पाद की गुणवत्ता और फार्म दावों के लिए संबंधित किसान पूर्णतः उत्तरदायी हैं।
                        </p>
                      </div>

                      <div className="bg-red-50 p-2.5 rounded-xl border border-red-200 space-y-1">
                        <strong className="block text-red-900 font-bold flex items-center space-x-1">
                          <span>• 24-Hour Float-Test Resolution Policy (24-घंटे फ्लोट टेस्ट नीति):</span>
                        </strong>
                        <p className="text-red-950 text-[10px] leading-normal">
                          Refund claims are strictly resolved via buyer's water-float camera proof submitted within 24 hours of delivery. False or unverified freshness claims are rejected by automated security rules.
                        </p>
                      </div>
                    </div>
                  )}
                </div>

                {/* 4. TRANSACTION LEDGER */}
                <div className="space-y-2">
                  <div className="flex items-center justify-between px-1">
                    <span className="text-xs font-bold text-slate-900 flex items-center space-x-1.5">
                      <FileText className="w-3.5 h-3.5 text-emerald-700" />
                      <span>लेनदेन इतिहास (Transaction Ledger)</span>
                    </span>
                    <span className="text-[10px] font-mono text-slate-500">
                      {walletTransactions.length} Transactions
                    </span>
                  </div>

                  <div className="space-y-2">
                    {walletTransactions.map((txn) => (
                      <div
                        key={txn.id}
                        className="bg-white border border-slate-200 rounded-xl p-2.5 shadow-2xs flex items-center justify-between hover:border-slate-300 transition-colors"
                      >
                        <div className="flex items-center space-x-2.5">
                          <div className={`w-8 h-8 rounded-lg flex items-center justify-center shrink-0 ${
                            txn.isDeduction ? 'bg-red-50 text-red-600' : 'bg-emerald-50 text-emerald-700'
                          }`}>
                            {txn.isDeduction ? (
                              <Minus className="w-4 h-4" />
                            ) : (
                              <Plus className="w-4 h-4" />
                            )}
                          </div>
                          <div>
                            <div className="text-[11px] font-bold text-slate-900 leading-tight">
                              {txn.title}
                            </div>
                            <div className="text-[9.5px] text-slate-500 font-mono flex items-center space-x-1.5 mt-0.5">
                              <span className="font-bold text-slate-700">{txn.orderId}</span>
                              <span>•</span>
                              <span>{txn.timestamp}</span>
                            </div>
                            <div className="text-[9px] text-slate-400 mt-0.5 truncate max-w-[170px]">
                              {txn.note}
                            </div>
                          </div>
                        </div>

                        <div className="text-right shrink-0 pl-2">
                          <div className={`text-xs font-bold font-mono ${
                            txn.isDeduction ? 'text-red-700' : 'text-[#1B5E20]'
                          }`}>
                            {txn.isDeduction ? `-₹${Math.abs(txn.amount).toFixed(2)}` : `+₹${txn.amount.toFixed(2)}`}
                          </div>
                          <div className="text-[9px] text-slate-500 font-mono mt-0.5">
                            शेष: ₹{txn.balanceAfter.toFixed(2)}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {/* 7. CITY HUB SHOP & CUSTODY TRANSFER SCREEN (lib/screens/city_hub_screen.dart) */}
            {currentScreen === 'hub-shop' && (
              <div className="p-3.5 space-y-3.5 animate-fadeIn">
                {/* 1. Hub Profile & Address Header */}
                <div className="bg-gradient-to-br from-blue-900 via-indigo-950 to-slate-950 text-white rounded-2xl p-4 shadow-md space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2.5">
                      <div className="w-8 h-8 rounded-xl bg-amber-400 text-slate-950 flex items-center justify-center font-bold">
                        <Store className="w-4.5 h-4.5" />
                      </div>
                      <div>
                        <div className="text-xs font-black text-white">
                          श्रीनाथ डेयरी व सिटी हब
                        </div>
                        <div className="text-[9.5px] text-blue-200">
                          Shrinath Dairy • Akola Bus Stand Gate 2
                        </div>
                      </div>
                    </div>

                    <span className={`text-[9px] font-black px-2 py-0.5 rounded-full border ${
                      sharedParcel.custody === 'hub_shop'
                        ? 'bg-amber-400 text-slate-950 border-amber-300 font-bold'
                        : 'bg-blue-900/80 text-blue-200 border-blue-700'
                    }`}>
                      {sharedParcel.custody === 'hub_shop' ? '● 1 Parcel in Custody' : '● Standby (0 in Custody)'}
                    </span>
                  </div>

                  {/* Hub Operator Info & Address */}
                  <div className="bg-white/10 backdrop-blur-xs p-2.5 rounded-xl border border-white/15 space-y-1 text-[10px]">
                    <div className="flex items-center justify-between text-blue-200">
                      <span>हब संचालक: <strong>सुरेश भाई पटेल (Suresh Patel)</strong></span>
                      <span className="font-mono text-amber-300">+91 98230 11223</span>
                    </div>
                    <div className="flex items-start space-x-1 text-slate-200 text-[9.5px]">
                      <MapPin className="w-3 h-3 text-amber-400 shrink-0 mt-0.5" />
                      <span>अकोला बस स्टैंड गेट नं. 2, मुख्य सड़क, अकोला (शीतगृह व कूलिंग उपलब्ध)</span>
                    </div>
                  </div>

                  {/* Hub Earnings & Fee Policy */}
                  <div className="flex items-center justify-between pt-1 border-t border-white/10 text-[10.5px]">
                    <span className="text-blue-200">हब कूलिंग व सुरक्षा शुल्क:</span>
                    <span className="font-mono font-bold text-amber-300">
                      +₹5.00 / पार्सल (खरीदार देय)
                    </span>
                  </div>
                </div>

                {/* 2. Custody Transfer Explanation Card */}
                <div className="bg-blue-50 border border-blue-200 rounded-xl p-3 text-xs space-y-1">
                  <div className="flex items-center space-x-1.5 font-bold text-blue-900">
                    <ShieldCheck className="w-4 h-4 text-blue-700 shrink-0" />
                    <span>कस्टडी ट्रांसफर व शून्य-लागत इन-ऐप OTP हैंडओवर</span>
                  </div>
                  <p className="text-[10px] text-blue-950 leading-relaxed">
                    जब कम्यूटर 2-मिनट हैंडशेक में असफल रहता है, तो पार्सल इस दुकान पर सुरक्षित छोड़ा जाता है। जब खरीदार दुकान पर आएंगे, तो वे अपना अनलॉक्ड 4-अंकीय OTP दिखाएंगे। OTP दर्ज करने पर ही अंडों की कस्टडी खरीदार को ट्रांसफर होगी।
                  </p>
                </div>

                {/* 3. Parcels in Hub Custody (Interactive Handover Section) */}
                <div className="space-y-2">
                  <div className="flex items-center justify-between px-1">
                    <span className="text-xs font-bold text-slate-900">
                      दुकान में सुरक्षित अंडे पार्सल (Crates in Custody)
                    </span>
                    <span className="text-[10px] font-mono text-slate-500">
                      {sharedParcel.custody === 'hub_shop' ? '1 Active' : '0 Pending'}
                    </span>
                  </div>

                  {/* Shared Order Card in Hub View */}
                  <div className={`bg-white rounded-2xl p-3.5 border shadow-xs space-y-3 transition-all ${
                    sharedParcel.status === 'delivered'
                      ? 'border-emerald-400 bg-emerald-50/20'
                      : sharedParcel.custody === 'hub_shop'
                      ? 'border-purple-400 ring-1 ring-purple-300'
                      : 'border-slate-200 opacity-90'
                  }`}>
                    {/* Parcel Header */}
                    <div className="flex items-start justify-between">
                      <div>
                        <div className="flex items-center space-x-2">
                          <span className="font-mono font-bold text-xs text-slate-900">{sharedParcel.orderId}</span>
                          <span className={`text-[9px] font-black px-1.5 py-0.2 rounded border ${
                            sharedParcel.status === 'delivered'
                              ? 'bg-emerald-100 text-emerald-800 border-emerald-300'
                              : sharedParcel.custody === 'hub_shop'
                              ? 'bg-purple-100 text-purple-800 border-purple-300'
                              : 'bg-slate-100 text-slate-600 border-slate-300'
                          }`}>
                            {sharedParcel.status === 'delivered'
                              ? '✓ हैंडओवर संपन्न'
                              : sharedParcel.custody === 'hub_shop'
                              ? '🏪 दुकान कस्टडी में'
                              : `स्थान: ${sharedParcel.custody.toUpperCase()}`}
                          </span>
                        </div>
                        <div className="text-[11px] font-bold text-slate-800 mt-0.5">
                          {sharedParcel.buyerName} ({sharedParcel.buyerPhone})
                        </div>
                        <div className="text-[10px] text-slate-500 mt-0.5">
                          {sharedParcel.eggSummary}
                        </div>
                      </div>

                      {/* Financials for Hub Shop */}
                      <div className="text-right">
                        <div className="font-mono font-black text-xs text-slate-900">
                          ₹{sharedParcel.price + sharedParcel.hubFee}
                        </div>
                        <div className="text-[8.5px] text-amber-700 bg-amber-50 px-1 py-0.2 rounded border border-amber-200 mt-0.5 font-bold">
                          +₹{sharedParcel.hubFee} हब शुल्क शामिल
                        </div>
                      </div>
                    </div>

                    {/* Custody Transfer Status Message */}
                    <div className="bg-slate-50 p-2 rounded-xl border border-slate-200 text-[10px] flex items-center justify-between">
                      <span className="text-slate-600">अंडे भंडारण स्थिति:</span>
                      <span className="font-bold text-slate-900">
                        {sharedParcel.status === 'delivered'
                          ? '✓ खरीदार को सुपुर्द कर दिए गए'
                          : sharedParcel.custody === 'hub_shop'
                          ? '❄️ कूलिंग चैंबर में सुरक्षित (Temp 18°C)'
                          : '🚚 कम्यूटर के पास या फार्म पर'}
                      </span>
                    </div>

                    {/* OTP Entry Handover Form (when in custody & not yet delivered) */}
                    {sharedParcel.status !== 'delivered' ? (
                      <div className="bg-purple-50/70 border border-purple-200 rounded-xl p-3 space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-[10.5px] font-bold text-purple-950 flex items-center space-x-1">
                            <KeyRound className="w-3.5 h-3.5 text-purple-700" />
                            <span>खरीदार का 4-अंकीय इन-ऐप OTP दर्ज करें:</span>
                          </label>
                          <button
                            type="button"
                            onClick={() => setHubOtpInput(sharedParcel.pickupCode)}
                            className="text-[9px] text-purple-700 hover:text-purple-900 font-bold underline"
                          >
                            Fill OTP ({sharedParcel.pickupCode})
                          </button>
                        </div>

                        <div className="grid grid-cols-12 gap-2">
                          <input
                            type="text"
                            maxLength={4}
                            value={hubOtpInput}
                            onChange={(e) => setHubOtpInput(e.target.value)}
                            placeholder="e.g. 4821"
                            className="col-span-6 bg-white border border-purple-300 rounded-xl px-3 py-2 text-center font-mono font-black text-sm tracking-widest text-slate-900 focus:outline-none focus:ring-2 focus:ring-purple-500 shadow-inner"
                          />
                          <button
                            type="button"
                            onClick={() => handleVerifyDeliveryOtp()}
                            className="col-span-6 py-2 bg-[#1B5E20] hover:bg-emerald-900 text-white rounded-xl font-bold text-xs flex items-center justify-center space-x-1 shadow-sm transition-all"
                          >
                            <Check className="w-3.5 h-3.5" />
                            <span>हैंडओवर सत्यापित करें</span>
                          </button>
                        </div>

                        <div className="text-[9px] text-slate-500 flex items-center justify-between">
                          <span>• OTP सही होने पर डिलीवरी दर्ज होगी व ₹5 हब शुल्क प्राप्त होगा।</span>
                          {!sharedParcel.isOtpUnlocked && (
                            <span className="text-amber-700 font-bold">⚠️ Buyer OTP still locked</span>
                          )}
                        </div>
                      </div>
                    ) : (
                      <div className="bg-emerald-100/70 border border-emerald-300 rounded-xl p-2.5 flex items-center space-x-2 text-[10.5px] text-emerald-950 font-bold">
                        <CheckCircle2 className="w-4 h-4 text-emerald-700 shrink-0" />
                        <span>हैंडओवर पूर्ण! खरीदार ने अंडे प्राप्त किए व ₹5 दुकान शुल्क चुकता किया।</span>
                      </div>
                    )}
                  </div>
                </div>

                {/* 4. Hub Operator Financial Settlement Ledger */}
                <div className="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-xs space-y-2">
                  <div className="flex items-center justify-between text-xs font-bold text-slate-900">
                    <span className="flex items-center space-x-1.5">
                      <Wallet className="w-4 h-4 text-purple-700" />
                      <span>हब शुल्क निपटान (City Hub Settlement Ledger)</span>
                    </span>
                    <span className="font-mono text-[10px] text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded font-bold">
                      Settled Instantly
                    </span>
                  </div>

                  <div className="bg-slate-50 rounded-xl p-2.5 border border-slate-200 space-y-1.5 text-[10.5px]">
                    <div className="flex justify-between items-center text-slate-700">
                      <span>हब हैंडलिंग शुल्क (प्रति अंडा क्रेट):</span>
                      <span className="font-mono font-bold text-slate-900">₹5.00</span>
                    </div>
                    <div className="flex justify-between items-center text-slate-700">
                      <span>आज के प्राप्त हब शुल्क:</span>
                      <span className="font-mono font-black text-[#1B5E20]">
                        ₹{sharedParcel.status === 'delivered' ? '15.00' : '10.00'}
                      </span>
                    </div>
                    <div className="pt-1 border-t border-slate-200 text-[9px] text-slate-500">
                      • सिटी हब दुकान संचालक को प्रत्येक संभाले गए पार्सल पर ₹5 का सीधा कमीशन नकद/UPI द्वारा मिलता है।
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* WATER FLOAT TEST INFO MODAL (Customer Home Feed) */}
          {showFloatModal && (
            <div className="absolute inset-0 bg-black/80 backdrop-blur-xs z-50 p-4 flex flex-col justify-end animate-fadeIn">
              <div className="bg-white rounded-3xl p-5 space-y-3 text-slate-900 shadow-2xl">
                <div className="flex items-center justify-between pb-2 border-b border-slate-100">
                  <div className="flex items-center space-x-2">
                    <span className="text-xl">💧</span>
                    <h3 className="text-sm font-bold text-[#1B5E20]">वाटर फ्लोट टेस्ट क्या है?</h3>
                  </div>
                  <button 
                    onClick={() => setShowFloatModal(false)}
                    className="w-7 h-7 rounded-full bg-slate-100 flex items-center justify-center font-bold text-slate-600"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>

                <div className="space-y-2.5 text-xs text-slate-700">
                  <div className="p-2.5 rounded-xl bg-emerald-50 border border-emerald-200">
                    <strong className="text-emerald-900 block font-bold">1. ताज़ा अंडा (Fresh Egg):</strong>
                    कटोरी के तल पर क्षैतिज रूप से सीधा बैठता है। हवा की थैली छोटी होती है। (100% सुरक्षित एवं पौष्टिक).
                  </div>

                  <div className="p-2.5 rounded-xl bg-red-50 border border-red-200">
                    <strong className="text-red-900 block font-bold">2. बासी / खराब अंडा (Spoiled Floating Egg):</strong>
                    पानी की सतह पर ऊपर तैरने लगता है। बैक्टीरिया गैस बनने से घनत्व घट जाता है। (सेवन न करें!).
                  </div>
                </div>

                <button
                  type="button"
                  onClick={() => setShowFloatModal(false)}
                  className="w-full py-2.5 bg-[#1B5E20] text-white rounded-xl font-bold text-xs"
                >
                  समझ गया (Understood)
                </button>
              </div>
            </div>
          )}

          {/* LEGAL TERMS & CONDITIONS MODAL (Login Gate) */}
          {showLoginLegalModal && (
            <div className="absolute inset-0 bg-slate-950/80 backdrop-blur-xs z-50 flex flex-col justify-end animate-fadeIn">
              <div className="bg-white rounded-t-3xl max-h-[85%] flex flex-col shadow-2xl border-t border-slate-200">
                <div className="p-4 border-b border-slate-100 flex items-center justify-between bg-slate-50 rounded-t-3xl">
                  <div className="flex items-center space-x-2">
                    <div className="w-8 h-8 rounded-lg bg-emerald-100 text-emerald-800 flex items-center justify-center">
                      <Scale className="w-4 h-4" />
                    </div>
                    <div>
                      <h3 className="text-xs font-black text-slate-900 tracking-tight">
                        {loginLegalModalTitle}
                      </h3>
                      <p className="text-[10px] text-slate-500 font-mono">IT Act 2000 • Sec 79 Intermediary</p>
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() => setShowLoginLegalModal(false)}
                    className="w-7 h-7 rounded-full bg-slate-200 text-slate-600 flex items-center justify-center"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>

                <div className="p-4 overflow-y-auto space-y-3 text-[11px] leading-relaxed text-slate-700">
                  <div className="bg-slate-50 rounded-xl p-2.5 border border-slate-200 space-y-0.5">
                    <strong className="block font-bold text-emerald-900">
                      1. Intermediary Platform Notice (IT Act 2000, Sec 79)
                    </strong>
                    <p className="text-slate-600">
                      AndaExpress operates solely as a digital mediator/technology aggregator connecting Buyers and Sellers.
                    </p>
                  </div>

                  <div className="bg-slate-50 rounded-xl p-2.5 border border-slate-200 space-y-0.5">
                    <strong className="block font-bold text-amber-900">
                      2. Dispute & Liability Disclaimer
                    </strong>
                    <p className="text-slate-600">
                      The platform is NOT a party to any transaction. Any dispute regarding product quality, pricing, delivery, payments, or damages is strictly between the Buyer and Seller.
                    </p>
                  </div>

                  <div className="bg-slate-50 rounded-xl p-2.5 border border-slate-200 space-y-0.5">
                    <strong className="block font-bold text-red-900">
                      3. Legal Immunity
                    </strong>
                    <p className="text-slate-600">
                      The App, its owners, operators, and affiliates hold zero liability or financial/legal obligation in any legal proceeding, cyber claim, or consumer dispute. Buyers and Sellers accept full sole responsibility.
                    </p>
                  </div>

                  <div className="bg-slate-50 rounded-xl p-2.5 border border-slate-200 space-y-0.5">
                    <strong className="block font-bold text-blue-900">
                      4. Mandatory Compliance
                    </strong>
                    <p className="text-slate-600">
                      Both parties must strictly adhere to platform guidelines (GPS verification, lay-date accuracy, Water Float Test refund policies).
                    </p>
                  </div>
                </div>

                <div className="p-3 border-t border-slate-100 bg-slate-50 rounded-b-3xl">
                  <button
                    type="button"
                    onClick={() => {
                      setLoginAgreedToTerms(true);
                      setShowLoginLegalModal(false);
                    }}
                    className="w-full py-2 bg-emerald-800 text-white rounded-xl font-bold text-xs shadow-md"
                  >
                    I Agree & Accept Terms
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* Success Toasts */}
          {orderPlacedSuccess && (
            <div className="absolute inset-0 bg-emerald-950/90 backdrop-blur-xs z-50 flex flex-col items-center justify-center p-6 text-white text-center animate-fadeIn">
              <CheckCircle2 className="w-12 h-12 text-emerald-400 mb-2" />
              <h3 className="text-base font-bold">ऑर्डर सफलतापूर्वक दर्ज हुआ!</h3>
              <p className="text-xs text-emerald-200 mt-1 max-w-[220px]">
                Support Fee ₹{platformFee} applied under active Firebase slab. Delivery assigned via {orderType}.
              </p>
            </div>
          )}

          {disputeSubmitted && (
            <div className="absolute inset-0 bg-red-950/90 backdrop-blur-xs z-50 flex flex-col items-center justify-center p-6 text-white text-center animate-fadeIn">
              <ShieldCheck className="w-12 h-12 text-emerald-400 mb-2" />
              <h3 className="text-base font-bold">विवाद क्लेम दर्ज किया गया!</h3>
              <p className="text-xs text-red-200 mt-1 max-w-[220px]">
                Water float test live photo verified. 100% refund initiated for {disputeOrderId}.
              </p>
            </div>
          )}

          {batchPublishedSuccess && (
            <div className="absolute inset-0 bg-emerald-950/95 backdrop-blur-xs z-50 flex flex-col items-center justify-center p-6 text-white text-center animate-fadeIn">
              <CheckCircle className="w-14 h-14 text-emerald-400 mb-2 animate-bounce" />
              <h3 className="text-base font-black">अंडा बैच सफलतापूर्वक प्रकाशित!</h3>
              <p className="text-xs text-amber-300 font-mono mt-1 font-bold">
                {lastPublishedBatch?.batchCode} • {lastPublishedBatch?.trays} Trays (₹{lastPublishedBatch?.totalValue})
              </p>
              <div className="mt-2 text-[10px] bg-emerald-900/80 border border-emerald-700/60 p-2.5 rounded-xl text-emerald-100 max-w-[260px] text-left space-y-1">
                <div>✓ Cloudinary Live Proof Uploaded (200 OK)</div>
                <div>✓ GPS Stamped: Paras to Akola Route</div>
                <div>✓ Delivery: {lastPublishedBatch?.deliveryMode === 'farm_pickup' ? 'Farm Self-Pickup (₹0)' : `Commuter Delivery (₹${lastPublishedBatch?.deliveryFee})`}</div>
                <div className="text-amber-200 font-semibold">✓ ₹2 Fixed Platform Fee (Deducted only upon delivery)</div>
              </div>
              <p className="text-[10px] text-slate-300 mt-2 font-medium">ग्राहक होम फीड में जोड़ा गया...</p>
            </div>
          )}

          {/* Commuter Alert Toast / Head-Up Notification */}
          {commuterAlertToast.show && (
            <div className="absolute top-12 inset-x-3 bg-slate-900/95 text-white p-3.5 rounded-2xl border border-amber-500/50 shadow-2xl z-50 animate-fadeIn backdrop-blur-md space-y-1.5">
              <div className="flex items-center space-x-2">
                {commuterAlertToast.type === 'fcm' && <BellRing className="w-4 h-4 text-amber-400 animate-bounce" />}
                {commuterAlertToast.type === 'whatsapp' && <MessageCircle className="w-4 h-4 text-emerald-400" />}
                {commuterAlertToast.type === 'call' && <Phone className="w-4 h-4 text-cyan-400" />}
                {commuterAlertToast.type === 'hub' && <Store className="w-4 h-4 text-amber-400" />}
                {commuterAlertToast.type === 'delivered' && <CheckCircle className="w-4 h-4 text-emerald-400" />}
                <span className="font-bold text-xs text-white">{commuterAlertToast.title}</span>
              </div>
              <p className="text-[10.5px] text-slate-300 leading-tight">
                {commuterAlertToast.desc}
              </p>
            </div>
          )}

          {/* UPI RECHARGE MODAL */}
          {showUpiModal && (
            <div className="absolute inset-0 bg-slate-950/80 backdrop-blur-xs z-50 p-4 flex flex-col justify-end animate-fadeIn">
              <div className="bg-white rounded-3xl p-5 space-y-3.5 text-slate-900 shadow-2xl border border-slate-200">
                <div className="flex items-center justify-between pb-2 border-b border-slate-100">
                  <div className="flex items-center space-x-2">
                    <div className="w-8 h-8 rounded-xl bg-emerald-100 text-[#1B5E20] flex items-center justify-center font-bold">
                      ₹
                    </div>
                    <div>
                      <h3 className="text-xs font-black text-slate-900">UPI वॉलेट रिचार्ज (Top-up)</h3>
                      <p className="text-[10px] text-slate-500 font-mono">VPA: andaexpress@icici</p>
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() => setShowUpiModal(false)}
                    className="w-7 h-7 rounded-full bg-slate-100 flex items-center justify-center font-bold text-slate-600 hover:bg-slate-200"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>

                <div className="text-center py-1">
                  <div className="text-xs text-slate-500">रिचार्ज राशि (Recharge Amount):</div>
                  <div className="text-2xl font-black font-mono text-[#1B5E20] mt-0.5">
                    ₹{selectedTopUpAmount}.00
                  </div>
                </div>

                {/* Simulated QR Code Box */}
                <div className="bg-slate-50 p-3.5 rounded-2xl border border-slate-200 flex flex-col items-center justify-center space-y-2">
                  <div className="w-28 h-28 bg-white border-2 border-slate-800 rounded-xl p-1.5 shadow-sm flex items-center justify-center relative">
                    <div className="w-full h-full bg-slate-950 rounded-lg p-1 grid grid-cols-6 grid-rows-6 gap-0.5">
                      {Array.from({ length: 36 }).map((_, i) => (
                        <div
                          key={i}
                          className={`rounded-xs ${
                            (i % 7 === 0 || i % 5 === 0 || i < 6 || i > 30 || i % 6 === 0)
                              ? 'bg-white'
                              : 'bg-emerald-400'
                          }`}
                        />
                      ))}
                    </div>
                    <div className="absolute inset-0 flex items-center justify-center">
                      <div className="w-6 h-6 rounded-md bg-white border border-slate-300 flex items-center justify-center text-[10px] font-bold">
                        🥚
                      </div>
                    </div>
                  </div>
                  <div className="text-[9.5px] font-bold text-slate-600">
                    Google Pay • PhonePe • Paytm • BHIM UPI
                  </div>
                </div>

                <div className="text-[10px] text-slate-500 text-center leading-relaxed">
                  भुगतान सफल होते ही ₹{selectedTopUpAmount}.00 आपके विक्रेता खाते में स्वतः जुड़ जाएंगे।
                </div>

                <div className="grid grid-cols-2 gap-2 pt-1">
                  <button
                    type="button"
                    onClick={() => setShowUpiModal(false)}
                    className="py-2.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs"
                  >
                    रद्द करें
                  </button>
                  <button
                    type="button"
                    onClick={() => processUpiRecharge(selectedTopUpAmount)}
                    className="py-2.5 rounded-xl bg-[#1B5E20] hover:bg-emerald-900 text-white font-bold text-xs shadow-md flex items-center justify-center space-x-1"
                  >
                    <Check className="w-3.5 h-3.5" />
                    <span>भुगतान सत्यापित करें</span>
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* Wallet Success Toast */}
          {walletSuccessToast.show && (
            <div className="absolute top-12 inset-x-3 bg-emerald-950 text-white p-3 rounded-2xl border border-emerald-500/60 shadow-2xl z-50 animate-fadeIn backdrop-blur-md flex items-center space-x-2.5">
              <CheckCircle2 className="w-5 h-5 text-emerald-400 shrink-0" />
              <div className="text-[11px] font-bold leading-tight">
                {walletSuccessToast.message}
              </div>
            </div>
          )}
          {/* 4-Party Real-Time Interconnection Sync Toast */}
          {syncToast.show && (
            <div className={`absolute top-12 inset-x-3 text-white p-3 rounded-2xl shadow-2xl z-50 animate-fadeIn backdrop-blur-md flex items-center space-x-2.5 border ${
              syncToast.type === 'success'
                ? 'bg-emerald-950/95 border-emerald-500/80 ring-1 ring-emerald-400'
                : syncToast.type === 'warning'
                ? 'bg-amber-950/95 border-amber-500/80 ring-1 ring-amber-400'
                : 'bg-blue-950/95 border-blue-500/80 ring-1 ring-blue-400'
            }`}>
              {syncToast.type === 'success' && <CheckCircle2 className="w-5 h-5 text-emerald-400 shrink-0" />}
              {syncToast.type === 'warning' && <AlertTriangle className="w-5 h-5 text-amber-400 shrink-0" />}
              {syncToast.type === 'info' && <Store className="w-5 h-5 text-blue-400 shrink-0" />}
              <div className="flex-1">
                <div className="text-[11px] font-bold leading-tight">{syncToast.title}</div>
                <div className="text-[9.5px] text-slate-300 mt-0.5 leading-tight">{syncToast.desc}</div>
              </div>
            </div>
          )}

          {/* BOTTOM NAVIGATION BAR */}
          <div className="absolute bottom-0 inset-x-0 h-14 bg-white border-t border-slate-200 px-2 flex items-center justify-around z-30 shadow-md">
            <button
              onClick={() => navigateTo('home')}
              className={`flex flex-col items-center py-1 px-2 transition-all ${
                currentScreen === 'home' ? 'text-[#1B5E20] font-bold' : 'text-slate-400'
              }`}
            >
              <Home className="w-4 h-4" />
              <span className="text-[9px] mt-0.5">Home Feed</span>
            </button>

            <button
              onClick={() => navigateTo('checkout')}
              className={`flex flex-col items-center py-1 px-2 relative transition-all ${
                currentScreen === 'checkout' ? 'text-[#1B5E20] font-bold' : 'text-slate-400'
              }`}
            >
              <ShoppingBag className="w-4 h-4" />
              <span className="text-[9px] mt-0.5">Checkout</span>
              {totalCartCount > 0 && (
                <span className="absolute top-1 right-2 w-2 h-2 rounded-full bg-red-500"></span>
              )}
            </button>

            <button
              onClick={() => navigateTo('dispute')}
              className={`flex flex-col items-center py-1 px-2 transition-all ${
                currentScreen === 'dispute' ? 'text-red-600 font-bold' : 'text-slate-400'
              }`}
            >
              <AlertTriangle className="w-4 h-4" />
              <span className="text-[9px] mt-0.5">Dispute</span>
            </button>

            <button
              onClick={() => navigateTo('seller-upload')}
              className={`flex flex-col items-center py-1 px-2 transition-all ${
                currentScreen === 'seller-upload' ? 'text-amber-600 font-bold' : 'text-slate-400'
              }`}
            >
              <Camera className="w-4 h-4" />
              <span className="text-[9px] mt-0.5">Seller Batch</span>
            </button>

            <button
              onClick={() => navigateTo('login')}
              className={`flex flex-col items-center py-1 px-2 transition-all ${
                currentScreen === 'login' ? 'text-[#1B5E20] font-bold' : 'text-slate-400'
              }`}
            >
              <User className="w-4 h-4" />
              <span className="text-[9px] mt-0.5">Login</span>
            </button>
          </div>

          {/* Android Home Bar */}
          <div className="h-2 flex items-center justify-center pb-1 bg-white">
            <div className="w-28 h-1 bg-slate-300 rounded-full"></div>
          </div>
        </div>
      </div>
    </div>
  );
};
