       IDENTIFICATION DIVISION.

       PROGRAM-ID. RPT3000.

      *  Programmer.: Gabe Dilley and Garrett Finke
      *  Date.......: 2026.03.17
      *  GitHub URL.: https://github.com/gawdilley/COBOL-Chapter-4-Assignment
      *  Description: This program reads customer master records and
      *  produces a Year-To-Date Sales Report. It prints customer
      *  sales for the current and previous year, calculates the
      *  change amount and percentage, and displays branch totals
      *  and grand totals.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           SELECT INPUT-CUSTMAST ASSIGN TO CUSTMAST.
           SELECT OUTPUT-RPT3000 ASSIGN TO RPT3001.

       DATA DIVISION.

       FILE SECTION.

       FD  INPUT-CUSTMAST.
       01  CUSTOMER-MASTER-RECORD.
           05  CM-BRANCH-NUMBER        PIC 9(2).
           05  CM-SALESREP-NUMBER      PIC 9(2).
           05  CM-CUSTOMER-NUMBER      PIC 9(5).
           05  CM-CUSTOMER-NAME        PIC X(20).
           05  CM-SALES-THIS-YTD       PIC S9(5)V9(2).
           05  CM-SALES-LAST-YTD       PIC S9(5)V9(2).
           05  FILLER                  PIC X(87).

       FD  OUTPUT-RPT3000.
       01  PRINT-AREA                  PIC X(130).

       WORKING-STORAGE SECTION.

       01  SWITCHES.
           05  CUSTMAST-EOF-SWITCH     PIC X VALUE "N".

       01  CONTROL-FIELDS.
           05  HOLD-BRANCH-NUMBER      PIC 99 VALUE ZERO.

       01  CALCULATED-FIELDS.
           05  CHANGE-AMOUNT           PIC S9(7)V99 VALUE ZERO.

       01  PRINT-FIELDS.
           05  PAGE-COUNT              PIC S9(3) VALUE ZERO.
           05  LINES-ON-PAGE           PIC S9(3) VALUE +55.
           05  LINE-COUNT              PIC S9(3) VALUE +99.

       01  TOTAL-FIELDS.
           05  BRANCH-TOTAL-THIS-YTD   PIC S9(7)V99 VALUE ZERO.
           05  BRANCH-TOTAL-LAST-YTD   PIC S9(7)V99 VALUE ZERO.
           05  GRAND-TOTAL-THIS-YTD    PIC S9(7)V99 VALUE ZERO.
           05  GRAND-TOTAL-LAST-YTD    PIC S9(7)V99 VALUE ZERO.

       01  CURRENT-DATE-AND-TIME.
           05  CD-YEAR                 PIC 9999.
           05  CD-MONTH                PIC 99.
           05  CD-DAY                  PIC 99.
           05  CD-HOURS                PIC 99.
           05  CD-MINUTES              PIC 99.
           05  FILLER                  PIC X(9).

       01  HEADING-LINE-1.
           05  FILLER              PIC X(7)    VALUE "DATE:  ".
           05  HL1-MONTH           PIC 9(2).
           05  FILLER              PIC X       VALUE "/".
           05  HL1-DAY             PIC 9(2).
           05  FILLER              PIC X       VALUE "/".
           05  HL1-YEAR            PIC 9(4).
           05  FILLER              PIC X(16)   VALUE SPACES.
           05  FILLER              PIC X(25)
               VALUE "YEAR-TO-DATE SALES REPORT".
           05  FILLER              PIC X(22)   VALUE SPACES.
           05  FILLER              PIC X(6)    VALUE "PAGE: ".
           05  HL1-PAGE-NUMBER     PIC ZZ9.
           05  FILLER              PIC X(44)   VALUE SPACES.

       01  HEADING-LINE-2.
           05  FILLER              PIC X(7)    VALUE "TIME:  ".
           05  HL2-HOURS           PIC 9(2).
           05  FILLER              PIC X       VALUE ":".
           05  HL2-MINUTES         PIC 9(2).
           05  FILLER              PIC X(68)   VALUE SPACES.
           05  FILLER              PIC X(7)    VALUE "RPT3001".
           05  FILLER              PIC X(43)   VALUE SPACES.

       01  HEADING-LINE-3.
           05  FILLER PIC X(9)  VALUE "BRANCH   ".
           05  FILLER PIC X(7)  VALUE "CUST   ".
           05  FILLER PIC X(25) VALUE SPACES.
           05  FILLER PIC X(6)  VALUE "SALES ".
           05  FILLER PIC X(7) VALUE SPACES.
           05  FILLER PIC X(7)  VALUE "SALES ".
           05  FILLER PIC X(8) VALUE SPACES.
           05  FILLER PIC X(7)  VALUE "CHANGE ".
           05  FILLER PIC X(4)  VALUE SPACES.
           05  FILLER PIC X(7)  VALUE "CHANGE ".
           05  FILLER PIC X(46) VALUE SPACES.

       01  HEADING-LINE-4.
           05  FILLER PIC X(9)  VALUE " NUM     ".
           05  FILLER PIC X(7)  VALUE "NUM    ".
           05  FILLER PIC X(20) VALUE "CUSTOMER NAME".
           05  FILLER PIC X(4)  VALUE SPACES.
           05  FILLER PIC X(8)  VALUE "THIS YTD".
           05  FILLER PIC X(5)  VALUE SPACES.
           05  FILLER PIC X(8)  VALUE "LAST YTD".
           05  FILLER PIC X(8)  VALUE SPACES.
           05  FILLER PIC X(8)  VALUE "AMOUNT".
           05  FILLER PIC X(2)  VALUE SPACES.
           05  FILLER PIC X(8)  VALUE "PERCENT".
           05  FILLER PIC X(31) VALUE SPACES.

       01  HEADING-LINE-5.
           05  FILLER              PIC X(6)    VALUE ALL "-".
           05  FILLER              PIC X(3)    VALUE SPACES.
           05  FILLER              PIC X(5)    VALUE ALL "-".
           05  FILLER              PIC X(2)    VALUE SPACES.
           05  FILLER              PIC X(20)   VALUE ALL "-".
           05  FILLER              PIC X(3)    VALUE SPACES.
           05  FILLER              PIC X(10)   VALUE ALL "-".
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  FILLER              PIC X(10)   VALUE ALL "-".
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  FILLER              PIC X(10)   VALUE ALL "-".
           05  FILLER              PIC X(3)    VALUE SPACES.
           05  FILLER              PIC X(6)    VALUE ALL "-".
           05  FILLER              PIC X(44)   VALUE SPACES.

       01  CUSTOMER-LINE.
           05  FILLER              PIC X(2)    VALUE SPACES.
           05  CL-BRANCH-NUMBER    PIC 99.
           05  FILLER              PIC X(5)    VALUE SPACES.
           05  CL-CUSTOMER-NUMBER  PIC 9(5).
           05  FILLER              PIC X(2)    VALUE SPACES.
           05  CL-CUSTOMER-NAME    PIC X(20).
           05  FILLER              PIC X(3)    VALUE SPACES.
           05  CL-SALES-THIS-YTD   PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  CL-SALES-LAST-YTD   PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  CL-CHANGE-AMOUNT    PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(3)    VALUE SPACES.
           05  CL-CHANGE-PERCENT   PIC ZZ9.9-.
           05  FILLER              PIC X(47)   VALUE SPACES.

       01  BRANCH-TOTAL-LINE.
           05  FILLER              PIC X(24)   VALUE SPACES.
           05  FILLER              PIC X(13)   VALUE "BRANCH TOTAL".
           05  FILLER              PIC X(2)    VALUE SPACES.
           05  BTL-SALES-THIS-YTD  PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  BTL-SALES-LAST-YTD  PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  BTL-CHANGE-AMOUNT   PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(3)    VALUE SPACES.
           05  BTL-CHANGE-PERCENT  PIC ZZ9.9-.
           05  FILLER              PIC X(48)   VALUE SPACES.

       01  DASHED-TOTAL-LINE.
           05  FILLER              PIC X(38)   VALUE SPACES.
           05  FILLER              PIC X(10)   VALUE ALL "=".
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  FILLER              PIC X(10)   VALUE ALL "=".
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  FILLER              PIC X(10)   VALUE ALL "=".
           05  FILLER              PIC X(3)    VALUE SPACES.
           05  FILLER              PIC X(6)    VALUE ALL "=".
           05  FILLER              PIC X(45)   VALUE SPACES.

       01  GRAND-TOTAL-LINE.
           05  FILLER              PIC X(24)   VALUE SPACES.
           05  FILLER              PIC X(11)   VALUE "GRAND TOTAL".
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  GTL-SALES-THIS-YTD  PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  GTL-SALES-LAST-YTD  PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(4)    VALUE SPACES.
           05  GTL-CHANGE-AMOUNT   PIC ZZ,ZZ9.99-.
           05  FILLER              PIC X(3)    VALUE SPACES.
           05  GTL-CHANGE-PERCENT  PIC ZZ9.9-.
           05  FILLER              PIC X(48)   VALUE SPACES.

       PROCEDURE DIVISION.

       000-PREPARE-SALES-REPORT.

           OPEN INPUT INPUT-CUSTMAST
                OUTPUT OUTPUT-RPT3000

           PERFORM 100-FORMAT-REPORT-HEADING
           PERFORM 210-READ-CUSTOMER-RECORD

           IF CUSTMAST-EOF-SWITCH = "N"
               MOVE CM-BRANCH-NUMBER TO HOLD-BRANCH-NUMBER
               PERFORM 200-PREPARE-SALES-LINES
                   UNTIL CUSTMAST-EOF-SWITCH = "Y"
               PERFORM 240-PRINT-BRANCH-TOTAL
               PERFORM 300-PRINT-GRAND-TOTALS
           END-IF

           CLOSE INPUT-CUSTMAST OUTPUT-RPT3000
           STOP RUN.

       100-FORMAT-REPORT-HEADING.

           MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-AND-TIME
           MOVE CD-MONTH TO HL1-MONTH
           MOVE CD-DAY TO HL1-DAY
           MOVE CD-YEAR TO HL1-YEAR
           MOVE CD-HOURS TO HL2-HOURS
           MOVE CD-MINUTES TO HL2-MINUTES.

       200-PREPARE-SALES-LINES.

           IF CM-BRANCH-NUMBER NOT = HOLD-BRANCH-NUMBER
               PERFORM 240-PRINT-BRANCH-TOTAL
               MOVE ZERO TO BRANCH-TOTAL-THIS-YTD
                            BRANCH-TOTAL-LAST-YTD
               MOVE CM-BRANCH-NUMBER TO HOLD-BRANCH-NUMBER
           END-IF

           PERFORM 220-PRINT-CUSTOMER-LINE
           PERFORM 210-READ-CUSTOMER-RECORD.

       210-READ-CUSTOMER-RECORD.

           READ INPUT-CUSTMAST
               AT END
                   MOVE "Y" TO CUSTMAST-EOF-SWITCH
           END-READ.

       220-PRINT-CUSTOMER-LINE.

           IF LINE-COUNT >= LINES-ON-PAGE
               PERFORM 230-PRINT-HEADING-LINES
           END-IF

           MOVE CM-BRANCH-NUMBER TO CL-BRANCH-NUMBER
           MOVE CM-CUSTOMER-NUMBER TO CL-CUSTOMER-NUMBER
           MOVE CM-CUSTOMER-NAME TO CL-CUSTOMER-NAME
           MOVE CM-SALES-THIS-YTD TO CL-SALES-THIS-YTD
           MOVE CM-SALES-LAST-YTD TO CL-SALES-LAST-YTD

           COMPUTE CHANGE-AMOUNT =
               CM-SALES-THIS-YTD - CM-SALES-LAST-YTD

           MOVE CHANGE-AMOUNT TO CL-CHANGE-AMOUNT

           IF CM-SALES-LAST-YTD = ZERO
               MOVE 999.9 TO CL-CHANGE-PERCENT
           ELSE
               COMPUTE CL-CHANGE-PERCENT ROUNDED =
                   CHANGE-AMOUNT * 100 / CM-SALES-LAST-YTD
           END-IF

           MOVE CUSTOMER-LINE TO PRINT-AREA
           WRITE PRINT-AREA

           ADD 1 TO LINE-COUNT
           ADD CM-SALES-THIS-YTD TO BRANCH-TOTAL-THIS-YTD
           ADD CM-SALES-LAST-YTD TO BRANCH-TOTAL-LAST-YTD
           ADD CM-SALES-THIS-YTD TO GRAND-TOTAL-THIS-YTD
           ADD CM-SALES-LAST-YTD TO GRAND-TOTAL-LAST-YTD.

       230-PRINT-HEADING-LINES.

           ADD 1 TO PAGE-COUNT
           MOVE PAGE-COUNT TO HL1-PAGE-NUMBER
           MOVE HEADING-LINE-1 TO PRINT-AREA
           WRITE PRINT-AREA
           MOVE HEADING-LINE-2 TO PRINT-AREA
           WRITE PRINT-AREA
           MOVE SPACES TO PRINT-AREA
           WRITE PRINT-AREA
           MOVE HEADING-LINE-3 TO PRINT-AREA
           WRITE PRINT-AREA
           MOVE HEADING-LINE-4 TO PRINT-AREA
           WRITE PRINT-AREA
           MOVE HEADING-LINE-5 TO PRINT-AREA
           WRITE PRINT-AREA
           MOVE ZERO TO LINE-COUNT.

       240-PRINT-BRANCH-TOTAL.

           COMPUTE CHANGE-AMOUNT =
               BRANCH-TOTAL-THIS-YTD - BRANCH-TOTAL-LAST-YTD

           MOVE BRANCH-TOTAL-THIS-YTD TO BTL-SALES-THIS-YTD
           MOVE BRANCH-TOTAL-LAST-YTD TO BTL-SALES-LAST-YTD
           MOVE CHANGE-AMOUNT TO BTL-CHANGE-AMOUNT

           IF BRANCH-TOTAL-LAST-YTD = ZERO
               MOVE 999.9 TO BTL-CHANGE-PERCENT
           ELSE
               COMPUTE BTL-CHANGE-PERCENT ROUNDED =
                   CHANGE-AMOUNT * 100 / BRANCH-TOTAL-LAST-YTD
           END-IF

           MOVE BRANCH-TOTAL-LINE TO PRINT-AREA
           WRITE PRINT-AREA

           MOVE SPACES TO PRINT-AREA
           WRITE PRINT-AREA

           ADD 2 TO LINE-COUNT.

       300-PRINT-GRAND-TOTALS.

           COMPUTE CHANGE-AMOUNT =
               GRAND-TOTAL-THIS-YTD - GRAND-TOTAL-LAST-YTD

           MOVE GRAND-TOTAL-THIS-YTD TO GTL-SALES-THIS-YTD
           MOVE GRAND-TOTAL-LAST-YTD TO GTL-SALES-LAST-YTD
           MOVE CHANGE-AMOUNT TO GTL-CHANGE-AMOUNT

           IF GRAND-TOTAL-LAST-YTD = ZERO
               MOVE 999.9 TO GTL-CHANGE-PERCENT
           ELSE
               COMPUTE GTL-CHANGE-PERCENT ROUNDED =
                   CHANGE-AMOUNT * 100 / GRAND-TOTAL-LAST-YTD
           END-IF

           MOVE GRAND-TOTAL-LINE TO PRINT-AREA
           WRITE PRINT-AREA.
