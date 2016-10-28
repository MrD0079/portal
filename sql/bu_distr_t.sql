SELECT p.id, p.name payer_name, SUM (i.summa) summa
    FROM invoice i, bud_fil p, calendar c
   WHERE     i.payer = p.id
         AND i.ok_fm = 1
         AND i.invoice_sended = 1
         AND i.promo = 0
         AND i.act_prov_month = c.data
         AND c.y = :y
GROUP BY p.id, p.name
ORDER BY payer_name