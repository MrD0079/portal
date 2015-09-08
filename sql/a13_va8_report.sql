/* Formatted on 03.09.2013 10:39:19 (QP5 v5.227.12220.39724) */
  SELECT z1.*, DECODE (SIGN (rost_perc - 40), -1, 0, 1) is_act
    FROM (SELECT z.*,
                 DECODE (
                    SIGN (
                       DECODE (NVL (sum07, 0), 0, 0, sum08 / sum07 * 100 - 100)),
                    -1, 0,
                    DECODE (NVL (sum07, 0), 0, 0, sum08 / sum07 * 100 - 100))
                    rost_perc,
                 DECODE (SIGN (NVL (sum08, 0) - NVL (sum07, 0)),
                         -1, 0,
                         NVL (sum08, 0) - NVL (sum07, 0))
                    rost_uah,
                 NVL (sum08, 0) * 0.05 bonus_plan
            FROM (  SELECT v.tab_num,
                           st.fio fio_ts,
                           v.fio_eta,
                           v.tp_ur,
                           v.tp_addr,
                           v.tp_kod,
                           NVL (vtps.contact_lpr,
                                (SELECT TRIM (contact_tel || ' ' || contact_fio)
                                   FROM routes
                                  WHERE tp_kod = v.tp_kod AND ROWNUM = 1))
                              contact_lpr,
                           sum07,
                             sum08
                           - NVL (sm8.summa, 0)
                           - NVL (ss8.summa, 0)
                           - NVL (sp8.summa, 0)
                              sum08,
                           vtps.fakt_bonus,
                           vtps.ok_traid,
                           vtps.ok_ts,
                           vtps.ok_chief,
                           fn_getname (
                                        (SELECT parent
                                           FROM parents
                                          WHERE tn = st.tn))
                              parent_fio,
                           (SELECT parent
                              FROM parents
                             WHERE tn = st.tn)
                              parent_tn,
                           TO_CHAR (vtps.ok_ts_date, 'dd.mm.yyyy') ok_ts_date,
                           TO_CHAR (vtps.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss')
                              ok_chief_date,
                           st.tn
                      FROM a13_va8_tp_select vtps,
                           a13_va8 v,
                           user_list st,
                           (  SELECT a.tp_kod, SUM (a.summa) summa
                                FROM a13_sm8 a,
                                     a13_sm8_tp_select t,
                                     a13_sm8_action_nakl n
                               WHERE     TRUNC (a.data, 'mm') =
                                            TO_DATE ('01.08.2013', 'dd.mm.yyyy')
                                     AND A.TP_KOD = T.TP_KOD
                                     AND T.SELECTED = 1
                                     AND A.H_TP_KOD_DATA_NAKL =
                                            N.H_TP_KOD_DATA_NAKL
                                     AND NVL (n.if1, 0) + NVL (n.if2, 0) > 0
                            GROUP BY a.tp_kod) sm8,
                           (  SELECT a.tp_kod, SUM (a.summa) summa
                                FROM a13_ss8 a,
                                     a13_ss8_tp_select t,
                                     a13_ss8_action_nakl n
                               WHERE     TRUNC (a.data, 'mm') =
                                            TO_DATE ('01.08.2013', 'dd.mm.yyyy')
                                     AND A.TP_KOD = T.TP_KOD
                                     AND T.SELECTED = 1
                                     AND A.H_TP_KOD_DATA_NAKL =
                                            N.H_TP_KOD_DATA_NAKL
                                     AND NVL (n.if1, 0) + NVL (n.if2, 0) > 0
                            GROUP BY a.tp_kod) ss8,
                           (  SELECT a.tp_kod, SUM (a.summa) summa
                                FROM a13_sp8 a,
                                     a13_sp8_tp_select t,
                                     a13_sp8_action_nakl n
                               WHERE     TRUNC (a.data, 'mm') =
                                            TO_DATE ('01.08.2013', 'dd.mm.yyyy')
                                     AND A.TP_KOD = T.TP_KOD
                                     AND T.SELECTED = 1
                                     AND A.H_TP_KOD_DATA_NAKL =
                                            N.H_TP_KOD_DATA_NAKL
                                     AND NVL (n.if1, 0) + NVL (n.if2, 0) > 0
                            GROUP BY a.tp_kod) sp8
                     WHERE     v.tab_num = st.tab_num
                           AND st.tn IN
                                  (SELECT slave
                                 FROM full
                                WHERE master =
                                             DECODE (
                                                :exp_list_without_ts,
                                                0, DECODE (
                                                      :tn,
                                                      -1, (SELECT MAX (tn)
                                                             FROM user_list
                                                            WHERE is_admin = 1),
                                                      :tn),
                                                :exp_list_without_ts))
                           AND st.tn IN
                                  (SELECT slave
                                 FROM full
                                WHERE master =
                                             DECODE (
                                                :exp_list_only_ts,
                                                0, DECODE (
                                                      :tn,
                                                      -1, (SELECT MAX (tn)
                                                             FROM user_list
                                                            WHERE is_admin = 1),
                                                      :tn),
                                                :exp_list_only_ts))
                           AND (   st.tn IN
                                      (SELECT slave
                                         FROM full
                                        WHERE master =
                                                 DECODE (
                                                    :tn,
                                                    -1, (SELECT MAX (tn)
                                                           FROM user_list
                                                          WHERE is_admin = 1),
                                                    :tn))
                                OR (SELECT NVL (is_traid, 0)
                                      FROM user_list
                                     WHERE tn =
                                              DECODE (:tn,
                                                      -1, (SELECT MAX (tn)
                                                             FROM user_list
                                                            WHERE is_admin = 1),
                                                      :tn)) = 1)
                           AND v.tp_kod = vtps.tp_kod
                           AND v.tp_kod = sm8.tp_kod(+)
                           AND v.tp_kod = ss8.tp_kod(+)
                           AND v.tp_kod = sp8.tp_kod(+)
                           AND st.dpt_id = :dpt_id
                           AND vtps.selected = 1
                           AND DECODE (:eta_list, '', v.h_fio_eta, :eta_list) =
                                  v.h_fio_eta
                           AND DECODE (:ok_traid,  1, 0,  2, 1) =
                                  DECODE (:ok_traid,  1, 0,  2, vtps.ok_traid)
                           AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) =
                                  DECODE (:ok_ts,
                                          1, 0,
                                          2, vtps.ok_ts,
                                          3, NVL (vtps.ok_ts, 0))
                           AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
                                  DECODE (:ok_chief,
                                          1, 0,
                                          2, vtps.ok_chief,
                                          3, NVL (vtps.ok_chief, 0))
                           AND v.tp_kod = vtps.tp_kod
                           AND st.dpt_id = :dpt_id
                           AND vtps.selected = 1
                  ORDER BY st.fio,
                           v.fio_eta,
                           v.tp_ur,
                           v.tp_addr) z) z1
   WHERE DECODE (:is_act,  1, 0,  2, 1,  3, 0) =
            DECODE (:is_act, 1, 0, DECODE (SIGN (rost_perc - 40), -1, 0, 1))
ORDER BY fio_ts,
         fio_eta,
         tp_ur,
         tp_addr