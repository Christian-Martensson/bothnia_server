import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration4 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_Image", "resolution", (c) {c.isNullable = true;});
		database.alterColumn("_ImageMetaData", "description", (c) {c.isNullable = true;});
		database.alterColumn("_ImageMetaData", "firstPubDate", (c) {c.isNullable = true;});
		database.alterColumn("_ImageMetaData", "coordinates", (c) {c.isNullable = true;});
		database.alterColumn("_ImageMetaData", "license", (c) {c.isNullable = true;});
		database.alterColumn("_ImageMetaData", "usesLeft", (c) {c.isNullable = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    