using CatalogService from '../../srv/cat-service';

////////////////////////////////////////////////////////////////////////////
//
//	Books Object Page
//
annotate CatalogService.Books with {
    title       @title: 'Title:)';
    descr       @title: 'Description:)';
    price        @title: 'Price:(';
    currency      @title: 'Currency:)';
	author          @title: 'Author';
}

annotate CatalogService.Books with @(
	UI: {
  	HeaderInfo: { //key info about the object
		TypeName: 'Book',
		TypeNamePlural: 'Books',
		Title: {
			$Type: 'UI.DataField',
			Value: title
		},
  		Description: { //subtitle
			$Type: 'UI.DataField',
			Value: descr
		}
  	},
		HeaderFacets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Description}', Target: '@UI.FieldGroup#Descr'},
		],
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Details}', Target: '@UI.FieldGroup#Price'},
		],
		//see it when click on header of object in a row(defines the content of the object page)
		FieldGroup#Descr: {
			Data: [
				{Value: descr},
			]
		},
		FieldGroup#Price: {
			Data: [
				{Value: price},
				{Value: currency.symbol, Label: '{i18n>Currency}'},
			]
		},
	}
);


////////////////////////////////////////////////////////////////////////////
//
//	Books Object Page
//
annotate CatalogService.Books with @(
	UI: {
	  SelectionFields: [ ID, price, currency_code ], //for search filter. defines which of the properties are exposed as search fields in the header bar above the list
		LineItem: [ //The columns and their order
			{Value: title},
			{Value: descr},
			{Value: price},
			{Value: currency.symbol, Label:' '},
		]
	},
);
