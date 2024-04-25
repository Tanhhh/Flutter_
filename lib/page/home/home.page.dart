import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/home/widget/icon.widget.dart';
import 'package:flutter_ltdddoan/page/home/widget/item.widget.dart';
import '../Cart/Cartpage.dart';
import '../search/SearchItem.dart';
import 'menu_bar.dart';
import '../../repositories/products/getproduct_list.dart';
import '../../model/product_model.dart';
import '../home/widget/fliterproduct.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Product> products = [];

class _HomePageState extends State<HomePage> {
  void getNewProducts() async {
    ProductRepository productRepository = ProductRepository();
    products = await productRepository.getNewProductsWithImages();
    setState(() {});
  }

  void getHotProducts() async {
    ProductRepository productRepository = ProductRepository();
    products = await productRepository.getHotProducts();
    setState(() {});
  }

  void getSaleProducts() async {
    ProductRepository productRepository = ProductRepository();
    products = await productRepository.getSaleProductDocumentIds();
    setState(() {});
  }

  void getAllProducts() async {
    ProductRepository productRepository = ProductRepository();
    products = await productRepository.getAllProducts();
    setState(() {});
  }

  int selectedIndex = 0;

  static final List<String> listCategory = [
    "Tất cả",
    "Phổ biến",
    "Mới",
    "Sale"
  ];
  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: const Row(
          children: [
            Padding(
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
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(children: [
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
                total: '3',
              ),
              IconWidget(
                onTap: () {},
                iconPath: Assets.images.fav.path,
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
            ]),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(listCategory.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      switch (index) {
                        case 0: // "Tất cả"
                          getAllProducts();
                          break;
                        case 1: // "Phổ biến"
                          getHotProducts();
                          break;
                        case 2: // "Mới"
                          getNewProducts();
                          break;
                        case 3: // "Sale"
                          getSaleProducts();
                          break;
                        default:
                          getAllProducts();
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listCategory[index],
                          style: TextStyle(
                            color: selectedIndex == index
                                ? const Color(0xFF6342E8)
                                : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: listCategory[index].length * 3.5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? const Color(0xFF6342E8)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 1,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Hiển thị hộp thoại lọc sản phẩm khi nhấn vào nút "Lọc sản phẩm"
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Trả về widget FilterDialog để hiển thị trong hộp thoại
                        return FilterDialog();
                      },
                    );
                  },
                  child: Row(
                    children: [
                      const Text(
                        "Lọc sản phẩm",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Hiển thị hộp thoại lọc sản phẩm khi nhấn vào biểu tượng
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // Trả về widget FilterDialog để hiển thị trong hộp thoại
                              return FilterDialog();
                            },
                          );
                        },
                        child: Image.asset(
                          Assets.images.sortTool.path,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.images.gridView.path),
                    const SizedBox(
                      width: 8,
                    ),
                    Image.asset(Assets.images.fullView.path)
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3.5 / 4,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ItemWidget(
                    product: product,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
