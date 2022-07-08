@EndUserText.label: 'Test Contractor Custom View'
@UI: {
  headerInfo: { typeName: 'Contractor', typeNamePlural: 'Contractors', title: { type: #STANDARD, value: 'contractor_id' } } }
@Search.searchable: true
@ObjectModel.semanticKey: ['contractor_id']
@ObjectModel.query.implementedBy: 'ABAP:ZUM_CTRB_BACKEND_SEL'
define root custom entity ZTHAC_CTRB_CUST
{
      @UI: {
      lineItem:       [ { position: 10, importance: #HIGH } ],
      identification: [ { position: 10, label: 'Contractor ID' } ] }
      @Search.defaultSearchElement: true  
  key contractor_id   : zthac_contractor_id;
      BusinessPartner : abap.char( 10 );
      @UI: {
      lineItem:       [ { position: 70, importance: #HIGH } ],
      identification: [ { position: 70 } ],
      selectionField: [ { position: 70 } ] }
      FirstName       : abap.char( 40 );
      @UI: {
      lineItem:       [ { position: 80, importance: #HIGH } ],
      identification: [ { position: 80 } ],
      selectionField: [ { position: 80 } ] }
      LastName        : abap.char( 40 );
      @UI: {
      lineItem:       [ { position: 90, importance: #HIGH } ],
      identification: [ { position: 90 } ] }
//      selectionField: [ { position: 90 } ] }
      HouseNumber     : abap.char( 10 );
      @UI: {
      lineItem:       [ { position: 100, importance: #HIGH } ],
      identification: [ { position: 100 } ] }
//      selectionField: [ { position: 100 } ] }
      StreetName      : abap.char( 60 );
      @UI: {
      lineItem:       [ { position: 110, importance: #HIGH } ],
      identification: [ { position: 110 } ] }
//      selectionField: [ { position: 110 } ] }
      CityName        : abap.char( 40 );
      @UI: {
      lineItem:       [ { position: 120, importance: #HIGH } ],
      identification: [ { position: 120 } ] }
//      selectionField: [ { position: 120 } ] }
      Region          : abap.char( 3 );
      @UI: {
      lineItem:       [ { position: 130, importance: #HIGH } ],
      identification: [ { position: 130 } ] }
//      selectionField: [ { position: 130 } ] }
      Country         : abap.char( 3 );
      @UI: {
      lineItem:       [ { position: 140, importance: #HIGH } ],
      identification: [ { position: 140 } ] }
//      selectionField: [ { position: 140 } ] }
      PostalCode      : abap.char( 10 );
      @UI: {
      lineItem:       [ { position: 20, importance: #HIGH } ],
      identification: [ { position: 20 } ],
      selectionField: [ { position: 20 } ] }      
      vendor_id           : zthac_vendor_id;
      @UI: {
      lineItem:       [ { position: 30, importance: #HIGH } ],
      identification: [ { position: 30 } ],
      selectionField: [ { position: 30 } ] }
      external_id         : zthac_contractor_id;
      @UI: {
      lineItem:       [ { position: 40, importance: #HIGH } ],
      identification: [ { position: 40 } ] }
//      selectionField: [ { position: 40 } ] }      
      start_date      : zthac_start_date;
      @UI: {
      lineItem:       [ { position: 50, importance: #HIGH } ],
      identification: [ { position: 50 } ] }
//      selectionField: [ { position: 50 } ] }
      end_date        : zthac_end_date;
      @UI: {
      lineItem:       [ { position: 60, importance: #HIGH } ],
      identification: [ { position: 60 } ],
      selectionField: [ { position: 60 } ] }
      status          : zthac_contr_status;
      created_by      : syuname;
      created_at      : timestampl;
      last_changed_by : syuname;
      last_changed_at : timestampl;
      CalculatedEtag : abap.string( 0 );
      
}
