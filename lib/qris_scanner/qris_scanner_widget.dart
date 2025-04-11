
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sdk_scanner/qris_scanner_sdk.dart';
import 'package:scan/scan.dart';

class QrisScannerWidget extends StatefulWidget {

  final Function(String? result, String erorrMessage)? onScanCompleted;
  final String? iconFLashOff;
  final String? iconFlashOn;
  final String? lootieFiles;
  final String? qrisIcon;

  const QrisScannerWidget({Key? key, this.onScanCompleted, this.iconFLashOff,
    this.iconFlashOn, this.lootieFiles, this.qrisIcon}) : super(key: key);

  @override
  State<QrisScannerWidget> createState() => _QrisScannerWidgetState();
}

class _QrisScannerWidgetState extends State<QrisScannerWidget> with WidgetsBindingObserver {
  late MobileScannerController cameraController;
  ValueNotifier<TorchState> torchStateValueNotifier = ValueNotifier(TorchState.off);

  bool _screenOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    cameraController = MobileScannerController();
    cameraController.addListener(_torchStateListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _checkPermissions();
    });
  }

  @override
  void dispose() {
    cameraController.removeListener(_torchStateListener);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!cameraController.value.isInitialized) {
          cameraController.start();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if (cameraController.value.isInitialized) {
          cameraController.stop();
        }
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: MobileScanner(
                    controller: cameraController,
                    onDetect: (barcode) {
                      if (!_screenOpened) {
                        if (barcode.barcodes.first.rawValue == null) {
                          widget.onScanCompleted?.call(null, 'Scan Failed');
                        } else {
                          _screenOpened = true;
                          final decomposer = QrisValidator(barcode
                              .barcodes.first
                              .rawValue!);
                          final segments = decomposer.parsingAndCheck();
                          final qrisData = QRISData.fromDecomposed(segments);
                          widget.onScanCompleted?.call(qrisData.toString(), 'Scan Success');
                          _screenOpened = false;

                        }
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(35),
                        child: Lottie.asset(
                          widget.lootieFiles ?? 'assets/lootie/scan_qr.json',
                          fit: BoxFit.fill,
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x14242424),
                            blurRadius: 16,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  widget.qrisIcon ?? 'assets/images/qris_logo.svg',
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      iconSize: 40,
                                      color: Colors.white,
                                      icon: ValueListenableBuilder(
                                        valueListenable:
                                        torchStateValueNotifier,
                                        builder: (context, state, child) {
                                          switch ( state as TorchState) {
                                            case TorchState.off:
                                              return SvgPicture
                                                  .asset(
                                                  widget.iconFLashOff ??
                                                  'assets/images/ic_flash_inactive.svg'
                                              );
                                            case TorchState.on:
                                              return SvgPicture
                                                  .asset(
                                                  widget.iconFlashOn ??
                                                  'assets/images/ic_flash_active.svg'
                                              );
                                            default:
                                              return const SizedBox
                                                  .shrink();
                                          }
                                        },
                                      ),
                                      onPressed: () =>
                                          cameraController
                                              .toggleTorch(),
                                    ),
                                    IconButton(
                                        iconSize: 40,
                                        color: Colors.white,
                                        icon: SvgPicture.asset(
                                            'assets/images/ic_upload_img_rounded.svg',
                                        ),
                                        onPressed: () async {
                                          final XFile? pickedImage =
                                          await ImagePicker()
                                              .pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 100);
                                          if (pickedImage == null) return;
                                          String? dataScan = await Scan.parse(pickedImage.path);
                                          if (!_screenOpened) {
                                            if (dataScan == null) {
                                              if(context.mounted){
                                                //NOTPROCESS
                                                widget.onScanCompleted?.call(null, 'Scan Failed');
                                              }
                                            } else {
                                              _screenOpened = true;
                                              if(context.mounted){
                                                //PROCESS
                                                final decomposer = QrisValidator(dataScan);
                                                final segments = decomposer.parsingAndCheck();
                                                final qrisData = QRISData.fromDecomposed(segments);
                                                widget.onScanCompleted?.call(qrisData.toString(), 'Scan Success');
                                                _screenOpened = false;
                                              }
                                            }
                                          }
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkPermissions() async {
    final cameraGranted = await PermissionUtils.requestCameraPermission();
    setState(() {
      if (!cameraGranted) {
        PermissionUtils.openAppSettingsIfPermanentlyDenied();
      }
    });
  }

  void _torchStateListener() {
    var state = cameraController.value.torchState;
    torchStateValueNotifier.value = state;
  }
}