-- ─── TABLE: EAPPPopup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPPopup" (
    PopName character varying(50) NOT NULL PRIMARY KEY,
    Script text,
    Html text,
    Conn character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
