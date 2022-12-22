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

ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) 
FROM Portfolio_Project.dbo.NashvilleHousing NashvilleHousing

ALTER TABLE NashvilleHousing 
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress))
FROM Portfolio_Project.dbo.NashvilleHousing NashvilleHousing


SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

-- Remove Duplicates

-- Delete Unused Columns