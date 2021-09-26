--------------------------------------------------------------------------------------------------------------------
-- Joining Both Tables (inner join to return only matching records between both tables)


select *
from SalesData as S
inner join
ViewableProducts as V
on S.viewable_product_id = V.[ viewable_product_id ]


-----------------------------------------------------------------------------------------------------------------------

-- Date/Time Columns Seperated into Date Columns


select convert(date, created_at) as 'Date Created'
,convert(date, removed_at) as 'Date Removed'
from SalesData 


-----------------------------------------------------------------------------------------------------------------

-- Standardize Date Format



Update SalesData
Set created_at = convert(date, created_at)

alter table SalesData
Add DateCreated Date;

Update SalesData
Set DateCreated = convert(date, created_at)



Update SalesData
Set removed_at = convert(date, removed_at)

alter table SalesData
Add DateRemoved Date;

Update SalesData
Set DateRemoved = convert(date, removed_at)


-------------------------------------------------------------------------------------------

-- Delete Unused Columns


Alter Table
SalesData
Drop Column created_at, removed_at