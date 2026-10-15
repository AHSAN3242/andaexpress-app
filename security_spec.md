# AndaExpress Firestore Security Specification & TDD Matrix

## 1. Data Invariants
1. **Identity & Non-Repudiation**:
   - `users/{userId}` can only be created with `uid == request.auth.uid`. A user cannot elevate their own role to `admin` or change their `status` to `active` if pending verification.
   - `products/{productId}` can only be created by an authenticated `seller` or `admin`, with `seller_id == request.auth.uid`.
   - `orders/{orderId}` must have `buyer_id == request.auth.uid`. The buyer cannot alter `seller_id` or tamper with the `platform_fee`.
2. **Platform Fee Integrity**:
   - The `platform_fee` must strictly adhere to the `app_settings/general` slabs:
     - ₹0 - ₹100: Fee = ₹1
     - ₹101 - ₹500: Fee = ₹2
     - ₹501 - ₹1000: Fee = ₹3
     - ₹1001 - ₹2000: Fee = ₹5
     - ₹2001 - ₹999999: Fee = ₹10
   - Client modifications attempting `platform_fee: 0` on an order above ₹100 must be rejected.
3. **Float Test Proof Mandate on Disputes**:
   - Every dispute must be filed by the order's `buyer_id`.
   - The dispute must provide a non-empty `float_test_proof_photo_url` pointing to verifiable image storage when claiming freshness defects.
   - `admin_remarks` can only be modified by an administrator.
4. **Terminal Order State Locking**:
   - Once an order reaches `delivered` or `cancelled`, non-admin parties cannot modify order items, prices, or revert status.
   - Sellers can only progress order status from `pending` -> `confirmed` -> `packed` -> `out_for_delivery` -> `delivered`.
5. **Admin Sovereign Gate**:
   - `app_settings` (including `platform_fee_slabs`) is read-only for authenticated users and strictly write-protected for users holding the `admin` role or existing in `/admins/{uid}`.

---

## 2. The "Dirty Dozen" Malicious Payloads

### Payload 01: Ghost Fee Spoof (Buyer Tampering Platform Fee to 0)
- **Target**: `orders/ord_1001`
- **Actor**: `buyer_abc`
- **Attempt**: Setting `item_amount: 1500`, `platform_fee: 0` (Bypassing slab fee of ₹5).
- **Expected Outcome**: `PERMISSION_DENIED`.

### Payload 02: Seller Stock/Price Hijack
- **Target**: `products/prod_seller2_eggs`
- **Actor**: `seller_attacker`
- **Attempt**: Modifying price or stock of a batch owned by `seller_farmer_john`.
- **Expected Outcome**: `PERMISSION_DENIED` (Seller ID mismatch).

### Payload 03: Privilege Escalation to Admin
- **Target**: `users/attacker_uid`
- **Actor**: `attacker_uid`
- **Attempt**: Self-registering or updating profile with `"role": "admin"`.
- **Expected Outcome**: `PERMISSION_DENIED`.

### Payload 04: Dispute Filed Without Float-Test Photo Proof
- **Target**: `disputes/disp_901`
- **Actor**: `buyer_abc`
- **Attempt**: Submitting freshness dispute with `"float_test_proof_photo_url": ""`.
- **Expected Outcome**: `PERMISSION_DENIED` (String length minimum violated).

### Payload 05: Tampering Delivered Order (Post-Terminal Write)
- **Target**: `orders/ord_delivered_88`
- **Actor**: `seller_farm`
- **Attempt**: Changing `item_amount` or status from `delivered` back to `confirmed`.
- **Expected Outcome**: `PERMISSION_DENIED` (Terminal state lock).

### Payload 06: Malicious Admin Remarks Injection
- **Target**: `disputes/disp_901`
- **Actor**: `seller_farm` or `buyer_abc`
- **Attempt**: Setting `"admin_remarks": "Approved refund from seller funds"`.
- **Expected Outcome**: `PERMISSION_DENIED` (Admin-only field).

### Payload 07: Unauthenticated PII Scraping
- **Target**: `users/victim_uid`
- **Actor**: Unauthenticated anonymous user
- **Attempt**: Reading user's phone, delivery address, and GPS coordinates.
- **Expected Outcome**: `PERMISSION_DENIED`.

### Payload 08: Denial of Wallet via 2MB Batch Code
- **Target**: `products/prod_flood`
- **Actor**: `seller_bad`
- **Attempt**: Sending `unique_batch_code` with 2,000,000 bytes string to exhaust storage/indexing.
- **Expected Outcome**: `PERMISSION_DENIED` (Exceeds `maxLength: 64`).

### Payload 09: Impersonated Order Creation (Orphaned Order)
- **Target**: `orders/ord_fake`
- **Actor**: `buyer_abc`
- **Attempt**: Setting `"buyer_id": "victim_buyer_xyz"`.
- **Expected Outcome**: `PERMISSION_DENIED` (`incoming().buyer_id != request.auth.uid`).

### Payload 10: App Settings Fee Slabs Overwrite
- **Target**: `app_settings/general`
- **Actor**: `buyer_abc` or `seller_farm`
- **Attempt**: Overwriting `platform_fee_slabs` to set fees to 0 for all tiers.
- **Expected Outcome**: `PERMISSION_DENIED` (Requires verified admin status).

### Payload 11: Future/Past Client Timestamp Manipulation
- **Target**: `products/prod_101`
- **Actor**: `seller_farm`
- **Attempt**: Setting `network_timestamp: "1999-01-01T00:00:00Z"` to fake an ancient timestamp.
- **Expected Outcome**: `PERMISSION_DENIED` (Enforced `request.time`).

### Payload 12: Invalid GeoPoint Injection
- **Target**: `users/test_user`
- **Actor**: `test_user`
- **Attempt**: Sending `geo_point: { "latitude": "invalid_string", "longitude": 99999 }`.
- **Expected Outcome**: `PERMISSION_DENIED` (Enforced latitude/longitude number bounds).
