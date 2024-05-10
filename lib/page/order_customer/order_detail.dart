import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/cart_model.dart';
import 'package:flutter_ltdddoan/model/customeraddress.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';
import 'package:flutter_ltdddoan/model/order_model.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';
import 'package:flutter_ltdddoan/repositories/order/order_detail_repositoy.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  OrderDetailPage({required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _showCustomerInfo = false;
  OrderDetailRepository orderDetailRepository = OrderDetailRepository();
  late List<Cart> orderDetails = [];
  OrderModel? order;
  Discount? discount;
  CustomerAddress? cusAdrress;
  PaymentMethod? paymentMethod;

  String? cusAdrressId;
  String? discountId;
  String? paymentMethodId;

  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      order = await orderDetailRepository.getOrderById(widget.orderId);
      cusAdrressId = order!.customerAddressId;
      discountId = order!.discountId;
      paymentMethodId = order!.paymentMethodId;
      discount =
          await orderDetailRepository.getDiscountProductById(discountId!);
      orderDetails =
          await orderDetailRepository.getOrderDetailsByOrderId(widget.orderId);
      cusAdrress = await orderDetailRepository.getAddressById(cusAdrressId!);
      paymentMethod =
          await orderDetailRepository.getPaymentMethodById(paymentMethodId!);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? createdDateTime;
    if (order?.createDate != null) {
      createdDateTime =
          DateFormat('HH\':\'mm dd/MM/yyyy').format(order!.createDate!);
    } else {
      createdDateTime = 'Chưa cập nhật';
    }
    String? confirmDate;
    if (order?.confirmDate != null) {
      confirmDate =
          DateFormat('HH\':\'mm dd/MM/yyyy').format(order!.confirmDate!);
    } else {
      confirmDate = 'Chưa cập nhật';
    }
    String? shipDate;
    if (order?.shipDate != null) {
      shipDate = DateFormat('HH\':\'mm dd/MM/yyyy').format(order!.shipDate!);
    } else {
      shipDate = 'Chưa cập nhật';
    }
    String? successDate;
    if (order?.successDate != null) {
      successDate =
          DateFormat('HH\':\'mm dd/MM/yyyy').format(order!.successDate!);
    } else {
      successDate = 'Chưa cập nhật';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết đơn hàng',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  if (order!.isConfirm == false &&
                      order!.isCancel == false &&
                      order!.isReturn == false)
                    _buildCancelButton(context, order!.orderId!),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        _buildOrderTrackerItem(
                            'Đã đặt',
                            order!.isConfirm == false &&
                                order!.isCancel == false &&
                                order!.isReturn == false,
                            createdDateTime.toString()),
                        Spacer(),
                        _buildOrderTrackerItem(
                            'Đã xác nhận',
                            order!.isConfirm == true &&
                                order!.isShip != true &&
                                order!.isCancel == false &&
                                order!.isReturn == false,
                            confirmDate.toString()),
                        Spacer(),
                        _buildOrderTrackerItem(
                            'Đang giao',
                            order!.isShip == true &&
                                order!.isSuccess == false &&
                                order!.isCancel == false &&
                                order!.isReturn == false,
                            shipDate.toString()),
                        Spacer(),
                        _buildOrderTrackerItem(
                            'Hoàn thành',
                            order!.isSuccess == true &&
                                order!.isCancel == false &&
                                order!.isReturn == false,
                            successDate.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showCustomerInfo = !_showCustomerInfo;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Thông tin giao hàng',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  _showCustomerInfo
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Đặt các thông tin khách hàng ở đây
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: _showCustomerInfo ? null : 0,
                          child: _buildCustomerInfoItem(
                            cusAdrress!.name,
                            cusAdrress!.phone,
                            '${cusAdrress!.addressNote}, ${cusAdrress!.address}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),

                              Text(
                                ' Đơn hàng #${widget.orderId}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Duyệt qua danh sách orderDetails
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderDetails.length,
                                itemBuilder: (context, index) {
                                  var orderDetail = orderDetails[index];
                                  return _buildOrderTile(
                                    orderDetail.image,
                                    orderDetail.productName,
                                    orderDetail.quantity.toString(),
                                    currencyFormat
                                        .format(orderDetail.price)
                                        .toString(),
                                    orderDetail.sizeName,
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Discount: ${discount != null ? discount!.value.toString() : '0'}% ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Thanh toán: ${paymentMethod!.name} ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Tổng tiền:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${currencyFormat.format(order!.totalPayment)}VND ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOrderTile(String imagePath, String itemName, String quantity,
      String price, String sizeName) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      leading: Container(
        margin: EdgeInsets.only(right: 30),
        child: SizedBox(
          width: 60,
          height: 60,
          child: PhotoView(
            imageProvider: NetworkImage(imagePath),
            loadingBuilder: (context, event) => CircularProgressIndicator(),
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.covered,
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
          ),
        ),
      ),
      title: Text(itemName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                    sizeName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Text(
                'SL: $quantity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                price + 'VND',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoItem(
      String customerName, String phoneNumber, String address) {
    return Container(
      width: double.infinity, // Thiết lập width bằng kích thước tối đa
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomerDetail('Tên khách hàng', customerName),
          _buildCustomerDetail('Số điện thoại', phoneNumber),
          _buildCustomerDetail('Địa chỉ', address),
        ],
      ),
    );
  }

  Widget _buildCustomerDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildOrderTrackerItem(String title, bool isActive, String? time) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? Color(0xFF6342E8) : Colors.grey,
          ),
        ),
        SizedBox(height: 5),
        if (time != null && time.isNotEmpty)
          Text(
            time,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}

Widget _buildCancelButton(BuildContext context, String orderId) {
  return ElevatedButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
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
                        'Bạn có chắc chắn muốn hủy đơn hàng này?',
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
                      Navigator.of(context).pop();
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
                        'Hủy đơn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        OrderDetailRepository orderDetailRepository =
                            OrderDetailRepository();
                        await orderDetailRepository.updateOrder(orderId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã hủy đơn hàng'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      Navigator.pushReplacementNamed(context, '/myOrder');
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
    child: Text(
      'Hủy đơn',
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
