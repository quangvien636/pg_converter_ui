-- ─── PROCEDURE→FUNCTION: workingtime_setworkingtime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_setworkingtime(integer, integer, integer, integer, character varying, integer, double precision, double precision, character varying, double precision, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtime(
    IN reguserno integer,
    IN userno integer,
    IN workingday integer,
    IN timetype integer,
    IN checktime character varying,
    IN provider integer,
    IN latitude double precision,
    IN longitude double precision,
    IN remark character varying,
    IN longtime double precision,
    IN timeoffset double precision
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkingTime_Times(RegUserNo, RegDate, UserNo, WorkingDay, TimeType,
		CheckTime, Provider, Latitude, Longitude, Remark,TimeCheckLong,TimeOffset)
	VALUES(RegUserNo, NOW(), UserNo, WorkingDay, TimeType,
		CheckTime, Provider, Latitude, Longitude, Remark,LongTime,TimeOffset);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
