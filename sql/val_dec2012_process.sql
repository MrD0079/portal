/* Formatted on 18.12.2012 15:01:18 (QP5 v5.163.1008.3004) */
  SELECT z1.*, DECODE (SIGN (rost_perc - 20), -1, 0, 1) is_act
    FROM (SELECT z.*,
                 DECODE (SIGN (DECODE (sales11, 0, 0, sales12 / sales11 * 100 - 100)), 1, DECODE (sales11, 0, 0, sales12 / sales11 * 100 - 100), 0) rost_perc,
                 DECODE (SIGN (sales12 - sales11), 1, sales12 - sales11, 0) rost_uah,
                 DECODE (SIGN (sales12 - sales11), 1, sales12 - sales11, 0) * 0.2 bonus_plan
            FROM (  SELECT val_dec2012.tab_num,
                           st.fio fio_ts,
                           val_dec2012.fio_eta,
                           val_dec2012.tp_ur,
                           val_dec2012.tp_addr,
                           val_dec2012.tp_kod,
                           NVL (tps.contact_lpr,
                                (SELECT TRIM (contact_tel || ' ' || contact_fio)
                                   FROM routes
                                  WHERE tp_kod = val_dec2012.tp_kod AND ROWNUM = 1))
                              contact_lpr,
                           SUM (CASE WHEN TRUNC (val_dec2012.data, 'mm') = TO_DATE ('01.11.2012', 'dd.mm.yyyy') THEN val_dec2012.summa ELSE 0 END) sales11,
                           SUM (CASE WHEN TRUNC (val_dec2012.data, 'mm') = TO_DATE ('01.12.2012', 'dd.mm.yyyy') THEN val_dec2012.summa ELSE 0 END) sales12,
                           tps.fakt_bonus,
                           tps.ok_traid,
                           tps.ok_ts,
                           tps.ok_chief,
                           fn_getname (
                                        (SELECT parent
                                           FROM parents
                                          WHERE tn = st.tn))
                              parent_fio,
                           (SELECT parent
                              FROM parents
                             WHERE tn = st.tn)
                              parent_tn,
                           TO_CHAR (tps.ok_ts_date, 'dd.mm.yyyy') ok_ts_date,
                           TO_CHAR (tps.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss') ok_chief_date,
                           st.tn
                      FROM val_dec2012_tp_select tps, val_dec2012, user_list st
                     WHERE     val_dec2012.tab_num = st.tab_num
                           AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                           AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                           AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                           AND val_dec2012.tp_kod = tps.tp_kod(+)
                           AND st.dpt_id = :dpt_id
                           AND selected = 1
                           AND DECODE (:ok_traid,  1, 0,  2, 1) = DECODE (:ok_traid,  1, 0,  2, tps.ok_traid)
                           AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) = DECODE (:ok_ts,  1, 0,  2, tps.ok_ts,  3, NVL (tps.ok_ts, 0))
                           AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief,  1, 0,  2, tps.ok_chief,  3, NVL (tps.ok_chief, 0))
                  GROUP BY val_dec2012.tab_num,
                           st.fio,
                           val_dec2012.fio_eta,
                           val_dec2012.tp_ur,
                           val_dec2012.tp_addr,
                           val_dec2012.tp_kod,
                           tps.selected,
                           tps.contact_lpr,
                           tps.fakt_bonus,
                           tps.ok_traid,
                           tps.ok_ts,
                           tps.ok_chief,
                           tps.ok_ts_date,
                           tps.ok_chief_date,
                           st.tn
                  ORDER BY st.fio,
                           val_dec2012.fio_eta,
                           val_dec2012.tp_ur,
                           val_dec2012.tp_addr) z) z1
   WHERE DECODE (:is_act,  1, 0,  2, 1,  3, 0) = DECODE (:is_act, 1, 0, DECODE (SIGN (rost_perc - 20), -1, 0, 1))
ORDER BY fio_ts,
         fio_eta,
         tp_ur,
         tp_addr