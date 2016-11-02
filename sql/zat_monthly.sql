/* Formatted on 09/04/2015 13:06:08 (QP5 v5.227.12220.39724) */
SELECT ROWNUM,
       m.odometr_start,
       m.odometr_end,
       NVL (odometr_end, 0) - NVL (odometr_start, 0) odometr_delta,
       m.is_accepted,
       m.is_processed,
       tickets,
       amort,
       present_cost,
       stationery,
       media_advert,
       mail,
       conference,
       training_food,
       esv,
       single_tax,
       account_payments,
       mobile,
         NVL (present_cost, 0)
       + NVL (stationery, 0)
       + NVL (media_advert, 0)
       + NVL (mail, 0)
       + NVL (conference, 0)
       + NVL (training_food, 0)
       + NVL (esv, 0)
       + NVL (single_tax, 0)
       + NVL (account_payments, 0)
       + NVL (mobile, 0)
          other_total,
       msg,
       cur_id,
       c.name valuta,m.gbo_warmup_vol,m.gbo_warmup_sum
  FROM zat_monthly m, currencies c
 WHERE     m.tn = :tn
       AND TO_DATE ('01' || '.' || m.m || '.' || m.y, 'dd.mm.yy') =
              TO_DATE (:month_list, 'dd.mm.yyyy')
       AND m.cur_id = c.id(+)