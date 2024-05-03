import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/product/provider/productquantity_get.dart';
import 'package:get/get.dart';

class QuantitySelector extends StatelessWidget {
  final QuantityController controller = Get.put(QuantityController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (controller.quantity.value > 1) {
                controller.decrease();
              }
            },
            child: Icon(
              Icons.remove,
              color: Color(0xFF4C53A5),
              size: 18,
            ),
          ),
          SizedBox(width: 10),
          Obx(() => Text(
                controller.quantity.value.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          SizedBox(width: 10),
          GestureDetector(
            onTap: controller.increase,
            child: Icon(
              Icons.add,
              color: Color(0xFF4C53A5),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
