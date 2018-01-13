/* Formatted on 12.01.2018 13:15:18 (QP5 v5.252.13127.32867) */
SELECT COUNT (id) c
  FROM bud_ru_zay
 WHERE     (SELECT NVL (tu, 0)
              FROM bud_ru_st_ras
             WHERE id = bud_ru_zay.kat) = :tu
       AND (   get_bud_ru_zay_cur_acceptor_tn (bud_ru_zay.id) = :tn
            OR bud_ru_zay.tn = :tn
            OR ( (SELECT accept_order
                    FROM bud_ru_zay_accept
                   WHERE     z_id = bud_ru_zay.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM bud_ru_zay_accept
                                  WHERE z_id = bud_ru_zay.id AND accepted = 0)) >=
                   (SELECT accept_order
                      FROM bud_ru_zay_accept
                     WHERE z_id = bud_ru_zay.id AND tn = :tn)))
       AND DECODE ( (SELECT COUNT (*)
                       FROM bud_ru_zay_accept
                      WHERE z_id = bud_ru_zay.id AND accepted = 2),
                   0, 0,
                   1) = 0
       AND get_bud_ru_zay_cur_status (bud_ru_zay.id) <> 1
       AND bud_ru_zay.valid_no = 0
       AND get_bud_ru_zay_cur_acceptor_tn (bud_ru_zay.id) = :tn