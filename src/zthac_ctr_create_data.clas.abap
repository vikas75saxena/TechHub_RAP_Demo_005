CLASS zthac_ctr_create_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zthac_ctr_create_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: itab_tgt TYPE STANDARD TABLE OF zthac_ctr_bck,
          itab_src TYPE STANDARD TABLE OF zthac_contr.

    SELECT * FROM zthac_contr INTO TABLE @itab_src.
    CHECK sy-subrc EQ 0.
    LOOP AT itab_src ASSIGNING FIELD-SYMBOL(<fs_src>).
      APPEND INITIAL LINE TO itab_tgt ASSIGNING FIELD-SYMBOL(<fs_tgt>).
      MOVE-CORRESPONDING <fs_src> TO <fs_tgt>.
    ENDLOOP.
*   delete existing entries in the database table
    DELETE FROM zthac_ctr_bck.
*   insert the new table entries
    INSERT zthac_ctr_bck FROM TABLE @itab_tgt.
*   output the result as a console message
    out->write( |{ sy-dbcnt } status entries inserted successfully!| ).
  ENDMETHOD.
ENDCLASS.
