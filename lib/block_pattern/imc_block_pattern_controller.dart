import 'dart:async';
import 'dart:math';

import 'package:default_state_manager/block_pattern/imc_state.dart';

class ImcBlockPatternController {
  final _imcStreamController = StreamController<ImcState>.broadcast()
    ..add(ImcState(imc: 0));

  Stream<ImcState> get imcOut => _imcStreamController.stream;

  void dispose() {
    _imcStreamController.close();
  }

  Future<void> calcularIMC({required double peso, required double altura}) async {
    try {
      _imcStreamController.add(ImcStateLoading());

      await Future.delayed(const Duration(seconds: 1));

      final imc = peso / pow(altura, 2);

      _imcStreamController.add(ImcState(imc: imc));
    } on Exception {
      _imcStreamController.add(ImcStateError(message: 'Erro ao calcular o IMC!!'));
    }
  }
}
