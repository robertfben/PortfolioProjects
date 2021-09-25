/*


Cleaning data in SQL Queries


*/



Select *
from NashvilleHousing


------------------------------------------------------------------

-- Standardize Date Format


Select SaleDateConverted, convert(date, saledate)
from NashvilleHousing


Update NashvilleHousing
Set SaleDate = convert(date, saledate) 


Alter Table NashvilleHousing
Add SaleDateConverted Date; 

Update NashvilleHousing
Set SaleDateConverted = convert(date, saledate) 


------------------------------------------------------------------------


-- Populate Property Address Data



Select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a 
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



Update a
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a 
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------



-- Breaking out Address into Individual Column (Address, City, State)


Select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID



select
substring(PropertyAddress,1, charindex(',',PropertyAddress) -1) as 'Address'
, substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) as 'Address'
from NashvilleHousing


Alter Table NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1, charindex(',',PropertyAddress) -1)


Alter Table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))




-- Alternate Method to Above



Select OwnerAddress
from NashvilleHousing


Select 
parsename(replace(OwnerAddress, ',','.'),3)
,parsename(replace(OwnerAddress, ',','.'),2)
,parsename(replace(OwnerAddress, ',','.'),1)
from NashvilleHousing


Alter Table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',','.'),3)


Alter Table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',','.'),2)


Alter Table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',','.'),1)


--------------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in ''Sold as Vacant'' Field



select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, CASE
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldasVacant
end
from NashvilleHousing


update NashvilleHousing
set SoldAsVacant = CASE
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldasVacant
end


-------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


ALTER TABLE
NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate