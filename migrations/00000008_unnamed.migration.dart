import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration8 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_ImageToTag", "tag", (c) {c.deleteRule = DeleteRule.cascade;});
		database.alterColumn("_ImageToTag", "image", (c) {c.deleteRule = DeleteRule.cascade;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    