using { sap.capire.bookshop as my } from '../db/schema';

@(path:'/browse')
@impl: './cat-service.js' 
service CatalogService  {

  @readonly entity Books as SELECT from my.Books {*} excluding { createdBy, modifiedBy };

  @requires_: 'authenticated-user'
  @insertonly entity Orders as projection on my.Orders;
}