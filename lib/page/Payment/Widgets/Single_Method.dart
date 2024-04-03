import 'package:flutter/material.dart';

class SingleMethod extends StatefulWidget {
  final Widget image;
  final String text;
  final bool selectedMethod;
  final VoidCallback onTap;

  const SingleMethod({
    Key? key,
    required this.selectedMethod,
    required this.image,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  _SingleMethodState createState() => _SingleMethodState();
}

class _SingleMethodState extends State<SingleMethod> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Gọi hàm callback khi người dùng nhấn vào
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 20, right: 20, top: 5.0, bottom: 20),
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 0, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent, // Đổi màu nền thành trong suốt
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF6342e8),
              ),
              child: widget.image,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    textAlign: TextAlign.center, // Căn giữa văn bản theo chiều ngang
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.selectedMethod ? Color(0xFF6342e8) : Colors.transparent,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
