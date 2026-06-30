-- ─── FUNCTION: workingtime_countrequest ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_countrequest(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_countrequest(
    p_from integer,
    p_to integer,
    p_uno integer,
    p_type integer
) RETURNS TABLE(
    workingno serial,
    reguserno integer,
    regdate timestamp without time zone,
    userno integer,
    workingday integer,
    timetype integer,
    checktime character(6),
    provider integer,
    latitude double precision,
    longitude double precision,
    remark character varying(500),
    ipserver character varying(250),
    timechecklong double precision,
    timeoffset double precision,
    distance character varying(250),
    latcompany double precision,
    lngcompany double precision,
    beaconinfo character varying(500),
    namecompany character varying(500),
    postid character varying(50),
    postname character varying(500),
    deptid character varying(50),
    deptname character varying(500),
    locationno integer,
    groupid integer,
    lunchstart character(4),
    lunchend character(4),
    starworking character(4),
    endworking character(4),
    isaddlunch boolean,
    bin1 character(4),
    bout1 character(4),
    bin2 character(4),
    bout2 character(4),
    isb1 boolean,
    isb2 boolean,
    timeworking integer,
    workingdayc integer,
    checktimec integer,
    checktimefull timestamp without time zone,
    timeworking2 integer,
    address character varying(600),
    status integer,
    dateupdate timestamp without time zone,
    datedelete timestamp without time zone,
    checktimefullo timestamp without time zone,
    userdeleted integer,
    bno integer,
    bname character varying(500),
    timeworkingf integer,
    timeworkingf2 integer
)
AS $function$
DECLARE
    temp_department table(  
   departno int
  );
BEGIN


  INSERT INTO TEMP_DEPARTMENT  
  EXEC WorkingTime_GetAllChildDepartByUID p_uno;


		RETURN QUERY
		SELECT  
			COUNT(1) AS uncomfirm
		FROM WorkingTime_Times t  
		INNER JOIN WorkingTime_Times_v2 t2  ON t.WorkingNo = t2.WorkingNo
		INNER JOIN WorkingTime_RequestCorrectionTime r  ON t.WorkingNo = r.WorkingNo
		LEFT JOIN Organization_BelongToDepartment OB ON OB.UserNo = t.UserNo
		WHERE t.WorkingDayC BETWEEN  p_from AND p_to
		AND (t.Provider = 999) 
		AND R.STATUS = 0 AND R.REJECT = 0
		AND (p_type = 1 OR OB.DepartNo IN(select DepartNo from TEMP_DEPARTMENT) OR OB.DepartNo IN (SELECT * FROM Organization_GetDepartments_Reflexive(D_NO, 0)));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
