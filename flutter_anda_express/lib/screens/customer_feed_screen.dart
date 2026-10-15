import 'package:flutter/material.dart';
import '../models/product_model.dart';

/// Customer Home Feed Screen for AndaExpress
/// Displays nearby farm-fresh egg & chicken lots with GPS distance,
/// verified fresh badges, lay date countdown, and Water Float Test education.
class CustomerFeedScreen extends StatefulWidget {
  final Function(String productId) onAddToCart;
  final VoidCallback onOpenFloatTestGuide;

  const CustomerFeedScreen({
    super.key,
    required this.onAddToCart,
    required this.onOpenFloatTestGuide,
  });

  @override
  State<CustomerFeedScreen> createState() => _CustomerFeedScreenState();
}

class _CustomerFeedScreenState extends State<CustomerFeedScreen> {
  String _selectedCategory = 'all';

  // Sample farm lots
  final List<Map<String, dynamic>> _mockProducts = [
    {
      'id': 'prod_desi_egg_30',
      'title': 'देसी फ्री-रेंज अंडे (Desi Free-Range Eggs)',
      'seller_name': 'शर्मा ऑर्गेनिक पोल्ट्री फार्म',
      'category': 'eggs',
      'egg_type': 'desi',
      'price': 340,
      'stock': 120,
      'lay_date': '2026-09-28',
      'batch_code': '#EGG-842',
      'distance_km': 2.4,
      'verified': true,
      'photo_url': 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400',
    },
    {
      'id': 'prod_kadaknath_egg_12',
      'title': 'कड़कनाथ ब्लैक अंडे (Pure Kadaknath Eggs)',
      'seller_name': 'झाबुआ कड़कनाथ ब्रीडर्स',
      'category': 'eggs',
      'egg_type': 'kadaknath',
      'price': 480,
      'stock': 45,
      'lay_date': '2026-09-29',
      'batch_code': '#KAD-119',
      'distance_km': 4.1,
      'verified': true,
      'photo_url': 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
    },
    {
      'id': 'prod_layer_egg_30',
      'title': 'फ्रेश फार्म लेयर अंडे (Farm Layer Brown Eggs)',
      'seller_name': 'ग्रीन वैली पोल्ट्री फार्म',
      'category': 'eggs',
      'egg_type': 'layer',
      'price': 210,
      'stock': 300,
      'lay_date': '2026-09-29',
      'batch_code': '#EGG-843',
      'distance_km': 1.8,
      'verified': true,
      'photo_url': 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // GPS Location & Verification Banner
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1B5E20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Color(0xFFF59E0B), size: 18),
                      SizedBox(width: 6),
                      Text(
                        'डिलीवरी: सेक्टर 14, गुरुग्राम • 2.4 किमी दायरा',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Water Float Test Info Trigger
                  InkWell(
                    onTap: widget.onOpenFloatTestGuide,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.parseBorder(Border.all(color: Colors.white24)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.science, color: Color(0xFFF59E0B), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '🥚 100% ताज़गी गारंटी: पानी में फ्लोट टेस्ट गाइड देखें',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildCategoryChip('all', 'सभी उत्पाद'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('desi', 'देसी अंडे (Desi)'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('kadaknath', 'कड़कनाथ (Kadaknath)'),
                ],
              ),
            ),
          ),

          // Product List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = _mockProducts[index];
                return _buildProductCard(product);
              },
              childCount: _mockProducts.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label) {
    final isSelected = _selectedCategory == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedCategory = id),
      selectedColor: const Color(0xFF1B5E20),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product['photo_url'],
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '✓ Verified Fresh',
                        style: TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${product['distance_km']} किमी',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  product['seller_name'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${product['price']}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.extrabold, color: Color(0xFF1B5E20)),
                        ),
                        Text(
                          'Lay: ${product['lay_date']}',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => widget.onAddToCart(product['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add_shopping_cart, size: 14),
                      label: const Text('जोड़ें (Add)', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
