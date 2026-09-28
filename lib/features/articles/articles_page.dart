import 'package:flutter/material.dart';

import '../../core/widgets/coming_soon_view.dart';

/// Artikel edukasi kesehatan. Menunggu endpoint CI3.
class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      icon: Icons.article_rounded,
      title: 'Artikel',
      description:
          'Bacaan edukasi kesehatan dari rumah sakit akan tampil di sini '
          'berserta kategori dan pencarian.',
    );
  }
}
