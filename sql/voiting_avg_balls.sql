/* Formatted on 11/04/2016 15:31:42 (QP5 v5.252.13127.32867) */
/*  SELECT AVG (v.ball1) ball1,
         AVG (v.ball2) ball2,
         AVG (v.ball3) ball3,
         pc.product1,
         pc.product2,
         pc.product3,
         p1.name p1name,
         p2.name p2name,
         p3.name p3name
    FROM voiting v,
         voiting_prod_color pc,
         voiting_prod p1,
         voiting_prod p2,
         voiting_prod p3
   WHERE pc.product1 = p1.id AND pc.product2 = p2.id AND pc.product3 = p3.id
GROUP BY pc.product1,
         pc.product2,
         pc.product3,
         p1.name,
         p2.name,
         p3.name*/
		 
		 /* Formatted on 12/04/2016 10:58:31 (QP5 v5.252.13127.32867) */
  SELECT AVG (v.ball1) ball1,
         AVG (v.ball2) ball2,
         AVG (v.ball3) ball3,
         CASE
            WHEN pc.product1 = 1 THEN 1
            WHEN pc.product2 = 1 THEN 2
            WHEN pc.product3 = 1 THEN 3
         END
            color1,
         CASE
            WHEN pc.product1 = 2 THEN 1
            WHEN pc.product2 = 2 THEN 2
            WHEN pc.product3 = 2 THEN 3
         END
            color2,
         CASE
            WHEN pc.product1 = 3 THEN 1
            WHEN pc.product2 = 3 THEN 2
            WHEN pc.product3 = 3 THEN 3
         END
            color3,
         pc.product1,
         pc.product2,
         pc.product3
    FROM voiting v, voiting_prod_color pc
GROUP BY pc.product1, pc.product2, pc.product3