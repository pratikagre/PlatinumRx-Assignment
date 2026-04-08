# PlatinumRx Data Analyst Assignment

This repository contains the solutions for the PlatinumRx Data Analyst Assignment. It is divided into three main components: SQL databases, Spreadsheets analysis, and Python scripting.

## 1. Project Structure

```
Data_Analyst_Assignment/
│
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql    # Schema & initial data for Hotel System
│   ├── 02_Hotel_Queries.sql         # 5 SQL queries for analyzing Hotel data
│   ├── 03_Clinic_Schema_Setup.sql   # Schema & initial data for Clinic System
│   └── 04_Clinic_Queries.sql        # 5 SQL queries for analyzing Clinic data
│
├── Spreadsheets/
│   └── Spreadsheet_Solution.md      # Discussion and formulas for the spreadsheet task
│
├── Python/
│   ├── 01_Time_Converter.py         # Script to convert minutes to hours and minutes
│   ├── 02_Remove_Duplicates.py      # Script to conditionally remove duplicate characters
│   └── 03_Create_Excel.py           # Optional helper script to auto-generate Excel setup
│
└── README.md                        # Assignment overview and strategy
```

## 2. SQL Solutions Approach

- **Schemas/Tables:** The database structures required for the hotel and clinic systems were successfully mocked along with data insertion mimicking the given examples. 
- **Hotel Queries:** We employed `ROW_NUMBER()`, `RANK()`, `COALESCE`, and aggregated `SUM/GROUP BY` logic to handle queries efficiently. Extracting metrics like the top / bottom items in a given month uses Common Table Expressions (CTEs) combined with ranking functions for clean output.
- **Clinic Queries:** Similarly, monthly aggregations and profits (Revenue vs. Expenses) were calculated. CTEs played a crucial role here to align Revenues and Expenses on a continuous month basis.

## 3. Spreadsheet Analysis

Due to environment restrictions, a fully functioning `.xlsx` cannot be fully pre-packaged without user-provided actions, however you will find detailed formula steps within the markdown file `Spreadsheets/Spreadsheet_Solution.md`. Also included is a Python script (`Python/03_Create_Excel.py`) using `openpyxl` which automates populating the sample arrays and formulas for you!

**Basic logic implemented:**
- VLOOKUP is used with `cms_id` joining the feedback and ticket sheet. The array mapping utilizes accurate indexing.
- For same day/hour logic, we compare parsed values. Extracting the `INT` handles the date evaluation. Comparing the `HOUR(TIMEVALUE())` checks matching occurrence events effectively. 

## 4. Python Tasks

1. **Time Conversion (`01_Time_Converter.py`):** Uses mathematical operators like modulo (`%`) and integer division (`//`) to calculate the hours and leftover minutes correctly. Also contains logic to string-format singular vs. plural times beautifully.
2. **Remove Duplicates (`02_Remove_Duplicates.py`):** Evaluates occurrences sequentially via loops without modifying positional order of the original string input.

## 5. Execution

- Navigate to the `SQL` folder to pull scripts into an editor like MySQL Workbench. Executable against any Postgres/MySQL DB with minor standardizations.
- Run Python scripts simply by: `python Python/01_Time_Converter.py`.
