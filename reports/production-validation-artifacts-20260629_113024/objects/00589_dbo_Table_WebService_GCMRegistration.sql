-- ─── TABLE: WebService_GCMRegistration ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WebService_GCMRegistration" (
    RegNo serial NOT NULL,
    RegID text,
    DateCreate date,
    IsDeleted integer,
    UserNo integer,
    PhoneToken character varying(250),
    AppKey character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
