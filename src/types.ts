export interface PlatformFeeSlab {
  min: number;
  max: number;
  fee: number;
}

export interface UserEntity {
  uid: string;
  phone: string;
  role: 'buyer' | 'seller' | 'admin';
  name: string;
  address: string;
  geo_point: {
    latitude: number;
    longitude: number;
  };
  status: 'active' | 'suspended' | 'pending_verification';
  created_at?: string;
  updated_at?: string;
}

export interface ProductEntity {
  product_id: string;
  seller_id: string;
  category: 'eggs' | 'chicken' | 'combo' | 'feed';
  egg_type: 'desi' | 'organic' | 'broiler_table' | 'free_range' | 'kadaknath' | 'quail' | 'duck' | 'none';
  price: number;
  stock: number;
  lay_date: string;
  expiry_date: string;
  unique_batch_code: string;
  photo_url: string;
  network_timestamp: string;
  gps_lat_long: {
    latitude: number;
    longitude: number;
  };
  farm_name?: string;
}

export interface OrderItem {
  product_id: string;
  title: string;
  egg_type: string;
  unit_price: number;
  quantity: number;
  subtotal: number;
}

export interface OrderEntity {
  order_id: string;
  buyer_id: string;
  seller_id: string;
  items: OrderItem[];
  item_amount: number;
  platform_fee: number;
  order_type: 'Pickup' | 'Courier';
  payment_mode: 'cod' | 'upi' | 'card' | 'wallet';
  status: 'pending' | 'confirmed' | 'packed' | 'out_for_delivery' | 'delivered' | 'cancelled' | 'disputed';
  network_timestamp: string;
}

export interface AppSettingsEntity {
  platform_fee_slabs: PlatformFeeSlab[];
  app_name: string;
  support_phone: string;
  freshness_guarantee_days: number;
  updated_at: string;
  updated_by: string;
}

export interface DisputeEntity {
  dispute_id: string;
  order_id: string;
  buyer_id: string;
  seller_id: string;
  reason: string;
  float_test_proof_photo_url: string;
  status: 'opened' | 'under_review' | 'resolved_refund' | 'rejected';
  admin_remarks: string;
  created_at?: string;
  updated_at?: string;
}

export interface SecurityTestCase {
  id: string;
  title: string;
  category: 'Fee Integrity' | 'Role Escalation' | 'Terminal State' | 'Float Test Proof' | 'PII Isolation' | 'Denial of Wallet';
  actor: string;
  targetCollection: string;
  attemptDescription: string;
  payload: Record<string, any>;
  expectedResult: 'DENIED' | 'ALLOWED';
  matchedRuleHelper: string;
  vulnerabilityPrevented: string;
}
