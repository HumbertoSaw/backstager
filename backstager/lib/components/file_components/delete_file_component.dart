import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:flutter/material.dart';

class DeleteFileComponent extends StatefulWidget {
  final MediaFile file;
  final VoidCallback? onFileDeleted;

  const DeleteFileComponent({
    super.key,
    required this.file,
    this.onFileDeleted,
  });

  @override
  State<DeleteFileComponent> createState() => _DeleteFileComponentState();
}

class _DeleteFileComponentState extends State<DeleteFileComponent> {
  bool _isSaving = false;

  final MediaFileDao fileDao = MediaFileDao(DatabaseConn.instance);

  Future<void> _deleteFile() async {
    setState(() => _isSaving = true);
    final t = AppLocalizations.of(context)!;

    try {
      await fileDao.deleteMediaFile(widget.file.id!);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.deleteFileViewSuccess)));

      if (widget.onFileDeleted != null) {
        widget.onFileDeleted!();
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating file: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        t.deleteFileViewTitle,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(t.deleteFileViewConfirmation)],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.deleteFileViewCancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _deleteFile,
          child: Text(t.deleteFileViewConfirm),
        ),
      ],
    );
  }
}
