import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controller.dart';
import './../../widgets/widgets.dart';
import './../../views/views.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cartController = Get.find<CartController>();
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Banners
              BannerCarousel(banners: controller.banners),

              const SizedBox(height: 16),

              /// Categorias
              const Text(
                'Categorias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final categoria = controller.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryTile(
                        category: categoria,
                        onTap: () {
                          Get.toNamed(
                            '/category/${Uri.encodeComponent(categoria)}',
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// Produtos em destaque
              const Text(
                'Produtos em destaque',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.featuredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = controller.featuredProducts[index];
                  return ProductCard(
                    product: product,
                    cartAnimationMethod: (imageKey) {
                      cartController.itemSelectedCartAnimations(imageKey);
                    },
                    onTap: () {
                      Get.to(() => ProductDetailPage(product: product));
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
