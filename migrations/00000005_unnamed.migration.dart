import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration5 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_User", "role", (c) {c.defaultValue = "customer";});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    