import 'dart:ui';

import 'package:get/get.dart';
import 'package:jhentai/src/utils/log.dart';

import '../service/storage_service.dart';

enum DeviceDirection { followSystem, landscape, portrait }

enum ReadDirection {
  top2bottomList,
  left2rightSinglePage,
  left2rightSinglePageFitWidth,
  left2rightDoubleColumn,
  left2rightList,
  right2leftSinglePage,
  right2leftSinglePageFitWidth,
  right2leftDoubleColumn,
  right2leftList,
}

enum TurnPageMode {
  image,
  screen,

  /// if one image covers the whole screen => screen
  /// else => image
  adaptive,
}

enum AutoModeStyle {
  scroll,
  turnPage,
}

class ReadSetting {
  static RxBool enableImmersiveMode = true.obs;
  static RxBool keepScreenAwakeWhenReading = true.obs;
  static RxBool enableCustomReadBrightness = false.obs;
  static RxInt customBrightness = 50.obs;
  static RxInt imageSpace = 6.obs;
  static RxBool showThumbnails = true.obs;
  static RxBool showScrollBar = true.obs;
  static RxBool showStatusInfo = true.obs;
  static RxBool enablePageTurnByVolumeKeys = true.obs;
  static RxBool enablePageTurnAnime = true.obs;
  static RxBool enableDoubleTapToScaleUp = false.obs;
  static RxBool enableTapDragToScaleUp = false.obs;
  static RxBool enableBottomMenu = false.obs;
  static Rx<DeviceDirection> deviceDirection = DeviceDirection.followSystem.obs;
  static Rx<ReadDirection> readDirection = GetPlatform.isMobile ? ReadDirection.top2bottomList.obs : ReadDirection.left2rightList.obs;
  static RxBool notchOptimization = false.obs;
  static RxInt imageRegionWidthRatio = 100.obs;
  static RxBool useThirdPartyViewer = false.obs;
  static RxnString thirdPartyViewerPath = RxnString();
  static RxDouble autoModeInterval = 2.0.obs;
  static Rx<AutoModeStyle> autoModeStyle = AutoModeStyle.turnPage.obs;
  static Rx<TurnPageMode> turnPageMode = TurnPageMode.adaptive.obs;
  static RxInt preloadDistance = 1.obs;
  static RxInt preloadDistanceLocal = GetPlatform.isIOS ? 3.obs : 8.obs;
  static RxInt preloadPageCount = 1.obs;
  static RxInt preloadPageCountLocal = 3.obs;
  static RxBool displayFirstPageAlone = true.obs;
  static RxBool reverseTurnPageDirection = false.obs;
  static RxBool disablePageTurningOnTap = false.obs;
  static RxBool enableMaxImageKilobyte =
      (GetPlatform.isDesktop || PlatformDispatcher.instance.views.first.physicalSize.width / PlatformDispatcher.instance.views.first.devicePixelRatio >= 600)
          ? false.obs
          : true.obs;
  static RxInt maxImageKilobyte = (1024 * 5).obs;

  static bool get isInListReadDirection =>
      readDirection.value == ReadDirection.top2bottomList ||
      readDirection.value == ReadDirection.left2rightList ||
      readDirection.value == ReadDirection.right2leftList;

  static bool get isInHorizontalReadDirection =>
      readDirection.value == ReadDirection.left2rightSinglePage ||
      readDirection.value == ReadDirection.right2leftSinglePage ||
      readDirection.value == ReadDirection.left2rightSinglePageFitWidth ||
      readDirection.value == ReadDirection.right2leftSinglePageFitWidth ||
      readDirection.value == ReadDirection.left2rightDoubleColumn ||
      readDirection.value == ReadDirection.right2leftDoubleColumn ||
      readDirection.value == ReadDirection.left2rightList ||
      readDirection.value == ReadDirection.right2leftList;

  static bool get isInSinglePageReadDirection =>
      readDirection.value == ReadDirection.left2rightSinglePage ||
      readDirection.value == ReadDirection.right2leftSinglePage ||
      readDirection.value == ReadDirection.left2rightSinglePageFitWidth ||
      readDirection.value == ReadDirection.right2leftSinglePageFitWidth;

  static bool get isInFitWidthReadDirection =>
      readDirection.value == ReadDirection.left2rightSinglePageFitWidth || readDirection.value == ReadDirection.right2leftSinglePageFitWidth;

  static bool get isInDoubleColumnReadDirection =>
      readDirection.value == ReadDirection.left2rightDoubleColumn || readDirection.value == ReadDirection.right2leftDoubleColumn;

  static bool get isInRight2LeftDirection =>
      readDirection.value == ReadDirection.right2leftSinglePage ||
      readDirection.value == ReadDirection.right2leftSinglePageFitWidth ||
      readDirection.value == ReadDirection.right2leftDoubleColumn ||
      readDirection.value == ReadDirection.right2leftList;

  static void init() {
    Map<String, dynamic>? map = Get.find<StorageService>().read<Map<String, dynamic>>('readSetting');
    if (map != null) {
      _initFromMap(map);
      Log.debug('init ReadSetting success', false);
    } else {
      Log.debug('init ReadSetting success: default', false);
    }
  }

  static saveEnableImmersiveMode(bool value) {
    Log.debug('saveEnableImmersiveMode:$value');
    enableImmersiveMode.value = value;
    _save();
  }

  static saveKeepScreenAwakeWhenReading(bool value) {
    Log.debug('saveKeepScreenAwakeWhenReading:$value');
    keepScreenAwakeWhenReading.value = value;
    _save();
  }

  static saveEnableCustomReadBrightness(bool value) {
    Log.debug('saveEnableCustomReadBrightness:$value');
    enableCustomReadBrightness.value = value;
    _save();
  }

  static saveCustomBrightness(int value) {
    Log.debug('saveCustomBrightness:$value');
    customBrightness.value = value;
    _save();
  }

  static saveImageSpace(int value) {
    Log.debug('saveImageSpace:$value');
    imageSpace.value = value;
    _save();
  }

  static saveShowThumbnails(bool value) {
    Log.debug('saveShowThumbnails:$value');
    showThumbnails.value = value;
    _save();
  }

  static saveShowScrollBar(bool value) {
    Log.debug('saveShowScrollBar:$value');
    showScrollBar.value = value;
    _save();
  }

  static saveShowStatusInfo(bool value) {
    Log.debug('saveShowStatusInfo:$value');
    showStatusInfo.value = value;
    _save();
  }

  static saveAutoModeInterval(double value) {
    Log.debug('saveAutoModeInterval:$value');
    autoModeInterval.value = value;
    _save();
  }

  static saveAutoModeStyle(AutoModeStyle value) {
    Log.debug('saveAutoModeStyle:${value.name}');
    autoModeStyle.value = value;
    _save();
  }

  static saveDeviceDirection(DeviceDirection value) {
    Log.debug('saveDeviceDirection:${value.name}');
    deviceDirection.value = value;
    _save();
  }

  static saveReadDirection(ReadDirection value) {
    Log.debug('saveReadDirection:${value.name}');
    readDirection.value = value;
    _save();
  }

  static saveNotchOptimization(bool value) {
    Log.debug('saveNotchOptimization:$value');
    notchOptimization.value = value;
    _save();
  }

  static saveImageRegionWidthRatio(int value) {
    Log.debug('saveImageRegionWidthRatio:$value');
    imageRegionWidthRatio.value = value;
    _save();
  }

  static saveUseThirdPartyViewer(bool value) {
    Log.debug('saveUseThirdPartyViewer:$value');
    useThirdPartyViewer.value = value;
    _save();
  }

  static saveThirdPartyViewerPath(String? value) {
    Log.debug('saveThirdPartyViewerPath:$value');
    thirdPartyViewerPath.value = value;
    _save();
  }

  static saveEnablePageTurnByVolumeKeys(bool value) {
    Log.debug('saveEnablePageTurnByVolumeKeys:$value');
    enablePageTurnByVolumeKeys.value = value;
    _save();
  }

  static saveEnablePageTurnAnime(bool value) {
    Log.debug('saveEnablePageTurnAnime:$value');
    enablePageTurnAnime.value = value;
    _save();
  }

  static saveEnableDoubleTapToScaleUp(bool value) {
    Log.debug('saveEnableDoubleTapToScaleUp:$value');
    enableDoubleTapToScaleUp.value = value;
    _save();
  }

  static saveEnableTapDragToScaleUp(bool value) {
    Log.debug('saveEnableTapDragToScaleUp:$value');
    enableTapDragToScaleUp.value = value;
    _save();
  }

  static saveEnableBottomMenu(bool value) {
    Log.debug('saveEnableBottomMenu:$value');
    enableBottomMenu.value = value;
    _save();
  }

  static saveTurnPageMode(TurnPageMode value) {
    Log.debug('saveTurnPageMode:${value.name}');
    turnPageMode.value = value;
    _save();
  }

  static savePreloadDistance(int value) {
    Log.debug('savePreloadDistance:$value');
    preloadDistance.value = value;
    _save();
  }

  static savePreloadDistanceLocal(int value) {
    Log.debug('savePreloadDistanceLocal:$value');
    preloadDistanceLocal.value = value;
    _save();
  }

  static savePreloadPageCount(int value) {
    Log.debug('savePreloadPageCount:$value');
    preloadPageCount.value = value;
    _save();
  }

  static savePreloadPageCountLocal(int value) {
    Log.debug('savePreloadPageCountLocal:$value');
    preloadPageCountLocal.value = value;
    _save();
  }

  static saveDisplayFirstPageAlone(bool value) {
    Log.debug('saveDisplayFirstPageAlone:$value');
    displayFirstPageAlone.value = value;
    _save();
  }

  static saveReverseTurnPageDirection(bool value) {
    Log.debug('saveReverseTurnPageDirection:$value');
    reverseTurnPageDirection.value = value;
    _save();
  }

  static saveDisablePageTurningOnTap(bool value) {
    Log.debug('saveDisablePageTurningOnTap:$value');
    disablePageTurningOnTap.value = value;
    _save();
  }

  static saveEnableMaxImageKilobyte(bool value) {
    Log.debug('saveEnableMaxImageKilobyte:$value');
    enableMaxImageKilobyte.value = value;
    _save();
  }

  static saveMaxImageKilobyte(int value) {
    Log.debug('saveMaxImageKilobyte:$value');
    maxImageKilobyte.value = value;
    _save();
  }

  static Future<void> _save() async {
    await Get.find<StorageService>().write('readSetting', _toMap());
  }

  static Map<String, dynamic> _toMap() {
    return {
      'enableImmersiveMode': enableImmersiveMode.value,
      'keepScreenAwakeWhenReading': keepScreenAwakeWhenReading.value,
      'enableCustomReadBrightness': enableCustomReadBrightness.value,
      'customBrightness': customBrightness.value,
      'imageSpace': imageSpace.value,
      'showThumbnails': showThumbnails.value,
      'showScrollBar': showScrollBar.value,
      'showStatusInfo': showStatusInfo.value,
      'enablePageTurnByVolumeKeys': enablePageTurnByVolumeKeys.value,
      'enablePageTurnAnime': enablePageTurnAnime.value,
      'enableDoubleTapToScaleUp': enableDoubleTapToScaleUp.value,
      'enableTapDragToScaleUp': enableTapDragToScaleUp.value,
      'enableBottomMenu': enableBottomMenu.value,
      'autoModeInterval': autoModeInterval.value,
      'autoModeStyle': autoModeStyle.value.index,
      'deviceDirection': deviceDirection.value.index,
      'readDirection': readDirection.value.index,
      'notchOptimization': notchOptimization.value,
      'imageRegionWidthRatio': imageRegionWidthRatio.value,
      'useThirdPartyViewer': useThirdPartyViewer.value,
      'thirdPartyViewerPath': thirdPartyViewerPath.value,
      'turnPageMode': turnPageMode.value.index,
      'preloadDistance': preloadDistance.value,
      'preloadDistanceLocal': preloadDistanceLocal.value,
      'preloadPageCount': preloadPageCount.value,
      'preloadPageCountLocal': preloadPageCountLocal.value,
      'displayFirstPageAlone': displayFirstPageAlone.value,
      'reverseTurnPageDirection': reverseTurnPageDirection.value,
      'disablePageTurningOnTap': disablePageTurningOnTap.value,
      'enableMaxImageKilobyte': enableMaxImageKilobyte.value,
      'maxImageKilobyte': maxImageKilobyte.value,
    };
  }

  static _initFromMap(Map<String, dynamic> map) {
    enableImmersiveMode.value = map['enableImmersiveMode'];
    keepScreenAwakeWhenReading.value = map['keepScreenAwakeWhenReading'] ?? keepScreenAwakeWhenReading.value;
    enableCustomReadBrightness.value = map['enableCustomReadBrightness'] ?? enableCustomReadBrightness.value;
    customBrightness.value = map['customBrightness'] ?? customBrightness.value;
    imageSpace.value = map['imageSpace'] ?? imageSpace.value;
    showThumbnails.value = map['showThumbnails'] ?? showThumbnails.value;
    showScrollBar.value = map['showScrollBar'] ?? showScrollBar.value;
    showStatusInfo.value = map['showStatusInfo'] ?? showStatusInfo.value;
    enablePageTurnByVolumeKeys.value = map['enablePageTurnByVolumeKeys'] ?? enablePageTurnByVolumeKeys.value;
    enablePageTurnAnime.value = map['enablePageTurnAnime'];
    enableDoubleTapToScaleUp.value = map['enableDoubleTapToScaleUp'] ?? enableDoubleTapToScaleUp.value;
    enableTapDragToScaleUp.value = map['enableTapDragToScaleUp'] ?? enableTapDragToScaleUp.value;
    enableBottomMenu.value = map['enableBottomMenu'] ?? enableBottomMenu.value;
    autoModeInterval.value = map['autoModeInterval'] ?? autoModeInterval.value;
    autoModeStyle.value = AutoModeStyle.values[map['autoModeStyle'] ?? AutoModeStyle.scroll.index];
    deviceDirection.value = DeviceDirection.values[map['deviceDirection'] ?? DeviceDirection.followSystem.index];
    readDirection.value = ReadDirection.values[map['readDirection']];
    notchOptimization.value = map['notchOptimization'] ?? notchOptimization.value;
    imageRegionWidthRatio.value = map['imageRegionWidthRatio'] ?? imageRegionWidthRatio.value;
    useThirdPartyViewer.value = map['useThirdPartyViewer'] ?? useThirdPartyViewer.value;
    thirdPartyViewerPath.value = map['thirdPartyViewerPath'];
    turnPageMode.value = TurnPageMode.values[map['turnPageMode']];
    preloadDistance.value = map['preloadDistance'];
    preloadDistanceLocal.value = map['preloadDistanceLocal'] ?? preloadDistanceLocal.value;
    preloadPageCount.value = map['preloadPageCount'];
    preloadPageCountLocal.value = map['preloadPageCountLocal'] ?? preloadPageCountLocal.value;
    displayFirstPageAlone.value = map['displayFirstPageAlone'] ?? displayFirstPageAlone.value;
    reverseTurnPageDirection.value = map['reverseTurnPageDirection'] ?? reverseTurnPageDirection.value;
    disablePageTurningOnTap.value = map['disablePageTurningOnTap'] ?? disablePageTurningOnTap.value;
    enableMaxImageKilobyte.value = map['enableMaxImageKilobyte'] ?? enableMaxImageKilobyte.value;
    maxImageKilobyte.value = map['maxImageKilobyte'] ?? maxImageKilobyte.value;
  }
}
