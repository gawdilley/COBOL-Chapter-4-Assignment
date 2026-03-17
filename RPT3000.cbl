       IDENTIFICATION DIVISION.

       PROGRAM-ID. RPT3000.

      *  Programmer.: Gabe Dilley and Garrett Finke
      *  Date.......: 2026.03.17
      *  GitHub URL.: https://github.com/gawdilley/COBOL-Chapter-4-Assignment
      *  Description: This program reads customer master records and
      *  produces a Year-To-Date Sales Report. It prints customer
      *  sales for the current and previous year, calculates the
      *  change amount and percentage, and displays grand totals
      *  for all qualifying customers.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           SELECT INPUT-CUSTMAST ASSIGN TO CUSTMAST.
           SELECT OUTPUT-RPT3000 ASSIGN TO RPT3000.

       DATA DIVISION.

       FILE SECTION.

       FD  INPUT-CUSTMAST
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 130 CHARACTERS
           BLOCK CONTAINS 130 CHARACTERS.
       01  CUSTOMER-MASTER-RECORD.
           05  CM-BRANCH-NUMBER        PIC 9(2).
           05  CM-SALESREP-NUMBER      PIC 9(2).
           05  CM-CUSTOMER-NUMBER      PIC 9(5).
           05  CM-CUSTOMER-NAME        PIC X(20).
           05  CM-SALES-THIS-YTD       PIC S9(5)V9(2).
           05  CM-SALES-LAST-YTD       PIC S9(5)V9(2).
           05  FILLER                  PIC X(87).

       FD  OUTPUT-RPT3000
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 130 CHARACTERS
           BLOCK CONTAINS 130 CHARACTERS.
       01  PRINT-AREA      PIC X(130).

       WORKING-STORAGE SECTION.

       01  SWITCHES.
           05  CUSTMAST-EOF-SWITCH     PIC X    VALUE "N".

       *>Adding this from Powerpoint
       01  CALCULATED-FIELDS.
           05 CHANGE-AMOUNT        PIC s9(5)V99.

       01  PRINT-FIELDS.
           05  PAGE-COUNT      PIC S9(3)   VALUE ZERO.
           05  LINES-ON-PAGE   PIC S9(3)   VALUE +55.
           05  LINE-COUNT      PIC S9(3)   VALUE +99.
           05  SPACE-CONTROL   PIC S9.

       01  TOTAL-FIELDS.
           05  GRAND-TOTAL-THIS-YTD   PIC S9(7)V99   VALUE ZERO.
           05  GRAND-TOTAL-LAST-YTD   PIC S9(7)V99   VALUE ZERO.

       01  CURRENT-DATE-AND-TIME.
           05  CD-YEAR         PIC 9999.
           05  CD-MONTH        PIC 99.
           05  CD-DAY          PIC 99.
           05  CD-HOURS        PIC 99.
           05  CD-MINUTES      PIC 99.
           05  FILLER          PIC X(9).

       01  HEADING-LINE-1.
           05  FILLER          PIC X(7)    VALUE "DATE:  ".
           05  HL1-MONTH       PIC 9(2).
           05  FILLER          PIC X(1)    VALUE "/".
           05  HL1-DAY         PIC 9(2).
           05  FILLER          PIC X(1)    VALUE "/".
           05  HL1-YEAR        PIC 9(4).
           05  FILLER          PIC X(11)   VALUE SPACE.
           05  FILLER          PIC X(20)   VALUE "YEAR-TO-DATE SALES R".
           05  FILLER          PIC X(20)   VALUE "EPORT               ".
           05  FILLER          PIC X(18)    VALUE "            PAGE: ".
           05  Hl1-PAGE-NUMBER PIC ZZZ9.
           05  FILLER          PIC X(39)   VALUE SPACE.

       01  HEADING-LINE-2.
           05  FILLER          PIC X(7)    VALUE "TIME:  ".
           05  HL2-HOURS       PIC 9(2).
           05  FILLER          PIC X(1)    VALUE ":".
           05  HL2-MINUTES     PIC 9(2).
           05  FILLER          PIC X(68)   VALUE SPACE.
           05  FILLER          PIC X(10)   VALUE "RPT3001".
           05  FILLER          PIC X(39)   VALUE SPACE.

       01  HEADING-LINE-3.
           05  FILLER      PIC X(20)   VALUE "BRANCH SALES CUST   ".
           *>Adding spaces for my brain to work better
           05  FILLER      PIC X(14)    VALUE ALL' '.
           05  FILLER      PIC X(20)   VALUE "            SALES   ".
           05  FILLER      PIC X(19)   VALUE "      SALES        ".
           *>Added this line from Powerpoint
           05  FILLER      PIC X(20)   VALUE "CHANGE     CHANGE   ".
           05  FILLER      PIC X(26)   VALUE SPACE.

       01  HEADING-LINE-4.
           05  FILLER      PIC X(13)   VALUE " NUM    REP ".
           05  FILLER      PIC X(20)   VALUE "NUM    CUSTOMER NAME".
           05  FILLER      PIC X(20)   VALUE "           THIS YTD ".
           05  FILLER      PIC X(20)   VALUE "     LAST YTD       ".
           *>Added this line from Powerpoint
           05  FILLER      PIC X(20)   VALUE "AMOUNT    PERCENT   ".
           05  FILLER      PIC X(39)   VALUE SPACE.

           *>Copied Heading-Line-4 and changed it to dashes
       01  HEADING-LINE-5.
           05  FILLER      PIC X(6)   VALUE ALL'-'.
           05  FILLER      PIC X(1)   VALUE SPACE.
           05  FILLER      PIC X(5)   VALUE ALL'-'.
           05  FILLER      PIC X(1)   VALUE SPACE.
           05  FILLER      PIC X(5)   VALUE ALL'-'.
           05  FILLER      PIC X(2)   VALUE SPACE.
           05  FILLER      PIC X(20)   VALUE ALL'-'.
           05  FILLER      PIC X(3)   VALUE SPACE.
           05  FILLER      PIC X(10)   VALUE ALL'-'.
           05  FILLER      PIC X(4)   VALUE SPACE.
           05  FILLER      PIC X(10)   VALUE ALL'-'.
           05  FILLER      PIC X(4)   VALUE SPACE.
           05  FILLER      PIC X(10)   VALUE ALL'-'.
           05  FILLER      PIC X(3)   VALUE SPACE.
           05  FILLER      PIC X(6)   VALUE ALL'-'.
           05  FILLER      PIC X(39)   VALUE SPACE.

       01  CUSTOMER-LINE.
       05  FILLER              PIC X(2)  VALUE SPACE.
           *>Add two columns
           05  CL-BRANCH-NUMBER    PIC 99.
           05  FILLER              PIC X(4)  VALUE SPACE.
           05  CL-SALESREP-NUMBER  PIC 99.
           05  FILLER              PIC X(3)  VALUE SPACE.
           05  CL-CUSTOMER-NUMBER  PIC 9(5).
           05  FILLER              PIC X(2)     VALUE SPACE.
           05  CL-CUSTOMER-NAME    PIC X(20).
           05  FILLER              PIC X(3)     VALUE SPACE.
           05  CL-SALES-THIS-YTD   PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)     VALUE SPACE.
           05  CL-SALES-LAST-YTD   PIC ZZ,ZZ9.99-.
           *>Added these four lines from Powerpoint
           *>Start of addition
           05  FILLER              PIC X(4)     VALUE SPACE.
           05  CL-CHANGE-AMOUNT    PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(3)     VALUE SPACE.
           05  CL-CHANGE-PERCENT   PIC ZZ9.9-.
           *>End of addition
           05  FILLER              PIC X(41)    VALUE SPACE.

       01  DASHED-TOTAL-LINE.
           05  FILLER              PIC X(40)    VALUE SPACE.
           05  FILLER              PIC X(13)     VALUE ALL'='.
           05  FILLER              PIC X(1)     VALUE SPACE.
           05  FILLER              PIC X(13)     VALUE ALL'='.
           05  FILLER              PIC X(1)     VALUE SPACE.
           05  FILLER              PIC X(13)     VALUE ALL'='.
           05  FILLER              PIC X(3)     VALUE SPACE.
           05  FILLER              PIC X(5)     VALUE ALL'='.
           05  FILLER              PIC X(55)    VALUE SPACE.

       01  GRAND-TOTAL-LINE.
           05  FILLER              PIC X(40)    VALUE SPACE.
           05  GTL-SALES-THIS-YTD  PIC Z,ZZZ,ZZ9.99-.
           05  FILLER              PIC X(1)     VALUE SPACE.
           05  GTL-SALES-LAST-YTD  PIC Z,ZZZ,ZZ9.99-.
           *>Added these four lines from Powerpoint
           *>Start of addition
           05  FILLER              PIC X(1)     VALUE SPACE.
           05  GTL-CHANGE-AMOUNT   PIC Z,ZZZ,ZZ9.99-.
           05  FILLER              PIC X(3)     VALUE SPACE.
           05  GTL-CHANGE-PERCENT  PIC ZZ9.9-.
           *>End of addition
           05  FILLER              PIC X(42)    VALUE SPACE.



       PROCEDURE DIVISION.

       000-PREPARE-SALES-REPORT.

           OPEN INPUT  INPUT-CUSTMAST
                OUTPUT OUTPUT-RPT3000.
           PERFORM 100-FORMAT-REPORT-HEADING.
           PERFORM 200-PREPARE-SALES-LINES
               UNTIL CUSTMAST-EOF-SWITCH = "Y".
           PERFORM 300-PRINT-GRAND-TOTALS.
           CLOSE INPUT-CUSTMAST
                 OUTPUT-RPT3000.
           STOP RUN.

       100-FORMAT-REPORT-HEADING.

           MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-AND-TIME.
           MOVE CD-MONTH   TO HL1-MONTH.
           MOVE CD-DAY     TO HL1-DAY.
           MOVE CD-YEAR    TO HL1-YEAR.
           MOVE CD-HOURS   TO HL2-HOURS.
           MOVE CD-MINUTES TO HL2-MINUTES.

       200-PREPARE-SALES-LINES.

           PERFORM 210-READ-CUSTOMER-RECORD.
           IF CUSTMAST-EOF-SWITCH = "N"
               *>Added from Powerpoint
               IF CM-SALES-THIS-YTD >= 10000
                   PERFORM 220-PRINT-CUSTOMER-LINE.

       210-READ-CUSTOMER-RECORD.

           READ INPUT-CUSTMAST
               AT END
                   MOVE "Y" TO CUSTMAST-EOF-SWITCH.

       220-PRINT-CUSTOMER-LINE.

           IF LINE-COUNT >= LINES-ON-PAGE
               PERFORM 230-PRINT-HEADING-LINES.
           MOVE CM-BRANCH-NUMBER   TO CL-BRANCH-NUMBER.
           MOVE CM-SALESREP-NUMBER TO CL-SALESREP-NUMBER.
           MOVE CM-CUSTOMER-NUMBER  TO CL-CUSTOMER-NUMBER.
           MOVE CM-CUSTOMER-NAME    TO CL-CUSTOMER-NAME.
           MOVE CM-SALES-THIS-YTD   TO CL-SALES-THIS-YTD.
           MOVE CM-SALES-LAST-YTD   TO CL-SALES-LAST-YTD.
           *>Added 10 lines from Powerpoint
           *>Start of addition
           COMPUTE CHANGE-AMOUNT =
               CM-SALES-THIS-YTD - CM-SALES-LAST-YTD.
           MOVE CHANGE-AMOUNT TO CL-CHANGE-AMOUNT.
           IF CM-SALES-LAST-YTD = ZERO
               MOVE 999.9 TO CL-CHANGE-PERCENT
           ELSE
               COMPUTE CL-CHANGE-PERCENT ROUNDED =
                   CHANGE-AMOUNT * 100 / CM-SALES-LAST-YTD
                   ON SIZE ERROR
                       MOVE 999.9 to CL-CHANGE-PERCENT.
           *>End of addition
           MOVE CUSTOMER-LINE TO PRINT-AREA.
           WRITE PRINT-AREA.
           ADD 1 TO LINE-COUNT.
           ADD CM-SALES-THIS-YTD TO GRAND-TOTAL-THIS-YTD.
           ADD CM-SALES-LAST-YTD TO GRAND-TOTAL-LAST-YTD.
           MOVE 1 TO SPACE-CONTROL.

       230-PRINT-HEADING-LINES.

           ADD 1 TO PAGE-COUNT.
           MOVE PAGE-COUNT     TO HL1-PAGE-NUMBER.
           MOVE HEADING-LINE-1 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-2 TO PRINT-AREA.
           WRITE PRINT-AREA.
           *>Add a blank line by moving spaces into print-area
           MOVE SPACES TO PRINT-AREA.
           WRITE PRINT-AREA.
           *>End blank line
           MOVE HEADING-LINE-3 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE HEADING-LINE-4 TO PRINT-AREA.
           WRITE PRINT-AREA.
           *>Print new heading line
           MOVE HEADING-LINE-5 TO PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE ZERO TO LINE-COUNT.
           MOVE 2 TO SPACE-CONTROL.

       300-PRINT-GRAND-TOTALS.

           MOVE GRAND-TOTAL-THIS-YTD TO GTL-SALES-THIS-YTD.
           MOVE GRAND-TOTAL-LAST-YTD TO GTL-SALES-LAST-YTD.
           *>Add 10 lines from Powerpoint
           *>Start of addition
           COMPUTE CHANGE-AMOUNT =
               GRAND-TOTAL-THIS-YTD - GRAND-TOTAL-LAST-YTD.
           MOVE CHANGE-AMOUNT TO GTL-CHANGE-AMOUNT.
           IF GRAND-TOTAL-LAST-YTD = ZERO
               MOVE 999.9 TO GTL-CHANGE-PERCENT
           ELSE
               COMPUTE GTL-CHANGE-PERCENT ROUNDED =
                   CHANGE-AMOUNT * 100 / GRAND-TOTAL-LAST-YTD
                   ON SIZE ERROR
                       MOVE 999.9 TO GTL-CHANGE-PERCENT.
           *>End of addition
           MOVE DASHED-TOTAL-LINE to PRINT-AREA.
           WRITE PRINT-AREA.
           MOVE GRAND-TOTAL-LINE TO PRINT-AREA.
           WRITE PRINT-AREA.
