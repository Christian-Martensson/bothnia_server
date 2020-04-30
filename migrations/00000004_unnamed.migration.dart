import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration4 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteTable("_Category");
		database.deleteColumn("_ImageMetaData", "category");
		database.deleteColumn("_Image", "path");
		database.addColumn("_Photographer", SchemaColumn("phone", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.alterColumn("_Photographer", "email", (c) {c.isUnique = false;c.isNullable = true;});
		database.addColumn("_User", SchemaColumn("role", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    