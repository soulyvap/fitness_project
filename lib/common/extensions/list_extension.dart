export "list_extension.dart";

extension ListExtension<T> on List<T> {
  List<T> sorted(int Function(T, T) compare) {
    final list = List<T>.from(this);
    list.sort(compare);
    return list;
  }

  List<dynamic> mapList(dynamic Function(T) toElement) {
    return map(toElement).toList();
  }

  T? firstOrNull(bool Function(T) predicate) {
    for (final element in this) {
      if (predicate(element)) {
        return element;
      }
    }
    return null;
  }
}
