/* Formatted on 12/22/2015 2:07:59  (QP5 v5.252.13127.32867) */
SELECT                              /*COUNT (DISTINCT an.H_client) cnt_nakl,*/
      COUNT (DISTINCT client) cnt_client,
       SUM (DECODE (bonus_dt1, NULL, NULL, bonus_sum1)) bonus_sum,
       SUM (DECODE (bonus_dt1, NULL, NULL, 1)) bonus_dt_cnt,
       SUM (ok_chief) ok_chief,
         DECODE (
            NVL (SUM (CASE WHEN perc >= 100 THEN sales END), 0),
            0, 0,
            (SUM (bonus_sum1)) / SUM (CASE WHEN perc >= 100 THEN sales END))
       * 100
          zat,
       SUM (plan) plan,
       SUM (sales) sales,
       SUM (bonus) bonus,
       SUM (CASE WHEN perc >= 100 THEN 1 END) cnt_act_client
  FROM (  SELECT wm_concat (DISTINCT fn_getname ( (SELECT parent
                                                     FROM parents
                                                    WHERE tn = st.tn)))
                    parent_fio,
                 wm_concat (DISTINCT (SELECT parent
                                             FROM parents
                                            WHERE tn = st.tn))
            parent_tn,
         wm_concat (DISTINCT st.fio) ts_fio,
                 wm_concat (DISTINCT d.fio_eta) fio_eta,
                 sp.client,
                 sp.h_client,
                 DECODE (an.id, NULL, 0, 1) selected,
                 an.bonus_sum1,
                 TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
                          wm_concat (DISTINCT (SELECT TO_CHAR (max(lu), 'dd.mm.yyyy hh24:mi:ss') lu
                                FROM ACT_OK
                               WHERE     tn = (SELECT parent
                                                 FROM parents
                                                WHERE tn = st.tn)
                                     AND m = :month
                                     AND act = :act /*and fil=an.fil*/))
            ok_chief_date,
         wm_concat (DISTINCT (SELECT DECODE (max(lu), NULL, 0, 1)
                                FROM ACT_OK
                               WHERE     tn = (SELECT parent
                                                 FROM parents
                                                WHERE tn = st.tn)
                                     AND m = :month
                                     AND act = :act /*and fil=an.fil*/))
            ok_chief,

                 COUNT (*) c,
                 sp.plan * 1000 plan,
                 sp.bonus,
                 SUM (d.act_summ) sales,
                 GREATEST (
                    0,
                    DECODE (NVL (sp.plan * 1000, 0),
                            0, 0,
                            SUM (d.act_summ) / (sp.plan * 1000) * 100))
                    perc,
                 COUNT (DISTINCT d.tp_kod) tp_cnt
            FROM A1512T_XLS_SALESPLAN sp,
                 A1512T_XLS_TPCLIENT tp,
                 a1512t d,
                 A1512t_ACTION_CLIENT an,
                 user_list st
           WHERE     d.tab_num = st.tab_num
                 AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master =
                                             DECODE ( :tn, -1, master, :tn))
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
                 AND tp.tp_kod = d.tp_kod
                 AND sp.H_client = tp.H_client
                 AND sp.H_client = an.H_client(+)
                 AND DECODE ( :eta_list, '', d.h_fio_eta, :eta_list) =
                        d.h_fio_eta
                 AND DECODE ( :ok_bonus,  1, 0,  2, 1,  3, 0) =
                        DECODE ( :ok_bonus,
                                1, 0,
                                2, DECODE (an.bonus_dt1, NULL, 0, 1),
                                3, DECODE (an.bonus_dt1, NULL, 0, 1))
        GROUP BY sp.client,
                 sp.h_client,
                 an.id,
                 an.bonus_sum1,
                 an.bonus_dt1,
                 sp.plan,
                 sp.bonus
          HAVING :ok_plan =
                    DECODE (
                       :ok_plan,
                       1, 1,
                       2, CASE
                             WHEN GREATEST (
                                     0,
                                     DECODE (
                                        NVL (sp.plan * 1000, 0),
                                        0, 0,
                                          SUM (d.act_summ)
                                        / (sp.plan * 1000)
                                        * 100)) >= 100
                             THEN
                                2
                          END,
                       3, CASE
                             WHEN GREATEST (
                                     0,
                                     DECODE (
                                        NVL (sp.plan * 1000, 0),
                                        0, 0,
                                          SUM (d.act_summ)
                                        / (sp.plan * 1000)
                                        * 100)) < 100
                             THEN
                                3
                          END)
        ORDER BY parent_fio,
                 ts_fio,
                 fio_eta,
                 sp.client)