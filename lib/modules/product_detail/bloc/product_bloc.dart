import 'package:appcurso/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "product_event.dart";
part "product_state.dart";

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(super.initialState) {
    on<FetchProduct>(_fetchProduct);
  }

  _fetchProduct(FetchProduct event, Emitter<ProductState> emit) {
    // on fetch product
  }
}
