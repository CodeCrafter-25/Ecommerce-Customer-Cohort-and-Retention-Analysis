# Data Quality Checklist

**Dataset:** Online Retail II  
**Review Status:** In Progress  
**Source File:** `online_retail_II.xlsx`


## File Structure
- [x] Confirm that the Excel file opens correctly
- [x] Record the workbook sheet names
- [x] Count rows in each sheet
- [x] Calculate the total number of rows
- [x] Confirm that all required columns are present
- [x] Confirm the minimum and maximum transaction dates


## Required Columns
- [x] `Invoice`
- [x] `StockCode`
- [x] `Description`
- [x] `Quantity`
- [x] `InvoiceDate`
- [x] `Price`
- [x] `Customer ID`
- [x] `Country`


## Data Quality Checks

- [ ] Count cancelled invoices starting with `C`
- [ ] Count records with zero or negative `Quantity`
- [ ] Count records with zero or negative `Price`
- [ ] Check for duplicate rows
- [ ] Check for missing or invalid transaction dates
- [ ] Count unique customers
- [ ] Count unique invoices
- [ ] Review the list of countries
- [x] Count missing `Customer ID` values
- [x] Count missing product descriptions


## Review Results

|              Metric          |   Result         |
|------------------------------|------------------|
| Total rows                   | 1 067 371        |
| Unique customers             | Pending          |
| Unique invoices              | Pending          |
| Missing Customer ID          | 243 007          |
| Missing product descriptions | 4 382            |
| Cancelled transactions       | Pending          |
| Zero or negative quantity    | Pending          |
| Zero or negative price       | Pending          |
| Duplicate rows               | Pending          |
| Minimum transaction date     | 01.12.2009 07:45 |
| Maximum transaction date     | 09.12.2011 12:50 |


## Workbook Sheets

|       Sheet      |         Rows           |     Minimum Date    |    Maximum Date     |
|------------------|------------------------|---------------------|---------------------|
| `Year 2009-2010` | 525461                 | 01.12.2009 07:45    | 09.12.2010 20:01    |
| `Year 2010-2011` | 541910                 | 01.12.2010 08:46    | 09.12.2011 12:50    |
| **Total**        | **1 067 371**          | **01.12.2009 07:45**| **09.12.2011 12:50**|


## Planned Cleaning Rules

**The cleaned dataset should:**

- exclude records without `Customer ID`;
- exclude cancelled invoices;
- exclude zero or negative quantities;
- exclude zero or negative prices;
- remove duplicate rows;
- preserve valid transaction dates;
- calculate revenue as `Quantity × Price`.

The final cleaning rules will be confirmed after the initial data review.
