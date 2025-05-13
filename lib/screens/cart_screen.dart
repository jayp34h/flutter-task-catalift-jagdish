import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../models/cart_model.dart';
import '../models/course_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF1A1A67),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF1A1A67),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (cartModel.itemCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Clear Cart',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A67),
                          ),
                        ),
                      ),
                      content: const Text('Are you sure you want to remove all items from your cart?'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cartModel.clearCart();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cart cleared'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: cartModel.itemCount == 0
          ? _buildEmptyCart(context)
          : _buildCartWithItems(context, cartModel),
    );
  }

  // Extracted method for empty cart UI - improves code readability and maintenance
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/empty_cart.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true,
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A67),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Add courses to your cart to purchase them',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A67),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Browse Courses',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted method for cart with items - improves code organization
  Widget _buildCartWithItems(BuildContext context, CartModel cartModel) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartModel.items.length,
            itemBuilder: (context, index) {
              final course = cartModel.items[index];
              return _buildCartItem(context, course, cartModel);
            },
          ),
        ),
        _buildCheckoutSection(context, cartModel),
      ],
    );
  }

  // Extracted method for cart item - improves reusability
  Widget _buildCartItem(BuildContext context, Course course, CartModel cartModel) {
    return Dismissible(
      key: Key(course.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (direction) {
        cartModel.removeItem(course);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${course.title} removed from cart'),
            duration: const Duration(seconds: 1),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                cartModel.addItem(course);
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image with Gradient Background
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getColorForCourse(course.id),
                          _getColorForCourse(course.id).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _getColorForCourse(course.id).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForCourse(course.tags.first),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  if (course.isHighlyEnrolled)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Popular',
                          style: TextStyle(
                            color: _getColorForCourse(course.id),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              
              // Course Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1A1A67),
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        Text(
                          ' ${course.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '(${course.enrolledCount})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            course.instructorName,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${course.price.toInt()}',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1A1A67),
                            ),
                          ),
                        ),
                        // Remove Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              cartModel.removeItem(course);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${course.title} removed from cart'),
                                  duration: const Duration(seconds: 1),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      cartModel.addItem(course);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted method for checkout section - improves maintainability
  Widget _buildCheckoutSection(BuildContext context, CartModel cartModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coupon Code
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.discount_outlined,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Apply coupon code
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1A1A67),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Price Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade100,
              ),
            ),
            child: Column(
              children: [
                _buildPriceRow(
                  'Subtotal (${cartModel.itemCount} ${cartModel.itemCount == 1 ? 'item' : 'items'})',
                  '₹${cartModel.totalPrice.toInt()}',
                  isTotal: false,
                ),
                const SizedBox(height: 12),
                _buildPriceRow(
                  'Discount',
                  '₹0',
                  isTotal: false,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Colors.grey),
                ),
                _buildPriceRow(
                  'Total:',
                  '₹${cartModel.totalPrice.toInt()}',
                  isTotal: true,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Handle checkout
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Checkout',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A67),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/animations/success.json',
                          width: 120,
                          height: 120,
                          repeat: false,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your order has been placed successfully!',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    actions: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            cartModel.clearCart();
                            Navigator.pop(context); // Return to course details
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A67),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Continue Shopping',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A67),
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Checkout',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for price rows - reduces code duplication
  Widget _buildPriceRow(String label, String value, {required bool isTotal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: isTotal ? Colors.black : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 22 : 14,
              color: isTotal ? const Color(0xFF1A1A67) : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to get color for course - improves code organization
  Color _getColorForCourse(String id) {
    switch (id) {
      case '1':
        return Colors.blue.shade700;
      case '2':
        return Colors.purple.shade700;
      case '3':
        return Colors.orange.shade700;
      case '4':
        return Colors.green.shade700;
      case '5':
        return Colors.red.shade700;
      default:
        return Colors.indigo.shade700;
    }
  }

  // Helper method to get icon for course - improves code organization
  IconData _getIconForCourse(String tag) {
    switch (tag.toLowerCase()) {
      case 'programming':
        return Icons.code;
      case 'design':
        return Icons.brush;
      case 'business':
        return Icons.business;
      case 'marketing':
        return Icons.trending_up;
      case 'photography':
        return Icons.camera_alt;
      case 'music':
        return Icons.music_note;
      case 'ai':
      case 'artificial intelligence':
        return Icons.psychology;
      default:
        return Icons.school;
    }
  }
}
