class UpdateProduct {
  String? id;
  String? name;
  String? description;
  int? price;
  int? promotionalPrice;
  String? createAt;
  String? expiredAt;
  String? status;
  int? quantity;
  int? sold;

  UpdateProduct(
      { this.id,
        this.name,
       this.description,
       this.price,
       this.promotionalPrice,
       this.createAt,
       this.expiredAt,
       this.status,
       this.quantity,
       this.sold});
}
