import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BackStager'**
  String get appTitle;

  /// No description provided for @homeViewNoFilesFound.
  ///
  /// In en, this message translates to:
  /// **'No folders or files found'**
  String get homeViewNoFilesFound;

  /// No description provided for @homeViewRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get homeViewRefresh;

  /// No description provided for @homeViewAddFiles.
  ///
  /// In en, this message translates to:
  /// **'Add Files'**
  String get homeViewAddFiles;

  /// No description provided for @homeViewAddFolder.
  ///
  /// In en, this message translates to:
  /// **'Add Folder'**
  String get homeViewAddFolder;

  /// No description provided for @homeViewFolderOptions.
  ///
  /// In en, this message translates to:
  /// **'Folder Options'**
  String get homeViewFolderOptions;

  /// No description provided for @homeViewFileOptions.
  ///
  /// In en, this message translates to:
  /// **'File Options'**
  String get homeViewFileOptions;

  /// No description provided for @homeViewEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get homeViewEdit;

  /// No description provided for @homeViewDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get homeViewDelete;

  /// No description provided for @homeViewMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get homeViewMove;

  /// No description provided for @homeViewConfirmDeleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this folder?'**
  String get homeViewConfirmDeleteFolder;

  /// No description provided for @homeViewConfirmDeleteFile.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this file?'**
  String get homeViewConfirmDeleteFile;

  /// No description provided for @permissionScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio & Image Access Required'**
  String get permissionScreenTitle;

  /// No description provided for @permissionScreenDescription.
  ///
  /// In en, this message translates to:
  /// **'Backstager needs permission to access audio files and images on your device. This is required to load your media and save clips.'**
  String get permissionScreenDescription;

  /// No description provided for @permissionScreenAllowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get permissionScreenAllowAccess;

  /// No description provided for @permissionScreenAudioPermission.
  ///
  /// In en, this message translates to:
  /// **'Audio Access'**
  String get permissionScreenAudioPermission;

  /// No description provided for @permissionScreenPhotosPermission.
  ///
  /// In en, this message translates to:
  /// **'Photos Access'**
  String get permissionScreenPhotosPermission;

  /// No description provided for @permissionScreenPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionScreenPermissionDenied;

  /// No description provided for @permissionScreenPermissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Access Granted'**
  String get permissionScreenPermissionGranted;

  /// No description provided for @permissionScreenPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Enable in Settings'**
  String get permissionScreenPermissionPermanentlyDenied;

  /// No description provided for @permissionScreenPermissionRestricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted (Parental Controls)'**
  String get permissionScreenPermissionRestricted;

  /// No description provided for @permissionScreenPermissionLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited Access'**
  String get permissionScreenPermissionLimited;

  /// No description provided for @audioPlayerNoClips.
  ///
  /// In en, this message translates to:
  /// **'No clips created'**
  String get audioPlayerNoClips;

  /// No description provided for @audioPlayerCreateClip.
  ///
  /// In en, this message translates to:
  /// **'Create Clip'**
  String get audioPlayerCreateClip;

  /// No description provided for @audioPlayerPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get audioPlayerPlay;

  /// No description provided for @audioPlayerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get audioPlayerPause;

  /// No description provided for @audioPlayerStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get audioPlayerStop;

  /// No description provided for @audioPlayerLoop.
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get audioPlayerLoop;

  /// No description provided for @audioPlayerDeleteClipTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Clip'**
  String get audioPlayerDeleteClipTitle;

  /// No description provided for @audioPlayerDeleteClipMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{clipName}\"?'**
  String audioPlayerDeleteClipMessage(Object clipName);

  /// No description provided for @audioPlayerDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get audioPlayerDelete;

  /// No description provided for @audioPlayerClipCreated.
  ///
  /// In en, this message translates to:
  /// **'Clip created successfully'**
  String get audioPlayerClipCreated;

  /// No description provided for @audioPlayerClipCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create clip'**
  String get audioPlayerClipCreationFailed;

  /// No description provided for @audioPlayerClipDeleted.
  ///
  /// In en, this message translates to:
  /// **'Clip deleted successfully'**
  String get audioPlayerClipDeleted;

  /// No description provided for @audioPlayerClipDeletionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete clip'**
  String get audioPlayerClipDeletionFailed;

  /// No description provided for @audioPlayerTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'{minutes}:{seconds}'**
  String audioPlayerTimeFormat(Object minutes, Object seconds);

  /// No description provided for @audioPlayerTimeFormatWithHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}:{minutes}:{seconds}'**
  String audioPlayerTimeFormatWithHours(Object hours, Object minutes, Object seconds);

  /// No description provided for @folderContentViewNoFiles.
  ///
  /// In en, this message translates to:
  /// **'No files in this folder'**
  String get folderContentViewNoFiles;

  /// No description provided for @folderContentViewFileOptions.
  ///
  /// In en, this message translates to:
  /// **'File Options'**
  String get folderContentViewFileOptions;

  /// No description provided for @folderContentViewEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get folderContentViewEdit;

  /// No description provided for @folderContentViewDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get folderContentViewDelete;

  /// No description provided for @folderContentViewMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get folderContentViewMove;

  /// No description provided for @folderContentViewConfirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete File'**
  String get folderContentViewConfirmDeleteTitle;

  /// No description provided for @folderContentViewConfirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this file?'**
  String get folderContentViewConfirmDeleteMessage;

  /// No description provided for @folderContentViewFileMoved.
  ///
  /// In en, this message translates to:
  /// **'File moved successfully'**
  String get folderContentViewFileMoved;

  /// No description provided for @folderContentViewFileMoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to move file'**
  String get folderContentViewFileMoveFailed;

  /// No description provided for @folderContentViewFileDeleted.
  ///
  /// In en, this message translates to:
  /// **'File deleted successfully'**
  String get folderContentViewFileDeleted;

  /// No description provided for @folderContentViewFileDeletionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete file'**
  String get folderContentViewFileDeletionFailed;

  /// No description provided for @folderContentViewFileUpdated.
  ///
  /// In en, this message translates to:
  /// **'File updated successfully'**
  String get folderContentViewFileUpdated;

  /// No description provided for @folderContentViewFileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update file'**
  String get folderContentViewFileUpdateFailed;

  /// No description provided for @addFilesViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Media Files'**
  String get addFilesViewTitle;

  /// No description provided for @addFilesViewEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Add files and save them with the buttons below'**
  String get addFilesViewEmptyState;

  /// No description provided for @addFilesViewAddFiles.
  ///
  /// In en, this message translates to:
  /// **'Add Files'**
  String get addFilesViewAddFiles;

  /// No description provided for @addFilesViewSaveFiles.
  ///
  /// In en, this message translates to:
  /// **'Save Files'**
  String get addFilesViewSaveFiles;

  /// No description provided for @addFilesViewSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get addFilesViewSaving;

  /// No description provided for @addFilesViewFileSaved.
  ///
  /// In en, this message translates to:
  /// **'Files saved successfully!'**
  String get addFilesViewFileSaved;

  /// No description provided for @addFilesViewSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving files, try again or report'**
  String get addFilesViewSaveError;

  /// No description provided for @addFilesViewPickError.
  ///
  /// In en, this message translates to:
  /// **'Error picking files: {error}'**
  String addFilesViewPickError(Object error);

  /// No description provided for @addFilesViewAudioFile.
  ///
  /// In en, this message translates to:
  /// **'Audio File'**
  String get addFilesViewAudioFile;

  /// No description provided for @addFilesViewVideoFile.
  ///
  /// In en, this message translates to:
  /// **'Video File'**
  String get addFilesViewVideoFile;

  /// No description provided for @addFilesViewFileSize.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String addFilesViewFileSize(Object size);

  /// No description provided for @addFilesViewRemoveFile.
  ///
  /// In en, this message translates to:
  /// **'Remove File'**
  String get addFilesViewRemoveFile;

  /// No description provided for @createFolderViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Folder'**
  String get createFolderViewTitle;

  /// No description provided for @createFolderViewNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get createFolderViewNameLabel;

  /// No description provided for @createFolderViewNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter folder name'**
  String get createFolderViewNameHint;

  /// No description provided for @createFolderViewCoverLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder Cover Image (Optional)'**
  String get createFolderViewCoverLabel;

  /// No description provided for @createFolderViewSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to select image'**
  String get createFolderViewSelectImage;

  /// No description provided for @createFolderViewCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get createFolderViewCancel;

  /// No description provided for @createFolderViewCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Folder'**
  String get createFolderViewCreate;

  /// No description provided for @createFolderViewEmptyNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a folder name'**
  String get createFolderViewEmptyNameError;

  /// No description provided for @createFolderViewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Folder \"{folderName}\" created successfully'**
  String createFolderViewSuccess(Object folderName);

  /// No description provided for @createFolderViewFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to create folder: {error}'**
  String createFolderViewFailure(Object error);

  /// No description provided for @deleteFolderViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder'**
  String get deleteFolderViewTitle;

  /// No description provided for @deleteFolderViewConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove this folder from app storage?'**
  String get deleteFolderViewConfirmation;

  /// No description provided for @deleteFolderViewCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteFolderViewCancel;

  /// No description provided for @deleteFolderViewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteFolderViewConfirm;

  /// No description provided for @deleteFolderViewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Folder deleted successfully'**
  String get deleteFolderViewSuccess;

  /// No description provided for @deleteFolderViewFailure.
  ///
  /// In en, this message translates to:
  /// **'Error deleting folder: {error}'**
  String deleteFolderViewFailure(Object error);

  /// No description provided for @editFolderViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Folder'**
  String get editFolderViewTitle;

  /// No description provided for @editFolderViewNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Change name'**
  String get editFolderViewNameLabel;

  /// No description provided for @editFolderViewNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new folder name'**
  String get editFolderViewNameHint;

  /// No description provided for @editFolderViewCoverLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder Cover Image (Optional)'**
  String get editFolderViewCoverLabel;

  /// No description provided for @editFolderViewSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to select image'**
  String get editFolderViewSelectImage;

  /// No description provided for @editFolderViewCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editFolderViewCancel;

  /// No description provided for @editFolderViewSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editFolderViewSave;

  /// No description provided for @editFolderViewSuccessRename.
  ///
  /// In en, this message translates to:
  /// **'Folder renamed successfully'**
  String get editFolderViewSuccessRename;

  /// No description provided for @editFolderViewSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'Folder and image updated successfully'**
  String get editFolderViewSuccessUpdate;

  /// No description provided for @editFolderViewFailure.
  ///
  /// In en, this message translates to:
  /// **'Error updating folder: {error}'**
  String editFolderViewFailure(Object error);

  /// No description provided for @deleteFileViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete File'**
  String get deleteFileViewTitle;

  /// No description provided for @deleteFileViewConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove this file from app storage? The original file will stay on your device.'**
  String get deleteFileViewConfirmation;

  /// No description provided for @deleteFileViewCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteFileViewCancel;

  /// No description provided for @deleteFileViewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteFileViewConfirm;

  /// No description provided for @deleteFileViewSuccess.
  ///
  /// In en, this message translates to:
  /// **'File deleted successfully'**
  String get deleteFileViewSuccess;

  /// No description provided for @deleteFileViewFailure.
  ///
  /// In en, this message translates to:
  /// **'Error deleting file: {error}'**
  String deleteFileViewFailure(Object error);

  /// No description provided for @editFileViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit File'**
  String get editFileViewTitle;

  /// No description provided for @editFileViewNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Change name'**
  String get editFileViewNameLabel;

  /// No description provided for @editFileViewNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new file name'**
  String get editFileViewNameHint;

  /// No description provided for @editFileViewCoverLabel.
  ///
  /// In en, this message translates to:
  /// **'File Cover Image (Optional)'**
  String get editFileViewCoverLabel;

  /// No description provided for @editFileViewSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to select image'**
  String get editFileViewSelectImage;

  /// No description provided for @editFileViewCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editFileViewCancel;

  /// No description provided for @editFileViewSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editFileViewSave;

  /// No description provided for @editFileViewSuccessRename.
  ///
  /// In en, this message translates to:
  /// **'File renamed successfully'**
  String get editFileViewSuccessRename;

  /// No description provided for @editFileViewSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'File and image updated successfully'**
  String get editFileViewSuccessUpdate;

  /// No description provided for @editFileViewFailure.
  ///
  /// In en, this message translates to:
  /// **'Error updating file: {error}'**
  String editFileViewFailure(Object error);

  /// No description provided for @moveFileViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Move File'**
  String get moveFileViewTitle;

  /// No description provided for @moveFileViewLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading folders...'**
  String get moveFileViewLoading;

  /// No description provided for @moveFileViewNoFolders.
  ///
  /// In en, this message translates to:
  /// **'No folders found'**
  String get moveFileViewNoFolders;

  /// No description provided for @moveFileViewSelectInstruction.
  ///
  /// In en, this message translates to:
  /// **'Select a folder to move your file'**
  String get moveFileViewSelectInstruction;

  /// No description provided for @moveFileViewMainFolder.
  ///
  /// In en, this message translates to:
  /// **'Main folder'**
  String get moveFileViewMainFolder;

  /// No description provided for @moveFileViewCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get moveFileViewCancel;

  /// No description provided for @moveFileViewMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get moveFileViewMove;

  /// No description provided for @moveFileViewSuccess.
  ///
  /// In en, this message translates to:
  /// **'File moved successfully'**
  String get moveFileViewSuccess;

  /// No description provided for @moveFileViewNoChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes were made to the file'**
  String get moveFileViewNoChanges;

  /// No description provided for @moveFileViewFailure.
  ///
  /// In en, this message translates to:
  /// **'Error moving file: {error}'**
  String moveFileViewFailure(Object error);

  /// No description provided for @createClipViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Clip'**
  String get createClipViewTitle;

  /// No description provided for @createClipViewClipNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Clip Name'**
  String get createClipViewClipNameLabel;

  /// No description provided for @createClipViewClipNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter clip name'**
  String get createClipViewClipNameHint;

  /// No description provided for @createClipViewClipColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Clip color (Optional)'**
  String get createClipViewClipColorLabel;

  /// No description provided for @createClipViewClipRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Clip Range'**
  String get createClipViewClipRangeLabel;

  /// No description provided for @createClipViewStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Start: {start}s'**
  String createClipViewStartLabel(Object start);

  /// No description provided for @createClipViewEndLabel.
  ///
  /// In en, this message translates to:
  /// **'End: {end}s'**
  String createClipViewEndLabel(Object end);

  /// No description provided for @createClipViewCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get createClipViewCancel;

  /// No description provided for @createClipViewCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Clip'**
  String get createClipViewCreate;

  /// No description provided for @createClipViewErrorAudioLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load audio: {error}'**
  String createClipViewErrorAudioLoad(Object error);

  /// No description provided for @createClipViewErrorEmptyName.
  ///
  /// In en, this message translates to:
  /// **'Clip name cannot be empty'**
  String get createClipViewErrorEmptyName;

  /// No description provided for @createClipViewErrorCreate.
  ///
  /// In en, this message translates to:
  /// **'Failed to create clip: {error}'**
  String createClipViewErrorCreate(Object error);

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonFolderName.
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get commonFolderName;

  /// No description provided for @commonFileName.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get commonFileName;

  /// No description provided for @commonRoot.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get commonRoot;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
