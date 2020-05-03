import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration6 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_ImageMetaData", "user");
		database.deleteColumn("_User", "role");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    