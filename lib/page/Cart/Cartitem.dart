import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/cart_model.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Biến toàn cục để lưu tổng số lượng được chọn của tất cả các mục
int totalSelectCount = 0;

class Cartitem extends StatefulWidget {
  final String productName;
  final double defaultPrice;
  final String imageUrl;
  final int initialQuantity;
  final String sizeName;
  const Cartitem({
    Key? key,
    required this.productName,
    required this.defaultPrice,
    required this.imageUrl,
    required this.initialQuantity,
    required this.sizeName,
  }) : super(key: key);

  @override
  _CartitemState createState() => _CartitemState();
}

class _CartitemState extends State<Cartitem> {
  bool showDelete = false;
  bool isSelected = false;
  int currentQuantity = 0;
  double currentPrice = 0;
  double initialPrice = 0;
  int selectCount = 0;

  @override
  void initState() {
    super.initState();
    currentQuantity = widget.initialQuantity;
    initialPrice = widget.defaultPrice;
    currentPrice = initialPrice * currentQuantity;
    totalSelectCount = 0;
    Provider.of<CartRepository>(context, listen: false).clearSelectedItems();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < 0) {
          setState(() {
            showDelete = true;
          });
        } else {
          setState(() {
            showDelete = false;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[800],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: buildCartItem(),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: showDelete ? 80 : 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    showDelete = false;
                  });
                  _showDeleteConfirmationDialog(context);
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final cartProvider = Provider.of<CartRepository>(context, listen: false);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: Colors.white,
          content: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Bạn có chắc chắn muốn xóa sản phẩm này?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: Color(0xFF6342E8),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Container(
                    height: 40,
                    width: 120,
                    alignment: Alignment.center,
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6342E8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng hộp thoại
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF6342E8)),
                  ),
                  child: Container(
                    height: 40,
                    width: 120,
                    alignment: Alignment.center,
                    child: Text(
                      'Xóa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    cartProvider.removeFromCart(
                      productName: widget.productName,
                      price: widget.defaultPrice,
                      imageUrl: widget.imageUrl,
                      quantity: widget.initialQuantity,
                      sizeName: widget.sizeName,
                    );
                    if (selectCount == 1) {
                      totalSelectCount -= 1;
                    } else {
                      totalSelectCount = totalSelectCount;
                    }
                    selectCount = 0;

                    Navigator.pushReplacementNamed(context, '/cart');
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildCartItem() {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');

    return Consumer<CartRepository>(
      builder: (context, cartRepository, _) {
        return Container(
          height: 140,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFF1F4FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    isSelected = value!;
                    if (isSelected) {
                      selectCount = 1;
                      totalSelectCount += selectCount;
                      // Thêm sản phẩm vào danh sách đã chọn
                    } else {
                      selectCount = 0;
                      totalSelectCount -= 1;
                      // Loại bỏ sản phẩm khỏi danh sách đã chọn
                    }
                  });
                  cartRepository.toggleSelectedItem(
                    Cart(
                      productName: widget.productName,
                      sizeName: widget.sizeName,
                      quantity: currentQuantity,
                      price: widget.defaultPrice,
                      image: widget.imageUrl,
                    ),
                    select: isSelected,
                  );
                },
                shape: ContinuousRectangleBorder(),
              ),
              Container(
                height: 90,
                width: 90,
                margin: EdgeInsets.only(right: 15),
                child: Image.network(widget.imageUrl),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6342E8),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(40, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      backgroundColor: Color(0xFF6342E8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.sizeName}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price: ${currencyFormat.format(initialPrice)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 1),
                      Text(
                        'VND',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: 85,
                height: 25,
                margin: EdgeInsets.only(right: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (currentQuantity > 1) {
                            currentQuantity--;
                            cartRepository
                                .decreaseQuantityByProductNameAndSizeName(
                              productName: widget.productName,
                              sizeName: widget.sizeName,
                            );
                            isSelected = false;

                            cartRepository.getTotalPrice();
                            cartRepository.toggleSelectedItem(
                              Cart(
                                productName: widget.productName,
                                sizeName: widget.sizeName,
                                quantity: currentQuantity,
                                price: widget.defaultPrice,
                                image: widget.imageUrl,
                              ),
                              select: isSelected,
                            );
                            if (selectCount == 0) {
                              totalSelectCount += 1;
                            } else {
                              totalSelectCount = totalSelectCount;
                            }

                            print(currentQuantity);
                            selectCount = 1;
                          } else {
                            _showDeleteConfirmationDialog(context);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Color(0xFF4C53A5),
                          size: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 1),
                        alignment: Alignment.center,
                        child: Text(
                          '$currentQuantity',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (currentQuantity < 999) {
                            currentQuantity++;
                            cartRepository
                                .increaseQuantityByProductNameAndSizeName(
                              productName: widget.productName,
                              sizeName: widget.sizeName,
                            );
                            isSelected = false;

                            cartRepository.getTotalPrice();
                            cartRepository.toggleSelectedItem(
                              Cart(
                                productName: widget.productName,
                                sizeName: widget.sizeName,
                                quantity: currentQuantity,
                                price: widget.defaultPrice,
                                image: widget.imageUrl,
                              ),
                              select: isSelected,
                            );
                            if (selectCount == 0) {
                              totalSelectCount += 1;
                            } else {
                              totalSelectCount = totalSelectCount;
                            }
                            selectCount = 1;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Color(0xFF4C53A5),
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
