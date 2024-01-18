import 'dart:async';

import 'package:belajar_bloc/data/cart_items.dart';
import 'package:belajar_bloc/data/grocery_data.dart';
import 'package:belajar_bloc/data/wishlist_items.dart';
import 'package:belajar_bloc/features/home/models/home_product_data_model.dart';
import 'package:belajar_bloc/features/home/ui/home.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeProductWishListButtonClickedEvent>(
        homeProductWishListButtonClickedEvent);
    on<HomeProductCartButtonClickedEvent>(homeProductCartButtonClickedEvent);
    on<HomeWishListButtonNavigateEvent>(homeWishListButtonNavigateEvent);
    on<HomeCartButtonNavigateEvent>(homeCartButtonNavigateEvent);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());

      // Simulate a delay (remove this in your actual implementation)
      await Future.delayed(Duration(seconds: 3));

      // Map and transform the data
      final products = GroceryData.groceryProducts
          .map((e) => ProductDataModel(
                id: e['id'] ?? 0,
                name: e['name'] ?? 'Unknown',
                price: e['price'] ?? 0.0,
                description: e['description'] ?? 'No description available',
                imageUrl: e['imageurl'],
              ))
          .toList();

      // Emit the success state
      emit(HomeLoadedSuccessState(products: products));
    } catch (e) {
      // Handle errors by emitting an error state
      emit(HomeErrorState());
      // Optionally, log the error for debugging
      print('Error in homeInitialEvent: $e');
    }
  }

  FutureOr<void> homeProductWishListButtonClickedEvent(
      HomeProductWishListButtonClickedEvent event, Emitter<HomeState> emit) {
    print('WhistList Clicked');
    wishlistItems.add(event.clickedProduct);
    emit(HomeProductItemWishlistedActionState());
  }

  FutureOr<void> homeProductCartButtonClickedEvent(
      HomeProductCartButtonClickedEvent event, Emitter<HomeState> emit) {
    print('cart clicked');
    cartItems.add(event.clickedProduct);
    emit(HomeProductItemCartedActionState());
  }

  FutureOr<void> homeWishListButtonNavigateEvent(
      HomeWishListButtonNavigateEvent event, Emitter<HomeState> emit) {
    print('WishList Navigate Clicked');
    emit(HomeNavigateToWishListPageActionState());
  }

  FutureOr<void> homeCartButtonNavigateEvent(
      HomeCartButtonNavigateEvent event, Emitter<HomeState> emit) {
    print('Cart Navigate Click');
    emit(HomeNavigateToCartPageActionState());
  }

  
}
