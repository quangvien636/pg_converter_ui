INSERT INTO public."Orders" (userid, amount)
VALUES (1, 25.50)
RETURNING orderid, userid, amount;
