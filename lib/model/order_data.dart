import 'address_model.dart';
import 'cart_model.dart';

class OrderData {
  List<Cart>? cartItems;
  double? totalAmount;
  Address? address;

  OrderData({this.cartItems, this.totalAmount, this.address});
}
