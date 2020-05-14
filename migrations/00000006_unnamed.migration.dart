import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration6 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_Image", "base64");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    