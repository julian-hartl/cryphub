import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryphub/data/logger/logger_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../data/utils/converters.dart';
import '../../../../domain/crypto_currency/crypto_currency.dart';
import '../../../blocs/favorite_currencies/favorite_currencies_bloc.dart';
import '../../../blocs/favorite_currencies_notifier/favorite_currencies_notifier_bloc.dart';
import '../../../blocs/latest_currencies/latest_currencies_bloc.dart';
import '../../../themes.dart';
import '../../../widgets/alerts.dart';
import '../../../widgets/retry.dart';

class LatestCurrenciesView extends StatelessWidget with LoggerProvider {
  final PagingController<int, CryptoCurrency> pagingController;

  const LatestCurrenciesView({
    required this.pagingController,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // for details see here: https://pub.dev/packages/infinite_scroll_pagination
    return BlocListener<LatestCurrenciesBloc, LatestCurrenciesState>(
      listener: (context, state) {
        state.when(
          loadingSuccess: (currencies, page) {
            logger.info('Loaded ${currencies.size} items for page $page');
            //when number of received items is lower than what should be displayed on a page, it is the last page
            final isLastPage = currencies.size < LatestCurrenciesBloc.pageSize;
            if (isLastPage) {
              pagingController.appendLastPage(currencies.asList());
            } else {
              pagingController.appendPage(currencies.asList(), page + 1);
            }
          },
          loading: () => {},
          error: (message) {
            pagingController.error = message;
          },
        );
      },
      child: BlocListener<FavoriteCurrenciesNotifierBloc,
          FavoriteCurrenciesNotifierState>(
        listener: (context, state) {
          state.maybeWhen(
              markCurrencyAsFavoriteError: (symbol, _) {
                ErrorAlert.show(context, 'Could not mark $symbol as favorite.');
              },
              removeCurrencyFromFavoritesError: (symbol, _) {
                ErrorAlert.show(
                    context, 'Could not remove $symbol from favorites.');
              },
              orElse: () {});
        },
        child: BlocBuilder<FavoriteCurrenciesBloc, FavoriteCurrenciesState>(
          builder: (context, favoritesState) {
            return favoritesState.when(
              updatedFavorites: (favorites) {
                return PagedSliverList<int, CryptoCurrency>(
                  builderDelegate: PagedChildBuilderDelegate<CryptoCurrency>(
                    itemBuilder: (context, item, index) => CurrencyCard(
                      cryptoCurrency: item,
                      isFavorite: favorites
                          .asList()
                          .map((f) => f.symbol)
                          .toList()
                          .contains(item.symbol),
                    ),
                    animateTransitions: true,
                    firstPageErrorIndicatorBuilder: (context) =>
                        _buildErrorIndicator(),
                    newPageErrorIndicatorBuilder: (context) =>
                        _buildErrorIndicator(),
                    firstPageProgressIndicatorBuilder: (context) =>
                        _buildProgressIndicator(),
                    newPageProgressIndicatorBuilder: (context) =>
                        _buildProgressIndicator(),
                    noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No currencies found...'),
                        ElevatedButton(
                            onPressed: () {
                              pagingController.refresh();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.refresh),
                                Gap(10),
                                Text('Refresh'),
                              ],
                            ))
                      ],
                    )),
                  ),
                  pagingController: pagingController,
                );
              },
              updating: () => SliverList(
                  delegate: SliverChildListDelegate.fixed([
                _buildProgressIndicator(),
              ])),
              error: (message) => SliverList(
                  delegate: SliverChildListDelegate.fixed([
                _buildErrorIndicator(message),
              ])),
            );
          },
        ),
      ),
    );
  }

  Padding _buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorIndicator([String? message]) {
    return Center(
      child: Retry(message ?? pagingController.error, onRetry: () {
        pagingController.refresh();
      }),
    );
  }
}

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    Key? key,
    required this.cryptoCurrency,
    required this.isFavorite,
  }) : super(key: key);

  final CryptoCurrency cryptoCurrency;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
        ),
        child: Row(
          children: [
            FavoriteButton(
              isFavorite: isFavorite,
              onTap: (isFavorite) {
                if (!isFavorite) {
                  context.read<FavoriteCurrenciesBloc>().add(
                      FavoriteCurrenciesEvent.removeFromFavorites(
                          cryptoCurrency.symbol));
                } else {
                  context.read<FavoriteCurrenciesBloc>().add(
                      FavoriteCurrenciesEvent.markAsFavorite(
                          cryptoCurrency.symbol));
                }
              },
            ),
            const Gap(10),
            CircleAvatar(
              radius: 25.0,
              // https://stackoverflow.com/questions/53577962/better-way-to-load-images-from-network-flutter
              child: CachedNetworkImage(
                imageUrl: cryptoCurrency.iconUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
            const Gap(10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cryptoCurrency.symbol),
                  Text(convertCurrencyToSymbol(cryptoCurrency.currency) +
                      cryptoCurrency.currentPrice.toStringAsFixed(2)),
                  _growthRateBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _growthRateBox() {
    final noGrowth =
        double.parse(cryptoCurrency.percentChange24h.toStringAsFixed(2)) ==
            0.00;
    final isPositiveGrowth = !cryptoCurrency.percentChange24h.isNegative;
    final color = noGrowth
        ? noGrowthColor
        : (isPositiveGrowth ? positiveGrowthColor : negativeGrowthColor);
    final icon = noGrowth
        ? Icons.horizontal_rule
        : (isPositiveGrowth ? Icons.arrow_upward : Icons.arrow_downward);
    return Container(
      child: Row(
        children: [
          Text(
            '${cryptoCurrency.percentChange24h.toStringAsFixed(2)}%',
            style: TextStyle(
              // displays color depending on growth rate
              color: color,
            ),
          ),
          const Gap(10),
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 15.0,
            ),
          )
        ],
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  final bool isFavorite;

  /// Triggers every time it is tapped
  /// Returns the current button state
  final void Function(bool isFavorite) onTap;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;
  @override
  void initState() {
    isFavorite = widget.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
        widget.onTap(isFavorite);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: isFavorite
            ? const Icon(
                Icons.favorite,
                color: Colors.redAccent,
              )
            : Icon(
                Icons.favorite_outline,
                color: Theme.of(context).colorScheme.onBackground,
              ),
      ),
    );
  }
}
