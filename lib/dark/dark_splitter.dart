
import 'package:polymer/polymer.dart';

@CustomTag('dark-splitter')
class DarkSplitter extends PolymerElement {
  @published String direction;
  @published bool locked;
  @published int minSize;
  @published bool allowOverflow;
  @published bool disableSelection;

  DarkSplitter.created() : super.created();
}
