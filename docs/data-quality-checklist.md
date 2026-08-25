# Data Quality Checklist

**Dataset:** Online Retail II  
**Review Status:** Planned  
**Source File:** `online_retail_II.xlsx`

## File Structure

- [ ] Confirm that the Excel file opens correctly
- [ ] Record the workbook sheet names
- [ ] Count rows in each sheet
- [ ] Calculate the total number of rows
- [ ] Confirm that all required columns are present
- [ ] Confirm the minimum and maximum transaction dates

## Required Columns

- [ ] `InvoiceNo`
- [ ] `StockCode`
- [ ] `Description`
- [ ] `Quantity`
- [ ] `InvoiceDate`
- [ ] `UnitPrice`
- [ ] `CustomerID`
- [ ] `Country`

## Data Quality Checks

- [ ] Count missing `CustomerID` values
- [ ] Count missing product descriptions
- [ ] Count cancelled invoices starting with `C`
- [ ] Count records with zero or negative `Quantity`
- [ ] Count records with zero or negative `UnitPrice`
- [ ] Check for duplicate rows
- [ ] Check for missing or invalid transaction dates
- [ ] Count unique customers
- [ ] Count unique invoices
- [ ] Review the list of countries

## Review Results

| Metric | Result |
|---|---:|
| Total rows | Pending |
| Unique customers | Pending |
| Unique invoices | Pending |
| Missing CustomerID | Pending |
| Cancelled transactions | Pending |
| Zero or negative quantity | Pending |
| Zero or negative unit price | Pending |
| Duplicate rows | Pending |
| Minimum transaction date | Pending |
| Maximum transaction date | Pending |

## Planned Cleaning Rules

The cleaned dataset should:

- exclude records without `CustomerID`;
- exclude cancelled invoices;
- exclude zero or negative quantities;
- exclude zero or negative prices;
- remove duplicate rows;
- preserve valid transaction dates;
- calculate revenue as `Quantity × UnitPrice`.

The final cleaning rules will be confirmed after the initial data review.
