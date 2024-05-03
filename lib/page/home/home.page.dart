import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/home/widget/item.widget.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:flutter_ltdddoan/repositories/products/favorite_product.dart';
import '../../repositories/products/getproduct_list.dart';
import '../../model/product_model.dart';
import '../home/widget/fliterproduct.dart';
import '../home/widget/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Product> products = [];
User? currentUser;

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

  Future<int>? favoriteProductCount;
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
    currentUser = UserRepository().getUserAuth();
    if (currentUser != null) {
      // Cập nhật giá trị của favoriteProductCount
      setState(() {
        favoriteProductCount =
            FavoriteProductRepository().countFavoriteProducts(currentUser!.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        cartRepository: cartRepository,
        favoriteProductCount: favoriteProductCount ?? Future.value(0),
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
