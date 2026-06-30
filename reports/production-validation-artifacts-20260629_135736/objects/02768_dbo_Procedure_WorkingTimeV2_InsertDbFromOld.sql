-- ─── PROCEDURE→FUNCTION: workingtimev2_insertdbfromold ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtimev2_insertdbfromold(integer, double precision, double precision, double precision, double precision, character varying, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtimev2_insertdbfromold(
    IN emp_no integer,
    IN work_date double precision,
    IN tot_holidays double precision,
    IN use_holidays double precision,
    IN jan_holidays double precision,
    IN org_attend_time character varying,
    IN org_finish_time character varying,
    IN attend_time character varying,
    IN finish_time character varying,
    IN absence_name character varying,
    IN today integer
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
