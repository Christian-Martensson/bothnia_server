import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration2 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_ImageMetaData", SchemaColumn.relationship("user", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("_User", SchemaColumn("created", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("modified", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("type", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, defaultValue: "'customer'", isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("canEditor", ManagedPropertyType.boolean, isPrimaryKey: false, autoincrement: false, defaultValue: "false", isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("canPhotographer", ManagedPropertyType.boolean, isPrimaryKey: false, autoincrement: false, defaultValue: "false", isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, defaultValue: "''", isIndexed: false, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    