import 'package:get/get.dart';

import '../controllers/controllers.dart';

import '../repository/repository.dart';
import '../services/services.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    final productService = ProductService();
    final categoryService = CategoryService();
    final bannerService = BannerService();
    final userService = UserService();
    final authService = AuthService();

    // Remote Repositories
    final productRemoteRepository = ProductRemoteRepository(productService);
    final categoryRemoteRepository = CategoryRemoteRepository(categoryService);
    final bannerRemoteRepository = BannerRemoteRepository(bannerService);

    final authRemoteRepository = AuthRemoteRepository(authService);
    final authLocalRepository = AuthLocalRepository();

    // Repositories
    final authRepository = AuthRepository(
      authLocalRepository,
      authRemoteRepository,
    );
    Get.put(authRepository);

    final productRepository = ProductRepository(productRemoteRepository);
    Get.put(productRepository);

    final categoryRepository = CategoryRepository(categoryRemoteRepository);
    Get.put(categoryRepository);

    final bannerRepository = BannerRepository(bannerRemoteRepository);
    Get.put(bannerRepository);

    final userLocalRepository = UserLocalRepository();
    final userRemoteRepository = UserRemoteRepository(userService);
    final userRepository = UserRepository(
      userLocalRepository,
      userRemoteRepository,
    );
    Get.put(userRepository);

    final cartLocalRepository = CartLocalRepository();
    final cartProductsLocalRepository = CartProductsLocalRepository();
    final cartRepository = CartRepository(
      cartLocalRepository,
      cartProductsLocalRepository,
    );
    Get.put(cartRepository);
    Get.put(CartController(cartRepository: cartRepository)); // OK

    final favoritosRepository = FavoritosRepository(FavoriteLocalRepository());
    Get.put(favoritosRepository);
    Get.put(
      FavoritosController(favoritosRepository: favoritosRepository),
    ); // ✅ ADD AQUI

    // Controllers globais
    Get.put(MainNavigationController());

    Get.put(UserController(userRepository: userRepository));

    Get.put(BannerController(bannerRepository: bannerRepository));
    Get.put(CategoryController(categoryRepository: categoryRepository));
    Get.put(ProductController(productRepository: productRepository));
    Get.put(AuthController(authRepository: authRepository));

    // Order
    Get.put(OrderService());
    Get.put(OrderRemoteRepository(Get.find<OrderService>()));
    Get.put(OrderLocalRepository());
    Get.put(
      OrderRepository(
        Get.find<OrderLocalRepository>(),
        Get.find<OrderRemoteRepository>(),
      ),
    );
    Get.put(OrderController(orderRepository: Get.find<OrderRepository>()));

    Get.put(
      HomeController(
        bannerRepository: bannerRepository,
        categoryRepository: categoryRepository,
        productRepository: productRepository,
      ),
    );
  }
}
