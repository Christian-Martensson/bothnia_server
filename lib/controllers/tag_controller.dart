import 'package:bothnia_server/bothnia_server.dart';
import 'package:bothnia_server/utility/helper.dart';

class TagController extends ManagedObjectController<Tag> {
  TagController(this.context) : super(context);

  final ManagedContext context;

  @override
  @Operation.post()
  Future<Response> createObject() async {
    Query<Tag> _query = Query<Tag>(context);

    Tag instance = _query.entity.instanceType
        .newInstance(const Symbol(""), []).reflectee as Tag;
    instance.readFromMap(request.body.as());
    _query.values = instance;

    Query<Tag> findQuery = Query<Tag>(context);
    findQuery.where((t) => t.name).equalTo(instance.name);
    var tag = await findQuery.fetchOne();
    if (tag != null) {
      return Response.ok(tag);
    }

    _query = await willInsertObjectWithQuery(_query);
    var result = await _query?.insert();

    if (result == null) return Response.ok({"key": "value"});

    return didInsertObject(result);

    return super.createObject();
  }
}
