import 'package:flutter/foundation.dart';

@immutable
class LoadingController {
  final bool Function() close;
  final bool Function(String text) update;

  const LoadingController({
    required this.close,
    required this.update,
  });
}
