import 'package:core_asgl/core_asgl.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/api_repo.dart';
import '../../core/core.dart';
import '../../home/home_bloc.dart';
import '../../utils/model/dialog_model.dart';
import '../../utils/widget/dialog_util.dart';

enum PreviewImageState { NONE, LOADING, SUCCESS, ERROR }

class CameraBloc {
  CoreStream<PreviewImageModel> previewImageStream = CoreStream();

  close() {
    previewImageStream?.close();
  }

  void changeStateToLoading(String loadingProcess) {
    PreviewImageModel _previewImageModel =
        PreviewImageModel(PreviewImageState.LOADING, loadingProcess);
    previewImageStream?.notify(_previewImageModel);
  }

  void changeStateToSuccess() {
    PreviewImageModel _previewImageModel =
        PreviewImageModel(PreviewImageState.SUCCESS, null);
    previewImageStream?.notify(_previewImageModel);
  }

  void changeStateToError() {
    PreviewImageModel _previewImageModel =
        PreviewImageModel(PreviewImageState.ERROR, null);
    previewImageStream?.notify(_previewImageModel);
  }

  void changeStateToNone() {
    PreviewImageModel _previewImageModel =
        PreviewImageModel(PreviewImageState.NONE, null);
    previewImageStream?.notify(_previewImageModel);
  }

  ApiRepo _apiRepo = ApiRepo();

  Future sendImage(BuildContext context, AppBloc appBloc, String type,
      double latitude, double longitude, String sPath) async {
    await _apiRepo.sendImage_Location(
        type: type,
        latitude: latitude,
        longitude: longitude,
        iPath: sPath,
        resultData: (data) async {
          if (data != null && data != "") {
            previewImageStream
                .notify(PreviewImageModel(PreviewImageState.NONE, null));
            appBloc.identificationBloc.getLatestDataAttendance();
            SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
            appBloc.homeBloc.updateOtherLayout(OtherLayoutState.NONE);
            DialogUtil.showDialogProject(context,
                dialogModel: DialogModel(
                    state: DialogType.INAPP,
                    urlAssetImageLogo: "asset/images/ic_success_dialog.png",
                    listRichText: [
                      RichTextModel("Ghi nhận thành công.", 0xff00b54e, 52,
                          "Roboto-Regular")
                    ],
                    marginRichText: EdgeInsets.only(
                      bottom: 96.0.h,
                    )));
          }
        },
        onErrorApiCallBack: (onError) {
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          appBloc.homeBloc.updateOtherLayout(OtherLayoutState.NONE);
          Toast.showShort("Chấm công bằng vị trí thất bại. Vui lòng thử lại.");
        });
  }
}

class PreviewImageModel {
  PreviewImageState state;
  dynamic loadingProcess;

  PreviewImageModel(this.state, this.loadingProcess);
}
