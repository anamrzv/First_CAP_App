using { AdminService } from './admin-service';
using { CatalogService } from './cat-service';

annotate AdminService with @(requires: 'identified-user');

//users can modify only their orders, see order with the same currency
annotate CatalogService.Orders with @(restrict: [
        { grant: 'READ', to: 'authenticated-user', where: 'currency_code = $user.currency' } ,
        { grant: 'UPDATE', to: 'authenticated-user', where: 'createdBy = $user'}
  ]);

  // Restrict access to orders to users with role "admin"
annotate AdminService.Orders with  @(restrict: [
   { grant: 'READ', to: 'admin' } 
]);
  