class DBrate {
  int? status;
  List<Data>? data;

  DBrate({this.status, this.data});

  DBrate.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  List<Product>? product;
  String? message;

  Data({this.product, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Product {
  int? id;
  String? categoryName;
  List<ProductSubCategories>? productSubCategories;

  Product({this.id, this.categoryName, this.productSubCategories});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['product_sub_categories'] != null) {
      productSubCategories = <ProductSubCategories>[];
      json['product_sub_categories'].forEach((v) {
        productSubCategories!.add(new ProductSubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.productSubCategories != null) {
      data['product_sub_categories'] =
          this.productSubCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductSubCategories {
  int? id;
  String? subCategoryName;
  List<Products>? products;

  ProductSubCategories({this.id, this.subCategoryName, this.products});

  ProductSubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryName = json['sub_category_name'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_category_name'] = this.subCategoryName;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productName;
  int? rate;
  int? productId;

  Products({this.productName, this.rate, this.productId});

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    rate = json['rate'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['rate'] = this.rate;
    data['product_id'] = this.productId;
    return data;
  }
}
