# SQL_Portfolio - MySQL
# Summary: Nashville Housing Database Data Cleaning
### 1. Database Setup
- Created the 'nashville housing' database
- Described to the structure of the 'housing' table

### 2. Standardize Date Format
- Modified the 'SaleDate' column to the Date data type for consistency

### 3. Populating Missing Data in PropertyAddress Column
- Identified and addressed 17 missing values in the 'PropertyAddress' column by using related 'ParcelID' information

### 4. Separate PropertyAddress into City and House Address
- Introduced 'HouseAddress' and 'City' columns by splitting the 'PropertyAddress' for improved analysis

### 5. Splitting Owner Address
- Broke down the 'OwnerAddress' into 'Owner_Address', 'OwnerCity', and 'OwnerState' for a more detailed owner profile

### 6. Changing Values in SoldAsVacant
- Standardized 'SoldAsVacant' values to 'Yes' and 'No' for consistency

### 7. Removing Duplicate Rows
- Eliminated 22 duplicate rows based on specific criteria, ensuring data integrity

### 8. Removing Unnecessary Columns
- Dropped 'OwnerAddress' and 'PropertyAddress' columns for a streamlined and focused dataset

## Conclusion
After data cleaning, the 'nashville_housing' database now contains 12,420 rows down from 12442 rows of data, providing a refined dataset for accurate analysis.
