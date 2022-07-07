import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:default_state_manager/block_pattern/imc_block_pattern_controller.dart';
import 'package:default_state_manager/block_pattern/imc_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/imc_gauge.dart';

class ImcBlockPatternPage extends StatefulWidget {
  const ImcBlockPatternPage({Key? key}) : super(key: key);

  @override
  State<ImcBlockPatternPage> createState() => _ImcBlockPatternPageState();
}

class _ImcBlockPatternPageState extends State<ImcBlockPatternPage> {
  final controller = ImcBlockPatternController();

  final pesoEC = TextEditingController();
  final alturaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pesoEC.dispose();
    alturaEC.dispose();
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC Block Pattern (Streams)'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<ImcState>(
                    stream: controller.imcOut,
                    builder: (context, snapshot) {
                      var imc = 0.0;

                      if (snapshot.hasData) {
                        imc = snapshot.data?.imc ?? 0;
                      }

                      return ImcGauge(imc: imc);
                    }),
                const SizedBox(height: 20),
                StreamBuilder<ImcState>(
                    stream: controller.imcOut,
                    builder: (context, snapshot) {
                      final dataValue = snapshot.data;

                      if (dataValue is ImcStateLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (dataValue is ImcStateError) {
                        return Center(
                          child: Text(dataValue.message),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                TextFormField(
                  controller: pesoEC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso'),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: 'pt_BR',
                      symbol: '',
                      decimalDigits: 2,
                      turnOffGrouping: true,
                    ),
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Peso é obrigatório';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: alturaEC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Altura'),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: 'pt_BR',
                      symbol: '',
                      decimalDigits: 2,
                      turnOffGrouping: true,
                    ),
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Altura é obrigatória';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      final formValid = formKey.currentState?.validate() ?? false;

                      if (formValid) {
                        var formatter = NumberFormat.simpleCurrency(
                          locale: 'pt_BR',
                          decimalDigits: 2,
                        );

                        double peso = formatter.parse(pesoEC.text) as double;
                        double altura = formatter.parse(alturaEC.text) as double;

                        controller.calcularIMC(peso: peso, altura: altura);
                      }
                    },
                    child: const Text('Calcular IMC'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
