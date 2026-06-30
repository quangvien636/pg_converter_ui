-- ─── TABLE: Orders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Orders" (
OrderId serial NOT NULL,
    UserId integer NOT NULL,
    Amount numeric(18,2) NOT NULL,
    PRIMARY KEY (OrderId),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES public."Users"(Id)
);
-- TODO: Owner mapping skipped. Target role qa_owner not verified.
