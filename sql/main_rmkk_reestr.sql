/* Formatted on 21/05/2018 11:21:35 (QP5 v5.252.13127.32867) */
  SELECT i.y
    FROM invoice i, calendar c, nets n
   WHERE     i.ok_fm = 1
         AND i.ok_rmkk <> 1
         AND c.data = i.data
         AND n.id_net = i.id_net
         AND i.promo = 0
         AND n.tn_rmkk = :tn
GROUP BY i.y
ORDER BY i.y