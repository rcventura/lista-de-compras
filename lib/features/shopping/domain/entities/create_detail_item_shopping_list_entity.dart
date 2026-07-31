class CreateDetailItemShoppingListEntity {
  final String? id;
  final String? createdAt;
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

  const CreateDetailItemShoppingListEntity({
    this.id,
    this.createdAt,
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
}
