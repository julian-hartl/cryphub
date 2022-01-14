import 'package:cryphub/application/widgets/expandable_sidebar.dart';

import '../../blocs/favorite_currencies/favorite_currencies_bloc.dart';
import '../../blocs/favorite_currencies_notifier/favorite_currencies_notifier_bloc.dart';
import '../../blocs/latest_currencies/latest_currencies_bloc.dart';
import 'widgets/favorite_currencies_carousel.dart';
import 'widgets/latest_currencies_view.dart';
import '../../../configure_dependencies.dart';
import '../../../domain/core/logger/logger.dart';
import '../../../domain/crypto_currency/crypto_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => app.get<FavoriteCurrenciesBloc>()
              ..add(const FavoriteCurrenciesEvent.loadFavorites())),
        BlocProvider(create: (context) => app.get<LatestCurrenciesBloc>()),
        BlocProvider(
          create: (context) => app.get<FavoriteCurrenciesNotifierBloc>(),
        )
      ],
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final PagingController<int, CryptoCurrency> pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 4);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      app.get<Logger>().info('Requesting new items from api. Page $pageKey');
      context
          .read<LatestCurrenciesBloc>()
          .add(LatestCurrenciesEvent.loadPage(pageKey));
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableSidebar(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            pagingController.refresh();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  'Home'.toUpperCase(),
                ),
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu),
                ),
                floating: true,
              ),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: FavoriteCurrenciesCarousel(),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  const Text('Latest'),
                ])),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver:
                    LatestCurrenciesView(pagingController: pagingController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
