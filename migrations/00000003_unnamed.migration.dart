import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration3 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_ImageMetaData", SchemaColumn("modified", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_ImageMetaData", SchemaColumn("captured", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.alterColumn("_ImageMetaData", "isPublicallyAdded", (c) {c.defaultValue = "false";});
		database.addColumn("_Image", SchemaColumn("description", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.addColumn("_Image", SchemaColumn("created", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_Image", SchemaColumn("modified", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.deleteColumn("_Image", "name");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    