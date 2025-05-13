import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/course_model.dart';
import '../models/cart_model.dart';
import '../screens/course_details_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isDetailCard;
  final VoidCallback? onTap;
  
  const CourseCard({
    super.key,
    required this.course,
    this.isDetailCard = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final isInCart = cartModel.isInCart(course);
    
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(course: course),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Image with Bookmark Icon
                Stack(
                  children: [
                    // Course Image Placeholder
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        color: _getColorForCourse(course.id),
                        child: Center(
                          child: Icon(
                            _getIconForCourse(course.tags.first),
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    
                    // Bookmark Icon
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            course.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            size: 20,
                            color: course.isBookmarked ? const Color(0xFF1A1A67) : Colors.grey,
                          ),
                          onPressed: () {
                            // Handle bookmark toggle
                          },
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    
                    // Highly Enrolled Tag
                    if (course.isHighlyEnrolled)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Highly Enrolled',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                // Course Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Course Title
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Rating and Enrollment
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
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '(${course.enrolledCount})',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Course Price
                        Text(
                          '₹${course.price.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1A1A67),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Add to Cart Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isInCart) {
                                cartModel.removeItem(course);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Removed from cart'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                cartModel.addItem(course);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to cart'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isInCart ? Colors.white : const Color(0xFF1A1A67),
                              foregroundColor: isInCart ? const Color(0xFF1A1A67) : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: const Color(0xFF1A1A67),
                                  width: isInCart ? 1 : 0,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              elevation: isInCart ? 0 : 2,
                            ),
                            child: Text(
                              isInCart ? 'Remove' : 'Add to Cart',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
  
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
  
  IconData _getIconForCourse(String tag) {
    switch (tag) {
      case 'AI & ML':
        return Icons.psychology;
      case 'Data Science':
        return Icons.analytics;
      case 'UI/UX':
        return Icons.design_services;
      case 'Product':
        return Icons.category;
      case 'Programming':
        return Icons.code;
      case 'Public Speaking':
        return Icons.record_voice_over;
      case 'Communication':
        return Icons.chat;
      default:
        return Icons.school;
    }
  }
}
