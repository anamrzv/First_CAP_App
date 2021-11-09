namespace sap.capire.bookshop; //helpful for reuse
using { Currency, managed, cuid } from '@sap/cds/common';
using { sap.capire.products.Products } from '../../products/db/schema';

entity Books : Products, additionalInfo {
  author   : Association to Authors;
}

entity Magazines : Products, additionalInfo {
  publisher : String(100);
}

entity Authors : managed {
  key ID   : Integer;
  name     : String(111);
  dateOfBirth : Date;
  dateOfDeath : Date;
  placeOfBirth : String;
  placeOfDeath : String;
  books    : Association to many Books on books.author = $self;
}

entity Orders : managed, cuid {
  OrderNo  : String @title:'Order Number'; //> readable key
  Items    : Composition of many OrderItems on Items.parent = $self;
}

entity OrderItems : cuid {
  parent   : Association to Orders;
  book     : Association to Books;
  amount   : Integer;
}

entity Movies : additionalInfo {
    key ID :Integer;
    name:String(100);
}

aspect additionalInfo {
    genre: String(100);
    language: String(200);
}