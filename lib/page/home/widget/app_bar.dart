import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:flutter_ltdddoan/page/home/widget/menu_bar.dart';
import 'package:flutter_ltdddoan/page/home/widget/icon.widget.dart';
import 'package:provider/provider.dart';
import '../../search/SearchItem.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CartRepository cartRepository;
  final VoidCallback? onCartChanged;
  final Future<int> favoriteProductCount;

  CustomAppBar({
    required this.cartRepository,
    required this.favoriteProductCount,
    this.onCartChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cartRepository = Provider.of<CartRepository>(context, listen: false);
    final itemCount = cartRepository.cartItems.length;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          "Geeta.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            children: [
              IconWidget(
                onTap: () {},
                iconPath: Assets.images.icon.path,
                isHaveCount: true,
                total: '5',
              ),
              IconWidget(
                onTap: () async {
                  // Thực hiện việc chuyển đến trang giỏ hàng
                  await Navigator.pushNamed(context, '/cart');
                },
                iconPath: Assets.images.cartIcon.path,
                isHaveCount: true,
                total: '${itemCount}',
              ),
              FutureBuilder<int>(
                future: favoriteProductCount,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return IconWidget(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/favorite');
                      },
                      iconPath: Assets.images.fav.path,
                      isHaveCount: true,
                      total: snapshot.data.toString(),
                    );
                  }
                },
              ),
              IconWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => searchItem()),
                  );
                },
                iconPath: Assets.images.searchIcon.path,
              ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 200),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: ProfileScreen(),
                      );
                    },
                    transitionBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(1, 0), end: Offset.zero)
                            .animate(animation),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
