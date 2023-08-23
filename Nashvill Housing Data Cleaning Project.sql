Select *
from [Portfolio Projects ].dbo.[Nashville Housing]


Select SaleDate
from [Portfolio Projects ].dbo.[Nashville Housing]

-- Populate Property Address data 

Select *
from [Portfolio Projects ].dbo.[Nashville Housing]
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b. PropertyAddress, ISNull(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Projects ].dbo.[Nashville Housing] a
join [Portfolio Projects ].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress	is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Projects ].dbo.[Nashville Housing] a
join [Portfolio Projects ].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress	is null

-- Breaking out Address into (Address, City, State)

Select PropertyAddress
from [Portfolio Projects ].dbo.[Nashville Housing]
order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from [Portfolio Projects ].dbo.[Nashville Housing]

Alter table [Nashville Housing] 
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table [Nashville Housing] 
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing]
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select *
from [Portfolio Projects ].dbo.[Nashville Housing]

Select OwnerAddress
from [Portfolio Projects ].dbo.[Nashville Housing]

Select 
PARSENAME(Replace(OwnerAddress, ',','.') , 3)
,PARSENAME(Replace(OwnerAddress, ',','.') , 2)
,PARSENAME(Replace(OwnerAddress, ',','.') , 1)
from [Portfolio Projects ].dbo.[Nashville Housing]

Alter table [Nashville Housing] 
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From [Portfolio Projects ].dbo.[Nashville Housing]

-- Remove Duplicates 

With RowNumCTE AS(
Select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					UniqueID
					) row_num

From [Portfolio Projects ].dbo.[Nashville Housing]
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--Delete Unused Columns

Select *
From [Portfolio Projects ].dbo.[Nashville Housing]

ALTER TABLE [Portfolio Projects ].dbo.[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



