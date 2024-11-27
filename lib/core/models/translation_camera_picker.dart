import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PolishCameraPickerTextDelegate implements CameraPickerTextDelegate {
  @override
  String get confirm => 'Potwierdź';

  @override
  String get languageCode => 'pl';

  @override
  String get loadFailed => 'Ładowanie nie powiodło się';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get sActionManuallyFocusHint => 'ręczne ustawienie ostrości';

  @override
  String get sActionPreviewHint => 'podgląd';

  @override
  String get sActionRecordHint => 'nagrywanie';

  @override
  String get sActionShootHint => 'zrób zdjęcie';

  @override
  String get sActionShootingButtonTooltip => 'przycisk robienia zdjęcia';

  @override
  String get sActionStopRecordingHint => 'zatrzymaj nagrywanie';

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) => value.name;

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    return 'Podgląd kamery ${sCameraLensDirectionLabel(value)}';
  }

  @override
  String sFlashModeLabel(FlashMode mode) =>
      'Tryb lampy błyskowej: ${mode.name}';

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) =>
      'Przełącz na kamerę ${sCameraLensDirectionLabel(value)}';

  @override
  String get saving => 'Zapisywanie...';

  @override
  String get shootingOnlyRecordingTips => 'Przytrzymaj, aby nagrać wideo.';

  @override
  String get shootingTapRecordingTips => 'Dotknij, aby nagrać wideo.';

  @override
  String get shootingTips => 'Dotknij, aby zrobić zdjęcie.';

  @override
  String get shootingWithRecordingTips =>
      'Dotknij, aby zrobić zdjęcie. Przytrzymaj, aby nagrać wideo.';
}

class UkrainianCameraPickerTextDelegate implements CameraPickerTextDelegate {
  @override
  String get confirm => 'Підтвердити';

  @override
  String get languageCode => 'uk';

  @override
  String get loadFailed => 'Завантаження не вдалося';

  @override
  String get loading => 'Завантаження...';

  @override
  String get sActionManuallyFocusHint => 'ручне фокусування';

  @override
  String get sActionPreviewHint => 'перегляд';

  @override
  String get sActionRecordHint => 'запис';

  @override
  String get sActionShootHint => 'зробити фото';

  @override
  String get sActionShootingButtonTooltip => 'кнопка зйомки';

  @override
  String get sActionStopRecordingHint => 'зупинити запис';

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) => value.name;

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    return 'Попередній перегляд камери ${sCameraLensDirectionLabel(value)}';
  }

  @override
  String sFlashModeLabel(FlashMode mode) => 'Режим спалаху: ${mode.name}';

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) =>
      'Перемкнути на камеру ${sCameraLensDirectionLabel(value)}';

  @override
  String get saving => 'Збереження...';

  @override
  String get shootingOnlyRecordingTips => 'Утримуйте для запису відео.';

  @override
  String get shootingTapRecordingTips => 'Торкніться, щоб записати відео.';

  @override
  String get shootingTips => 'Торкніться, щоб зробити фото.';

  @override
  String get shootingWithRecordingTips =>
      'Торкніться, щоб зробити фото. Утримуйте, щоб записати відео.';
}
