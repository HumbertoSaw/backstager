// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BackStager';

  @override
  String get homeViewNoFilesFound => 'No folders or files found';

  @override
  String get homeViewRefresh => 'Refresh';

  @override
  String get homeViewAddFiles => 'Add Files';

  @override
  String get homeViewAddFolder => 'Add Folder';

  @override
  String get homeViewFolderOptions => 'Folder Options';

  @override
  String get homeViewFileOptions => 'File Options';

  @override
  String get homeViewEdit => 'Edit';

  @override
  String get homeViewDelete => 'Delete';

  @override
  String get homeViewMove => 'Move';

  @override
  String get homeViewConfirmDeleteFolder => 'Are you sure you want to delete this folder?';

  @override
  String get homeViewConfirmDeleteFile => 'Are you sure you want to delete this file?';

  @override
  String get permissionScreenTitle => 'Audio & Image Access Required';

  @override
  String get permissionScreenDescription => 'Backstager needs permission to access audio files and images on your device. This is required to load your media and save clips.';

  @override
  String get permissionScreenAllowAccess => 'Allow Access';

  @override
  String get permissionScreenAudioPermission => 'Audio Access';

  @override
  String get permissionScreenPhotosPermission => 'Photos Access';

  @override
  String get permissionScreenPermissionDenied => 'Permission Denied';

  @override
  String get permissionScreenPermissionGranted => 'Access Granted';

  @override
  String get permissionScreenPermissionPermanentlyDenied => 'Enable in Settings';

  @override
  String get permissionScreenPermissionRestricted => 'Restricted (Parental Controls)';

  @override
  String get permissionScreenPermissionLimited => 'Limited Access';

  @override
  String get audioPlayerNoClips => 'No clips created';

  @override
  String get audioPlayerCreateClip => 'Create Clip';

  @override
  String get audioPlayerPlay => 'Play';

  @override
  String get audioPlayerPause => 'Pause';

  @override
  String get audioPlayerStop => 'Stop';

  @override
  String get audioPlayerLoop => 'Loop';

  @override
  String get audioPlayerDeleteClipTitle => 'Delete Clip';

  @override
  String audioPlayerDeleteClipMessage(Object clipName) {
    return 'Are you sure you want to delete \"$clipName\"?';
  }

  @override
  String get audioPlayerDelete => 'Delete';

  @override
  String get audioPlayerClipCreated => 'Clip created successfully';

  @override
  String get audioPlayerClipCreationFailed => 'Failed to create clip';

  @override
  String get audioPlayerClipDeleted => 'Clip deleted successfully';

  @override
  String get audioPlayerClipDeletionFailed => 'Failed to delete clip';

  @override
  String audioPlayerTimeFormat(Object minutes, Object seconds) {
    return '$minutes:$seconds';
  }

  @override
  String audioPlayerTimeFormatWithHours(Object hours, Object minutes, Object seconds) {
    return '$hours:$minutes:$seconds';
  }

  @override
  String get folderContentViewNoFiles => 'No files in this folder';

  @override
  String get folderContentViewFileOptions => 'File Options';

  @override
  String get folderContentViewEdit => 'Edit';

  @override
  String get folderContentViewDelete => 'Delete';

  @override
  String get folderContentViewMove => 'Move';

  @override
  String get folderContentViewConfirmDeleteTitle => 'Delete File';

  @override
  String get folderContentViewConfirmDeleteMessage => 'Are you sure you want to delete this file?';

  @override
  String get folderContentViewFileMoved => 'File moved successfully';

  @override
  String get folderContentViewFileMoveFailed => 'Failed to move file';

  @override
  String get folderContentViewFileDeleted => 'File deleted successfully';

  @override
  String get folderContentViewFileDeletionFailed => 'Failed to delete file';

  @override
  String get folderContentViewFileUpdated => 'File updated successfully';

  @override
  String get folderContentViewFileUpdateFailed => 'Failed to update file';

  @override
  String get addFilesViewTitle => 'Add Media Files';

  @override
  String get addFilesViewEmptyState => 'Add files and save them with the buttons below';

  @override
  String get addFilesViewAddFiles => 'Add Files';

  @override
  String get addFilesViewSaveFiles => 'Save Files';

  @override
  String get addFilesViewSaving => 'Saving...';

  @override
  String get addFilesViewFileSaved => 'Files saved successfully!';

  @override
  String get addFilesViewSaveError => 'Error saving files, try again or report';

  @override
  String addFilesViewPickError(Object error) {
    return 'Error picking files: $error';
  }

  @override
  String get addFilesViewAudioFile => 'Audio File';

  @override
  String get addFilesViewVideoFile => 'Video File';

  @override
  String addFilesViewFileSize(Object size) {
    return '$size KB';
  }

  @override
  String get addFilesViewRemoveFile => 'Remove File';

  @override
  String get createFolderViewTitle => 'Create New Folder';

  @override
  String get createFolderViewNameLabel => 'Folder Name';

  @override
  String get createFolderViewNameHint => 'Enter folder name';

  @override
  String get createFolderViewCoverLabel => 'Folder Cover Image (Optional)';

  @override
  String get createFolderViewSelectImage => 'Tap to select image';

  @override
  String get createFolderViewCancel => 'Cancel';

  @override
  String get createFolderViewCreate => 'Create Folder';

  @override
  String get createFolderViewEmptyNameError => 'Please enter a folder name';

  @override
  String createFolderViewSuccess(Object folderName) {
    return 'Folder \"$folderName\" created successfully';
  }

  @override
  String createFolderViewFailure(Object error) {
    return 'Failed to create folder: $error';
  }

  @override
  String get deleteFolderViewTitle => 'Delete Folder';

  @override
  String get deleteFolderViewConfirmation => 'Remove this folder from app storage?';

  @override
  String get deleteFolderViewCancel => 'Cancel';

  @override
  String get deleteFolderViewConfirm => 'Delete';

  @override
  String get deleteFolderViewSuccess => 'Folder deleted successfully';

  @override
  String deleteFolderViewFailure(Object error) {
    return 'Error deleting folder: $error';
  }

  @override
  String get editFolderViewTitle => 'Edit Folder';

  @override
  String get editFolderViewNameLabel => 'Change name';

  @override
  String get editFolderViewNameHint => 'Enter new folder name';

  @override
  String get editFolderViewCoverLabel => 'Folder Cover Image (Optional)';

  @override
  String get editFolderViewSelectImage => 'Tap to select image';

  @override
  String get editFolderViewCancel => 'Cancel';

  @override
  String get editFolderViewSave => 'Save';

  @override
  String get editFolderViewSuccessRename => 'Folder renamed successfully';

  @override
  String get editFolderViewSuccessUpdate => 'Folder and image updated successfully';

  @override
  String editFolderViewFailure(Object error) {
    return 'Error updating folder: $error';
  }

  @override
  String get deleteFileViewTitle => 'Delete File';

  @override
  String get deleteFileViewConfirmation => 'Remove this file from app storage? The original file will stay on your device.';

  @override
  String get deleteFileViewCancel => 'Cancel';

  @override
  String get deleteFileViewConfirm => 'Delete';

  @override
  String get deleteFileViewSuccess => 'File deleted successfully';

  @override
  String deleteFileViewFailure(Object error) {
    return 'Error deleting file: $error';
  }

  @override
  String get editFileViewTitle => 'Edit File';

  @override
  String get editFileViewNameLabel => 'Change name';

  @override
  String get editFileViewNameHint => 'Enter new file name';

  @override
  String get editFileViewCoverLabel => 'File Cover Image (Optional)';

  @override
  String get editFileViewSelectImage => 'Tap to select image';

  @override
  String get editFileViewCancel => 'Cancel';

  @override
  String get editFileViewSave => 'Save';

  @override
  String get editFileViewSuccessRename => 'File renamed successfully';

  @override
  String get editFileViewSuccessUpdate => 'File and image updated successfully';

  @override
  String editFileViewFailure(Object error) {
    return 'Error updating file: $error';
  }

  @override
  String get moveFileViewTitle => 'Move File';

  @override
  String get moveFileViewLoading => 'Loading folders...';

  @override
  String get moveFileViewNoFolders => 'No folders found';

  @override
  String get moveFileViewSelectInstruction => 'Select a folder to move your file';

  @override
  String get moveFileViewMainFolder => 'Main folder';

  @override
  String get moveFileViewCancel => 'Cancel';

  @override
  String get moveFileViewMove => 'Move';

  @override
  String get moveFileViewSuccess => 'File moved successfully';

  @override
  String get moveFileViewNoChanges => 'No changes were made to the file';

  @override
  String moveFileViewFailure(Object error) {
    return 'Error moving file: $error';
  }

  @override
  String get createClipViewTitle => 'Create New Clip';

  @override
  String get createClipViewClipNameLabel => 'Clip Name';

  @override
  String get createClipViewClipNameHint => 'Enter clip name';

  @override
  String get createClipViewClipColorLabel => 'Clip color (Optional)';

  @override
  String get createClipViewClipRangeLabel => 'Clip Range';

  @override
  String createClipViewStartLabel(Object start) {
    return 'Start: ${start}s';
  }

  @override
  String createClipViewEndLabel(Object end) {
    return 'End: ${end}s';
  }

  @override
  String get createClipViewCancel => 'Cancel';

  @override
  String get createClipViewCreate => 'Create Clip';

  @override
  String createClipViewErrorAudioLoad(Object error) {
    return 'Failed to load audio: $error';
  }

  @override
  String get createClipViewErrorEmptyName => 'Clip name cannot be empty';

  @override
  String createClipViewErrorCreate(Object error) {
    return 'Failed to create clip: $error';
  }

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonFolderName => 'Folder Name';

  @override
  String get commonFileName => 'File Name';

  @override
  String get commonRoot => 'Root';
}
