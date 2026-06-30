-- ─── FUNCTION: workingtimev2_insertdbfromold ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev2_insertdbfromold(integer, double precision, double precision, double precision, double precision, character varying, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtimev2_insertdbfromold(
    emp_no integer,
    work_date double precision,
    tot_holidays double precision,
    use_holidays double precision,
    jan_holidays double precision,
    org_attend_time character varying,
    org_finish_time character varying,
    attend_time character varying,
    finish_time character varying,
    absence_name character varying,
    today integer
) RETURNS void
AS $function$
BEGIN

	insert into VW_HR_GW_TIME_INOUT (
	EMP_NO,
	WORK_DATE,
	TOT_HOLIDAYS ,
	USE_HOLIDAYS ,
	JAN_HOLIDAYS  ,
	ORG_ATTEND_TIME ,
	ORG_FINISH_TIME ,
	ATTEND_TIME ,
	FINISH_TIME ,
	ABSENCE_NAME ,
	insertDate)
	VALUES ( EMP_NO ,
            WORK_DATE ,
            TOT_HOLIDAYS ,
            USE_HOLIDAYS ,
            JAN_HOLIDAYS ,
            ORG_ATTEND_TIME ,
            ORG_FINISH_TIME,
            ATTEND_TIME ,
            FINISH_TIME ,
            ABSENCE_NAME ,
            today );
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
