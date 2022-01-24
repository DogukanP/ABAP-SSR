*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDOP_MV_EMPDET2.................................*
TABLES: ZDOP_MV_EMPDET2, *ZDOP_MV_EMPDET2. "view work areas
CONTROLS: TCTRL_ZDOP_MV_EMPDET2
TYPE TABLEVIEW USING SCREEN '0002'.
DATA: BEGIN OF STATUS_ZDOP_MV_EMPDET2. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZDOP_MV_EMPDET2.
* Table for entries selected to show on screen
DATA: BEGIN OF ZDOP_MV_EMPDET2_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZDOP_MV_EMPDET2.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZDOP_MV_EMPDET2_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZDOP_MV_EMPDET2_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZDOP_MV_EMPDET2.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZDOP_MV_EMPDET2_TOTAL.

*.........table declarations:.................................*
TABLES: ZDOP_EMPDETAIL2                .
