import 'dart:io';

class UploadFileReq {
  final String path;
  final File file;

  UploadFileReq({required this.path, required this.file});
}
