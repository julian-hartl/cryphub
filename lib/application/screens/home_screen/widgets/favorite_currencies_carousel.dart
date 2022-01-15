import 'package:carousel_slider/carousel_slider.dart';
import 'package:cryphub/configure_dependencies.dart';
import 'package:cryphub/data/utils/dominant_color_finder.dart';
import 'package:gap/gap.dart';
import 'package:kt_dart/collection.dart';
import '../../../blocs/favorite_currencies/favorite_currencies_bloc.dart';
import '../../../widgets/retry.dart';
import '../../../../data/utils/converters.dart';
import '../../../../domain/crypto_currency/crypto_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCurrenciesCarousel extends StatelessWidget {
  const FavoriteCurrenciesCarousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: state.when(
              updatedFavorites: (favorites) {
                if (favorites.isEmpty()) {
                  return const Center(
                    child: Text(
                      'You currently don\'t have\nany favorite currencies...',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                const itemsPerPage = 4;
                // calculates the number of pages needed to display at max 4 cards on each page
                final pages = (favorites.size / itemsPerPage).ceil();
                return CarouselSlider.builder(
                  itemBuilder: (context, page, realIndex) {
                    // checks if the current page is the last page
                    final isLastPage =
                        (favorites.size - (page + 1) * itemsPerPage) < 0;
                    // the item count for the current page
                    final itemCount = isLastPage
                        ? favorites.size - page * itemsPerPage
                        : itemsPerPage;
                    return FavoriteCurrenciesSlidePage(
                      itemCount: itemCount,
                      itemsPerPage: itemsPerPage,
                      currentPage: page,
                      favorites: favorites,
                    );
                  },
                  itemCount: pages,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    disableCenter: true,
                    viewportFraction: 1,
                  ),
                );
              },
              updating: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (errorMessage) => Center(
                child: Retry(errorMessage, onRetry: () {
                  context
                      .read<FavoriteCurrenciesBloc>()
                      .add(const FavoriteCurrenciesEvent.loadFavorites());
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FavoriteCurrenciesSlidePage extends StatefulWidget {
  const FavoriteCurrenciesSlidePage({
    Key? key,
    required this.itemCount,
    required this.itemsPerPage,
    required this.favorites,
    required this.currentPage,
  }) : super(key: key);

  final int itemCount;
  final int itemsPerPage;
  final KtList<CryptoCurrency> favorites;
  final int currentPage;

  @override
  State<FavoriteCurrenciesSlidePage> createState() =>
      _FavoriteCurrenciesSlidePageState();
}

class _FavoriteCurrenciesSlidePageState
    extends State<FavoriteCurrenciesSlidePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        scrollDirection: Axis.horizontal,
        shrinkWrap: widget.itemCount > 1,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.itemCount,
        itemBuilder: (context, gridIndex) => FavoriteCurrencyCard(
            favorite: widget.favorites[
                widget.currentPage * widget.itemsPerPage + gridIndex]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FavoriteCurrencyCard extends StatefulWidget {
  const FavoriteCurrencyCard({
    Key? key,
    required this.favorite,
  }) : super(key: key);

  final CryptoCurrency favorite;

  @override
  State<FavoriteCurrencyCard> createState() => _FavoriteCurrencyCardState();
}

class _FavoriteCurrencyCardState extends State<FavoriteCurrencyCard> {
  @override
  void initState() {
    app
        .get<DominantColorFinder>()
        .find(NetworkImage(widget.favorite.iconUrl))
        .then((value) {
      setState(() {
        computedDominantColor = Future.value(value);
      });
    });
    super.initState();
  }

  Future<void> computeOnDominantColor() async {
    if (computedOnDominantColor != null) return;
    computedOnDominantColor =
        (await computedDominantColor)!.computeLuminance() < 0.6
            ? Colors.white
            : Colors.black;
    setState(() {});
  }

  Color? computedOnDominantColor;

  Future<Color>? computedDominantColor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color>(
        future: computedDominantColor,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final dominantColor = snapshot.data!;
            final onDominantColor = computedOnDominantColor ?? Colors.white;
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: dominantColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Image.network(widget.favorite.iconUrl),
                    radius: 35.0,
                    backgroundColor: onDominantColor,
                  ),
                  const Gap(10),
                  Text(
                    widget.favorite.name,
                    style: TextStyle(color: onDominantColor),
                  ),
                  const Gap(5),
                  Text(
                    '${convertCurrencyToSymbol(widget.favorite.currency)} ${widget.favorite.currentPrice.toStringAsFixed(2)}',
                    style: TextStyle(color: onDominantColor),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}