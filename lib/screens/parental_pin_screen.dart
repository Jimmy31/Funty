import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/app_settings_store.dart';

/// Verrou parental par code PIN (cf. PRD 6.1/6.6), protège l'accès à la
/// curation et aux statistiques. Le code est persisté (cf.
/// [AppSettingsStore]) et modifiable depuis l'espace parental — placeholder
/// "1234" tant que le parent n'a pas défini le sien.
class ParentalPinScreen extends StatefulWidget {
  const ParentalPinScreen({super.key});

  @override
  State<ParentalPinScreen> createState() => _ParentalPinScreenState();
}

class _ParentalPinScreenState extends State<ParentalPinScreen> {
  String _entered = '';
  bool _error = false;

  void _onDigit(String digit, String correctPin) {
    if (_entered.length >= correctPin.length) return;
    setState(() {
      _entered += digit;
      _error = false;
    });
    if (_entered.length == correctPin.length) {
      _checkPin(correctPin);
    }
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  void _checkPin(String correctPin) {
    if (_entered == correctPin) {
      context.go('/parental/dashboard');
    } else {
      setState(() {
        _error = true;
        _entered = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pin = context.watch<AppSettingsStore>().pin;

    return Scaffold(
      appBar: AppBar(title: const Text('Code parental')),
      body: pin == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Entrez le code parental',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pin.length, (index) {
                      final filled = index < _entered.length;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _error
                              ? Colors.red
                              : (filled
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300),
                        ),
                      );
                    }),
                  ),
                  if (_error)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'Code incorrect',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 32),
                  _NumericPad(
                    onDigit: (digit) => _onDigit(digit, pin),
                    onBackspace: _onBackspace,
                  ),
                ],
              ),
            ),
    );
  }
}

class _NumericPad extends StatelessWidget {
  const _NumericPad({required this.onDigit, required this.onBackspace});

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in rows)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final digit in row) _PadButton(digit, onDigit),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 72, height: 72),
            _PadButton('0', onDigit),
            SizedBox(
              width: 72,
              height: 72,
              child: IconButton(
                icon: const Icon(Icons.backspace_outlined),
                onPressed: onBackspace,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton(this.digit, this.onDigit);

  final String digit;
  final ValueChanged<String> onDigit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: TextButton(
        onPressed: () => onDigit(digit),
        child: Text(digit, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
