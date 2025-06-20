import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _deleteFolder() async {
    setState(() => _isSaving = true);

    try {
      await fileDao.deleteMediaFile(widget.folder.id!);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Folder deleted successfully')));

      if (widget.onFolderDeleted != null) {
        widget.onFolderDeleted!();
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
    return AlertDialog(
      title: Text(
        'Delete Folder',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text("Remove this folder from app storage?")],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _deleteFolder,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
