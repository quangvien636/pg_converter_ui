-- ─── PROCEDURE→FUNCTION: work_insertregularjournal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertregularjournal(integer, timestamp without time zone, integer, date, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertregularjournal(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN groupno integer,
    IN creationdate date,
    IN title character varying,
    IN divisionno integer,
    IN worktime integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO RegularWorkJournals (RegUserNo, RegDate, ModUserNo, ModDate,
		GroupNo, CreationDate, Title, DivisionNo, WorkTime, Content)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		GroupNo, CreationDate, Title, DivisionNo, WorkTime, Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
