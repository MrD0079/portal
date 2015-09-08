/* Formatted on 08/04/2015 18:08:46 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         z.name,
         z.sw_kod,
         TO_CHAR (z.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         TO_CHAR (z.data_end, 'dd.mm.yyyy') data_end,
         z.lu_fio,
         z.nd,
         z.rp,
         z.rf,
         z.login,
         s.password,
         (SELECT wm_concat (DISTINCT mail)
            FROM bud_fil_contacts
           WHERE delivery = 1 AND fil = z.id)
            delivery
    FROM bud_fil z, spr_users s
   WHERE z.id = :fil AND z.login = s.login(+)
ORDER BY z.name