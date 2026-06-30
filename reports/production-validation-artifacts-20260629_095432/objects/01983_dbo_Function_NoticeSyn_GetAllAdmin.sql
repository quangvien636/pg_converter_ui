-- ─── FUNCTION: noticesyn_getalladmin ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getalladmin(integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getalladmin(
    fpage integer,
    tpage integer
) RETURNS TABLE(
    colno text,
    totalcnt text,
    id text,
    userno text,
    username text,
    department text,
    col7 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT * FROM (
		select
		ROW_NUMBER() OVER(ORDER BY bg.USERGROUP_ID ASC) AS "COLNO",COUNT(*) OVER() AS TotalCnt,
		bg.USERGROUP_ID AS "Id", 
		bg.USER_NO AS "UserNo",
		CASE 
		  WHEN bg.USER_NO >0  THEN us.Name 
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "UserName" ,
		ag.AUTH_GRP_NM AS "GroupName",
		CASE 
		  WHEN bg.USER_NO >0  THEN public."UF_DepartmentName" (bg.USER_NO)  
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "Department" ,
		bg.DEPARTMENT_ID AS "DepartmentId",
		convert(datetime, bg.DTS_INSERT, 111) AS "Date"
	from 
	NoticeSyn_UserByGroup bg LEFT JOIN
	  Organization_Users us  
	  on us.UserNo = bg.USER_NO inner join NoticeSyn_AuthoGroup ag on bg.AUTH_GRP_ID=ag.AUTH_GRP_ID 

	  LEFT JOIN Organization_Departments od on od.DepartNo=bg.DEPARTMENT_ID
	  where ag.AUTH_GRP_NM <>'Super Admin'
	  AND NOT (bg.USER_NO >0 AND us.UserNo Is null)
	--select
	--	ROW_NUMBER() OVER(ORDER BY bg.USERGROUP_ID ASC) AS "COLNO",COUNT(*) OVER() AS TotalCnt,
	--	bg.USERGROUP_ID AS "Id", 
	--	us.UserNo,
	--	us.Name AS "UserName",
	--	'R&D' AS "Department",
	--	convert(datetime, bg.DTS_INSERT, 111) AS "Date"
	--from 
	--  Organization_Users us 
	--  inner join Notice_UserByGroup bg on us.UserNo = bg.USER_NO
	--  left join Notice_AuthoGroup au on  bg.AUTH_GRP_ID = au.AUTH_GRP_ID
	--  where au.AUTH_GRP_NM not ILIKE 'Super Admin'
	) AS TEMP
	WHERE TEMP.COLNO BETWEEN FPAGE AND TPAGE

END;

--EXEC Notice_GetAllAdmin 1 , 10
--select * from Notice_AuthoGroup
----------------------------------------------------.///////////////////////////////////////////-------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
