# Dataset

## Source

- **Dataset:** Online Retail II
- **Provider:** UCI Machine Learning Repository
- **Creator:** Daqing Chen
- **Source:** https://archive.ics.uci.edu/dataset/502/online+retail+ii
- **License:** Creative Commons Attribution 4.0 International (CC BY 4.0)
- **Original file:** `online_retail_II.xlsx`
- **File size:** 43.5 MB
- **Number of records:** 1,067,371
- **Period:** December 1, 2009 – December 9, 2011

## Description
Online Retail II contains real transaction data from a UK-based non-store online retailer. The dataset covers two years of customer purchases and is suitable for customer cohort, retention, repeat purchase, and revenue analysis.

## Main Columns

|     Column    |                                 Description                              |
|---------------|--------------------------------------------------------------------------|
| `Invoice`     | Unique invoice number. Values starting with `C` represent cancellations. |
| `StockCode`   | Unique product code.                                                     |
| `Description` | Product name.                                                            |
| `Quantity`    | Number of purchased product units.                                       |
| `InvoiceDate` | Date and time of the transaction.                                        |
| `Price`       | Product price per unit in pounds sterling.                               |
| `Customer ID` | Unique customer identifier.                                              |
| `Country`     | Customer’s country of residence.                                         |


## Planned Use

**The dataset will be used to:**
- identify each customer’s first purchase month;
- create monthly customer cohorts;
- calculate cohort size;
- calculate monthly retention rates;
- measure repeat purchase behavior;
- analyze revenue by cohort;
- calculate the time between the first and second purchase.

## Data Quality Notes
**The initial data review should include:**
- missing `Customer ID` values;
- cancelled transactions;
- zero or negative quantities;
- zero or negative prices;
- duplicate records;
- invalid transaction dates.

**Revenue will be calculated as:** *`Revenue = Quantity × Price`*

## Prepared Files
**The original Excel workbook was divided into two CSV files for loading into BigQuery:**
- `online_retail_2009_2010.csv`
- `online_retail_2010_2011.csv`

The files preserve the original workbook structure and column names. They will be combined in BigQuery before completing the remaining data quality checks.


## Repository Storage

The original Excel file is not stored in this repository because of its size. It can be downloaded from the official UCI Machine Learning Repository using the source link above.
