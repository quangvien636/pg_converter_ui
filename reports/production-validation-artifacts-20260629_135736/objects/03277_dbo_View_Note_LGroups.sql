-- ─── VIEW: Note_LGroups ───────────────────────────────
DROP VIEW IF EXISTS public."Note_LGroups";
CREATE OR REPLACE VIEW public."Note_LGroups" AS
SELECT  GroupNo, Name, OrderPostion, DayCreate AS DateCreated, DayEdit AS DateChanged, UserNo, Show, Icon, CheckDelete AS IsDefault
FROM     public.Note_Group
;
-- TODO: Owner mapping skipped. Target role postgres not verified.
