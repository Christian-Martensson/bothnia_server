import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration2 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_ImageMetaData", "category", (c) {c.isNullable = false;c.deleteRule = DeleteRule.restrict;});
		database.alterColumn("_Image", "imageMetaData", (c) {c.isNullable = false;c.deleteRule = DeleteRule.cascade;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    