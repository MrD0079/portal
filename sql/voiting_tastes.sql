/* Formatted on 11/04/2016 14:58:41 (QP5 v5.252.13127.32867) */
  SELECT u.fio,
           DECODE (v.product1, pc.product1, 1, 0)
         + DECODE (v.product2, pc.product2, 1, 0)
         + DECODE (v.product3, pc.product3, 1, 0)
            same
    FROM voiting v, voiting_prod_color pc, user_list u
   WHERE v.tn = u.tn
ORDER BY same DESC, fio