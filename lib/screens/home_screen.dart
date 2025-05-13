import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/course_model.dart';
import '../models/cart_model.dart';
import '../widgets/course_card.dart';
import 'cart_screen.dart';
import 'course_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<String> _filters = ['All', 'AI & ML', 'Product', 'UI/UX', 'Programming', 'Public Speaking'];
  String _selectedFilter = 'All';
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animation controller setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    
    // Auto-scroll the featured courses every 5 seconds
    Future.delayed(const Duration(seconds: 1), () {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        if (_currentPage < dummyCourses.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startAutoScroll();
      }
    });
  }

  // Get a gradient color based on course ID for visual variety
  LinearGradient _getGradientForCourse(String id) {
    switch (id) {
      case '1':
        return const LinearGradient(
          colors: [Color(0xFF1A1A67), Color(0xFF3D3D9D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '2':
        return const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '3':
        return const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '4':
        return const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '5':
        return const LinearGradient(
          colors: [Color(0xFFB71C1C), Color(0xFFF44336)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF1A1A67), Color(0xFF3D3D9D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    List<Course> filteredCourses = _selectedFilter == 'All'
        ? dummyCourses
        : dummyCourses.where((course) => course.tags.contains(_selectedFilter)).toList();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Cata',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A67),
                  ),
                ),
              ),
              TextSpan(
                text: 'lift',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3D3D9D),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Color(0xFF1A1A67),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                ),
              ),
              if (cartModel.itemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartModel.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for courses...',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF1A1A67),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Featured Courses
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 12.0),
                      child: Text(
                        'Featured Courses',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A67),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: dummyCourses.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final course = dummyCourses[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailsScreen(
                                    course: course,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getGradientForCourse(course.id).colors.first.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Background Gradient
                                  Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: _getGradientForCourse(course.id),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  
                                  // Gradient Overlay for better text visibility
                                  Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // Course Content
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Course Title
                                        Text(
                                          course.title,
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        // Course Rating and Enrollment
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                ' ${course.rating}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                '(${course.enrolledCount} enrolled)',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        // Tags
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: course.tags.map((tag) {
                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                tag,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const Spacer(),
                                        // Price
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '₹${course.price.toInt()}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 1,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                'View Details',
                                                style: TextStyle(
                                                  color: _getGradientForCourse(course.id).colors.first,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Bookmark Icon
                                  if (course.isBookmarked)
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.bookmark,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Page Indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          dummyCourses.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? const Color(0xFF1A1A67)
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Category Filters
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: _filters.length,
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = _selectedFilter == filter;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1A1A67)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1A1A67)
                                    : Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[800],
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              // Browse Courses Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: Color(0xFF1A1A67),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Browse Courses',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A67),
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            // Show all courses
                            setState(() {
                              _selectedFilter = 'All';
                            });
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: Color(0xFF1A1A67),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Course Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 12.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final course = filteredCourses[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailsScreen(
                                course: course,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Course Image
                              Stack(
                                children: [
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: _getGradientForCourse(course.id),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.school,
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
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Popular',
                                          style: TextStyle(
                                            color: _getGradientForCourse(course.id).colors.first,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              
                              // Course Details
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Rating
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                          Flexible(
                                            child: Text(
                                              ' ${course.rating}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              '(${course.enrolledCount})',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 10,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 4),
                                      
                                      // Course Title
                                      Text(
                                        course.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      
                                      const SizedBox(height: 4),
                                      
                                      // Price and Add to Cart
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '₹${course.price.toInt()}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF1A1A67),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Material(
                                              color: const Color(0xFF1A1A67).withOpacity(0.1),
                                              shape: const CircleBorder(),
                                              child: InkWell(
                                                customBorder: const CircleBorder(),
                                                onTap: () {
                                                  cartModel.addItem(course);
                                                  
                                                  // Show modern popup with course name and Go to Cart button
                                                  showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor: Colors.transparent,
                                                    isScrollControlled: true,
                                                    builder: (context) => Container(
                                                      padding: const EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(20),
                                                          topRight: Radius.circular(20),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.1),
                                                            blurRadius: 10,
                                                            spreadRadius: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            height: 5,
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey[300],
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          Container(
                                                            padding: const EdgeInsets.all(15),
                                                            decoration: BoxDecoration(
                                                              color: Colors.green.withOpacity(0.1),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: const Icon(
                                                              Icons.check_circle,
                                                              color: Colors.green,
                                                              size: 40,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15),
                                                          Text(
                                                            'Added to Cart!',
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Text(
                                                            course.title,
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              color: Colors.grey[600],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                              Navigator.pushNamed(context, '/cart');
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color(0xFF1A1A67),
                                                              foregroundColor: Colors.white,
                                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              minimumSize: const Size(double.infinity, 50),
                                                            ),
                                                            child: Text(
                                                              'Go to Cart',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text(
                                                              'Continue Shopping',
                                                              style: GoogleFonts.poppins(
                                                                color: Colors.grey[600],
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.add_shopping_cart,
                                                  color: Color(0xFF1A1A67),
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredCourses.length,
                  ),
                ),
              ),
              
              // Bottom Padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
