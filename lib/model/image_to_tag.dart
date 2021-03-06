import 'package:bothnia_server/bothnia_server.dart';

class ImageToTag extends ManagedObject<_ImageToTag> implements _ImageToTag {}

class _ImageToTag {
  @primaryKey
  int id;

  @Relate(#imageTags, onDelete: DeleteRule.cascade)
  Tag tag;

  @Relate(#imageTags, onDelete: DeleteRule.cascade)
  Image image;
}
