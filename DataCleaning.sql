/****** Data Cleaning in SQL ******/

select * from NashvilleHousing

--Standarize Date Format (Making saledate column to date datatype only)--------------------------------------------------

select saledate, convert(date,saledate)
from NashvilleHousing;  --Just Seeing the work to be done

update NashvilleHousing set SaleDate= convert(date,saledate); --Didn't work

alter table nashvillehousing add SaleDateOnly date; --Made a new column

update NashvilleHousing set saledateonly=convert(date,saledate); --Gave the values to a new column

alter table nashvillehousing 
drop column saledate;	--Droped the old column 'saledate'

select * from NashvilleHousing;

--Populate Property Address Data (making NULL values in property address = to propertyadress in same parcelid at onather uniqueID)-------------------------------------------

select a.parcelid, a.propertyaddress,b.parcelid, b.propertyaddress
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID =b.ParcelID
and a.[UniqueID ] !=b.[UniqueID ]	--selecting which have same parcelid but not same uniqueid 
where a.PropertyAddress is null;	--Giving null values

update a
set 
PropertyAddress= isnull(a.parcelid,b.ParcelID)
from NashvilleHousing a
join NashvilleHousing b				--SelfJoin
on a.ParcelID =b.ParcelID
and a.[UniqueID ] !=b.[UniqueID ]
where a.PropertyAddress is null;	--Updated propertyaddress

select * from nashvilleHousing where propertyaddress is null;	--Checking now, there is no null value in propertyaddress

--Breaking Out address into individual names(address,city,state)------------------------------------------

select PropertyAddress from NashvilleHousing;

	/*Its also giving ',' at the end so to remove it we'll subtract 1 from length clause
	and +1 to start after ',' */

select SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)) as Address,
substring(propertyaddress, charindex(',',propertyaddress)+1 , len(propertyaddress)) as city
from NashvilleHousing
order by city;	--Checking what to do

alter table NashvilleHousing
add PropertyCity nvarchar(255), Property_Address nvarchar(255); --made new columns

update NashvilleHousing 
set PropertyCity=substring(propertyaddress, charindex(',',propertyaddress)+1 , len(propertyaddress))

/*
update NashvilleHousing 
set Property_address=SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1);

Invalid length parameter passed to the LEFT or SUBSTRING function.
*/
update NashvilleHousing 
set Property_address=SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress))

select propertyaddress,propertycity,property_address
from NashvilleHousing

select * from NashvilleHousing

--Doing Owneraddress split but with different and easy technique-------------------------------------------

select owneraddress from NashvilleHousing;

select owneraddress,
parsename(replace(owneraddress, ',' , '.'),1),
parsename(replace(owneraddress, ',' , '.'),2),
parsename(replace(owneraddress, ',' , '.'),3)
from nashvillehousing;		--Looking what to do

update NashvilleHousing
set 
OwnerAddress=replace(owneraddress,',','.')		--As parsename works on period only

alter table nashvillehousing
add owneraddress_address nvarchar(255), owneraddress_city nvarchar(255), owneraddress_state nvarchar(255);	--New columns

update NashvilleHousing
set OwnerAddress_address = parsename(owneraddress,3);	

update NashvilleHousing
set OwnerAddress_city = parsename(owneraddress,2);

update NashvilleHousing
set OwnerAddress_state = parsename(owneraddress,1);

select OwnerAddress,OwnerAddress_address, OwnerAddress_city, OwnerAddress_state
from NashvilleHousing		--Checking the work

select * from NashvilleHousing

--Change Y and N to Yes and No in SoldAsVacant field---------------------------------------------------------------------

select soldasvacant
from NashvilleHousing;

select SoldAsVacant, case 
when soldasvacant='Y' then 'YES'
when soldasvacant='N' then 'NO'
else SoldAsVacant
end as Columnm
from nashvillehousing;		--Looking what to do

update NashvilleHousing
set SoldAsVacant = (case when soldasvacant='Y' then 'YES'
when soldasvacant='N' then 'NO'
else SoldAsVacant
end)
--Updated the column

select soldasvacant
from NashvilleHousing
where SoldAsVacant='Y' or SoldAsVacant='N' --Checking the work

--Removing Duplicate Rows-----------------------------------------------------------------------------------

select * from NashvilleHousing;

with rownumcte
as(
select *,
ROW_NUMBER() over(partition by
parcelid,
SalePrice,
SaleDateOnly,
Landvalue,
legalReference,
Property_address
order by 
parcelid) as row_num
from NashvilleHousing
)				--Making temp table for row number if partition by columns are same then row_num=2

delete from rownumcte
where row_num>1;
--Deleted rows where row_num>1

select * from rownumcte
where row_num>1;
--Checking the work

--Delete Unused columns--------------------------------------------------------------------------------

Alter table nashvillehousing
drop column Propertyaddress,taxDistrict,owneraddress

select * from NashvilleHousing

