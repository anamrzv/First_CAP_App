using { sap.capire.bookshop as my } from '../db/schema';

@(path:'/browse')
service CatalogService {

  @readonly entity Books as SELECT from my.Books {*} excluding { createdBy, modifiedBy };

  @insertonly entity Orders as projection on my.Orders;


  //our own event for remote service. it is used in cat-service.js
  event OrderBlocked {
    ID: UUID;
  };

  //for data which exists in DB already
  entity Magazines as projection on my.Magazines;
  //works when we make request .../MagazinesInfo(4)
  entity MagazinesInfo (RATING : Integer) as select from my.MagazinesInfo(REQ_RATING: :RATING) {*};



  //users can modify only their orders, see order with the same currency
  annotate CatalogService.Orders with 
     @(restrict: [
        { grant: 'READ', to: 'authenticated-user', where: 'currency_code = $user.currency' } ,
        { grant: 'UPDATE', to: 'authenticated-user', where: 'createdBy = $user'}
  ]);
}