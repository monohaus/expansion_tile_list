import 'package:expansion_tile_list/src/expansion_tile_extension.dart'; // Import your extension
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testing copyWith method in ExpansionTileExtension', () {
    // Create an instance of ExpansionTile
    ExpansionTile originalTile = const ExpansionTile(
      leading: Icon(Icons.ac_unit),
      title: Text('Original'),
      subtitle: Text('Subtitle'),
      initiallyExpanded: true,
      maintainState: true,
      tilePadding: EdgeInsets.all(10),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: EdgeInsets.all(20),
      backgroundColor: Colors.red,
      collapsedBackgroundColor: Colors.green,
      textColor: Colors.blue,
      collapsedTextColor: Colors.yellow,
      iconColor: Colors.purple,
      collapsedIconColor: Colors.orange,
      shape: RoundedRectangleBorder(),
      collapsedShape: RoundedRectangleBorder(),
      clipBehavior: Clip.hardEdge,
      controlAffinity: ListTileControlAffinity.leading,
      // Add other properties as needed
    );

    // Use the copyWith method
    ExpansionTile copiedTile = originalTile.copyWith(
      leading: const Icon(Icons.access_alarm),
      title: const Text('Copied'),
      subtitle: const Text('New Subtitle'),
      initiallyExpanded: false,
      maintainState: false,
      tilePadding: const EdgeInsets.all(15),
      expandedCrossAxisAlignment: CrossAxisAlignment.end,
      expandedAlignment: Alignment.centerRight,
      childrenPadding: const EdgeInsets.all(25),
      backgroundColor: Colors.yellow,
      collapsedBackgroundColor: Colors.blue,
      textColor: Colors.green,
      collapsedTextColor: Colors.red,
      iconColor: Colors.orange,
      collapsedIconColor: Colors.purple,
      shape: const RoundedRectangleBorder(),
      collapsedShape: const RoundedRectangleBorder(),
      clipBehavior: Clip.antiAlias,
      controlAffinity: ListTileControlAffinity.trailing,
      // Add other properties as needed
    );

    // Verify the result
    expect((copiedTile.leading as Icon).icon,
        Icons.access_alarm); // Check the leading
    expect((copiedTile.title as Text).data, 'Copied'); // Check the title
    expect((copiedTile.subtitle as Text).data,
        'New Subtitle'); // Check the subtitle
    expect(copiedTile.initiallyExpanded,
        false); // Check the initiallyExpanded property
    expect(copiedTile.maintainState, false); // Check the maintainState property
    expect(copiedTile.tilePadding,
        const EdgeInsets.all(15)); // Check the tilePadding property
    expect(
        copiedTile.expandedCrossAxisAlignment,
        CrossAxisAlignment
            .end); // Check the expandedCrossAxisAlignment property
    expect(copiedTile.expandedAlignment,
        Alignment.centerRight); // Check the expandedAlignment property
    expect(copiedTile.childrenPadding,
        const EdgeInsets.all(25)); // Check the childrenPadding property
    expect(copiedTile.backgroundColor,
        Colors.yellow); // Check the backgroundColor property
    expect(copiedTile.collapsedBackgroundColor,
        Colors.blue); // Check the collapsedBackgroundColor property
    expect(copiedTile.textColor, Colors.green); // Check the textColor property
    expect(copiedTile.collapsedTextColor,
        Colors.red); // Check the collapsedTextColor property
    expect(copiedTile.iconColor, Colors.orange); // Check the iconColor property
    expect(copiedTile.collapsedIconColor,
        Colors.purple); // Check the collapsedIconColor property
    expect(copiedTile.shape,
        isA<RoundedRectangleBorder>()); // Check the shape property
    expect(copiedTile.collapsedShape,
        isA<RoundedRectangleBorder>()); // Check the collapsedShape property
    expect(copiedTile.clipBehavior,
        Clip.antiAlias); // Check the clipBehavior property
    expect(copiedTile.controlAffinity,
        ListTileControlAffinity.trailing); // Check the controlAffinity property
    // Add other checks as needed
  });
}
