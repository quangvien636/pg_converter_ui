-- ─── TABLE: EASetPopUp ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EASetPopUp" (
    ID serial NOT NULL,
    Mode character varying(50) NOT NULL,
    Conn character varying(500),
    Qry text,
    CountQry text,
    Temp text,
    SearchOption character varying(500),
    Script text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
