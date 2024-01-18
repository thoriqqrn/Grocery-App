import 'package:belajar_bloc/features/cart/ui/cart.dart';
import 'package:belajar_bloc/features/home/bloc/home_bloc.dart';
import 'package:belajar_bloc/features/home/ui/product_tile_widget.dart';
import 'package:belajar_bloc/features/wishlist/ui/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToCartPageActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        } else if (state is HomeNavigateToWishListPageActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Wishlist()));
        } else if (state is HomeProductItemCartedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Item Added To Cart'),
            backgroundColor: Colors.green,
          ));
        } else if (state is HomeProductItemWishlistedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Item Added To Wishlist'),
            backgroundColor: Colors.green,
          ));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
              )),
            );
          case HomeLoadedSuccessState:
            // Perform null checks before accessing properties
            final stateCast = state as HomeLoadedSuccessState?;
            if (stateCast != null) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      "Grocery App",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    actions: [
                      IconButton(
                        onPressed: () {
                          homeBloc.add(HomeWishListButtonNavigateEvent());
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          homeBloc.add(HomeCartButtonNavigateEvent());
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  body: ListView.builder(
                    itemCount: stateCast.products.length,
                    itemBuilder: (context, index) {
                      return ProductTileWidget(
                          homeBloc: homeBloc,
                          productDataModel: stateCast.products[index]);
                    },
                  ));
            } else {
              // Handle the case where state is not of type HomeLoadedSuccessState
              return const SizedBox();
            }
          case HomeErrorState:
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }
}
