import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/widgets/cluster_widget.dart';

main() {
  group('Cluster widget', () {
    testWidgets('Cluster display # cases correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ClusterWidget(
            markers: [
              Marker(),
              Marker(),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(find.text("2"), findsOneWidget);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ClusterWidget(
            markers: [
              Marker(),
              Marker(),
              Marker(),
              Marker(),
              Marker(),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(find.text("5"), findsOneWidget);
    });
  });
}
