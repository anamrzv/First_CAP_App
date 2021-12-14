using AdminService from '../../srv/admin-service';

////////////////////////////////////////////////////////////////////////////
//
//	Books Object Page
//
annotate AdminService.Books with @(
	UI: {
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>General}', Target: '@UI.FieldGroup#General'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Details}', Target: '@UI.FieldGroup#Details'}
			],
		FieldGroup#General: {
			Data: [
				{Value: title},
				{Value: author_ID},
				{Value: descr},
			]
		},
		FieldGroup#Details: {
			Data: [
				{Value: stock},
				{Value: price},
				{Value: currency_code, Label: '{i18n>Currency}'},
			]
		}
	}
);
