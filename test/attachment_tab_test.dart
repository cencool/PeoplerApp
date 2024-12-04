import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/widgets/attachment_tab.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:provider/provider.dart';

void main() {
  group('AttachmentTab Widget Tests', () {
    testWidgets('Initial state shows attachment list view', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AppState(),
            child: AttachmentTab(),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Image cropping workflow', (WidgetTester tester) async {
      late Uint8List mockImageBytes;
      setUp(() async {
        // Load the test image
        final ByteData data = await rootBundle.load('test/assets/test_picture.png');
        mockImageBytes = data.buffer.asUint8List();
      });
      final controller = CropController();

      await tester.pumpWidget(
        MaterialApp(
          home: ImageCropFromBytes(
            imageBytesFuture: Future.value(mockImageBytes),
            controller: controller,
            onModeSwitch: (mode, id) {},
            activeAttachmentId: 1,
          ),
        ),
      );

      // Verify crop widget is shown
      expect(find.byType(Crop), findsOneWidget);

      // Verify crop button exists
      expect(find.byIcon(Icons.crop), findsOneWidget);

      // Test cropping action
      await tester.tap(find.byIcon(Icons.crop));
      await tester.pumpAndSettle();

      // Verify save dialog appears after cropping
      expect(find.byType(AttachmentSaveDialog), findsOneWidget);
    });

    testWidgets('Error handling for invalid image data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCropFromBytes(
            imageBytesFuture: Future.error('Invalid image data'),
            controller: CropController(),
            onModeSwitch: (_, __) {},
            activeAttachmentId: 1,
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SpinKitPouringHourGlass), findsOneWidget);
    });
  });
}
