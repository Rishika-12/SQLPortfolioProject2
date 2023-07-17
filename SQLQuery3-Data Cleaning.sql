select * 
from PortfolioProject..Nashville

--Date Format
select ConveretedSaledate, CONVERT(Date,SaleDate) as ConvertedDate
from PortfolioProject..Nashville

Update Nashville
Set SaleDate=CONVERT(Date,SaleDate)

Alter table Nashville
Add ConveretedSaledate Date;


Update Nashville
Set ConveretedSaledate=CONVERT(Date,SaleDate)

select * from Nashville

alter table Nashville
drop column SaleDateConvereted

--populating property address
select *
from PortfolioProject..Nashville
where PropertyAddress is null
--order by ParcelID

select t1.ParcelID,t1.PropertyAddress,t2.ParcelID,t2.PropertyAddress,ISNULL(t1.PropertyAddress,t2.PropertyAddress)
from PortfolioProject..Nashville as t1
join PortfolioProject..Nashville as t2
on t1.ParcelID=t2.ParcelID
and t1.[UniqueID]<>t2.[UniqueID ]

update t1
set PropertyAddress = ISNULL(t1.PropertyAddress,t2.PropertyAddress)
from PortfolioProject..Nashville as t1
join PortfolioProject..Nashville as t2
on t1.ParcelID=t2.ParcelID
and t1.[UniqueID]<>t2.[UniqueID ]
where t1.PropertyAddress is null

--breaking address
select PropertyAddress
from PortfolioProject..Nashville

select 
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)as Address
from PortfolioProject..Nashville

select 
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))as Address
from PortfolioProject..Nashville

Alter table Nashville
Add PropertySplitAddress nvarchar(255);


Update Nashville
Set PropertySplitAddress=substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter table Nashville
Add PropertyCity nvarchar(255);

Update Nashville
Set PropertyCity=substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select *
from Nashville

Select OwnerAddress 
from PortfolioProject..Nashville

select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject..Nashville

alter table Nashville
add OwnerSplitAddress nvarchar(255),OwnerSplitCity nvarchar(255),
OwnerSplitState nvarchar(255)
update Nashville
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3),
OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2),
OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

--alter table Nashville
--add OwnerSplitCity nvarchar(255)

--update Nashville
--set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


--alter table Nashville
--add OwnerSplitState nvarchar(255)

--update Nashville
--set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

select * from Nashville

--alter table Nashville
--drop column OwnerSplitAddress, OwnerSplitCity, OwnerSplitState

select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from Nashville
group by SoldAsVacant
order by 2

select SoldAsVacant,
Case when SoldAsVacant ='Y' Then 'YES'
When SoldAsVacant='N' THEN 'NO'
Else SoldAsVacant
End
from Nashville

update Nashville
set SoldAsVacant=
Case when SoldAsVacant ='Y' Then 'YES'
When SoldAsVacant='N' THEN 'NO'
Else SoldAsVacant
End
from Nashville

--remove duplicates
select *,
ROW_NUMBER() over(
partition by ParcelId,
PropertyAddress, SalePrice,SaleDate,LegalReference order by UniqueId
)row_num
from Nashville

--delete unused columns

select * from Nashville

alter table Nashville
drop column OwnerAddress,TaxDistrict, PropertyAddress
