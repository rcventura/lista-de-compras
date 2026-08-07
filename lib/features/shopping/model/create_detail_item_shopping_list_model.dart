import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';

class CreateDetailItemShoppingListModel {
  final String id;
  final String createdAt;
  final String productId;
  final String listId;
  final String userId;
  final String itemName;
  final String itemBrand;
  final double itemPrice;
  final double itemPricePromotional;
  final bool isPromotional;
  final double itemQuantity;
  final String itemType;
  final double itemPriceTotal;
  final String? itemDueDate;
  final String? itemNotes;

  CreateDetailItemShoppingListModel({
    required this.id,
    required this.createdAt,
    required this.productId,
    required this.listId,
    required this.userId,
    required this.itemName,
    required this.itemBrand,
    required this.itemPrice,
    required this.itemPricePromotional,
    required this.isPromotional,
    required this.itemQuantity,
    required this.itemType,
    required this.itemPriceTotal,
    this.itemDueDate,
    this.itemNotes,
  });

  factory CreateDetailItemShoppingListModel.fromMap(Map<String, dynamic> map) {
    return CreateDetailItemShoppingListModel(
      createdAt: map['created_at'] as String,
      id: map['id'] as String,
      productId: map['product_id'] as String,
      listId: map['list_id'] as String,
      userId: map['user_id'] as String,
      itemName: map['item_name'] as String,
      itemBrand: map['item_brand'] as String,
      itemPrice: map['item_price'] as double,
      itemPricePromotional: map['item_price_promotional'] as double,
      isPromotional: map['is_promotional'] as bool,
      itemQuantity: map['item_quantity'] as double,
      itemType: map['item_type'] as String,
      itemPriceTotal: map['item_price_total'] as double,
      itemDueDate: map['item_due_date'] as String,
      itemNotes: map['item_notes'] as String,
    );
  }

  CreateDetailItemShoppingListModel copyWith({
    required String id,
    required String createdAt,
    required String productId,
    required String listId,
    required String userId,
    required String itemName,
    required String itemBrand,
    required double itemPrice,
    required double itemPricePromotional,
    required bool isPromotional,
    required double itemQuantity,
    required String itemType,
    required double itemPriceTotal,
    String? itemDueDate,
    String? itemNotes,
  }) {
    return CreateDetailItemShoppingListModel(
      id: id,
      createdAt: createdAt,
      productId: productId,
      listId: listId,
      userId: userId,
      itemName: itemName,
      itemBrand: itemBrand,
      itemPrice: itemPrice,
      itemPricePromotional: itemPricePromotional,
      isPromotional: isPromotional,
      itemQuantity: itemQuantity,
      itemType: itemType,
      itemPriceTotal: itemPriceTotal,
      itemDueDate: itemDueDate,
      itemNotes: itemNotes,
    );
  }

  CreateDetailItemShoppingListEntity toEntity() {
    return CreateDetailItemShoppingListEntity(
      productId: productId,
      listId: listId,
      userId: userId,
      itemName: itemName,
      itemBrand: itemBrand,
      itemPrice: itemPrice,
      itemPricePromotional: itemPricePromotional,
      isPromotional: isPromotional,
      itemQuantity: itemQuantity,
      itemType: itemType,
      itemPriceTotal: itemPriceTotal,
      itemDueDate: itemDueDate,
      itemNotes: itemNotes,
      
    );
  }
}
