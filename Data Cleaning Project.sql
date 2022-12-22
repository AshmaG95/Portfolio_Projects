/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing 

-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM Portfolio_Project.dbo.NashvilleHousing 

ALTER TABLE NashvilleHousing 
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)
FROM Portfolio_Project.dbo.NashvilleHousing NashvilleHousing

-- Populate Property Address data

SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing 
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio_Project.dbo.NashvilleHousing a
JOIN Portfolio_Project.dbo.NashvilleHousing b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
--WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio_Project.dbo.NashvilleHousing a
JOIN Portfolio_Project.dbo.NashvilleHousing b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM Portfolio_Project.dbo.NashvilleHousing 
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) AS Address

FROM Portfolio_Project.dbo.NashvilleHousing


ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) 
FROM Portfolio_Project.dbo.NashvilleHousing NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing 
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress))
FROM Portfolio_Project.dbo.NashvilleHousing NashvilleHousing


SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing

SELECT OwnerAddress
FROM Portfolio_Project.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',','.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
FROM Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3) 
FROM Portfolio_Project.dbo.NashvilleHousing NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing 
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)
FROM Portfolio_Project.dbo.NashvilleHousing NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing 
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
FROM Portfolio_Project.dbo.NashvilleHousing NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM Portfolio_Project.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Portfolio_Project.dbo.NashvilleHousing

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				    UniqueID
				) row_num
FROM Portfolio_Project.dbo.NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num >1


-- Delete Unused Columns

SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
DROP COLUMN SaleDate