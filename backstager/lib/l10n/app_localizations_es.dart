// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'BackStager';

  @override
  String get homeViewNoFilesFound => 'No se encontraron carpetas o archivos';

  @override
  String get homeViewRefresh => 'Actualizar';

  @override
  String get homeViewAddFiles => 'Agregar Archivos';

  @override
  String get homeViewAddFolder => 'Agregar Carpeta';

  @override
  String get homeViewFolderOptions => 'Opciones de Carpeta';

  @override
  String get homeViewFileOptions => 'Opciones de Archivo';

  @override
  String get homeViewEdit => 'Editar';

  @override
  String get homeViewDelete => 'Eliminar';

  @override
  String get homeViewMove => 'Mover';

  @override
  String get homeViewConfirmDeleteFolder => '¿Estás seguro de eliminar esta carpeta?';

  @override
  String get homeViewConfirmDeleteFile => '¿Estás seguro de eliminar este archivo?';

  @override
  String get permissionScreenTitle => 'Acceso a Audio e Imágenes Requerido';

  @override
  String get permissionScreenDescription => 'Backstager necesita permiso para acceder a archivos de audio e imágenes en tu dispositivo. Esto es necesario para cargar tus medios y guardar clips.';

  @override
  String get permissionScreenAllowAccess => 'Permitir Acceso';

  @override
  String get permissionScreenAudioPermission => 'Acceso a Audio';

  @override
  String get permissionScreenPhotosPermission => 'Acceso a Fotos';

  @override
  String get permissionScreenPermissionDenied => 'Permiso Denegado';

  @override
  String get permissionScreenPermissionGranted => 'Acceso Permitido';

  @override
  String get permissionScreenPermissionPermanentlyDenied => 'Habilitar en Ajustes';

  @override
  String get permissionScreenPermissionRestricted => 'Restringido (Control Parental)';

  @override
  String get permissionScreenPermissionLimited => 'Acceso Limitado';

  @override
  String get audioPlayerNoClips => 'No hay clips creados';

  @override
  String get audioPlayerCreateClip => 'Crear Clip';

  @override
  String get audioPlayerPlay => 'Reproducir';

  @override
  String get audioPlayerPause => 'Pausar';

  @override
  String get audioPlayerStop => 'Detener';

  @override
  String get audioPlayerLoop => 'Repetir';

  @override
  String get audioPlayerDeleteClipTitle => 'Eliminar Clip';

  @override
  String audioPlayerDeleteClipMessage(Object clipName) {
    return '¿Estás seguro de querer eliminar \"$clipName\"?';
  }

  @override
  String get audioPlayerDelete => 'Eliminar';

  @override
  String get audioPlayerClipCreated => 'Clip creado exitosamente';

  @override
  String get audioPlayerClipCreationFailed => 'Error al crear clip';

  @override
  String get audioPlayerClipDeleted => 'Clip eliminado exitosamente';

  @override
  String get audioPlayerClipDeletionFailed => 'Error al eliminar clip';

  @override
  String audioPlayerTimeFormat(Object minutes, Object seconds) {
    return '$minutes:$seconds';
  }

  @override
  String audioPlayerTimeFormatWithHours(Object hours, Object minutes, Object seconds) {
    return '$hours:$minutes:$seconds';
  }

  @override
  String get folderContentViewNoFiles => 'No hay archivos en esta carpeta';

  @override
  String get folderContentViewFileOptions => 'Opciones de Archivo';

  @override
  String get folderContentViewEdit => 'Editar';

  @override
  String get folderContentViewDelete => 'Eliminar';

  @override
  String get folderContentViewMove => 'Mover';

  @override
  String get folderContentViewConfirmDeleteTitle => 'Eliminar Archivo';

  @override
  String get folderContentViewConfirmDeleteMessage => '¿Estás seguro de querer eliminar este archivo?';

  @override
  String get folderContentViewFileMoved => 'Archivo movido exitosamente';

  @override
  String get folderContentViewFileMoveFailed => 'Error al mover archivo';

  @override
  String get folderContentViewFileDeleted => 'Archivo eliminado exitosamente';

  @override
  String get folderContentViewFileDeletionFailed => 'Error al eliminar archivo';

  @override
  String get folderContentViewFileUpdated => 'Archivo actualizado exitosamente';

  @override
  String get folderContentViewFileUpdateFailed => 'Error al actualizar archivo';

  @override
  String get addFilesViewTitle => 'Agregar Archivos Multimedia';

  @override
  String get addFilesViewEmptyState => 'Agrega archivos y guárdalos con los botones de abajo';

  @override
  String get addFilesViewAddFiles => 'Agregar Archivos';

  @override
  String get addFilesViewSaveFiles => 'Guardar Archivos';

  @override
  String get addFilesViewSaving => 'Guardando...';

  @override
  String get addFilesViewFileSaved => '¡Archivos guardados exitosamente!';

  @override
  String get addFilesViewSaveError => 'Error al guardar archivos, intenta nuevamente o reporta';

  @override
  String addFilesViewPickError(Object error) {
    return 'Error al seleccionar archivos: $error';
  }

  @override
  String get addFilesViewAudioFile => 'Archivo de Audio';

  @override
  String get addFilesViewVideoFile => 'Archivo de Video';

  @override
  String addFilesViewFileSize(Object size) {
    return '$size KB';
  }

  @override
  String get addFilesViewRemoveFile => 'Eliminar Archivo';

  @override
  String get createFolderViewTitle => 'Crear Nueva Carpeta';

  @override
  String get createFolderViewNameLabel => 'Nombre de la Carpeta';

  @override
  String get createFolderViewNameHint => 'Ingresa el nombre de la carpeta';

  @override
  String get createFolderViewCoverLabel => 'Imagen de Portada (Opcional)';

  @override
  String get createFolderViewSelectImage => 'Toca para seleccionar una imagen';

  @override
  String get createFolderViewCancel => 'Cancelar';

  @override
  String get createFolderViewCreate => 'Crear Carpeta';

  @override
  String get createFolderViewEmptyNameError => 'Por favor ingresa un nombre para la carpeta';

  @override
  String createFolderViewSuccess(Object folderName) {
    return 'Carpeta \"$folderName\" creada exitosamente';
  }

  @override
  String createFolderViewFailure(Object error) {
    return 'Error al crear la carpeta: $error';
  }

  @override
  String get deleteFolderViewTitle => 'Eliminar Carpeta';

  @override
  String get deleteFolderViewConfirmation => '¿Eliminar esta carpeta del almacenamiento de la app?';

  @override
  String get deleteFolderViewCancel => 'Cancelar';

  @override
  String get deleteFolderViewConfirm => 'Eliminar';

  @override
  String get deleteFolderViewSuccess => 'Carpeta eliminada exitosamente';

  @override
  String deleteFolderViewFailure(Object error) {
    return 'Error al eliminar la carpeta: $error';
  }

  @override
  String get editFolderViewTitle => 'Editar Carpeta';

  @override
  String get editFolderViewNameLabel => 'Cambiar nombre';

  @override
  String get editFolderViewNameHint => 'Ingresa un nuevo nombre para la carpeta';

  @override
  String get editFolderViewCoverLabel => 'Imagen de Portada (Opcional)';

  @override
  String get editFolderViewSelectImage => 'Toca para seleccionar una imagen';

  @override
  String get editFolderViewCancel => 'Cancelar';

  @override
  String get editFolderViewSave => 'Guardar';

  @override
  String get editFolderViewSuccessRename => 'Carpeta renombrada exitosamente';

  @override
  String get editFolderViewSuccessUpdate => 'Carpeta e imagen actualizadas exitosamente';

  @override
  String editFolderViewFailure(Object error) {
    return 'Error al actualizar la carpeta: $error';
  }

  @override
  String get deleteFileViewTitle => 'Eliminar Archivo';

  @override
  String get deleteFileViewConfirmation => '¿Eliminar este archivo del almacenamiento de la app? El archivo original permanecerá en tu dispositivo.';

  @override
  String get deleteFileViewCancel => 'Cancelar';

  @override
  String get deleteFileViewConfirm => 'Eliminar';

  @override
  String get deleteFileViewSuccess => 'Archivo eliminado exitosamente';

  @override
  String deleteFileViewFailure(Object error) {
    return 'Error al eliminar el archivo: $error';
  }

  @override
  String get editFileViewTitle => 'Editar Archivo';

  @override
  String get editFileViewNameLabel => 'Cambiar nombre';

  @override
  String get editFileViewNameHint => 'Ingresa un nuevo nombre para el archivo';

  @override
  String get editFileViewCoverLabel => 'Imagen de Portada del Archivo (Opcional)';

  @override
  String get editFileViewSelectImage => 'Toca para seleccionar una imagen';

  @override
  String get editFileViewCancel => 'Cancelar';

  @override
  String get editFileViewSave => 'Guardar';

  @override
  String get editFileViewSuccessRename => 'Archivo renombrado exitosamente';

  @override
  String get editFileViewSuccessUpdate => 'Archivo e imagen actualizados exitosamente';

  @override
  String editFileViewFailure(Object error) {
    return 'Error al actualizar el archivo: $error';
  }

  @override
  String get moveFileViewTitle => 'Mover Archivo';

  @override
  String get moveFileViewLoading => 'Cargando carpetas...';

  @override
  String get moveFileViewNoFolders => 'No se encontraron carpetas';

  @override
  String get moveFileViewSelectInstruction => 'Selecciona una carpeta para mover tu archivo';

  @override
  String get moveFileViewMainFolder => 'Carpeta principal';

  @override
  String get moveFileViewCancel => 'Cancelar';

  @override
  String get moveFileViewMove => 'Mover';

  @override
  String get moveFileViewSuccess => 'Archivo movido exitosamente';

  @override
  String get moveFileViewNoChanges => 'No se hicieron cambios al archivo';

  @override
  String moveFileViewFailure(Object error) {
    return 'Error al mover el archivo: $error';
  }

  @override
  String get createClipViewTitle => 'Crear Nuevo Clip';

  @override
  String get createClipViewClipNameLabel => 'Nombre del Clip';

  @override
  String get createClipViewClipNameHint => 'Ingresa el nombre del clip';

  @override
  String get createClipViewClipColorLabel => 'Color del clip (Opcional)';

  @override
  String get createClipViewClipRangeLabel => 'Rango del Clip';

  @override
  String createClipViewStartLabel(Object start) {
    return 'Inicio: ${start}s';
  }

  @override
  String createClipViewEndLabel(Object end) {
    return 'Fin: ${end}s';
  }

  @override
  String get createClipViewCancel => 'Cancelar';

  @override
  String get createClipViewCreate => 'Crear Clip';

  @override
  String createClipViewErrorAudioLoad(Object error) {
    return 'Error al cargar el audio: $error';
  }

  @override
  String get createClipViewErrorEmptyName => 'El nombre del clip no puede estar vacío';

  @override
  String createClipViewErrorCreate(Object error) {
    return 'Error al crear el clip: $error';
  }

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonFolderName => 'Nombre de Carpeta';

  @override
  String get commonFileName => 'Nombre de Archivo';

  @override
  String get commonRoot => 'Raíz';
}
