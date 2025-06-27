import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/models/MediaFolder.dart';
import 'package:flutter/material.dart';

class DeleteFolderComponent extends StatefulWidget {
  final MediaFolder folder;
  final VoidCallback? onFolderDeleted;

  const DeleteFolderComponent({
    super.key,
    required this.folder,
    this.onFolderDeleted,
  });

  @override
  State<DeleteFolderComponent> createState() => _DeleteFolderComponentState();
}

class _DeleteFolderComponentState extends State<DeleteFolderComponent> {
  bool _isSaving = false;

  final MediaFileDao fileDao = MediaFileDao(DatabaseConn.instance);

  @override
  Future<void> _deleteFolder() async {
    final t = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);

    try {
      await fileDao.deleteMediaFile(widget.folder.id!);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.deleteFolderViewSuccess)));
      }

      if (widget.onFolderDeleted != null) {
        widget.onFolderDeleted!();
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating file: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        t.deleteFolderViewTitle,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Text(t.deleteFolderViewConfirmation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.deleteFolderViewCancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _deleteFolder,
          child: Text(t.deleteFolderViewConfirm),
        ),
      ],
    );
  }
}
