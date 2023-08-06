select *
from portfolioproject..nasvillehousing

--standardize date format

select saledate
from portfolioproject..nasvillehousing

select saledate, convert(date, saledate)
from portfolioproject..nasvillehousing

update nasvillehousing
set saledate = convert(date, saledate)
---above is not work

alter table nasvillehousing
add saledateconverted date;

update nasvillehousing
set saledateconverted = convert(date, saledate)

select saledateconverted, convert(date, saledate)
from portfolioproject..nasvillehousing


--Populate Property Address Data

select *
from portfolioproject..nasvillehousing

select PropertyAddress
from portfolioproject..nasvillehousing

select PropertyAddress
from portfolioproject..nasvillehousing
where PropertyAddress is null

select *
from portfolioproject..nasvillehousing
where PropertyAddress is null


select *
from portfolioproject..nasvillehousing
--where PropertyAddress is null
order by ParcelID


select *
from portfolioproject..nasvillehousing a
    join portfolioproject..nasvillehousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from portfolioproject..nasvillehousing a
    join portfolioproject..nasvillehousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from portfolioproject..nasvillehousing a
    join portfolioproject..nasvillehousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from portfolioproject..nasvillehousing a
    join portfolioproject..nasvillehousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from portfolioproject..nasvillehousing a
    join portfolioproject..nasvillehousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into Individual Column (Address, City, State) (ParseName or Substring)
--Breaking PropertyAddress using Substring
--Delimina separate different columns or values


select PropertyAddress
from portfolioproject..nasvillehousing
--where PropertyAddress is null
--order by ParcelD

select 
substring(Propertyaddress, 1, CHARINDEX(',', propertyaddress)) as Address
from portfolioproject..nasvillehousing

select 
substring(Propertyaddress, 1, CHARINDEX(',', propertyaddress)) as Address
, CHARINDEX(',', propertyaddress)
from portfolioproject..nasvillehousing
---to remove the from first address',' add '-1'

select 
substring(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address
from portfolioproject..nasvillehousing


select 
substring(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address
,substring(Propertyaddress, CHARINDEX(',', propertyaddress), len(propertyaddress)) as Address
from portfolioproject..nasvillehousing
---to remove the from second address',' add '+1'

select 
substring(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address
,substring(Propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress)) as Address
from portfolioproject..nasvillehousing
---cant separate 2 values from 1 column without creating 2 oyher columns
---create 2 new columns to add te values

alter table nasvillehousing
add PropertySplitAddress nvarchar(255);

update nasvillehousing
set PropertySplitAddress = substring(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

alter table nasvillehousing
add PropertySplitCity nvarchar(255);

update nasvillehousing
set PropertySplitCity = substring(Propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress))

select *
from portfolioproject..nasvillehousing

--Breaking OwnerAddress using Parsename
--Parsename uses '.' not ',')

select OwnerAddress
from portfolioproject..

select 
Parsename(Replace (OwnerAddress, ',','.'), 1)
from portfolioproject..nasvillehousing
---Parsename those things backward

select 
Parsename(Replace (OwnerAddress, ',','.'), 3)
,Parsename(Replace (OwnerAddress, ',','.'), 2)
,Parsename(Replace (OwnerAddress, ',','.'), 1)
from portfolioproject..nasvillehousing

alter table nasvillehousing
add OwnerSplitAddress nvarchar(255);

update nasvillehousing
set OwnerSplitAddress = Parsename(Replace (OwnerAddress, ',','.'), 3)

alter table nasvillehousing
add OwnerSplitCity nvarchar(255);

update nasvillehousing
set OwnerSplitCity = Parsename(Replace (OwnerAddress, ',','.'), 2)

alter table nasvillehousing
add OwnerSplitState nvarchar(255);

update nasvillehousing
set OwnerSplitState = Parsename(Replace (OwnerAddress, ',','.'), 1)


select *
from portfolioproject..nasvillehousing

--Changin Y and N to Yes and No in 'Sold as Vacant' field
--using CASE STATEMENT

select Distinct(SoldAsVacant)
from portfolioproject..nasvillehousing

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from portfolioproject..nasvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from portfolioproject..nasvillehousing

update nasvillehousing 
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end

select *
from portfolioproject..nasvillehousing


--Remove Duplicates

select *
from portfolioproject..nasvillehousing

select *,
       row_number() over(
	   partition by ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by
					   UniqueID
					   ) row_num
	               
from portfolioproject..nasvillehousing
order by ParcelID

With rownumCTE AS (
select *,
       row_number() over(
	   partition by ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by
					   UniqueID
					   ) row_num
	               
from portfolioproject..nasvillehousing
)
Select *
from rownumCTE
where row_num >1
order by ParcelID

With rownumCTE AS (
select *,
       row_number() over(
	   partition by ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by
					   UniqueID
					   ) row_num
	               
from portfolioproject..nasvillehousing
)
delete
from rownumCTE
where row_num >1
--order by ParcelID

--Delete unused columns


select *
from portfolioproject..nasvillehousing

alter table portfolioproject..nasvillehousing
drop column saledate, propertyaddress, owneraddress

alter table nasvillehousing
drop column taxdistrict