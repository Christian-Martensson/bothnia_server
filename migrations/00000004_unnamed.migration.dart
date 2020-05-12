import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration4 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Photographer", SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.deleteColumn("_Photographer", "fName");
		database.deleteColumn("_Photographer", "lName");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    