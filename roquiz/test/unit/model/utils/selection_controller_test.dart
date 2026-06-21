import 'package:roquiz/model/utils/selection_controller.dart';
import 'package:test/test.dart';

void main() {
  group('Initial state', () {
    test('Nothing selected', () {
      final s = SelectionController(3);

      expect(s.length, 3);
      expect(s.count, 0);
      expect(s.hasSelection, isFalse);
      expect(s.allSelected, isFalse);
      expect(s.selectedIndices, isEmpty);
      expect(s.isSelected(0), isFalse);
    });
  });

  group('Toggle', () {
    test('Toggling tracks count and indices', () {
      final s = SelectionController(3);

      s.toggle(1);
      expect(s.isSelected(1), isTrue);
      expect(s.count, 1);
      expect(s.hasSelection, isTrue);
      expect(s.selectedIndices, [1]);
      expect(s.allSelected, isNull); // partial

      s.toggle(1);
      expect(s.isSelected(1), isFalse);
      expect(s.count, 0);
      expect(s.allSelected, isFalse);
    });
  });

  group('Select all / clear / toggleAll', () {
    test('selectAll selects everything', () {
      final s = SelectionController(3);

      s.selectAll();
      expect(s.count, 3);
      expect(s.allSelected, isTrue);
      expect(s.selectedIndices, [0, 1, 2]);
    });

    test('clear deselects everything', () {
      final s = SelectionController(3)..selectAll();

      s.clear();
      expect(s.count, 0);
      expect(s.allSelected, isFalse);
    });

    test('toggleAll flips between all and none', () {
      final s = SelectionController(3);

      s.toggleAll();
      expect(s.allSelected, isTrue);

      s.toggleAll();
      expect(s.allSelected, isFalse);

      // From a partial state, toggleAll selects everything.
      s.toggle(0);
      s.toggleAll();
      expect(s.allSelected, isTrue);
    });
  });

  group('Resize', () {
    test('reset clears and resizes', () {
      final s = SelectionController(3)..selectAll();

      s.reset(5);
      expect(s.length, 5);
      expect(s.count, 0);
      expect(s.allSelected, isFalse);
    });

    test('insert keeps count consistent', () {
      final s = SelectionController(2)..toggle(0);

      s.insert(0, selected: true);
      expect(s.length, 3);
      expect(s.count, 2);
      expect(s.selectedIndices, [0, 1]);

      s.insert(3); // unselected, at the end
      expect(s.length, 4);
      expect(s.count, 2);
    });

    test('removeAt decrements count only when the item was selected', () {
      final s = SelectionController(3)..toggle(1);

      // Remove an unselected item: count unchanged.
      s.removeAt(0);
      expect(s.length, 2);
      expect(s.count, 1);
      expect(s.isSelected(0), isTrue); // formerly index 1

      // Remove the selected item: count drops.
      s.removeAt(0);
      expect(s.length, 1);
      expect(s.count, 0);
    });
  });
}
