import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:palette_generator/palette_generator.dart';

@lazySingleton
class DominantColorFinder {
  /// Finds the dominant color from the provided [image].
  ///
  /// Dominant color is the color that appears the most in the image.
  ///
  /// See https://stackoverflow.com/questions/62718295/how-to-get-dominant-color-from-image-in-flutter
  Future<Color> find(ImageProvider image) async {
    final paletteGenerator =
        await PaletteGenerator.fromImageProvider(image, maximumColorCount: 1);
    final dominantColor = paletteGenerator.dominantColor?.color;
    if (dominantColor != null) {
      return dominantColor;
    }
    throw Exception('Could not find dominant color.');
  }
}
