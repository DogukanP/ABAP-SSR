*&---------------------------------------------------------------------*
*& Report  RSUSR006                                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Display locked users and users with failed logon.                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*
*&---------------------------------------------------------------------*
*  04.07.2005 D040499 ( note 858641 )                            4.6B+
*  Change LINE-SIZE from 90 to 255 to aviod line-break after 90
*  characters in batch processing (not relevant for online process)
*
*  11.12.2006 R000731 (Note 1007027)                             7.00+
*  - bugfix on options for select via report RSUSR200 corrected
*&---------------------------------------------------------------------*

REPORT  zdop_rsusr006 LINE-SIZE 255 NO STANDARD PAGE HEADING. "note (858641)

* Definition of the parameters for printing and archiving
DATA: pri_params LIKE pri_params,
      arc_params LIKE arc_params,
      valid      TYPE c,
      gf_rsusr006.

IF sy-batch EQ 'X'.
  CALL FUNCTION 'GET_PRINT_PARAMETERS'
    EXPORTING
      no_dialog              = 'X'
      mode                   = 'CURRENT'
      report                 = 'RSUSR200'
    IMPORTING
      out_parameters         = pri_params
      out_archive_parameters = arc_params
      valid                  = valid.
  SUBMIT rsusr200 WITH notvalid EQ space
                  WITH succlog  EQ space
                  TO SAP-SPOOL SPOOL PARAMETERS pri_params
                  ARCHIVE PARAMETERS arc_params
                  WITHOUT SPOOL DYNPRO.
ELSE.
  gf_rsusr006 = 'X'.
  EXPORT gf_rsusr006 TO MEMORY ID 'FLAG'.
  SUBMIT rsusr200 WITH notvalid EQ space
                  WITH succlog  EQ space
                  and return.
ENDIF.


write :/ 'DOĞUKAN PADEL INSERT 07.01.2022'.
