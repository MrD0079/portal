/* Formatted on 14.01.2013 13:42:06 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c,
       COUNT (*) - SUM (is_act) is_not_act,
       SUM (is_act) is_act,
       SUM (DECODE (is_act, 1, bonus_plan, 0)) bonus_plan,
       SUM (DECODE (is_act, 1, fakt_bonus, 0)) fakt_bonus,
       SUM (ok_ts) ok_ts,
       SUM (ok_chief) ok_chief,
       DECODE (NVL (SUM (DECODE (is_act, 1, sales11 + sales12, 0)), 0), 0, 0, SUM (DECODE (is_act, 1, fakt_bonus, 0)) / SUM (DECODE (is_act, 1, sales11 + sales12, 0)) * 100) act_uah,
       SUM (sales11) sales11,
       SUM (sales12) sales12,
       DECODE (SIGN (DECODE (SUM (sales11), 0, 0, SUM (sales12) / SUM (sales11) * 100 - 100)), 1, DECODE (SUM (sales11), 0, 0, SUM (sales12) / SUM (sales11) * 100 - 100), 0) rost_perc,
       AVG ( (SELECT SUM (bonus)
                FROM val_dec2012_files st
               WHERE     st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)))
          files_bonus_total,
       AVG ( (SELECT SUM (bonus)
                FROM val_dec2012_files st
               WHERE     st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                     AND ok_traid = 1))
          files_bonus_traid
  FROM (SELECT z1.*, DECODE (SIGN (rost_perc - 20), -1, 0, 1) is_act
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
                                 st.tn,
                                 (SELECT SUM (bonus)
                                    FROM val_dec2012_files
                                   WHERE tn = st.tn)
                                    files_bonus_total,
                                 (SELECT COUNT (*)
                                    FROM val_dec2012_files
                                   WHERE tn = st.tn AND ok_traid = 1)
                                    files_bonus_traid
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
                                 st.tn) z) z1)