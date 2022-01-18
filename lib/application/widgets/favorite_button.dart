import 'package:flutter/material.dart';

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
                key: Key('favorite'),
                color: Colors.redAccent,
              )
            : Icon(
                Icons.favorite_outline,
                color: Theme.of(context).colorScheme.onBackground,
                key: const Key('not_favorite'),
              ),
      ),
    );
  }
}
