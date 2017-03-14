/* Formatted on 14.03.2017 10:55:27 (QP5 v5.252.13127.32867) */
  SELECT x.z_id /*"№ заявки"*/,
         (SELECT persik.wm_concat (DISTINCT m.eta)
            FROM persik.a14mega m
           WHERE     (   (x.tip_tp_id = 100027437 AND m.tp_kod = x.tp_kod)
                      OR (    x.tip_tp_id = 100027436
                          AND m.tp_kod IN (SELECT tp_kod
                                             FROM persik.tp_nets
                                            WHERE net_kod = x.tp_kod)))
                 AND m.dt = x.dt_start
                 AND m.dpt_id = x.dpt_id)
            eta/*"ФИО ЭТА"*/,
         /*x.tip_tp_id,
         x.tip_tp_name,*/
         x.tp_kod /*"Код ТП"*/,
         x.tp_name /*"Название ТП"*/,
         x.zat_fakt /*"Cумма затрат в ценах прайса"*/,
         x.tovarom /*"Товаром"*/,
         x.raz_vipl /*"Разовая выплата согласована"*/,
         x.num_doc /*"Номер документа"*/
    FROM (  SELECT zf.z_id,
                   MAX (CASE WHEN zf.ff_id = 100027438 THEN zf.val_list END)
                      tip_tp_id,
                   MAX (CASE WHEN zf.ff_id = 100027438 THEN zf.val_list_name END)
                      tip_tp_name,
                      MAX (CASE WHEN zf.ff_id = 100027047 THEN zf.val_list END)
                   || MAX (CASE WHEN zf.ff_id = 38477666 THEN zf.val_list END)
                      tp_kod,
                      MAX (
                         CASE WHEN zf.ff_id = 100027047 THEN zf.val_list_name END)
                   || MAX (
                         CASE WHEN zf.ff_id = 38477666 THEN zf.val_list_name END)
                      tp_name,
                   MAX (CASE WHEN zf.ff_id = 19311375 THEN zf.rep_val_number END)
                      zat_fakt,
                   MAX (CASE WHEN zf.ff_id = 66012670 THEN zf.val_bool END)
                      tovarom,
                   MAX (CASE WHEN zf.ff_id = 105129893 THEN zf.val_list_name END)
                      raz_vipl,
                   MAX (
                      CASE WHEN zf.ff_id = 105130090 THEN zf.val_number_int END)
                      num_doc,
                   (SELECT dpt_id
                      FROM persik.user_list
                     WHERE tn = (SELECT tn
                                   FROM persik.bud_ru_zay
                                  WHERE id = zf.z_id))
                      dpt_id,
                   TRUNC ( (SELECT dt_start
                              FROM persik.bud_ru_zay
                             WHERE id = zf.z_id),
                          'mm')
                      dt_start
              FROM persik.bud_ru_zay_ff zf, persik.bud_ru_ff f
             WHERE     zf.z_id IN (SELECT z.id
                                     FROM persik.bud_ru_zay z
                                    WHERE     (SELECT NVL (tu, 0)
                                                 FROM persik.bud_ru_st_ras
                                                WHERE id = z.kat) = 0
                                          AND TRUNC (z.created) BETWEEN TO_DATE (
                                                                           :dates_list1,
                                                                           'dd.mm.yyyy')
                                                                    AND TO_DATE (
                                                                           :dates_list2,
                                                                           'dd.mm.yyyy')
                                          AND report_data IS NOT NULL
                                          AND valid_no = 0
                                          AND z.kat = 114684341
                                          AND report_done = 1)
                   AND zf.ff_id = f.id
          GROUP BY zf.z_id) x
ORDER BY tip_tp_name, tp_name