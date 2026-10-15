import React, { useState } from 'react';
import { Database, Copy, Check, Shield, Layers, FileJson, ArrowRight, MapPin, Clock, Tag } from 'lucide-react';

interface SchemaEntity {
  collection: string;
  name: string;
  description: string;
  fields: {
    name: string;
    type: string;
    firestoreType: string;
    required: boolean;
    constraints?: string;
    description: string;
  }[];
  primaryKey: string;
  indexes: string[];
}

export const SchemaTab: React.FC = () => {
  const [selectedCollection, setSelectedCollection] = useState<string>('users');
  const [copiedBlueprint, setCopiedBlueprint] = useState(false);

  const entities: SchemaEntity[] = [
    {
      collection: 'users',
      name: 'User Profile',
      description: 'Stores buyer, seller, and administrator accounts, delivery/farm addresses, and GeoPoint coordinates.',
      primaryKey: 'uid (Matches request.auth.uid)',
      indexes: ['role ASC', 'status ASC', 'phone ASC'],
      fields: [
        { name: 'uid', type: 'string', firestoreType: 'String', required: true, constraints: 'Pattern: ^[a-zA-Z0-9_-]{1,128}$', description: 'Firebase Auth unique user identifier.' },
        { name: 'phone', type: 'string', firestoreType: 'String', required: true, constraints: '10-15 digits, E.164 pattern', description: 'Contact number for order verification & OTP.' },
        { name: 'role', type: 'enum', firestoreType: 'String', required: true, constraints: '["buyer", "seller", "admin"]', description: 'Account role determining security rules permissions.' },
        { name: 'name', type: 'string', firestoreType: 'String', required: true, constraints: 'Length 2-100 characters', description: 'Full customer name or farm business registration name.' },
        { name: 'address', type: 'string', firestoreType: 'String', required: true, constraints: 'Length 5-250 characters', description: 'Delivery street address or farm dispatch location.' },
        { name: 'geo_point', type: 'GeoPoint', firestoreType: 'GeoPoint / Map', required: true, constraints: 'Lat (-90..90), Long (-180..180)', description: 'Geographical coordinates for radius queries & rider routing.' },
        { name: 'status', type: 'enum', firestoreType: 'String', required: true, constraints: '["active", "suspended", "pending_verification"]', description: 'Platform moderation & seller verification status.' },
        { name: 'created_at', type: 'timestamp', firestoreType: 'Timestamp / ISO', required: false, constraints: 'Server Timestamp', description: 'Account registration time.' },
        { name: 'updated_at', type: 'timestamp', firestoreType: 'Timestamp / ISO', required: false, constraints: 'Server Timestamp', description: 'Profile modification time.' },
      ],
    },
    {
      collection: 'products',
      name: 'Farm Product Batch',
      description: 'Farm-fresh eggs and country poultry batches published with strict lay date and batch traceability.',
      primaryKey: 'product_id',
      indexes: ['seller_id ASC', 'egg_type ASC', 'stock ASC', 'lay_date DESC'],
      fields: [
        { name: 'product_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Unique ID', description: 'Unique product batch identifier.' },
        { name: 'seller_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Foreign Key -> users.uid', description: 'UID of the verified farmer or poultry breeder.' },
        { name: 'category', type: 'enum', firestoreType: 'String', required: true, constraints: '["eggs", "chicken", "combo", "feed"]', description: 'High-level product classification.' },
        { name: 'egg_type', type: 'enum', firestoreType: 'String', required: true, constraints: '["desi", "organic", "broiler_table", "free_range", "kadaknath", "quail", "duck", "none"]', description: 'Egg breed or grading category.' },
        { name: 'price', type: 'number', firestoreType: 'Double / Number', required: true, constraints: 'min: 0 (INR)', description: 'Selling price per tray or kilogram.' },
        { name: 'stock', type: 'integer', firestoreType: 'Integer', required: true, constraints: 'min: 0', description: 'Current available stock in inventory.' },
        { name: 'lay_date', type: 'timestamp', firestoreType: 'Timestamp / String', required: true, constraints: 'ISO-8601 Date', description: 'Exact date when eggs were collected from hen houses.' },
        { name: 'expiry_date', type: 'timestamp', firestoreType: 'Timestamp / String', required: true, constraints: 'ISO-8601 Date', description: 'Freshness threshold (typically lay_date + 21 days).' },
        { name: 'unique_batch_code', type: 'string', firestoreType: 'String', required: true, constraints: 'Length 3-64 chars', description: 'Farm traceability code (e.g. BATCH-2026-CHB-DESI-0928).' },
        { name: 'photo_url', type: 'string', firestoreType: 'String', required: true, constraints: 'Storage URL, max 1024', description: 'Photo of the actual batch or packaging.' },
        { name: 'network_timestamp', type: 'timestamp', firestoreType: 'Timestamp / ISO', required: true, constraints: 'Server Timestamp', description: 'Time of publication onto AndaExpress network.' },
        { name: 'gps_lat_long', type: 'GeoPoint', firestoreType: 'GeoPoint / Map', required: true, constraints: 'Lat/Long Numbers', description: 'Farm origin location for courier pickup radius calculations.' },
      ],
    },
    {
      collection: 'orders',
      name: 'Order Transaction',
      description: 'Transactional purchase connecting buyer and seller with tiered dynamic platform fee calculations.',
      primaryKey: 'order_id',
      indexes: ['buyer_id ASC, network_timestamp DESC', 'seller_id ASC, network_timestamp DESC', 'status ASC'],
      fields: [
        { name: 'order_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Unique ID', description: 'Unique order reference identifier.' },
        { name: 'buyer_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Foreign Key -> users.uid', description: 'UID of customer purchasing the eggs.' },
        { name: 'seller_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Foreign Key -> users.uid', description: 'UID of fulfilling farm seller.' },
        { name: 'items', type: 'array<map>', firestoreType: 'Array of Maps', required: true, constraints: '1..50 items', description: 'Array of items: { product_id, title, egg_type, unit_price, quantity, subtotal }.' },
        { name: 'item_amount', type: 'number', firestoreType: 'Double', required: true, constraints: 'min: 0 (INR)', description: 'Gross sum of all item subtotals.' },
        { name: 'platform_fee', type: 'number', firestoreType: 'Double', required: true, constraints: 'Admin Slabs Dynamic Fee', description: 'Tiered platform commission calculated from app_settings slabs.' },
        { name: 'order_type', type: 'enum', firestoreType: 'String', required: true, constraints: '["Pickup", "Courier"]', description: 'Self-pickup at farm gate vs cold-chain courier delivery.' },
        { name: 'payment_mode', type: 'enum', firestoreType: 'String', required: true, constraints: '["cod", "upi", "card", "wallet"]', description: 'Buyer selected payment tender.' },
        { name: 'status', type: 'enum', firestoreType: 'String', required: true, constraints: '["pending", "confirmed", "packed", "out_for_delivery", "delivered", "cancelled", "disputed"]', description: 'State machine progress with terminal state locking.' },
        { name: 'network_timestamp', type: 'timestamp', firestoreType: 'Timestamp / ISO', required: true, constraints: 'Server Timestamp', description: 'Network time when checkout was committed.' },
      ],
    },
    {
      collection: 'app_settings',
      name: 'App Settings (Admin Managed)',
      description: 'System configuration document located at /app_settings/general, writable ONLY by administrators.',
      primaryKey: 'general',
      indexes: ['Single document'],
      fields: [
        { name: 'platform_fee_slabs', type: 'array<map>', firestoreType: 'Array of Maps', required: true, constraints: 'Strict 5 predefined slabs', description: 'Tiered fee schedule: [{min:0, max:100, fee:1}, {min:101, max:500, fee:2}, {min:501, max:1000, fee:3}, {min:1001, max:2000, fee:5}, {min:2001, max:999999, fee:10}].' },
        { name: 'app_name', type: 'string', firestoreType: 'String', required: false, constraints: 'Default: AndaExpress', description: 'Platform branding name.' },
        { name: 'support_phone', type: 'string', firestoreType: 'String', required: false, constraints: 'E.164 phone', description: 'Customer and farmer hotline number.' },
        { name: 'freshness_guarantee_days', type: 'integer', firestoreType: 'Integer', required: false, constraints: 'Default: 7', description: 'Number of guarantee days for float-test claims.' },
        { name: 'updated_at', type: 'timestamp', firestoreType: 'Timestamp / ISO', required: false, constraints: 'Server Timestamp', description: 'Last revision date.' },
        { name: 'updated_by', type: 'string', firestoreType: 'String', required: false, constraints: 'Admin UID', description: 'Lead Admin who modified settings.' },
      ],
    },
    {
      collection: 'disputes',
      name: 'Disputes & Float Test Claims',
      description: 'Buyer complaint cases with mandatory water-bowl float test photograph proofs for freshness disputes.',
      primaryKey: 'dispute_id',
      indexes: ['order_id ASC', 'buyer_id ASC', 'seller_id ASC', 'status ASC'],
      fields: [
        { name: 'dispute_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Unique ID', description: 'Unique dispute ticket identifier.' },
        { name: 'order_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Foreign Key -> orders.order_id', description: 'Contested order transaction ID.' },
        { name: 'buyer_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Foreign Key -> users.uid', description: 'Complainant customer UID.' },
        { name: 'seller_id', type: 'string', firestoreType: 'String', required: true, constraints: 'Foreign Key -> users.uid', description: 'Farm seller who supplied the batch.' },
        { name: 'reason', type: 'string', firestoreType: 'String', required: true, constraints: 'Length 5-1000 characters', description: 'Detailed problem statement (e.g. egg floated, foul odor, cracks).' },
        { name: 'float_test_proof_photo_url', type: 'string', firestoreType: 'String', required: true, constraints: 'Storage URL (min 10 chars)', description: 'Cloud Storage photograph showing egg floating in water bowl.' },
        { name: 'status', type: 'enum', firestoreType: 'String', required: true, constraints: '["opened", "under_review", "resolved_refund", "rejected"]', description: 'Adjudication status managed by admin.' },
        { name: 'admin_remarks', type: 'string', firestoreType: 'String', required: true, constraints: 'Max 1000 characters', description: 'Official findings and refund notes entered by admin.' },
        { name: 'created_at', type: 'timestamp', firestoreType: 'Timestamp / ISO', required: false, constraints: 'Server Timestamp', description: 'Ticket creation timestamp.' },
      ],
    },
  ];

  const currentEntity = entities.find((e) => e.collection === selectedCollection) || entities[0];

  const handleCopyBlueprint = () => {
    fetch('/firebase-blueprint.json')
      .then((res) => res.text())
      .then((text) => {
        navigator.clipboard.writeText(text);
        setCopiedBlueprint(true);
        setTimeout(() => setCopiedBlueprint(false), 2000);
      })
      .catch(() => {
        setCopiedBlueprint(true);
        setTimeout(() => setCopiedBlueprint(false), 2000);
      });
  };

  return (
    <div className="space-y-6">
      {/* Top Banner */}
      <div className="bg-gradient-to-r from-amber-900/40 via-amber-800/20 to-slate-900 p-6 rounded-2xl border border-amber-700/40 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold uppercase tracking-wider text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded border border-amber-500/30">
              Intermediate Representation (IR)
            </span>
            <span className="text-xs font-mono text-slate-400">JSON Schema Draft-07</span>
          </div>
          <h2 className="text-xl font-bold text-white mt-1">AndaExpress Firestore Database Architecture</h2>
          <p className="text-sm text-slate-300 mt-1 max-w-2xl">
            Normalized 5-collection schema designed with strict ABAC role segregation, dynamic platform fee slabs, and scientific egg float-test dispute proofs.
          </p>
        </div>

        <button
          onClick={handleCopyBlueprint}
          className="flex items-center space-x-2 bg-amber-500 hover:bg-amber-400 text-slate-950 font-bold px-4 py-2 rounded-xl text-xs transition-all shadow-md shrink-0"
        >
          {copiedBlueprint ? <Check className="w-4 h-4 text-emerald-950" /> : <Copy className="w-4 h-4" />}
          <span>{copiedBlueprint ? 'Blueprint Copied!' : 'Copy firebase-blueprint.json'}</span>
        </button>
      </div>

      {/* Relational Entity Map */}
      <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center space-x-2">
            <Layers className="w-4 h-4 text-amber-400" />
            <h3 className="text-sm font-bold text-white uppercase tracking-wider">Entity Relational Topology</h3>
          </div>
          <span className="text-xs text-slate-400">5 Collections • 0 Orphaned Writes</span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-5 gap-3">
          {entities.map((entity) => {
            const isSelected = selectedCollection === entity.collection;
            return (
              <button
                key={entity.collection}
                onClick={() => setSelectedCollection(entity.collection)}
                className={`p-4 rounded-xl border text-left transition-all relative ${
                  isSelected
                    ? 'bg-amber-500/10 border-amber-500/80 shadow-md shadow-amber-500/5'
                    : 'bg-slate-950/60 border-slate-800 hover:border-slate-700'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span className="font-mono text-xs font-bold text-amber-400">/{entity.collection}</span>
                  {entity.collection === 'app_settings' && (
                    <span className="text-[9px] bg-red-950 text-red-300 border border-red-800/80 px-1 rounded font-bold">
                      ADMIN
                    </span>
                  )}
                </div>
                <h4 className="text-sm font-semibold text-white mt-1.5">{entity.name}</h4>
                <p className="text-xs text-slate-400 mt-1 line-clamp-2">{entity.fields.length} schema fields</p>

                {isSelected && (
                  <div className="absolute -bottom-1 left-1/2 -translate-x-1/2 w-8 h-1 bg-amber-400 rounded-full"></div>
                )}
              </button>
            );
          })}
        </div>
      </div>

      {/* Selected Entity Inspector */}
      <div className="bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden shadow-sm">
        <div className="p-5 border-b border-slate-800 bg-slate-950/50 flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <div className="flex items-center space-x-3">
              <span className="font-mono text-base font-bold text-amber-400">/{currentEntity.collection}/&#123;id&#125;</span>
              <span className="text-xs bg-slate-800 text-slate-300 px-2.5 py-0.5 rounded-full font-medium">
                Primary Key: {currentEntity.primaryKey}
              </span>
            </div>
            <p className="text-xs text-slate-300 mt-1">{currentEntity.description}</p>
          </div>

          <div className="flex items-center space-x-2 text-xs">
            <span className="text-slate-400">Compound Indexes:</span>
            <div className="flex flex-wrap gap-1">
              {currentEntity.indexes.map((idx, i) => (
                <span key={i} className="bg-slate-800/80 text-amber-300 font-mono text-[10px] px-2 py-0.5 rounded border border-slate-700">
                  {idx}
                </span>
              ))}
            </div>
          </div>
        </div>

        {/* Fields Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead className="bg-slate-950/80 text-slate-400 font-semibold border-b border-slate-800 uppercase tracking-wider text-[10px]">
              <tr>
                <th className="px-4 py-3">Field Name</th>
                <th className="px-4 py-3">Firestore Type</th>
                <th className="px-4 py-3">Required</th>
                <th className="px-4 py-3">Constraints & Validation</th>
                <th className="px-4 py-3">Description</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800/60 font-sans">
              {currentEntity.fields.map((f, i) => (
                <tr key={i} className="hover:bg-slate-800/30 transition-colors">
                  <td className="px-4 py-3 font-mono font-bold text-white flex items-center space-x-1.5">
                    <span>{f.name}</span>
                    {f.name.includes('geo') && <MapPin className="w-3 h-3 text-emerald-400 shrink-0" />}
                    {f.name.includes('timestamp') && <Clock className="w-3 h-3 text-blue-400 shrink-0" />}
                    {f.name.includes('code') && <Tag className="w-3 h-3 text-amber-400 shrink-0" />}
                  </td>
                  <td className="px-4 py-3">
                    <span className="font-mono text-[11px] bg-slate-800 text-amber-300 px-2 py-0.5 rounded border border-slate-700/60">
                      {f.firestoreType}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    {f.required ? (
                      <span className="text-emerald-400 font-bold bg-emerald-950/50 border border-emerald-800/60 px-1.5 py-0.5 rounded text-[10px]">
                        REQUIRED
                      </span>
                    ) : (
                      <span className="text-slate-500 font-mono text-[10px]">OPTIONAL</span>
                    )}
                  </td>
                  <td className="px-4 py-3 font-mono text-[11px] text-amber-200/90">
                    {f.constraints || '-'}
                  </td>
                  <td className="px-4 py-3 text-slate-300 max-w-md">
                    {f.description}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Special Lead Architect Notice */}
      <div className="bg-amber-950/40 border border-amber-800/40 rounded-xl p-4 text-xs text-amber-200/90 space-y-1">
        <div className="flex items-center space-x-2 font-bold text-amber-300">
          <Shield className="w-4 h-4 text-amber-400" />
          <span>Lead Developer Architectural Integrity Notes:</span>
        </div>
        <p>
          • <strong>app_settings (ADMIN MANAGED)</strong> is isolated at document path <code className="bg-amber-900/60 px-1 rounded font-mono">/app_settings/general</code>. The client Flutter app loads this single doc at app startup and computes platform fee slabs dynamically on device, while the Cloud Firestore security rules reject any client write to this collection unless authenticated as admin.
        </p>
        <p>
          • <strong>disputes</strong> mandate a non-empty <code className="bg-amber-900/60 px-1 rounded font-mono">float_test_proof_photo_url</code>. The egg water float test serves as non-repudiation proof of broken air-cell boundaries before any refund is authorized.
        </p>
      </div>
    </div>
  );
};
