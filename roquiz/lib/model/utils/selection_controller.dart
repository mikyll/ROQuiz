/// Tracks a multi-selection over a list of [length] items by index.
///
/// Item-type agnostic: it only cares about how many items there are and which
/// are selected, so it is shared by every screen that offers "select many,
/// then act on them" (question editing, quiz history, ...). Mutations don't
/// trigger rebuilds on their own; callers wrap them in `setState`, matching the
/// surrounding views.
class SelectionController {
  List<bool> _selected;
  int _count = 0;

  SelectionController(int length)
    : _selected = List.filled(length, false, growable: true);

  int get count => _count;
  int get length => _selected.length;
  bool get hasSelection => _count > 0;

  bool isSelected(int index) => _selected[index];

  /// Tristate value for a select-all checkbox: `true` = all, `false` = none,
  /// `null` = some (partial).
  bool? get allSelected {
    if (_count == 0) {
      return false;
    }
    if (_count == _selected.length) {
      return true;
    }
    return null;
  }

  /// Indices of the selected items, in ascending order.
  List<int> get selectedIndices => [
    for (int i = 0; i < _selected.length; i++)
      if (_selected[i]) i,
  ];

  void toggle(int index) {
    _selected[index] = !_selected[index];
    _count += _selected[index] ? 1 : -1;
  }

  void selectAll() {
    for (int i = 0; i < _selected.length; i++) {
      _selected[i] = true;
    }
    _count = _selected.length;
  }

  void clear() {
    for (int i = 0; i < _selected.length; i++) {
      _selected[i] = false;
    }
    _count = 0;
  }

  /// Flips between all-selected and none-selected (drives the tristate checkbox).
  void toggleAll() {
    if (allSelected == true) {
      clear();
    } else {
      selectAll();
    }
  }

  /// Resizes to [length] items, clearing any selection.
  void reset(int length) {
    _selected = List.filled(length, false, growable: true);
    _count = 0;
  }

  void insert(int index, {bool selected = false}) {
    _selected.insert(index, selected);
    if (selected) {
      _count++;
    }
  }

  void removeAt(int index) {
    if (_selected.removeAt(index)) {
      _count--;
    }
  }
}
