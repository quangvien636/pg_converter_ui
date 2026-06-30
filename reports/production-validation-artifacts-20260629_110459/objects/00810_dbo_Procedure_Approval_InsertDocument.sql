-- ─── PROCEDURE→FUNCTION: approval_insertdocument ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_insertdocument(integer, timestamp without time zone, character varying, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_insertdocument(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN title character varying,
    IN filetype integer,
    IN formno integer,
    IN state integer,
    IN currentappno integer
) RETURNS SETOF record
AS $function$
DECLARE
    regusername character varying;
    regpositionname character varying;
    regdepartname character varying;
    documentno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SELECT U.Name, P.Name INTO regusername, regpositionname FROM Organization_Users U
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE U.UserNo = approval_insertdocument.reguserno
	
	INSERT INTO Approval_Documents (RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		ModUserNo, ModDate, ModUserName, ModPositionName, ModDepartName,
		Title, FileType, FormNo ,State, CurrentAppNo)
	VALUES(RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		Title, FileType, FormNo, State, CurrentAppNo)
	

	DocumentNo := (SELECT lastval());
	RETURN QUERY
	SELECT DocumentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
