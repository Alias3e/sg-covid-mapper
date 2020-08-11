import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';

main() {
  group('SearchBoxEvent test', () {
    test('returns opacity 0.0 when panel position is 1.0', () {
      OpacityChanged testSubect = OpacityChanged(1.0);
      expect(testSubect.opacity, 0.0);
    });

    test('returns opacity 1.0 when panel position is 0.0', () {
      OpacityChanged testSubect = OpacityChanged(0.0);
      expect(testSubect.opacity, 1.0);
    });

    test('returns opacity 0.5 when panel position is 0.5', () {
      OpacityChanged testSubect = OpacityChanged(0.5);
      expect(testSubect.opacity, 0.5);
    });

    test('returns opacity 0.75 when panel position is 0.25', () {
      OpacityChanged testSubect = OpacityChanged(0.25);
      expect(testSubect.opacity, 0.75);
    });

    test('returns opacity 0.25 when panel position is 0.75', () {
      OpacityChanged testSubect = OpacityChanged(0.75);
      expect(testSubect.opacity, 0.25);
    });
  });
}
