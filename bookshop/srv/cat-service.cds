using { sap.capire.bookshop as my } from '../db/schema';
using { API_BUSINESS_PARTNER as external } from './external/API_BUSINESS_PARTNER.csn';

@(path:'/browse')
@impl: './cat-service.js' 
service CatalogService @(_requires: 'authenticated-user') {

  @readonly entity Books as SELECT from my.Books {*} excluding { createdBy, modifiedBy };

  @insertonly entity Orders as projection on my.Orders;

  @readonly entity BusinessPartners as projection on external.A_BusinessPartner {
    key BusinessPartner as ID,
    FirstName,
    MiddleName,
    LastName,
    BusinessPartnerIsBlocked
  };

  //our own event for remote service. it is used in cat-service.js
  event OrderBlocked {
    ID: UUID;
  };

  //for data which exists in DB already
  entity Magazines as projection on my.Magazines;
  //works when we make request .../MagazinesInfo(4)
  entity MagazinesInfo (RATING : Integer) as select from my.MagazinesInfo(REQ_RATING: :RATING) {*};

  entity MagazinesDescr as select from my.MagazinesDescr;



  //users can modify only their orders, see order with the same currency
  annotate CatalogService.Orders with 
     @(restrict: [
        { grant: 'READ', to: 'authenticated-user', where: 'currency_code = $user.currency' } ,
        { grant: 'UPDATE', to: 'authenticated-user', where: 'createdBy = $user'}
  ]);
}