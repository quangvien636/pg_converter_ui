-- ─── PROCEDURE→FUNCTION: notice_getallcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getallcount();
CREATE OR REPLACE FUNCTION public.notice_getallcount(
) RETURNS SETOF record
AS $function$
DECLARE
    userno integer;
    admin integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT UserNo INTO userno FROM Organization_Users WHERE UserID = UserId


	SELECT COUNT(x.UserNo) INTO admin FROM(
		select m.UserNo 
		from Authority_ModulePermission m 
		join Center_Applications c on m.ApplicationNo = c.ApplicationNo
		where c.projectCode = 'Notice' AND UserNo = UserNo
		union 
		select UserNo from Authority_SitePermissions WHERE UserNo = UserNo
    )x

	RETURN QUERY
	SELECT
		COALESCE(COUNT(N.NoticeNo),0) AS AllCnt,
		COALESCE(SUM(CASE WHEN today <= N.EndDate AND (A.RCnt IS NULL) AND COALESCE(N.IsSeen2, 0) = 0 THEN 1 ELSE 0 END),0) AS UnCnt --20231116
	FROM 
	 Notices N --JOIN NoticeDivisions d on n.DivisionNo = n.DivisionNo
	 Join Organization_Users u on n.RegUserNo = u.UserNo
	LEFT OUTER JOIN 
	(
		select dt.NoticeNo, COUNT (dt.NoticeNo) AS RCnt
		from	  NoticeReference dt
		WHERE dt.UserID = UserId
		GROUP BY dt.NoticeNo
	) A ON N.NoticeNo = A.NoticeNo
	WHERE  ((IsShare = FALSE 
			OR N.RegUserNo = UserNo
			OR N.NoticeNo IN (SELECT NoticeNo FROM NoticeSharers NS
								JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP
								ON DP.DepartNo = NS.DepartNo
								)
			)
			OR (N.NoticeNo IN (SELECT NSS.NoticeNo FROM NoticeSharers NSS
								WHERE NSS.NoticeNo = N.NoticeNo
								AND UserNo = UserNo
								)
			)
			OR (N.NoticeNo IN (SELECT S.NoticeNo FROM NoticeSharers S
								WHERE S.DepartNo IN (SELECT DepartNo FROM Organization_BelongToDepartment WHERE S.UserNo = UserNo)
							)
			))
			AND (ADMIN > 0 OR  today >= N.STARTDATE);
	--GROUP BY N.DivisionNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
