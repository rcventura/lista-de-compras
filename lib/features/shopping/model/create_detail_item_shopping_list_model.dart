import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';

class CreateDetailItemShoppingListModel {
  final String id;
  final String createdAt;
  final String listId;
  final String productId;
  final String userId;
  final String listItemId;
  final String itemName;
  final String? itemBrand;
  final double itemQuantity;
  final String itemType;
  final double itemPrice;
  final bool isPromotional;
  final double itemPricePromotional;
  final String? itemDueDate;
  final String? itemNotes;
  final double itemPriceTotal;
  final double? itemFractionalPrice;

  CreateDetailItemShoppingListModel({
    required this.id,
    required this.createdAt,
    required this.listId,
    required this.productId,
    required this.userId,
    required this.listItemId,
    required this.itemName,
    required this.itemBrand,
    required this.itemQuantity,
    required this.itemType,
    required this.itemPrice,
    required this.isPromotional,
    required this.itemPricePromotional,
    this.itemDueDate,
    this.itemNotes,
    required this.itemPriceTotal,
    this.itemFractionalPrice,
  });

  factory CreateDetailItemShoppingListModel.fromMap(Map<String, dynamic> map) {
    return CreateDetailItemShoppingListModel(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      listId: map['list_id'] as String,
      productId: map['product_id'] as String,
      userId: map['user_id'] as String,
      listItemId: map['list_item_id'] as String,
      itemName: map['item_name'] as String,
      itemBrand: map['item_brand'] as String?,
      itemQuantity: (map['item_quantity'] as num).toDouble(),
      itemType: map['item_type'] as String,
      itemPrice: (map['item_price'] as num).toDouble(),
      isPromotional: map['is_promotional'] as bool,
      itemPricePromotional: (map['item_price_promotional'] as num).toDouble(),
      itemDueDate: map['item_due_date'],
      itemNotes: map['item_notes'] as String?,
      itemPriceTotal: (map['item_price_total'] as num).toDouble(),
      itemFractionalPrice: map['item_fractional_price'] != null
          ? (map['item_fractional_price'] as num).toDouble()
          : null
    );
  }

  CreateDetailItemShoppingListModel copyWith({
    required String id,
    required String createdAt,
    required String listId,
    required String productId,
    required String userId,
    required String listItemId,
    required String itemName,
    required String? itemBrand,
    required double itemQuantity,
    required String itemType,
    required double itemPrice,
    required bool isPromotional,
    required double itemPricePromotional,
    required double itemPriceTotal,
    String? itemNotes,
    String? itemDueDate,
    double? itemFractionalPrice,
  }) {
    return CreateDetailItemShoppingListModel(
      id: id,
      createdAt: createdAt,
      listId: listId,
      productId: productId,
      userId: userId,
      listItemId: listItemId,
      itemName: itemName,
      itemBrand: itemBrand,
      itemQuantity: itemQuantity,
      itemType: itemType,
      itemPrice: itemPrice,
      isPromotional: isPromotional,
      itemPricePromotional: itemPricePromotional,
      itemDueDate: itemDueDate,
      itemNotes: itemNotes,
      itemPriceTotal: itemPriceTotal,
      itemFractionalPrice: itemFractionalPrice,
    );
  }

  CreateDetailItemShoppingListEntity toEntity() {
    return CreateDetailItemShoppingListEntity(
      id: id,
      createdAt: createdAt,
      listId: listId,
      productId: productId,
      userId: userId,
      listItemId: listItemId,
      itemName: itemName,
      itemBrand: itemBrand,
      itemQuantity: itemQuantity,
      itemType: itemType,
      itemPrice: itemPrice,
      isPromotional: isPromotional,
      itemPricePromotional: itemPricePromotional,
      itemDueDate: itemDueDate,
      itemNotes: itemNotes,
      itemPriceTotal: itemPriceTotal,
      itemFractionalPrice: itemFractionalPrice,
    );
  }
}
