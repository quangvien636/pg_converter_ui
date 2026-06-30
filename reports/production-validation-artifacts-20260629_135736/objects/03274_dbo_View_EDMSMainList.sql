-- ─── VIEW: EDMSMainList ───────────────────────────────
DROP VIEW IF EXISTS public."EDMSMainList";
CREATE OR REPLACE VIEW public."EDMSMainList" AS
SELECT     d.ID, d.Title, d.WriterID, d.RegDate, d.State, d.CheckoutId, d.DepartID, d.Version, d.AuthorityLevel, d.DocLevel, d.EADocFlag, d.ModDate,COALESCE(d.ModDate,d.RegDate) updatedate, d.GroupCode, d.Serial, d.KeyWord, COALESCE(d.Hit, 0) AS Hit,  200 AS EAAuth, d.Summary                      
FROM public.EDMSDocument AS d 
WHERE     (d.Docstate = 0) AND (d.IsDelete = '') AND (d.VersionState = 'Y') AND (d.ValDate > NOW())
;
-- TODO: Owner mapping skipped. Target role postgres not verified.
