/* Formatted on 22.03.2018 18:56:17 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT c.y,
                  c.my,
                  c.mt,
                  z.id,
                  z.dt_start,
                  z.fil,
                  f.name fil_name,
                  zff1.val_string,
                  zff2.val_textarea,
                  NVL (kat.tu, 0) tu
    FROM calendar c,
         bud_ru_zay z,
         user_list u,
         user_list u2,
         BUD_RU_st_ras st,
         BUD_RU_st_ras kat,
         bud_fil f,
         bud_funds fu,
         nets n,
         bud_ru_zay_ff zff1,
         bud_ru_ff ff1,
         bud_ru_zay_ff zff2,
         bud_ru_ff ff2
   WHERE     z.id_net = n.id_net(+)
         AND z.fil = f.id
         AND z.funds = fu.id
         AND z.tn = u.tn
         AND z.recipient = u2.tn
         AND u.dpt_id = :dpt_id
         AND z.st = st.id(+)
         AND z.kat = kat.id(+)
         AND kat.la = 1
         AND z.id = zff1.z_id
         AND zff1.ff_id = ff1.id
         AND ff1.admin_id = 1
         AND z.id = zff2.z_id
         AND zff2.ff_id = ff2.id
         AND ff2.admin_id = 2
         AND (SELECT accepted
                FROM bud_ru_zay_accept
               WHERE     z_id = z.id
                     AND accept_order =
                            DECODE (NVL ( (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE z_id = z.id AND accepted = 2),
                                         0),
                                    0, (SELECT MAX (accept_order)
                                          FROM bud_ru_zay_accept
                                         WHERE z_id = z.id),
                                    (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE z_id = z.id AND accepted = 2))) = 1
         AND valid_no = 0
         AND TRUNC (z.dt_start, 'mm') = c.data
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (    (SELECT NVL (is_ts, 0)
                         FROM user_list
                        WHERE tn = :tn) = 1
                  AND u.tn IN (SELECT slave
                                 FROM full
                                WHERE master = (SELECT parent
                                                  FROM parents
                                                 WHERE tn = :tn))))
         AND (TRUNC (z.dt_start, 'mm') >= ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -5/*1*/))
ORDER BY y,
         my,
         mt,
         id,
         dt_start,
         fil,
         fil_name,
         val_string,
         val_textarea