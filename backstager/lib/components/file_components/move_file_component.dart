import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/database/folder_dao.dart';
import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:backstager/models/MediaFolder.dart';
import 'package:flutter/material.dart';

class MoveFileComponent extends StatefulWidget {
  final MediaFile file;
  final VoidCallback? onFileMoved;

  const MoveFileComponent({super.key, required this.file, this.onFileMoved});

  @override
  State<MoveFileComponent> createState() => _MoveFileComponentState();
}

class _MoveFileComponentState extends State<MoveFileComponent> {
  bool _isSaving = false;
  bool _isLoading = true;
  MediaFolder? _selectedFolder;
  List<MediaFolder> _folders = [];
  final MediaFolderDao folderDao = MediaFolderDao(DatabaseConn.instance);
  final MediaFileDao fileDao = MediaFileDao(DatabaseConn.instance);
  late AppLocalizations t;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    t = AppLocalizations.of(context)!;
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    try {
      final folders = await folderDao.getAllMediaFolders();
      if (mounted) {
        setState(() {
          _folders = folders;
          _isLoading = false;
          _selectedFolder = widget.file.folderId != null
              ? _folders.firstWhere(
                  (folder) => folder.id == widget.file.folderId,
                  orElse: () => null as MediaFolder,
                )
              : null;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading folders: $e')));
    }
  }

  Future<void> _moveFile() async {
    if (widget.file.id == null) return;

    setState(() => _isSaving = true);

    try {
      final rowsAffected = await fileDao.patchFolderId(
        widget.file.id!,
        _selectedFolder?.id,
      );

      if (rowsAffected > 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.moveFileViewSuccess)));
        widget.onFileMoved?.call();
        if (mounted) Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.moveFileViewNoChanges)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error moving file: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        t.moveFileViewTitle,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoading
            ? SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              )
            : _folders.isEmpty
            ? Text(t.moveFileViewNoFolders)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.moveFileViewSelectInstruction),
                  const SizedBox(height: 10),
                  RadioListTile<MediaFolder?>(
                    title: Text(t.moveFileViewMainFolder),
                    value: null,
                    groupValue: _selectedFolder,
                    onChanged: (MediaFolder? value) {
                      setState(() {
                        _selectedFolder = value;
                      });
                    },
                  ),
                  ..._folders.map(
                    (folder) => RadioListTile<MediaFolder?>(
                      title: Text(folder.name),
                      value: folder,
                      groupValue: _selectedFolder,
                      onChanged: (MediaFolder? value) {
                        setState(() {
                          _selectedFolder = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.moveFileViewCancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _moveFile,
          child: Text(t.moveFileViewMove),
        ),
      ],
    );
  }
}
