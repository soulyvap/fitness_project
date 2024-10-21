export 'string_list_extension.dart';

extension StringListExtensions on List<String> {
  List<List<String>> toChunks(int chunkSize) {
    List<List<String>> chunks = [];

    for (var i = 0; i < length; i += chunkSize) {
      int end = (i + chunkSize < length) ? i + chunkSize : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }
}
