import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wicom/core/app_data.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/src/controller/product_controller.dart';
import 'package:wicom/src/view/widget/product_grid_view.dart';
import 'package:wicom/src/view/widget/list_item_selector.dart';

enum AppbarActionType { leading, trailing }

final ProductController controller = Get.put(ProductController());

class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
}
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  Widget appBarActionButton(AppbarActionType type) {
    IconData icon = Icons.ac_unit_outlined;

    if (type == AppbarActionType.trailing) {
      icon = Icons.search;
    }

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.lightGrey,
      ),
      child: IconButton(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        onPressed: () {},
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }

  PreferredSizeWidget get _appBar {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ensure search bar takes available space properly
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    print("Search input: $value"); // Handle search input
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Adds spacing
              // Uncomment these lines if you want action buttons
              // appBarActionButton(AppbarActionType.leading),
              // appBarActionButton(AppbarActionType.trailing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recommendedProductListView(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: AppData.recommendedProducts.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: AppData.recommendedProducts[index].cardBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '30% OFF DURING \n WEEKEND',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppData.recommendedProducts[index].buttonBackgroundColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            "Get Now",
                            style: TextStyle(
                              color: AppData.recommendedProducts[index].buttonTextColor!,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    AppData.recommendedProducts[index].imagePath,
                    height: 125,
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topCategoriesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Top categories",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: AppColor.darkOrange),
            child: Text(
              "SEE ALL",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.deepOrange.withValues(alpha: 0.7),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _topProductsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Trending Products",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: AppColor.darkOrange),
            child: Text(
              "SEE ALL",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.deepOrange.withValues(alpha: 0.7),
              ),
            ),
          )
        ],
      ),
    );
  }



  Widget _topCategoriesListView() {
    final List<Category> testCategories = [
      Category(name: "Electronics", imageUrl: "https://cdn-icons-png.flaticon.com/128/3144/3144456.png"),
      Category(name: "Fashion", imageUrl: "https://cdn-icons-png.flaticon.com/128/892/892458.png"),
      Category(name: " Furniture", imageUrl: "https://cdn-icons-png.flaticon.com/128/1827/1827379.png"),
      Category(name: "Sports", imageUrl: "https://cdn-icons-png.flaticon.com/128/1046/1046862.png"),
      Category(name: "Toys", imageUrl: "https://cdn-icons-png.flaticon.com/128/3625/3625212.png"),
      Category(name: "Automobile", imageUrl: "https://cdn-icons-png.flaticon.com/128/743/743007.png"),
      Category(name: "Books", imageUrl: "https://cdn-icons-png.flaticon.com/128/2995/2995683.png"),
      Category(name: "Health", imageUrl: "https://cdn-icons-png.flaticon.com/128/2966/2966327.png"),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Prevents scrolling issues
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1, // Adjust aspect ratio if needed
      ),
      itemCount: testCategories.length,
      itemBuilder: (context, index) {
        final category = testCategories[index];
        return GestureDetector(
          onTap: () {
            debugPrint("Category Selected: ${category.name}");
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                category.imageUrl,
                width: 40, // Icon size
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.getAllItems();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Hello Sina",
                //   style: Theme.of(context).textTheme.displayLarge,
                // ),
                // Text(
                //   "Lets gets somethings?",
                //   style: Theme.of(context).textTheme.headlineSmall,
                // ),
                // _recommendedProductListView(context),
                _topCategoriesHeader(context),
                _topCategoriesListView(),
                // _topProductsHeader(context),
                // _productsGridView(),
                // GetBuilder(
                //   builder: (ProductController controller) {
                //     return CategoriesGridView(
                //       items: controller.filteredProducts,
                //       likeButtonPressed: (index) => controller.isFavorite(index),
                //       isPriceOff: (product) => controller.isPriceOff(product),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _productsGridView() {
    final List<Product> testProducts = [
      Product(name: "Smartphone", price: "TZS 500,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/2920/2920323.png"),
      Product(name: "Laptop", price: "TZS 1,200,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/4333/4333609.png"),
      Product(name: "Headphones", price: "TZS 150,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/2913/2913964.png"),
      Product(name: "Smart Watch", price: "TZS 300,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/1532/1532660.png"),
      Product(name: "Camera", price: "TZS 800,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/2921/2921822.png"),
      Product(name: "Shoes", price: "TZS 100,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/9785/9785892.png"),
      Product(name: "Backpack", price: "TZS 90,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/3556/3556651.png"),
      Product(name: "Sunglasses", price: "TZS 50,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/3257/3257018.png"),
      Product(name: "Wireless Speaker", price: "TZS 250,000", imageUrl: "https://cdn-icons-png.flaticon.com/128/2917/2917998.png"),
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8, // Adjusted for better fit
      ),
      itemCount: testProducts.length,
      itemBuilder: (context, index) {
        final product = testProducts[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity, // Full width
                    fit: BoxFit.cover, // Crop & fill card width
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.price,
                      style: const TextStyle(fontSize: 12, color: Colors.green),
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
class Product {
  final String name;
  final String price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}
