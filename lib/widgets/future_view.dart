import 'package:flutter/material.dart';

import '../services/space_service.dart';
import '../theme/app_theme.dart';
import 'state_views.dart';

// Cuida dos três estados de uma requisição (carregando, erro, dados).
// O loader recebe "force" (true ao atualizar). O builder deve devolver um
// widget rolável, para o "puxar para atualizar" funcionar.
class FutureView<T> extends StatefulWidget {
  final Future<T> Function(bool force) loader;
  final Widget Function(BuildContext context, T data) builder;

  const FutureView({super.key, required this.loader, required this.builder});

  @override
  State<FutureView<T>> createState() => _FutureViewState<T>();
}

class _FutureViewState<T> extends State<FutureView<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.loader(false);
  }

  Future<void> _reload() async {
    final novo = widget.loader(true);
    setState(() => _future = novo);
    try {
      await novo;
    } catch (_) {
      // o erro já aparece na tela pelo FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SignalLoader();
        }
        if (snapshot.hasError) {
          final erro = snapshot.error;
          return Center(
            child: StateMessage(
              title: 'Sem sinal.',
              message: erro is ApiException ? erro.message : 'Ocorreu um erro inesperado.',
              actionLabel: 'TENTAR DE NOVO',
              onAction: _reload,
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.signal,
          backgroundColor: AppColors.panel,
          onRefresh: _reload,
          child: widget.builder(context, snapshot.data as T),
        );
      },
    );
  }
}
