import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:flutter_ltdddoan/page/favorite_product/favoriteproduct_page.dart';
import 'package:flutter_ltdddoan/page/home/widget/icon.widget.dart';
import 'package:flutter_ltdddoan/page/home/widget/menu_bar.dart';
import '../../Cart/Cartpage.dart';
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
    return AppBar(
      leadingWidth: 100,
      leading: const Padding(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cartpage()),
                  );
                },
                iconPath: Assets.images.cartIcon.path,
                isHaveCount: true,
                total: '${cartRepository.itemCount}',
              ),
              FutureBuilder<int>(
                future: favoriteProductCount,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return IconWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavoritePage()),
                        );
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
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 200),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: MenuBarRight(), // Hiển thị menu bar tùy chỉnh
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
