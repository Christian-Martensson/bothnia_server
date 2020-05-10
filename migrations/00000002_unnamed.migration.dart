import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration2 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteTable("_ImageMetaData");
		database.addColumn("_Image", SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_Image", SchemaColumn("captured", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.addColumn("_Image", SchemaColumn("firstPubDate", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.addColumn("_Image", SchemaColumn("xCoordinates", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.addColumn("_Image", SchemaColumn("yCoordinates", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.addColumn("_Image", SchemaColumn("license", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.addColumn("_Image", SchemaColumn("usesLeft", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
		database.addColumn("_Image", SchemaColumn("isPublicallyAdded", ManagedPropertyType.boolean, isPrimaryKey: false, autoincrement: false, defaultValue: "false", isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_Image", SchemaColumn.relationship("photographer", ManagedPropertyType.bigInteger, relatedTableName: "_Photographer", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("_Image", SchemaColumn.relationship("user", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.deleteColumn("_Image", "version");
		database.deleteColumn("_Image", "imageMetaData");
		database.addColumn("_ImageToTag", SchemaColumn.relationship("image", ManagedPropertyType.bigInteger, relatedTableName: "_Image", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.deleteColumn("_ImageToTag", "imageMetaData");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    