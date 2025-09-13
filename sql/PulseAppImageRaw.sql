drop table [apidev].[dbo].[PulseAppImageRaw]

select * 
into [apidev].[dbo].[PulseAppImageRaw]
from
(
SELECT
	[ImageID]
	,concat(ImageID, '-', replace(replace([ImageName], 'TOY', ''), '-hkProductCatalog' , '')) as ImageIdentifier
	,replace(replace([ImageName], 'TOY', ''), '-hkProductCatalog' , '') as ImageName
	,[ImageType]
	,[FileSize]
	,[Width]
	,[Height]
	,concat('https://azaueausadevdpp02.blob.core.windows.net/product-images/01_Raw/', [ImageName]) as LocationRaw
	,'Pulse App' as [CreatedBy]
	,UploadedDate as [CreatedDate]
	
FROM 
	[apidev].[dbo].[ProductImageData]

WHERE
	left([ImageName], 3) = 'TOY'

UNION ALL

SELECT
	[ImageID]
	,concat(ImageID, '-', replace(replace([ImageName], 'SUB', ''), '-masterProductCatalog', '')) as ImageIdentifier
	,replace(replace([ImageName], 'SUB', ''), '-masterProductCatalog' , '') as ImageName
	,[ImageType]
	,[FileSize]
	,[Width]
	,[Height]
	,concat('https://azaueausadevdpp02.blob.core.windows.net/product-images/01_Raw/', [ImageName]) as LocationRaw
	,'Pulse App' as [CreatedBy]
	,UploadedDate as [CreatedDate]
	
FROM 
	[apidev].[dbo].[ProductImageData]

WHERE
	left([ImageName], 3) = 'SUB'
) a