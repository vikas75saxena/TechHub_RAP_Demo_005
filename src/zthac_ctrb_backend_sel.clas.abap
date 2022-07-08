CLASS zthac_ctrb_backend_sel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zthac_ctrb_backend_sel IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: ls_textid TYPE scx_t100key.
    TRY.
        DATA(lo_client_proxy) = zthac_ctr_backend_hlpr=>get_client_proxy(  ).
      CATCH Zctnr_bckdn_serv_cons INTO DATA(oref).
    ENDTRY.
    TRY.
        DATA(lo_read_request) = lo_client_proxy->create_resource_for_entity_set( 'A_BUSINESSPARTNER' )->create_request_for_read( ).
        """Request Count
        IF io_request->is_total_numb_of_rec_requested( ).
          lo_read_request->request_count( ).
*                    io_response->set_total_number_of_records( 20 ).
        ENDIF.
        """Request Data
        IF io_request->is_data_requested( ).
          """Request Paging
          DATA(ls_paging) = io_request->get_paging( ).
          IF ls_paging->get_offset( ) >= 0.
            lo_read_request->set_skip( ls_paging->get_offset( ) ).
          ENDIF.
          IF ls_paging->get_page_size( ) <>
         if_rap_query_paging=>page_size_unlimited.
            lo_read_request->set_top( ls_paging->get_page_size( ) ).
          ENDIF.
        ENDIF.
        """Request Filtering
        TRY.
            DATA(lt_filter_range) = io_request->get_filter( )->get_as_ranges( ).
          CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
            RAISE EXCEPTION TYPE Zctnr_bckdn_serv_cons
              EXPORTING
                textid   = ls_textid
                previous = lx_no_range.
        ENDTRY.
        DATA(lv_filter_string) = io_request->get_filter( )->get_as_sql_string( ).
        LOOP AT lt_filter_range ASSIGNING FIELD-SYMBOL(<ls_filter>).
          IF <ls_filter>-name = 'FirstName' or <ls_filter>-name = 'LastName'.
          "Filtering for remote attributes
          "create filter factory for read request
          DATA(lo_filter_factory) = lo_read_request->create_filter_factory( ).
          DATA: lv_filter_property type /iwbep/if_cp_runtime_types=>ty_property_path.
          lv_filter_property = <ls_filter>-name.
          DATA(lo_filter_for_current_field) = lo_filter_factory->create_by_range(
            iv_property_path = lv_filter_property
            it_range = <ls_filter>-range ).
          "Concatenate filter if more than one filter element
          DATA: lo_filter TYPE REF TO /iwbep/if_cp_filter_node.
          IF lo_filter IS INITIAL.
            lo_filter = lo_filter_for_current_field.
          ELSE.
            lo_filter = lo_filter->and( lo_filter_for_current_field ).
          ENDIF.
          ELSE.
          "Filtering for local attributes

          ENDIF.
        ENDLOOP.
        IF lo_filter IS NOT INITIAL.
          lo_read_request->set_filter( lo_filter ).
        ENDIF.

        """Execute the Request
        DATA(lo_response) = lo_read_request->execute( ).
        """Set Count
        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lo_response->get_count( ) ).
        ENDIF.
        IF io_request->is_data_requested( ).
          DATA: lt_ctrb_data     TYPE STANDARD TABLE OF zthac_ctrb_cust,
                lt_ctrb_locl     TYPE STANDARD TABLE OF zthac_ctr_bck,
                lt_remote_bp     TYPE STANDARD TABLE OF zum_a_businesspartner,
                lt_remote_bpid   TYPE STANDARD TABLE OF zum_a_bupaidentification,
                lt_remote_bpaddr TYPE STANDARD TABLE OF zum_a_businesspartneraddress.
          lo_response->get_business_data( IMPORTING et_business_data =
   lt_remote_bp ).
          IF lt_remote_bp IS NOT INITIAL.
            SELECT * FROM zthac_ctr_bck FOR ALL ENTRIES IN @lt_remote_bp
            WHERE external_id = @lt_remote_bp-BusinessPartner
            INTO TABLE @lt_ctrb_locl.
            IF sy-subrc = 0.
              LOOP AT lt_ctrb_locl ASSIGNING FIELD-SYMBOL(<ls_ctrb_locl>).
                APPEND INITIAL LINE TO lt_ctrb_data ASSIGNING FIELD-SYMBOL(<ls_ctrb_data>).
                MOVE-CORRESPONDING <ls_ctrb_locl> TO <ls_ctrb_data>.
                <ls_ctrb_data>-BusinessPartner = lt_remote_bp[ BusinessPartner = <ls_ctrb_locl>-external_id ]-BusinessPartner.
                <ls_ctrb_data>-FirstName = lt_remote_bp[ BusinessPartner = <ls_ctrb_locl>-external_id ]-FirstName.
                <ls_ctrb_data>-LastName = lt_remote_bp[ BusinessPartner = <ls_ctrb_locl>-external_id ]-LastName.
              ENDLOOP.
            ENDIF.
          ENDIF.
          io_response->set_data( lt_ctrb_data ).
        ENDIF.
      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
