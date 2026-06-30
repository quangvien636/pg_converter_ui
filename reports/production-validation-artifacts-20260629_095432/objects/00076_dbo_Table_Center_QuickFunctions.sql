-- ─── TABLE: Center_QuickFunctions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_QuickFunctions" (
    FunctionNo serial NOT NULL,
    UserNo integer NOT NULL,
    ApplicationNo integer NOT NULL,
    FunctionId character varying(100) NOT NULL,
    IconUrl character varying(200) NOT NULL,
    Name character varying(100) NOT NULL,
    Description character varying(1000) NOT NULL,
    Url character varying(200) NOT NULL,
    IsPopup boolean NOT NULL,
    PopupWidth integer NOT NULL,
    PopupHeight integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
