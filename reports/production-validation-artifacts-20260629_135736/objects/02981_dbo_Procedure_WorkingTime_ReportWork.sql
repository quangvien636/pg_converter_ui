-- ─── PROCEDURE→FUNCTION: workingtime_reportwork ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_reportwork(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_reportwork(
    IN p_sd integer,
    IN p_dno integer DEFAULT 0,
    IN p_uno integer DEFAULT 0,
    IN p_type integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    tbl table(departno int,parentno int);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	 IF p_type <> 1 AND p_dno = 0 THEN
	   p_dno2 := -1;
	   with name_tree as 
		(
		   CREATE TEMP TABLE U1 AS SELECT DepartNo, ParentNo
		   from Organization_Departments
		   where DepartNo in (  select  DepartNo FROM Organization_BelongToDepartment WHERE UserNo = workingtime_reportwork.p_uno )
		   union all
		   select C.DepartNo, C.ParentNo
		   from Organization_Departments c
		   join name_tree p on C.ParentNo = p.DepartNo
		) ;
		insert into tbl(DepartNo, ParentNo)
		RETURN QUERY
		select DepartNo, ParentNo
		from name_tree;END IF;
	 else begin
	  p_dno2 := workingtime_reportwork.p_dno;;
	  insert into tbl(DepartNo, ParentNo) values(p_dno,0)
	 END;

	RETURN QUERY
	SELECT B.UserNo FROM (CREATE TEMP TABLE W1 AS SELECT UserNo 
					from  Organization_BelongToDepartment 
					WHERE (p_dno2 = 0 OR DepartNo IN (SELECT DepartNo FROM tbl))
					group by UserNo) B
		JOIN Organization_Users U  ON U.UserNo = B.UserNo 
		--INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
		JOIN (SELECT u1.UserNo FROM Organization_Users U1 LEFT JOIN WorkingTime_AllowDevices A ON U1.userno = a.userno	where COALESCE(ContentAllow, 'true') ILIKE '%true%') AL ON U.UserNo = AL.UserNo
		WHERE  U.Enabled = TRUE AND U.IsVirtual = FALSE 	
		--and (p_dno2=0 OR B.DepartNo IN (SELECT DepartNo FROM tbl));

		---tru ra nguoi finish 20231004

		RETURN QUERY
		SELECT t1.UserNo, t1.TimeType FROM WorkingTime_Times t1
		join U1 u on t1.UserNo = u.UserNo 
		WHERE t1.RegDate = (CREATE TEMP TABLE W2 AS SELECT MAX(t2.RegDate)
                 FROM WorkingTime_Times t2
                 WHERE t2.RegUserNo = t1.RegUserNo)
                 and WorkingDayC = workingtime_reportwork.p_sd
				 and COALESCE(t1.status,0) != 1

		RETURN QUERY
		select UserNo FROM W1 
		where TimeType = 1
		group by UserNo

         RETURN QUERY
         SELECT (SELECT COUNT(UserNo) FROM U1) as TotalStaff
			   ,(SELECT COUNT( UserNo ) FROM W2) AS TotalCheckIn;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
