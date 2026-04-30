import 'package:flutter/material.dart';
import 'package:wicom/src/model/product.dart';
import 'package:wicom/src/model/numerical.dart';
import 'package:wicom/src/model/categorical.dart';
import 'package:wicom/src/model/product_category.dart';
import 'package:wicom/src/model/product_size_type.dart';
import 'package:wicom/src/model/recommended_product.dart';
import 'package:wicom/src/model/bottom_nav_bar_item.dart';

import 'app_color.dart';

class AppData {
  const AppData._();

  /// Laravel API base including `/api` (same host as attendanceportal).
  static String url = "https://payroll.softecki.com/api";

  /// Shown in UI (rebrand).
  static String appDisplayName = "Softecki FaceAccess";

  /// Legacy label used in older screens.
  static String School_name = "Softecki FaceAccess";
  static const String dummyText = 'Lorem Ipsum is simply dummy text of the printing and typesetting'
      ' industry. Lorem Ipsum has been the industry\'s standard dummy text'
      ' ever since the 1500s, when an unknown printer took a galley of type'
      ' and scrambled it to make a type specimen book.';

  static List<Product> products = [
    Product(
      name: 'Electronics',
      price: 460,
      isAvailable: true,
      off: 300,
      quantity: 0,
      images: [
        'assets/images/a53_1.png',
        'assets/images/a53_2.png',
        'assets/images/a53_3.png',
      ],
      isFavorite: true,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Vehicles',
      price: 380,
      isAvailable: false,
      off: 220,
      quantity: 0,
      images: [
        'assets/images/tab_s7_fe_1.png',
        'assets/images/tab_s7_fe_2.png',
        'assets/images/tab_s7_fe_3.png',
      ],
      isFavorite: false,
      rating: 4,
      type: ProductType.tablet,
    ),
    Product(
      name: 'Property',
      price: 650,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/tab_s8_1.png',
        'assets/images/tab_s8_2.png',
        'assets/images/tab_s8_3.png',
      ],
      isFavorite: false,
      rating: 3,
      type: ProductType.tablet,
    ),
    Product(
      name: 'Fashion',
      price: 229,
      isAvailable: true,
      off: 200,
      quantity: 0,
      images: [
        'assets/images/galaxy_watch_4_1.png',
        'assets/images/galaxy_watch_4_2.png',
        'assets/images/galaxy_watch_4_3.png',
      ],
      isFavorite: false,
      rating: 5,
      sizes: ProductSizeType(
        categorical: [
          Categorical(CategoricalType.small, true),
          Categorical(CategoricalType.medium, false),
          Categorical(CategoricalType.large, false),
        ],
      ),
      type: ProductType.watch,
    ),
    Product(
      name: 'Services',
      price: 330,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/apple_watch_series_7_1.png',
        'assets/images/apple_watch_series_7_2.png',
        'assets/images/apple_watch_series_7_3.png',
      ],
      isFavorite: false,
      rating: 4,
      sizes: ProductSizeType(
        numerical: [
          Numerical('41', true),
          Numerical('45', false),
        ],
      ),
      type: ProductType.watch,
    ),
    Product(
      name: ' Appliances',
      price: 230,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/beats_studio_3-1.png',
        'assets/images/beats_studio_3-2.png',
        'assets/images/beats_studio_3-3.png',
        'assets/images/beats_studio_3-4.png',
      ],
      isFavorite: false,
      rating: 2,
      type: ProductType.headphone,
    ),
    Product(
      name: 'Jobs',
      price: 497,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/samsung_q_60_a_1.png',
        'assets/images/samsung_q_60_a_2.png',
      ],
      isFavorite: false,
      rating: 3,
      sizes: ProductSizeType(
        numerical: [
          Numerical('43', true),
          Numerical('50', false),
          Numerical('55', false),
        ],
      ),
      type: ProductType.tv,
    ),
    Product(
      name: 'Sony x 80 J',
      price: 498,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/sony_x_80_j_1.png',
        'assets/images/sony_x_80_j_2.png',
      ],
      isFavorite: false,
      sizes: ProductSizeType(
        numerical: [
          Numerical('50', true),
          Numerical('65', false),
          Numerical('85', false),
        ],
      ),
      rating: 2,
      type: ProductType.tv,
    ),
  ];

  static List<ProductCategory> categories = [
    ProductCategory(
      type: ProductType.all,
      icon: Icons.all_inclusive,
    ),
    ProductCategory(
      type: ProductType.mobile,
      icon: Icons.phone_android,
    ),
    ProductCategory(
      type: ProductType.watch,
      icon: Icons.watch,
    ),
    ProductCategory(
      type: ProductType.tablet,
      icon: Icons.tablet,
    ),
    ProductCategory(
      type: ProductType.headphone,
      icon: Icons.headphones,
    ),
    ProductCategory(
      type: ProductType.tv,
      icon: Icons.tv,
    ),
  ];

  static List<Color> randomColors = [
    const Color(0xFFFCE4EC),
    const Color(0xFFF3E5F5),
    const Color(0xFFEDE7F6),
    const Color(0xFFE3F2FD),
    const Color(0xFFE0F2F1),
    const Color(0xFFF1F8E9),
    const Color(0xFFFFF8E1),
    const Color(0xFFECEFF1),
  ];

  static const Color lightOrangeColor = Color(0xFFff0000);

  static List<BottomNavBarItem> bottomNavBarItems = [
    const BottomNavBarItem(
      "Home",
      Icon(Icons.home),
    ),
    const BottomNavBarItem(
      "History",
      Icon(Icons.bar_chart),
    ),
    const BottomNavBarItem(
      "Profile",
      Icon(Icons.person),
    ),
  ];

  static List<RecommendedProduct> recommendedProducts = [
    RecommendedProduct(
      cardBackgroundColor:  AppColor.primaryColor,
    ),
  ];
}

