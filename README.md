# SQL_Portfolio - MySQL
## Summary: Nashville Housing Database Data Cleaning
#### 1. Database Setup
- Created the 'nashville housing' database
- Described to the structure of the 'housing' table
#### 2. Standardize Date Format
- Modified the 'SaleDate' column to the Date data type for consistency.
#### 3. Populating Missing Data in PropertyAddress Column
- Checked and identified rows with null 'PropertyAddress'
- Found and replaced null 'PropertyAddress' values by matching 'ParcelID' values
- Updated the 'housing' table with populated 'PropertyAddress' values
#### 4. Separate PropertyAddress into City and House Address
- Split 'PropertyAddress' into 'HouseAddress' and 'City'.
- Added new columns for 'HouseAddress' and 'City', updating them based on the split values.
