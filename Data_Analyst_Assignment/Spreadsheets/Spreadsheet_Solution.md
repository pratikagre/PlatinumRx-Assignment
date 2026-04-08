# Spreadsheet Solutions

Based on the prompt, you've been asked to:
1. Populate `ticket_created_at` in the `feedbacks` table.
2. Count tickets created and closed on:
   a. the **same day**
   b. the **same hour of the same day**

## Data Setup Instructions

1. Create a workbook `Ticket_Analysis.xlsx`.
2. Create two worksheets: **ticket** and **feedbacks**.
3. Insert the sample data provided into both tables starting from Cell `A1`.

## Question 1: Populate ticket_created_at

In the `feedbacks` sheet, the target `ticket_created_at` column needs data from the `ticket` sheet based on matching `cms_id`.

**Formula (in `feedbacks` sheet, Cell D2):**
```excel
=VLOOKUP(A2, ticket!E:B, 2, FALSE)
```
*(Note: Because `cms_id` is the 5th column in `ticket` but we need column B, `INDEX-MATCH` or `XLOOKUP` is actually safer and much better than structural VLOOKUP hacking.)*

**Better Approach with INDEX/MATCH (Cell D2):**
```excel
=INDEX(ticket!B:B, MATCH(A2, ticket!E:E, 0))
```
**Explanation:** 
`MATCH` finds the row in `ticket` where `cms_id` is located. `INDEX` returns the corresponding `created_at` value from column B in that same row. Drag this formula down the column.

---

## Question 2: Time Analysis

Within the `ticket` sheet, we must evaluate count of created & closed on the same day and same hour.

**Step 1: Determine Same Day (Create Helper Column F: "Same Day?")**

Assuming `created_at` is column B and `closed_at` is column C.

**Formula (Cell F2):**
```excel
=IF(INT(B2)=INT(C2), TRUE, FALSE)
```
**Explanation:** `INT()` strips the time portion of an excel timestamp leaving just the Date format. We compare if the creation date equals closure date.

**Step 2: Determine Same Hour (Create Helper Column G: "Same Hour?")**

**Formula (Cell G2):**
```excel
=IF(AND(F2=TRUE, HOUR(B2)=HOUR(C2)), TRUE, FALSE)
```
**Explanation:** We ensure they are on the "Same Day" first using column F, then `HOUR()` parses out the hours (e.g. 16 vs 16). If they match, it's evaluated to TRUE.

**Step 3: Finding Outlet-Wise Counts**

You can build a pivot table to aggregate these values correctly:

1. Insert > PivotTable. Range represents `A1:G100` (or whatever span you populated).
2. Drag `outlet_id` to the **Rows**.
3. Drag "Same Day?" to the **Filters** section -> specify `TRUE`.
4. Drag `ticket_id` into **Values** (Ensure it counts, not sums). This answers **2a**.
5. Change the Filter "Same Day?" to "Same Hour?" -> specify `TRUE`. This answers **2b**.

Alternatively with a formula (`COUNTIFS`):
If you have a list of unique `outlet_id` in column J (starting J2):

For Same Day Count (K2):
```excel
=COUNTIFS(D:D, J2, F:F, TRUE)
```
For Same Hour Count (L2):
```excel
=COUNTIFS(D:D, J2, G:G, TRUE)
```
