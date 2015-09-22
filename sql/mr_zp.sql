/* Formatted on 22/09/2015 15:52:48 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         h.num,
         z.head_id,
         u.fio svms,
         z.fio_otv,
         z.pin,
         TO_CHAR (z.pin_lu, 'dd.mm.yyyy hh24:mi:ss') pin_lu,
         z.pin_lu_fio
    FROM routes_head h, spr_users u, mr_zp z
   WHERE     h.tn = u.tn
         AND h.data = TO_DATE (:month_list, 'dd.mm.yyyy')
         AND z.head_id = h.id
ORDER BY svms, h.num, z.fio_otv