/* Formatted on 23/03/2016 09:54:49 (QP5 v5.252.13127.32867) */
  SELECT c.my,
         c.mt,
         TO_CHAR (c.data, 'dd.mm.yyyy') datat,
         p.id,
         p.name payer_name,
         SUM (i.summa) summa
    FROM invoice i, bud_fil p, calendar c
   WHERE     i.payer = p.id
         AND i.ok_fm = 1
         AND i.invoice_sended = 1
         AND i.promo = 0
         AND i.act_prov_month = c.data
         AND c.y = :y
GROUP BY c.my,
         c.mt,
         c.data,
         p.id,
         p.name
ORDER BY payer_name, my, datat