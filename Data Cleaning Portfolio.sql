-- Cleaning data for SQL Queries --

Select *
from PortfolioProject.dbo.NashvilleHousing

--Standadize Date Format --

Select SaleDate, CONVERT (Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate =  CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing 
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted=  CONVERT(Date, SaleDate)

Select SaleDateConverted, CONVERT (Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

-- Populate Property Address data -- 

Select* 
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is NULL 
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is NULL 

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

	
-- Breaking out Address data Individual Columns (Address, City, State)--

Select PropertyAddress 
from PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress , 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address 
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing 
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress=  SUBSTRING(PropertyAddress , 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing 
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity=  SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select*
from PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing 
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress=  PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)


ALTER TABLE NashvilleHousing 
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)


ALTER TABLE NashvilleHousing 
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState=  PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select*
from PortfolioProject.dbo.NashvilleHousing


-- Change 'y' and 'n' to Yes and No in 'Sold as Vacant' field --

Select distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes' 
		when SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END 
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes' 
		when SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END 

-- Remove Duplicates --

WITH RowNumCTE as(
Select *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID 
					) row_num
From PortfolioProject.dbo.NashvilleHousing
)
Delete
From RowNumCTE
Where row_num > 1



WITH RowNumCTE as(
Select *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID 
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- Delete Some Columns-- 

Select*
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

