import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cryphub/application/ui_constants.dart';
import 'package:cryphub/application/widgets/shimmer_effect.dart';
import 'package:cryphub/core/app.dart';
import 'package:cryphub/data/logger/logger_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kt_dart/collection.dart';

import '../../../../data/utils/converters.dart';
import '../../../../data/utils/dominant_color_finder.dart';
import '../../../../domain/crypto_currency/crypto_currency.dart';
import '../../../blocs/favorite_currencies/favorite_currencies_bloc.dart';
import '../../../widgets/retry.dart';

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
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.favorite,
                          size: 100,
                        ),
                        Gap(10),
                        Text(
                          'You currently don\'t have\nany favorite currencies...',
                          textAlign: TextAlign.center,
                        ),
                      ],
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
                      itemsPerPage: itemsPerPage,
                      currentPage: page,
                      favorites: favorites,
                      templateAmount: itemsPerPage - itemCount,
                      itemCount: itemCount,
                    );
                  },
                  itemCount: pages,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    disableCenter: true,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    scrollPhysics: const BouncingScrollPhysics(),
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
    required this.itemsPerPage,
    required this.favorites,
    required this.currentPage,
    required this.templateAmount,
    required this.itemCount,
  }) : super(key: key);

  final int itemsPerPage;
  final KtList<CryptoCurrency> favorites;
  final int currentPage;
  final int itemCount;
  final int templateAmount;

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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.itemCount + widget.templateAmount,
          itemBuilder: (context, gridIndex) {
            if (gridIndex < widget.itemCount) {
              return FavoriteCurrencyCard(
                favorite: widget.favorites[
                    widget.currentPage * widget.itemsPerPage + gridIndex],
              );
            } else {
              return Container();
            }
          }),
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

class _FavoriteCurrencyCardState extends State<FavoriteCurrencyCard> with LoggerProvider{
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
  void didUpdateWidget(covariant FavoriteCurrencyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.favorite.iconUrl != widget.favorite.iconUrl){
      computeColors();
    }
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    computeColors();
  }

  void computeColors(){
    try {
      app
          .get<DominantColorFinder>()
          .find(CachedNetworkImageProvider(widget.favorite.iconUrl))
          .then((value) {

        setState(() {
          computedDominantColor = Future.value(value);
        });
        computeOnDominantColor();
      }).catchError((_) {
        setState(() {
          computedDominantColor =
              Future.value(Theme.of(context).colorScheme.primary);
        });
      });
    } catch (_) {}
  }

  static const cardBorderRadius = 10.0;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Color>(
        key: ValueKey(widget.favorite.symbol),
        future: computedDominantColor,
        builder: (context, snapshot) {
          final dominantColor = snapshot.data;
          logger.info(dominantColor);
          final onDominantColor = computedOnDominantColor;
          if (dominantColor == null || onDominantColor == null) {
            return ShimmerEffect(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              shimmerColor: Theme.of(context).colorScheme.secondary,
            );
          }
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: kHorizontalPagePadding, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardBorderRadius),
              color: dominantColor,
            ),
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
        });
  }
}
