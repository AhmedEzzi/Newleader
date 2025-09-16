import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:objectbox/objectbox.dart';
import '../../features/data/product/models/product_entity.dart';
import '../../objectbox.g.dart';

class ObjectBox {
  late final Store store;
  late final Box<ProductEntity> productBox;
  late final Box<CategoryEntity> categoryBox;
  late final Box<ProductStockEntity> stockBox;
  late final Box<ProductCollectionEntity> collectionBox;

  ObjectBox._create(this.store) {
    productBox = Box<ProductEntity>(store);
    categoryBox = Box<CategoryEntity>(store);
    stockBox = Box<ProductStockEntity>(store);
    collectionBox = Box<ProductCollectionEntity>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "product-cache"));
    return ObjectBox._create(store);
  }

  void closeStore() {
    if (store.isClosed() == false) {
      store.close();
    }
  }
}