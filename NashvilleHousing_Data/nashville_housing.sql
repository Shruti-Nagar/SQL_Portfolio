-- DATA CLEANING USING SQL

create database nashville_housing;
use nashville_housing;

describe housing;

select * from housing;

-- Standardize Date Format
alter table housing
modify SaleDate Date;

-- Populating missing data in PropertyAddress Column
select count(*)
from housing
where PropertyAddress is null; -- Total 17 rows are empty

/* For ParcelID without PropertyAddress, we check for ParcelID
that have same Address and ID, then use that address to replace null values */
select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, coalesce(a.PropertyAddress, b.PropertyAddress)
from housing a
join housing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

-- Updating table by populating the PropertyAddress Column
update housing a
join housing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
set a.PropertyAddress = coalesce(a.PropertyAddress, b.PropertyAddress)
where a.PropertyAddress is null;

-- Separating the PropertyAddress into city and house address
select PropertyAddress
from housing;

-- Using substring to separate Address
select substring_index(PropertyAddress, ',', 1) as HouseAddress, -- extracts from string before comma
		substring_index(PropertyAddress, ',', -1) as City -- extracts from the string after comma
from housing;

-- Updating housing table
-- HouseAddress
alter table housing
add HouseAddress varchar(255);

Update housing
set HouseAddress = substring_index(PropertyAddress, ',', 1);

-- City
alter table housing
add City varchar(255);

update housing
set City = substring_index(PropertyAddress, ',', -1);

-- Splitting Owner Address into Owner_Address, OwnerCity, OwnerState
select OwnerAddress
from housing;

select trim(substring_index(OwnerAddress, ',', 1)) as Owner_Address,
	trim(substring_index(substring_index(OwnerAddress, ',', 2), ',', -1)) as OwnerCity,
    trim(substring_index(OwnerAddress, ',', -1)) as OwnerState
from housing;

alter table housing
add Owner_Address varchar(255);

alter table housing
add OwnerCity varchar(255);

alter table housing
add OwnerState varchar(255);

update housing
set Owner_Address = trim(substring_index(OwnerAddress, ',', 1)),
OwnerCity = trim(substring_index(substring_index(OwnerAddress, ',', 2), ',', -1)),
OwnerState = trim(substring_index(OwnerAddress, ',', -1));

-- Changing values y and n in SoldAsVacant to Yes and No
select distinct SoldAsVacant, count(SoldAsVacant)
from housing
group by SoldAsVacant
Order by 2;
/* Y = 19, N= 127, Yes = 236, No = 12060 */

update housing
set SoldAsVacant = "Yes"
where SoldAsVacant = "Y";

update housing
set SoldAsVacant = "No"
where SoldAsVacant = "N";

-- Removing Duplicate Rows
delete from housing
where UniqueID in (
	select UniqueID
    from (
		select UniqueID, row_number() over(partition by ParcelID, HouseAddress, SalePrice, SaleDate, LegalReference
        order by UniqueID) as row_num
        from housing) as subquery
	where row_num > 1
    );
/* 22 rows deleted */

-- Removing columns which are of no use after Data Cleaning
alter table housing
drop column OwnerAddress,
drop column PropertyAddress;

/* After carring out DATA CLEANING, database is left with 12420 rows
*/