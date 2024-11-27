import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PolishAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const PolishAssetPickerTextDelegate();

  @override
  String get languageCode => 'pl';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get cancel => 'Anuluj';

  @override
  String get edit => 'Edytuj';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Ładowanie nie powiodło się';

  @override
  String get original => 'Oryginał';

  @override
  String get preview => 'Podgląd';

  @override
  String get select => 'Wybierz';

  @override
  String get emptyList => 'Pusta lista';

  @override
  String get unSupportedAssetType => 'Nieobsługiwany typ pliku HEIC.';

  @override
  String get unableToAccessAll =>
      'Nie można uzyskać dostępu do wszystkich zasobów na urządzeniu';

  @override
  String get viewingLimitedAssetsTip =>
      'Wyświetl tylko zasoby i albumy dostępne dla aplikacji.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Kliknij, aby zaktualizować dostępne zasoby';

  @override
  String get accessAllTip =>
      'Aplikacja może uzyskać dostęp tylko do niektórych zasobów na urządzeniu. '
      'Przejdź do ustawień systemowych i zezwól aplikacji na dostęp do wszystkich zasobów na urządzeniu.';

  @override
  String get goToSystemSettings => 'Przejdź do ustawień systemowych';

  @override
  String get accessLimitedAssets => 'Kontynuuj z ograniczonym dostępem';

  @override
  String get accessiblePathName => 'Dostępne zasoby';

  @override
  String get sTypeAudioLabel => 'Audio';

  @override
  String get sTypeImageLabel => 'Obraz';

  @override
  String get sTypeVideoLabel => 'Wideo';

  @override
  String get sTypeOtherLabel => 'Inny zasób';

  @override
  String get sActionPlayHint => 'odtwórz';

  @override
  String get sActionPreviewHint => 'podgląd';

  @override
  String get sActionSelectHint => 'wybierz';

  @override
  String get sActionSwitchPathLabel => 'zmień ścieżkę';

  @override
  String get sActionUseCameraHint => 'użyj kamery';

  @override
  String get sNameDurationLabel => 'czas trwania';

  @override
  String get sUnitAssetCountLabel => 'liczba';
}

class UkrainianAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const UkrainianAssetPickerTextDelegate();

  @override
  String get languageCode => 'uk';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get edit => 'Редагувати';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Не вдалося завантажити';

  @override
  String get original => 'Оригінал';

  @override
  String get preview => 'Попередній перегляд';

  @override
  String get select => 'Вибрати';

  @override
  String get emptyList => 'Порожній список';

  @override
  String get unSupportedAssetType => 'Тип файлу HEIC не підтримується.';

  @override
  String get unableToAccessAll =>
      'Неможливо отримати доступ до всіх ресурсів на пристрої';

  @override
  String get viewingLimitedAssetsTip =>
      'Переглядайте лише ті ресурси та альбоми, які доступні для програми.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Натисніть, щоб оновити доступні ресурси';

  @override
  String get accessAllTip =>
      'Програма може отримати доступ лише до деяких ресурсів на пристрої. '
      'Перейдіть до системних налаштувань і дозвольте програмі доступ до всіх ресурсів на пристрої.';

  @override
  String get goToSystemSettings => 'Перейдіть до системних налаштувань';

  @override
  String get accessLimitedAssets => 'Продовжити з обмеженим доступом';

  @override
  String get accessiblePathName => 'Доступні ресурси';

  @override
  String get sTypeAudioLabel => 'Аудіо';

  @override
  String get sTypeImageLabel => 'Зображення';

  @override
  String get sTypeVideoLabel => 'Відео';

  @override
  String get sTypeOtherLabel => 'Інший ресурс';

  @override
  String get sActionPlayHint => 'відтворити';

  @override
  String get sActionPreviewHint => 'перегляд';

  @override
  String get sActionSelectHint => 'вибрати';

  @override
  String get sActionSwitchPathLabel => 'змінити шлях';

  @override
  String get sActionUseCameraHint => 'використати камеру';

  @override
  String get sNameDurationLabel => 'тривалість';

  @override
  String get sUnitAssetCountLabel => 'кількість';
}
