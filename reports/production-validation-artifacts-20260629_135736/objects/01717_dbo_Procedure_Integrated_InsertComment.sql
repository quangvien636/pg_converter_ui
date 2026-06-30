-- ─── PROCEDURE→FUNCTION: integrated_insertcomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_insertcomment(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_insertcomment(
    IN commentno integer,
    IN integratedno integer,
    IN reguserno integer,
    IN content character varying
) RETURNS SETOF record
AS $function$
DECLARE
    rtn integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Mode = '0' THEN;
		INSERT INTO Integrated_Comments(IntegratedNo,RegUserNo,RegDate,Content,ModUserNo,ModDate)
		VALUES(IntegratedNo,RegUserNo,NOW(),Content,RegUserNo,NOW())
		RTN := lastval();
	END IF;
	ELSIF Mode = '1' THEN;
		UPDATE Integrated_Comments SET Content=integrated_insertcomment.content,ModUserNo=integrated_insertcomment.reguserno,ModDate=NOW() WHERE CommentNo=integrated_insertcomment.commentno
		RTN := @ERROR;
	END IF;
	ELSE;
		DELETE FROM Integrated_Comments WHERE CommentNo=integrated_insertcomment.commentno
		RTN := @ERROR;
	END IF;
	
	RETURN QUERY
	SELECT RTN
END;

-------------------------------//////////////////////---------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
