-- ─── TABLE: WorkingTime_AlarmSetting ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_AlarmSetting" (
    Id integer NOT NULL PRIMARY KEY,
    IsAlarm integer,
    Type integer,
    alText character varying(400),
    alTextEn character varying(400),
    alTextJP character varying(400),
    alTextVi character varying(400),
    alTextCi character varying(400)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
