/*

Clean Data in SQL Queries


*/

select *
from PortfolioProject.dbo.NashvilleHousing







-------------------------------------------------------------------------------------------------------------------------------
-- standardize date format

select SaleDateConverted
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date, SaleDate);

alter table nashvillehousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(date, saledate)


-------------------------------------------------------------------------------------------------------------------------------
--populate property address data 


select *
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null


select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


update a 
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-------------------------------------------------------------------------------------------------------------------------------

-- breaking out address into individual columns(e.g address,city,state)



--method 1


select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing



select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as address 
from PortfolioProject.dbo.NashvilleHousing


alter table nashvillehousing
add StreetAddress varchar(150);

update NashvilleHousing
set StreetAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table nashvillehousing
add City varchar(150);

update NashvilleHousing
set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))




-- method 2


select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)

from PortfolioProject.dbo.NashvilleHousing











alter table nashvillehousing
add OwnerStreetAddress varchar(150);

update NashvilleHousing
set OwnerStreetAddress =PARSENAME(REPLACE(OwnerAddress,',','.'),3)





alter table nashvillehousing
add OwnerCity varchar(150);

update NashvilleHousing
set OwnerCity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)







alter table nashvillehousing
add OwnerState varchar(150);

update NashvilleHousing
set OwnerState =PARSENAME(REPLACE(OwnerAddress,',','.'),1)



select *
from PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant"   field

select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant



select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing



update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end



-------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


with RowNumCTE  as(
select *,
	ROW_NUMBER() over(
	PARTITION BY 
	ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	Order by UniqueID) as row_num


from PortfolioProject.dbo.NashvilleHousing)

delete 
from RowNumCTE
where row_num >1


-------------------------------------------------------------------------------------------------------------------------------------------



--Delete Unused Columns

select *
from PortfolioProject.dbo.NashvilleHousing



Alter Table PortfolioProject.dbo.NashvilleHousing
drop column owneraddress, taxdistrict,propertyaddress, saledate


Alter Table PortfolioProject.dbo.NashvilleHousing
drop column saledate