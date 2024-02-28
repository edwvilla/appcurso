import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part "product_event.dart";
part "product_state.dart";

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductIdle()) {
    on<FetchProduct>(_fetchProduct);
  }

  // dependencias
  final apiService = ApiService();
  final loginController = Get.find<LoginController>();

  _fetchProduct(FetchProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    final String? token = loginController.userCredential?.jwt;

    if (token == null) {
      emit(ProductError(message: "User not authenticated"));
    }

    final product = await apiService.getProduct(
      token: token!,
      productId: event.productId,
    );

    if (product == null) {
      emit(ProductError(message: "Product not found"));
    } else {
      emit(ProductSuccess(product: product));
    }
  }
}
