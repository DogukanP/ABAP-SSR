*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDOP_MV_EMPLOYEE................................*
TABLES: ZDOP_MV_EMPLOYEE, *ZDOP_MV_EMPLOYEE. "view work areas
CONTROLS: TCTRL_ZDOP_MV_EMPLOYEE
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZDOP_MV_EMPLOYEE. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZDOP_MV_EMPLOYEE.
* Table for entries selected to show on screen
DATA: BEGIN OF ZDOP_MV_EMPLOYEE_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZDOP_MV_EMPLOYEE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZDOP_MV_EMPLOYEE_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZDOP_MV_EMPLOYEE_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZDOP_MV_EMPLOYEE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZDOP_MV_EMPLOYEE_TOTAL.

*.........table declarations:.................................*
TABLES: ZDOP_EMPLOYEE                  .
