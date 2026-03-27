# RPT3000 – Year-To-Date Sales Report

**Course:** COBOL Programming – Chapter 4 Assignment
**Authors:** [Gabe Dilley](https://github.com/gawdilley) | [Garrett Finke](https://github.com/gafink01)
**Date:** March 17, 2026
**GitHub:** [COBOL-Chapter-4-Assignment](https://github.com/gawdilley/COBOL-Chapter-4-Assignment)

---

## Description

RPT3000 is a COBOL batch reporting program that reads a sequential customer master file (`CUSTMAST`) and produces a formatted Year-To-Date (YTD) Sales Report (`RPT3001`). The report is designed for a multi-branch sales organization and provides a clear picture of how each customer — and each branch as a whole — is performing compared to the previous year.

---

## What the Program Does

### Input
The program reads fixed-length customer master records, each containing:
- Branch number
- Sales rep number
- Customer number
- Customer name
- Sales amount for the current year-to-date
- Sales amount for the prior year-to-date

### Processing
The program performs the following steps:

1. **Opens** the input customer master file and the output report file.
2. **Reads** each customer record sequentially until end-of-file.
3. **Detects branch breaks** — when the branch number changes between records, it triggers a branch total line before resetting the branch accumulators and continuing.
4. **Calculates** for each customer:
   - **Change Amount** — the difference between this year's and last year's YTD sales.
   - **Change Percent** — the percentage change relative to last year's sales. If last year's sales are zero, the percentage is capped at `999.9%` to prevent a divide-by-zero error.
5. **Accumulates** running totals at two levels:
   - **Branch totals** — reset when the branch number changes.
   - **Grand totals** — accumulated across all records throughout the entire run.
6. **Manages pagination** — when a page fills up (55 lines), a new page is started automatically with fresh heading lines.
7. **Prints** heading lines, customer detail lines, branch total lines, and a grand total line.

### Output
The printed report (`RPT3001`) includes:

- **Report headings** on each page with the current date, time, report title, report ID, and page number.
- **Column headers** describing Branch #, Customer #, Customer Name, Sales This YTD, Sales Last YTD, Change Amount, and Change Percent.
- **One detail line per customer** showing all of the above fields.
- **Branch total lines** after the last customer in each branch, showing summed YTD figures and the overall branch change amount and percentage.
- **A grand total line** at the end of the report showing totals across all branches.

---

## New Concepts Used

- **Control break processing** — detecting a change in branch number mid-file to trigger subtotal printing and accumulator resets before processing continues
- **Multi-level totals** — maintaining separate branch-level and grand-total accumulators simultaneously throughout the file read
- **Divide-by-zero protection** — using an `IF` condition to check for a zero denominator before computing the change percentage, substituting a sentinel value (`999.9`) when needed
- **Automatic pagination** — tracking lines printed per page with `LINE-COUNT` and `LINES-ON-PAGE`, and triggering a heading routine when the threshold is reached
- **`FUNCTION CURRENT-DATE`** — using the built-in COBOL intrinsic function to retrieve and display the system date and time in the report heading
- **Signed numeric fields (`S`)** — using `S9` PIC clauses and negative-sign edit characters (`-`) in output fields to properly handle and display negative sales change values
- **`ROUNDED` option on `COMPUTE`** — applying rounding to the percentage calculation to improve accuracy of displayed results
- **Report-style output formatting** — constructing multiple distinct heading lines, detail lines, and total lines using `FILLER`, fixed-width `PIC` clauses, and edit characters like `ZZ,ZZ9.99-`

---

## Authors

| Name | Profile |
|------|---------|
| Gabe Dilley | [GitHub](https://github.com/gawdilley) |
| Garrett Finke | [GitHub](https://github.com/gafink01) |
