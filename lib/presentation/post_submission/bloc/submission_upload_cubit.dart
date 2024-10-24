import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/db/models/update_submission_req.dart';
import 'package:fitness_project/data/storage/models/upload_file_req.dart';
import 'package:fitness_project/domain/usecases/db/update_submission.dart';
import 'package:fitness_project/domain/usecases/storage/upload_file.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

abstract class SubmissionUploadState {
  final String message;
  SubmissionUploadState({required this.message});
}

class Initial extends SubmissionUploadState {
  Initial() : super(message: "Initial");
}

class CompressingVideo extends SubmissionUploadState {
  CompressingVideo() : super(message: "Compressing video");
}

class AddingSubmission extends SubmissionUploadState {
  AddingSubmission() : super(message: "Adding submission");
}

class UploadingVideo extends SubmissionUploadState {
  UploadingVideo() : super(message: "Uploading video");
}

class UploadingThumbnail extends SubmissionUploadState {
  UploadingThumbnail() : super(message: "Uploading thumbnail");
}

class UpdatingUrls extends SubmissionUploadState {
  UpdatingUrls() : super(message: "Updating urls");
}

class Done extends SubmissionUploadState {
  Done() : super(message: "Done");
}

class Error extends SubmissionUploadState {
  Error({required super.message});
}

class SubmissionUploadCubit extends Cubit<SubmissionUploadState> {
  final String challengeId;
  final File videoFile;

  SubmissionUploadCubit({
    required this.challengeId,
    required this.videoFile,
  }) : super(Initial()) {
    uploadSubmission();
  }

  Future<void> uploadSubmission() async {
    emit(CompressingVideo());
    final compressedFiles = await _compressVideo(videoFile);
    if (compressedFiles == null) {
      emit(Error(message: "Failed to compress video"));
      return;
    }
    final compressedVideo = compressedFiles.$1;
    final thumbnail = compressedFiles.$2;
    emit(AddingSubmission());
    final submissionId = await _addSubmission();
    if (submissionId == null) {
      emit(Error(message: "Failed to add submission"));
      return;
    }
    emit(UploadingVideo());
    final videoUrl = await _uploadVideo(compressedVideo, submissionId);
    if (videoUrl == null) {
      emit(Error(message: "Failed to upload video"));
      return;
    }
    emit(UploadingThumbnail());
    final thumbnailUrl = await _uploadThumbnail(thumbnail, submissionId);
    if (thumbnailUrl == null) {
      emit(Error(message: "Failed to upload thumbnail"));
      return;
    }
    emit(UpdatingUrls());
    final urlUpdate = await _updateUrls(submissionId, videoUrl, thumbnailUrl);
    if (!urlUpdate) {
      emit(Error(message: "Failed to update urls"));
      return;
    }
    emit(Done());
  }

  Future<(File, File)?> _compressVideo(File videoFile) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.Res960x540Quality,
      deleteOrigin: true,
      frameRate: 24,
    );
    if (compressedVideo == null ||
        compressedVideo.path == null ||
        compressedVideo.file == null) {
      return null;
    }
    final thumbnail = await VideoCompress.getFileThumbnail(
      compressedVideo.path!,
      quality: 50,
      position: 1,
    );
    return (compressedVideo.file!, thumbnail);
  }

  Future<String?> _uploadVideo(File file, String submissionId) async {
    final videoUpload = await sl<UploadFileUseCase>().call(
      params: UploadFileReq(
          path:
              "videos/challenges/$challengeId/submissions/$submissionId/$submissionId.mp4",
          file: file),
    );
    String? returnValue = "";
    videoUpload.fold((l) {
      returnValue = null;
    }, (r) {
      returnValue = r;
    });
    return returnValue;
  }

  Future<String?> _uploadThumbnail(File file, String submissionId) async {
    final thumbnailUpload = await sl<UploadFileUseCase>().call(
        params: UploadFileReq(
      path:
          "videos/challenges/$challengeId/submissions/$submissionId/$submissionId.jpg",
      file: file,
    ));
    String? returnValue = "";
    thumbnailUpload.fold((l) {
      returnValue = null;
    }, (r) {
      returnValue = r;
    });
    return returnValue;
  }

  Future<String?> _addSubmission() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      throw Exception("User not found");
    }
    final addSubmission = await sl<UpdateSubmissionUseCase>().call(
      params: UpdateSubmissionReq(
        challengeId: challengeId,
        userId: currentUserId,
      ),
    );
    String? returnValue = "";
    addSubmission.fold((l) {
      returnValue = null;
    }, (r) {
      returnValue = r;
    });
    return returnValue;
  }

  Future<bool> _updateUrls(
      String submissionId, String videoUrl, String thumbnailUrl) async {
    final updateSubmission = await sl<UpdateSubmissionUseCase>().call(
      params: UpdateSubmissionReq(
        submissionId: submissionId,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
      ),
    );
    bool returnValue = false;
    updateSubmission.fold((l) {
      returnValue = false;
    }, (r) {
      returnValue = true;
    });
    return returnValue;
  }
}
