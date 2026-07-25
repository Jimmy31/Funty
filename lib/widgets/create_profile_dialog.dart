import 'package:flutter/material.dart';

const kAvailableAvatars = ['🦊', '🐸', '🐼', '🦁', '🐨', '🐵', '🦄', '🐙'];

/// Dialogue de création de profil (nom + avatar), partagé entre la
/// sélection de profil et le tableau de bord parental. Retourne
/// `(nom, avatarId)` ou `null` si annulé.
class CreateProfileDialog extends StatefulWidget {
  const CreateProfileDialog({super.key});

  @override
  State<CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends State<CreateProfileDialog> {
  final _nameController = TextEditingController();
  String _selectedAvatar = kAvailableAvatars.first;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouveau profil'),
      // SingleChildScrollView : avec le clavier ouvert sur un petit écran,
      // le nom + les 8 avatars ne tiennent pas toujours dans la hauteur
      // restante (overflow observé sur appareil réel).
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                for (final avatar in kAvailableAvatars)
                  ChoiceChip(
                    label: Text(avatar, style: const TextStyle(fontSize: 20)),
                    selected: _selectedAvatar == avatar,
                    onSelected: (_) =>
                        setState(() => _selectedAvatar = avatar),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _nameController.text.trim().isEmpty
              ? null
              : () => Navigator.of(
                  context,
                ).pop((_nameController.text.trim(), _selectedAvatar)),
          child: const Text('Créer'),
        ),
      ],
    );
  }
}
