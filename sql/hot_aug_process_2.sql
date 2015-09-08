/* Formatted on 19.08.2012 12:54:35 (QP5 v5.173.1008.3004) */
  SELECT z.*,
         DECODE (SIGN (DECODE (sales7, 0, 0, sales8 / sales7 * 100 - 100)),
                 1, DECODE (sales7, 0, 0, sales8 / sales7 * 100 - 100),
                 0)
            rost_perc,
         DECODE (SIGN (sales8 - sales7), 1, sales8 - sales7, 0) rost_uah,
         DECODE (SIGN (sales8 - sales7), 1, sales8 - sales7, 0) * 0.2
            bonus_plan
    FROM (  SELECT hot_aug.tab_num,
                   st.fio fio_ts,
                   hot_aug.fio_eta,
                   hot_aug.tp_ur,
                   hot_aug.tp_addr,
                   hot_aug.tp_kod,
                   hot_augtps.selected2,
                   NVL (hot_augtps.contact_lpr,
                        (SELECT TRIM (contact_tel || ' ' || contact_fio)
                           FROM routes
                          WHERE tp_kod = hot_aug.tp_kod AND ROWNUM = 1))
                      contact_lpr,
                   /*hot_augtps.tp_kat,*/
                   SUM (
                      CASE
                         WHEN TRUNC (hot_aug.data, 'mm') =
                                 TO_DATE ('01.07.2012', 'dd.mm.yyyy')
                         THEN
                            hot_aug.summa
                         ELSE
                            0
                      END)
                      sales7,
                   SUM (
                      CASE
                         WHEN TRUNC (hot_aug.data, 'mm') =
                                 TO_DATE ('01.08.2012', 'dd.mm.yyyy')
                         THEN
                            hot_aug.summa
                         ELSE
                            0
                      END)
                      sales8,
                      hot_augtps.fakt_bonus
              FROM hot_aug_tp_select hot_augtps,
                   hot_aug,
                   user_list st,
                   hot_aug_action_nakl an
             WHERE     hot_aug.tab_num = st.tab_num
                   AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                   AND st.tn = :tn
                   AND hot_aug.tp_kod = hot_augtps.tp_kod(+)
                   AND st.dpt_id = :dpt_id
                   AND selected = 1
                   AND hot_aug.tp_kod = an.tp_kod(+)
                   AND hot_aug.nakl = an.nakl(+)
                   AND an.nakl IS NULL
                   AND DECODE (:pt,  1, 0,  2, 1,  3, 0) =
                          DECODE (:pt,
                                  1, 0,
                                  NVL (selected2, 0), 3,
                                  NVL (selected2, 0))
                   AND DECODE (:eta_list, '', hot_aug.fio_eta, :eta_list) = hot_aug.fio_eta
          GROUP BY hot_aug.tab_num,
                   st.fio,
                   hot_aug.fio_eta,
                   hot_aug.tp_ur,
                   hot_aug.tp_addr,
                   hot_aug.tp_kod,
                   hot_augtps.selected,
                   hot_augtps.selected2,
                   hot_augtps.contact_lpr,
                   hot_augtps.fakt_bonus
          ORDER BY st.fio,
                   hot_aug.fio_eta,
                   hot_aug.tp_ur,
                   hot_aug.tp_addr) z
ORDER BY fio_ts,
         fio_eta,
         tp_ur,
         tp_addr