import 'package:flutter/foundation.dart';
import 'course_model.dart';

class CartModel extends ChangeNotifier {
  final List<Course> _items = [];
  
  List<Course> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.length;
  
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);
  
  void addItem(Course course) {
    if (!_items.any((item) => item.id == course.id)) {
      _items.add(course);
      notifyListeners();
    }
  }
  
  void removeItem(Course course) {
    _items.removeWhere((item) => item.id == course.id);
    notifyListeners();
  }
  
  bool isInCart(Course course) {
    return _items.any((item) => item.id == course.id);
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
