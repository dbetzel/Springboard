/****** Script for SelectTopNRows command from SSMS  ******/
SELECT datepart(week,time_stamp) as weeknumber
      ,[user_id]
      ,count([visited]) as visits_per_week
	  ,creation_time
	  ,[name]
	  ,email
	  ,creation_source
	  ,last_session_creation_time
	  ,opted_in_to_mailing_list
	  ,enabled_for_marketing_drip
	  ,org_id
	  ,invited_by_user_id
INTO #TempAdopters
FROM Testing.dbo.takehome_user_engagement tue 
	INNER JOIN Testing.dbo.takehome_users tu on  tue.user_id = tu.object_id
GROUP BY datepart(week,time_stamp), user_id, creation_time, [name], email, creation_source
	  ,last_session_creation_time, opted_in_to_mailing_list, enabled_for_marketing_drip
	  ,org_id, invited_by_user_id
HAVING count([visited]) >= 3

SELECT * 
FROM #TempAdopters
WHERE invited_by_user_id <> ''

SELECT creation_source, count(*) as countNonAdopters
FROM takehome_users
WHERE  object_id NOT IN
(	SELECT user_id
	FROM #TempAdopters
)
group by creation_source

SELECT DISTINCT creation_source
FROM takehome_users

SELECT creation_source, count(*) as countAdopters
FROM #TempAdopters
group by creation_source

SELECT count(*) TotalAdopters
FROM #TempAdopters

SELECT count(*) as TotalcountNonAdopters
FROM takehome_users
WHERE  object_id NOT IN
(	SELECT user_id
	FROM #TempAdopters
)