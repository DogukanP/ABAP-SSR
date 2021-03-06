*&---------------------------------------------------------------------*
*&  Include           ZDP_SATIS_SIP_RPR_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT vbak~vbeln
         vbap~posnr
         vbak~erdat
         vbak~erzet
         vbak~ernam
         adrp~name_text
         vbak~audat
         vbak~vbtyp
         vbak~auart
         tvak~auart
         vbak~netwr
         vbak~waerk
         vbak~vkorg
         vbak~vtweg
         vbak~spart
         vbap~matnr
         makt~maktx
    FROM vbak
    INNER JOIN vbap  ON vbak~vbeln = vbap~vbeln
    INNER JOIN makt  ON vbap~matnr = makt~matnr AND spras EQ sy-langu
    LEFT JOIN  usr21 ON vbak~ernam = usr21~bname
    INNER JOIN adrp  ON usr21~persnumber = adrp~persnumber
    INNER JOIN tvak  ON vbak~auart = tvak~auart
    INTO CORRESPONDING FIELDS OF TABLE gt_outm
    WHERE vbak~vbeln IN so_blgno
      AND vbak~ernam IN so_yrtn
      AND vbap~matnr IN so_mlzm.

  SORT gt_outm BY vbeln posnr ASCENDING.


  PERFORM get_def.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DEF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_def .

  DATA : gv_domain TYPE dd07l-domname,
         gv_domvalue TYPE dd07l-domvalue_l,
         gv_tab TYPE dd07v,
         gv_def TYPE string,
         gv_subrc TYPE sy-subrc,
         index TYPE sy-tabix.

  LOOP AT gt_outm INTO gs_outm.
    index = sy-tabix.
    gv_domain = 'VBTYP'.
    gv_domvalue = gs_outm-vbtyp.

    CALL FUNCTION 'DD_DOMVALUE_TEXT_GET'
      EXPORTING
        domname             = gv_domain
        value               = gv_domvalue
*     LANGU               = ' '
*     BYPASS_BUFFER       = ' '
     IMPORTING
       dd07v_wa            = gv_tab
       rc                  = gv_subrc.

    IF gv_subrc = 0.
      gs_outm-sbtit = gv_tab-ddtext.
      MODIFY gt_outm FROM gs_outm INDEX index TRANSPORTING sbtit.
    ENDIF.

    SELECT SINGLE bezei FROM tvakt INTO gv_def WHERE spras = 'TR'
    AND auart = gs_outm-auart  .
    gs_outm-sbtut = gv_def.
    MODIFY gt_outm FROM gs_outm INDEX index TRANSPORTING sbtut.

    SELECT SINGLE vtext FROM tvkot INTO gv_def WHERE spras = 'TR'
    AND vkorg = gs_outm-vkorg  .
    gs_outm-saort = gv_def.
    MODIFY gt_outm FROM gs_outm INDEX index TRANSPORTING saort.

    SELECT SINGLE vtext FROM tvtwt INTO gv_def WHERE spras ='TR'
    AND vtweg = gs_outm-vtweg  .
    gs_outm-dakta = gv_def.
    MODIFY gt_outm FROM gs_outm INDEX index TRANSPORTING dakta.

    SELECT SINGLE vtext FROM tspat INTO gv_def WHERE spras = 'TR'
    AND spart = gs_outm-spart  .
    gs_outm-bolta = gv_def.
    MODIFY gt_outm FROM gs_outm INDEX index TRANSPORTING bolta.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_data .
  CALL SCREEN 0100 .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SHOW_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_alv .

  IF go_custom_container IS INITIAL.
    CREATE OBJECT go_custom_container
      EXPORTING
        container_name = go_container.

    CREATE OBJECT go_grid
      EXPORTING
        i_parent = go_custom_container.

    PERFORM build_layout.

    PERFORM build_fcat .

    PERFORM exclude_button CHANGING gt_exclude .

    PERFORM event_handler.

    CALL METHOD go_grid->set_table_for_first_display ""alv bas??l??r.
    EXPORTING
      is_layout            = gs_layout
      it_toolbar_excluding = gt_exclude
      is_variant           = gs_variant
      i_save               = 'A'
    CHANGING
      it_outtab            = gt_outm[]
      it_fieldcatalog      = gt_fcat[].

    PERFORM register_event.
  ELSE .
    PERFORM check_changed_data    USING go_grid .
    PERFORM refresh_table_display USING go_grid .
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_layout .
  CLEAR gs_layout.
  gs_layout-zebra      = 'X'."ilk sat??r koyu ikinci sat??r a????k
  gs_layout-cwidth_opt = 'X'."kolonlar??n uzunluklar??n?? optimize et
  gs_layout-sel_mode   = 'A'."h??crelerin se??ilebilme kriteri
  gs_layout-stylefname = 'FIELD_STYLE'.
  gs_layout-info_fname = 'LINECOLOR'.
  gs_variant-report     = sy-repid .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fcat .

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'VBELN'.
  gs_fcat-scrtext_m = 'Sat???? Belgesi'.
*  gs_fcat-lzero = 'X'.
  gs_fcat-datatype = 'NUMC'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'POSNR'.
  gs_fcat-scrtext_m = 'Kalem'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'ERDAT'.
  gs_fcat-scrtext_m = 'Yaratma Tarihi'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'ERZET'.
  gs_fcat-scrtext_m = 'Saat'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'ERNAM'.
  gs_fcat-scrtext_m = 'Yarat??ld??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'NAME_TEXT'.
  gs_fcat-scrtext_m = 'Tam Ad??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'AUDAT'.
  gs_fcat-scrtext_m = 'Belge tarihi'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'VBTYP'.
  gs_fcat-scrtext_m = 'St??.Blg.Tipi'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SBTIT'.
  gs_fcat-scrtext_m = 'St??.Blg.Tipi Tan??m??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'AUART'.
  gs_fcat-scrtext_m = 'St??.Blg.T??r??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SBTUT'.
  gs_fcat-scrtext_m = 'St??.Blg.T??r?? Tan??m??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'NETWR'.
  gs_fcat-scrtext_m = 'Net De??er'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'WAERK'.
  gs_fcat-scrtext_m = 'Belge para birimi'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'VKORG'.
  gs_fcat-scrtext_m = 'Sat???? Org.'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SAORT'.
  gs_fcat-scrtext_m = 'Sat???? Org. Tan??m??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'VTWEG'.
  gs_fcat-scrtext_m = 'Da????t??m Kanal??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'DAKTA'.
  gs_fcat-scrtext_m = 'Da????t??m Kanal?? Tan??m??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SPART'.
  gs_fcat-scrtext_m = 'B??l??m'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'BOLTA'.
  gs_fcat-scrtext_m = 'B??l??m Tan??m??'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'MATNR'.
  gs_fcat-scrtext_m = 'Malzeme No'.
  gs_fcat-datatype = 'NUMC'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'MAKTX'.
  gs_fcat-scrtext_m = 'Malzeme Ad??'.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_BUTTON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_EXCLUDE  text
*----------------------------------------------------------------------*
FORM exclude_button  CHANGING p_gt_exclude.

  DATA: ls_exclude LIKE LINE OF gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_detail.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_print.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_check.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_views.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_graph.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_maintain_variant.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_refresh.
  APPEND ls_exclude TO gt_exclude.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EVENT_HANDLER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM event_handler .

  DATA: lcl_alv_event TYPE REF TO lcl_event_receiver .
  CREATE OBJECT lcl_alv_event.

  SET HANDLER lcl_alv_event->handle_toolbar      FOR go_grid.
  SET HANDLER lcl_alv_event->handle_user_command FOR go_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GO_GRID  text
*----------------------------------------------------------------------*
FORM check_changed_data  USING io_grid TYPE REF TO cl_gui_alv_grid .
  DATA: lv_valid TYPE c.

  CALL METHOD io_grid->check_changed_data
    IMPORTING
      e_valid = lv_valid.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GO_GRID  text
*----------------------------------------------------------------------*
FORM refresh_table_display  USING  p_grid TYPE REF TO cl_gui_alv_grid.
  DATA : ls_stable TYPE lvc_s_stbl .

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.
  CALL METHOD p_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  REGISTER_EVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM register_event .
  CALL METHOD go_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

  CALL METHOD go_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  YAZDIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM yazdir .

  CONSTANTS: lf_formname TYPE tdsfname  VALUE 'ZDOP_SF_SSR'.

  DATA:      lf_fm_name TYPE rs38l_fnam,
             ls_output TYPE ssfcompop,
             ls_control  TYPE ssfctrlop.

  DATA:lt_alv       TYPE TABLE OF zdop_s_ssr,
       ls_alv       TYPE zdop_s_ssr,
       lt_itab      TYPE TABLE OF zdop_s_ssr,
       ls_itab      TYPE zdop_s_ssr,
       lt_rows      TYPE lvc_t_row,
       ls_rows      TYPE lvc_s_row,
       ls_pdftab    TYPE tline,
       binfilesize  TYPE i,
       lt_pdftab    TYPE TABLE OF tline.

  CALL METHOD go_grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.
  IF lt_rows IS INITIAL.
    MESSAGE 'EN AZ B??R SATIR SE????N' TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = lf_formname
        variant            = ' '
        direct_call        = ' '
      IMPORTING
        fm_name            = lf_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE '??IKTI ALINAMADI' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.

    ls_control-no_open   = 'X'.
    ls_control-no_close  = 'X'.
    ls_output-tddest     = 'LP01'.
    ls_output-tdimmed    = 'X'.


    CALL FUNCTION 'SSF_OPEN'
      EXPORTING
        control_parameters = ls_control
        output_options     = ls_output
        user_settings      = ' '
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.



    LOOP AT lt_rows INTO ls_rows.
      CLEAR:  gs_outm, ls_alv.
      READ TABLE gt_outm INTO gs_outm INDEX ls_rows-index.
      MOVE-CORRESPONDING gs_outm TO ls_alv.
      APPEND ls_alv TO lt_alv.
    ENDLOOP.

    CLEAR:  gs_outm, ls_alv.

    LOOP AT lt_alv INTO ls_alv.

      CLEAR lt_itab.

      LOOP AT gt_outm INTO gs_outm WHERE vbeln EQ ls_alv-vbeln.
        MOVE-CORRESPONDING gs_outm TO ls_itab.
        APPEND ls_itab TO lt_itab.
      ENDLOOP.

      IF sy-subrc EQ 0.


        CALL FUNCTION lf_fm_name
            EXPORTING
              control_parameters = ls_control
              output_options     = ls_output
              user_settings      = ' '
              gs_ssr             = gs_outm
            TABLES
              gt_ssr             = lt_itab
            EXCEPTIONS
              formatting_error   = 1
              internal_error     = 2
              send_error         = 3
              user_canceled      = 4
              OTHERS             = 5.
        IF sy-subrc <> 0.
          MESSAGE '??IKTI ALINAMADI' TYPE 'S' DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.

      ENDIF.

    ENDLOOP.


    CALL FUNCTION 'SSF_CLOSE'
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        OTHERS           = 4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PDF_INDIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pdf_indir .
  CONSTANTS:lf_formname TYPE tdsfname VALUE 'ZDOP_SF_SSR'.
  DATA :file_name          TYPE string VALUE 'SATIS_SIP_RPR.PDF',
        file_path          TYPE string,
        full_path          TYPE string.
  DATA: lt_alv       TYPE TABLE OF zdop_s_ssr,
        ls_alv       TYPE zdop_s_ssr,
        lt_itab      TYPE TABLE OF zdop_s_ssr,
        ls_itab      TYPE zdop_s_ssr,
        lt_rows      TYPE lvc_t_row,
        ls_rows      TYPE lvc_s_row,
        ls_pdftab    TYPE tline,
        binfilesize  TYPE i,
        lt_pdftab    TYPE TABLE OF tline.

  DATA: lt_otf_data        LIKE TABLE OF itcoo,
        ls_otf_data        LIKE itcoo,
        t_otfdata          TYPE ssfcrescl,
        job_output_options TYPE ssfcresop,
        lf_fm_name         TYPE rs38l_fnam,
        ls_output          TYPE ssfcompop,
        ls_control         TYPE ssfctrlop.


  CALL METHOD go_grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.
  IF lt_rows IS INITIAL.
    MESSAGE 'EN AZ B??R SATIR SE????N' TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname           = lf_formname
          variant            = ' '
        direct_call        = ' '
        IMPORTING
          fm_name            = lf_fm_name
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.

    IF sy-subrc <> 0.
      MESSAGE '??IKTI ALINAMADI' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.

    CLEAR: ls_otf_data, lt_otf_data, t_otfdata, ls_control.

    ls_control-no_dialog = 'X'.
    ls_control-getotf    = 'X'.
    ls_control-langu     = 'T'.
    ls_output-tdprinter  = 'I9SWIN'.
    ls_output-tdnoprev   = 'X'.


    CALL FUNCTION 'SSF_OPEN'
      EXPORTING
        control_parameters = ls_control
        output_options     = ls_output
        user_settings      = 'X'
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.


    LOOP AT lt_rows INTO ls_rows.
      CLEAR: gs_outm, ls_alv .
      READ TABLE gt_outm INTO gs_outm INDEX ls_rows-index.
      MOVE-CORRESPONDING gs_outm TO ls_alv.
      APPEND ls_alv TO lt_alv.
    ENDLOOP.

    CLEAR:  gs_outm,ls_alv.

    "

    LOOP AT lt_alv INTO ls_alv.

      CLEAR lt_itab.

      LOOP AT gt_outm INTO gs_outm WHERE vbeln EQ ls_alv-vbeln.
        MOVE-CORRESPONDING gs_outm TO ls_itab.
        APPEND ls_itab TO lt_itab.
      ENDLOOP.

      IF sy-subrc EQ 0.

        CALL FUNCTION lf_fm_name
          EXPORTING
            control_parameters = ls_control
            output_options     = ls_output
            user_settings      = ' '
            gs_ssr             = gs_outm
          IMPORTING
            job_output_info    = t_otfdata
            job_output_options = job_output_options
          TABLES
            gt_ssr             = lt_itab
          EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 5.
        IF sy-subrc <> 0.
*          MESSAGE '??IKTI ALINAMADI' TYPE 'S' DISPLAY LIKE 'E'.
*          EXIT.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        CALL FUNCTION 'SSF_CLOSE'
        EXCEPTIONS
          formatting_error = 1
          internal_error   = 2
          send_error       = 3
          OTHERS           = 4.
      ENDIF.
    ENDLOOP.






    lt_otf_data = t_otfdata-otfdata.
    CALL FUNCTION 'CONVERT_OTF'
       EXPORTING
         format                = 'PDF'
       IMPORTING
         bin_filesize          = binfilesize
       TABLES
         otf                   = lt_otf_data
         lines                 = lt_pdftab
       EXCEPTIONS
         err_max_linewidth     = 1
         err_format            = 2
         err_conv_not_possible = 3
         err_bad_otf           = 4
         OTHERS                = 5.

    IF sy-subrc <> 0.
      MESSAGE '??IKTI ALINAMADI' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.

    CHECK lt_pdftab IS NOT INITIAL.




    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
      default_extension    = 'PDF'
      default_file_name    = file_name
      file_filter          = 'PDF'
      prompt_on_overwrite  = 'X'
      CHANGING
      filename             = file_name
      path                 = file_path
      fullpath             = full_path
      EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
    IF sy-subrc <> 0.
      MESSAGE '??IKTI ALINAMADI' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.



    CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          bin_filesize            = binfilesize
          filename                = full_path
          filetype                = 'BIN'
        TABLES
          data_tab                = lt_pdftab
        EXCEPTIONS
          file_write_error        = 1
          no_batch                = 2
          gui_refuse_filetransfer = 3
          invalid_type            = 4
          no_authority            = 5
          unknown_error           = 6
          header_not_allowed      = 7
          separator_not_allowed   = 8
          filesize_not_allowed    = 9
          header_too_long         = 10
          dp_error_create         = 11
          dp_error_send           = 12
          dp_error_write          = 13
          unknown_dp_error        = 14
          access_denied           = 15
          dp_out_of_memory        = 16
          disk_full               = 17
          dp_timeout              = 18
          file_not_found          = 19
          dataprovider_exception  = 20
          control_flush_error     = 21.


  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------

*&      Form  PDF_MAIL
*&---------------------------------------------------------------------

*       text
*----------------------------------------------------------------------

*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------

FORM pdf_mail .


  CONSTANTS:lf_formname TYPE tdsfname VALUE 'ZDOP_SF_SSR'.

  CONSTANTS:
    gc_subject     TYPE so_obj_des VALUE
    'ATTACHED PDF', " Email subject
    gc_email_to    TYPE adr6-smtp_addr VALUE
     'dogukan.padel@prodea.com.tr', " Valid email
    gc_head        TYPE soli VALUE 'Merhaba,',
    gc_text        TYPE soli VALUE
    'Bu mail maile ek olarak pdf ekleme denemesidir', " body text
    gc_footer      TYPE soli VALUE
    '??yi ??al????malar dilerim. Do??ukan Padel.',
    gc_type_raw    TYPE so_obj_tp   VALUE 'RAW', " Email type
    gc_att_type    TYPE soodk-objtp VALUE 'PDF', " Attachment type
    gc_att_subject TYPE sood-objdes VALUE 'Document in PDF'.

  DATA: gt_text           TYPE soli_tab.



  DATA: lt_otf_data  LIKE TABLE OF itcoo,
        ls_otf_data  LIKE itcoo,
        t_otfdata    TYPE ssfcrescl,
        job_output_options TYPE ssfcresop,
        file_name    TYPE string VALUE 'SATIS_SIP_RPR.PDF',
        file_path    TYPE string,
        full_path    TYPE string,
        lf_fm_name   TYPE rs38l_fnam,
        ls_output    TYPE ssfcompop,
        ls_buffer    TYPE string,
        lt_record    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
        ls_control   TYPE ssfctrlop.

  DATA: ls_xstring   TYPE xstring,
        lt_binarytab LIKE TABLE OF solix,
        ls_binarytab LIKE solix.

  DATA: lt_alv       TYPE TABLE OF zdop_s_ssr,
        ls_alv       TYPE zdop_s_ssr,
        lt_itab      TYPE TABLE OF zdop_s_ssr,
       ls_itab      TYPE zdop_s_ssr,
        lt_rows      TYPE lvc_t_row,
        ls_rows      TYPE lvc_s_row,
        ls_pdftab    TYPE tline,
        binfilesize  TYPE i,
        lt_pdftab    TYPE TABLE OF tline.

  DATA : gs_mail LIKE zdop_t_ssr_mail,
         gt_mail LIKE TABLE OF gs_mail.

  CLEAR : binfilesize, ls_pdftab, lt_pdftab.

  SELECT * FROM zdop_t_ssr_mail INTO TABLE gt_mail.

  CALL METHOD go_grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows[] .
  IF lt_rows IS INITIAL.
    MESSAGE 'EN AZ B??R SATIR SE????N' TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.

    LOOP AT lt_rows INTO ls_rows.
      CLEAR : ls_alv,gs_outm.
      READ TABLE gt_outm INTO gs_outm INDEX ls_rows-index.
      MOVE-CORRESPONDING gs_outm TO ls_alv.
      APPEND ls_alv TO lt_alv.
    ENDLOOP.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = lf_formname
      IMPORTING
        fm_name            = lf_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    IF sy-subrc <> 0.
      MESSAGE 'BA??ARISIZ' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.

    CLEAR: ls_otf_data, lt_otf_data, t_otfdata, ls_control.

    ls_control-no_dialog = 'X'.
    ls_control-getotf    = 'X'.
    ls_control-langu     = 'T'.
    ls_output-tdprinter  = 'I9SWIN'.
    ls_output-tdnoprev   = 'X'.


    CALL FUNCTION lf_fm_name
      EXPORTING
        control_parameters = ls_control
        output_options     = ls_output
        user_settings      = ' '
        gs_ssr             = gs_outm
      IMPORTING
        job_output_info    = t_otfdata
        job_output_options = job_output_options
      TABLES
        gt_ssr             = lt_alv
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    IF sy-subrc <> 0.
      MESSAGE 'BA??ARISIZ' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.

    lt_otf_data = t_otfdata-otfdata.

    CALL FUNCTION 'CONVERT_OTF'
     EXPORTING
       format                = 'PDF'
       max_linewidth         = 132
     IMPORTING
       bin_filesize          = binfilesize
       bin_file              = ls_xstring
     TABLES
       otf                   = lt_otf_data
       lines                 = lt_pdftab
     EXCEPTIONS
       err_max_linewidth     = 1
       err_format            = 2
       err_conv_not_possible = 3
       err_bad_otf           = 4
       OTHERS                = 5.

    IF sy-subrc <> 0.
      MESSAGE 'BA??ARISIZ' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = ls_xstring
      TABLES
        binary_tab = lt_binarytab[].

*    Email BODY
    APPEND gc_head TO gt_text.
    APPEND gc_text TO gt_text.
    APPEND gc_footer TO gt_text.

    gr_document = cl_document_bcs=>create_document(
                    i_type    = 'RAW'
                    i_text    = gt_text
                    i_length  = '12'
                    i_subject = 'PDF MAIL' ).


    LOOP AT gt_mail INTO gs_mail.
      gv_mail = gs_mail-mail.
      CHECK gv_mail IS NOT INITIAL.
      gr_send_request = cl_bcs=>create_persistent( ).
*    Email FROM...
      gr_sender_mail = cl_cam_address_bcs=>create_internet_address(
  'dogukan.padel@prodea.com.tr' ).
*    Add sender to send request
      gr_send_request->set_sender( gr_sender_mail ).
*    Email TO...
      gr_recipient = cl_cam_address_bcs=>create_internet_address(
  gv_mail ).
*    Add recipient to send request
      gr_send_request->add_recipient(
        EXPORTING
          i_recipient = gr_recipient
          i_express   = abap_true ).

*    Attachment
      gr_document->add_attachment(
        EXPORTING
          i_attachment_type    = 'PDF'
          i_attachment_subject = 'Document in PDF'
          i_att_content_hex    = lt_binarytab ).

*    Add document to send request
      gr_send_request->set_document( gr_document ).

*    Send email and get the result
      gv_sent_to_all = gr_send_request->send( i_with_error_screen =
  abap_true ).

      COMMIT WORK AND WAIT.
      IF gv_sent_to_all = abap_true.
        WRITE 'Email sent!'.
        MESSAGE 'E-mail Ba??ar??yla G??nderildi' TYPE 'S'.
      ELSE.
        MESSAGE 'E-mail G??nderilemedi!' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXCEL_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM excel_mail .
  DATA: lt_objtxt TYPE STANDARD TABLE OF solisti1,
        ls_objtxt TYPE solisti1 .
  DATA: lv_excel  TYPE string,
        lv_string TYPE string.
  DATA: lt_binary_content  TYPE solix_tab.
  CLEAR lv_excel.
  CLEAR ls_objtxt.

  DATA : gs_mail LIKE zdop_t_ssr_mail,
         gt_mail LIKE TABLE OF gs_mail.

  SELECT * FROM zdop_t_ssr_mail INTO TABLE gt_mail.

  ls_objtxt  = 'Merhabalar,'.
  APPEND ls_objtxt TO lt_objtxt.
  CLEAR  ls_objtxt.
  ls_objtxt  = 'Bu mail maile ek olarak excel ekleme denemesidir'.
  APPEND ls_objtxt TO lt_objtxt.
  CLEAR  ls_objtxt.
  ls_objtxt  = '??yi ??al????malar dilerim. Do??ukan Padel.'.
  APPEND ls_objtxt TO lt_objtxt.
  CLEAR  ls_objtxt.

  CONCATENATE 'Sat???? Belgesi' 'Kalem' 'Yaratma Tarihi' 'Saat'
              'Yarat??ld??' 'Tam Ad??' 'Belge Tarihi' 'Sts. Blg. Tipi'
              'Sts. Blg. Tipi Tan??m??' 'Sts. Blg. T??r??'
              'St??.Blg.T??r?? Tan??m??' 'Net De??er' 'Belge Para Birimi'
              'Sat???? Org.' 'Sat???? Org. Tan??m??'
              'Da????t??m Kanal??' 'Da????t??m Kanal?? Tan??m' 'B??l??m'
              'B??l??m Tan??m??' 'Malzeme No'  'Malzeme Ad??'
             INTO lv_excel SEPARATED BY cl_bcs_convert=>gc_tab.
  CONCATENATE lv_excel cl_bcs_convert=>gc_crlf INTO lv_excel.

  LOOP AT gt_outm INTO gs_outm.

    DATA : lv_netwr TYPE char20.
    lv_netwr = gs_outm-netwr.

    CONCATENATE
    gs_outm-vbeln gs_outm-posnr gs_outm-erdat gs_outm-erzet
    gs_outm-ernam gs_outm-name_text gs_outm-audat gs_outm-vbtyp
    gs_outm-sbtit gs_outm-auart gs_outm-sbtut lv_netwr
    gs_outm-waerk gs_outm-vkorg  gs_outm-saort gs_outm-vtweg
    gs_outm-dakta gs_outm-spart gs_outm-bolta
    gs_outm-matnr gs_outm-maktx
                INTO lv_string SEPARATED BY
                cl_bcs_convert=>gc_tab.
    CONCATENATE lv_string cl_bcs_convert=>gc_crlf INTO lv_string.
    CONCATENATE lv_excel lv_string INTO lv_excel.
    CLEAR:  lv_string.

  ENDLOOP.

  LOOP AT gt_mail INTO gs_mail.
    gv_mail = gs_mail-mail.
    CHECK gv_mail IS NOT INITIAL.

    gr_send_request = cl_bcs=>create_persistent( ).
*    Email FROM...
    gr_sender_mail = cl_cam_address_bcs=>create_internet_address(
'dogukan.padel@prodea.com.tr' ).
*    Add sender to send request
    gr_send_request->set_sender( gr_sender_mail ).
*    Email TO...
    gr_recipient = cl_cam_address_bcs=>create_internet_address(
gv_mail ).
*    Add recipient to send request
    gr_send_request->add_recipient(
      EXPORTING
        i_recipient = gr_recipient
        i_express   = abap_true ).

    gr_document = cl_document_bcs=>create_document(
                  i_type    = 'HTM'
                  i_text    =  lt_objtxt
                  i_subject = 'EXCEL MAIL' ).
    "Add lr_document to send request
    CALL METHOD gr_send_request->set_document( gr_document ).
    CALL METHOD cl_bcs_convert=>string_to_solix
               EXPORTING
                 iv_string   = lv_excel
                 iv_codepage = '4103'
                 iv_add_bom  = 'X'
               IMPORTING
                 et_solix    = lt_binary_content.

    CALL METHOD gr_document->add_attachment
      EXPORTING
        i_attachment_type     = 'XLS'
        i_attachment_subject  = 'Mail Attachment'
       " i_attachment_language = sy-langu
        i_att_content_hex     = lt_binary_content.
    " This code add pdf attachment at request
    CALL METHOD gr_send_request->set_document( gr_document ).


    CALL METHOD gr_send_request->send(
      EXPORTING
        i_with_error_screen = 'X'
      RECEIVING
        result              = gv_sent_to_all ).
    "Commit to send email
    COMMIT WORK AND WAIT.
    IF gv_sent_to_all = 'X'.
      MESSAGE 'Email g??nderildi!' TYPE 'S'.
    ELSE.
      MESSAGE 'Email g??nderilemedi!!!' TYPE 'E'.
    ENDIF.

  ENDLOOP.

ENDFORM.
