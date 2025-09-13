alter view vCCV2MediaContainerStagedP1 as
(
SELECT DISTINCT
	(case when CHARINDEX('-', [qualifier]) <> 0
	then SUBSTRING([qualifier], 1, CHARINDEX('-', [qualifier]) - 1)
	end) as CCV2PartNo
	,(case when PATINDEX('%-___-%', [qualifier]) <> 0 then
			SUBSTRING(
			[qualifier], 
			CHARINDEX('-', [qualifier]) + 1, 
			3)
		else
			1
    end) as ProductImageNo
	,LEFT([catalogVersion], CHARINDEX(':', [catalogVersion]) - 1) as [catalogVersion]
	,min([creationtime]) as [creationtime]
FROM
	[auto].[Staging].[CCV2MediaContainer]
where
	catalogversion like '%ProductCatalog:Staged%'
group by
	(case when CHARINDEX('-', [qualifier]) <> 0
	then SUBSTRING([qualifier], 1, CHARINDEX('-', [qualifier]) - 1)
	end)
	,(case when PATINDEX('%-___-%', [qualifier]) <> 0 then
			SUBSTRING(
			[qualifier], 
			CHARINDEX('-', [qualifier]) + 1, 
			3)
		else
			1
    end)
	,[catalogVersion]
)
;
alter view vCCV2MediaContainerProductionP1 as
(
SELECT DISTINCT
	(case when CHARINDEX('-', [qualifier]) <> 0
	then SUBSTRING([qualifier], 1, CHARINDEX('-', [qualifier]) - 1)
	end) as CCV2PartNo
	,(case when PATINDEX('%-___-%', [qualifier]) <> 0 then
			SUBSTRING(
			[qualifier], 
			CHARINDEX('-', [qualifier]) + 1, 
			3)
		else
			1
    end) as ProductImageNo
	,LEFT([catalogVersion], CHARINDEX(':', [catalogVersion]) - 1) as [catalogVersion]
	,min([creationtime]) as [creationtime]
FROM
	[auto].[Staging].[CCV2MediaContainer]
where
	catalogversion like '%ProductCatalog:Online%'
group by
	(case when CHARINDEX('-', [qualifier]) <> 0
	then SUBSTRING([qualifier], 1, CHARINDEX('-', [qualifier]) - 1)
	end)
	,(case when PATINDEX('%-___-%', [qualifier]) <> 0 then
			SUBSTRING(
			[qualifier], 
			CHARINDEX('-', [qualifier]) + 1, 
			3)
		else
			1
    end)
	,[catalogVersion]
)
;
--S2

create view vCCV2MediaContainerStagedS2 as
(
SELECT DISTINCT
	(case when CHARINDEX('-', [qualifier]) <> 0
	then SUBSTRING([qualifier], 1, CHARINDEX('-', [qualifier]) - 1)
	end) as CCV2PartNo
	,(case when PATINDEX('%-___-%', [qualifier]) <> 0 then
			SUBSTRING(
			[qualifier], 
			CHARINDEX('-', [qualifier]) + 1, 
			3)
		else
			1
    end) as ProductImageNo
	,LEFT([catalogVersion], CHARINDEX(':', [catalogVersion]) - 1) as [catalogVersion]
	,min([creationtime]) as [creationtime]
FROM
	[auto].[Staging].[CCV2MediaContainerS2]
where
	catalogversion like '%ProductCatalog:Staged%'
group by
	(case when CHARINDEX('-', [qualifier]) <> 0
	then SUBSTRING([qualifier], 1, CHARINDEX('-', [qualifier]) - 1)
	end)
	,(case when PATINDEX('%-___-%', [qualifier]) <> 0 then
			SUBSTRING(
			[qualifier], 
			CHARINDEX('-', [qualifier]) + 1, 
			3)
		else
			1
    end)
	,[catalogVersion]
)
;--s2
create view vCCV2MediaContainerProductionS2 as
(
SELECT DISTINCT
	(case when CHARINDEX('-', [qualifier]) <> 0
	then SUBSTRING([qualifier], 1, CHARINDEX('-', [qualifier]) - 1)
	end) as CCV2PartNo
	,(case when PATINDEX('%-___-%', [qualifier]) <> 0 then
			SUBSTRING(
			[qualifier], 
			CHARINDEX('-', [qualifier]) + 1, 
			3)
		else
			1
    end) as ProductImageNo
	,LEFT([catalogVersion], CHARINDEX(':', [catalogVersion]) - 1) as [catalogVersion]
	,min([creationtime]) as [creationtime]
FROM
	[auto].[Staging].[CCV2MediaContainerS2]
where
	catalogversion like '%ProductCatalog:Online%'
group by
	(case when CHARINDEX('-', [qualifier]) <> 0
	then SUBSTRING([qualifier], 1, CHARINDEX('-', [qualifier]) - 1)
	end)
	,(case when PATINDEX('%-___-%', [qualifier]) <> 0 then
			SUBSTRING(
			[qualifier], 
			CHARINDEX('-', [qualifier]) + 1, 
			3)
		else
			1
    end)
	,[catalogVersion]
)

--Prod
SELECT *
FROM [auto].[Staging].[CCV2MediaContainer]
where catalogversion like '%ProductCatalog:Online'

--Staging
SELECT *
FROM [auto].[Staging].[CCV2MediaContainer]
where catalogversion like '%ProductCatalog:Staged'


select distinct
catalogversion,
count(*)
FROM [auto].[Staging].[CCV2MediaContainer]
group by catalogversion
order by count(*) desc