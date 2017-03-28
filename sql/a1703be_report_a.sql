/* Formatted on 15/06/2016 13:51:51 (QP5 v5.252.13127.32867) */
  SELECT an.id,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.nakl_summ,
         d.act_nabor_1,
         d.act_nabor_2,
         d.act_nabor_3,
         /* TRUNC (d.act_nabor / 1000) * 100 */
         nvl(d.act_nabor_1,0) * 25 +
         nvl(d.act_nabor_2,0) * 36 +
         nvl(d.act_nabor_3,0) * 36 max_bonus,
         --TRUNC (d.act_nabor / 2) max_bonus2,
         d.tp_addr,
         NVL (an.if1, 0) selected_if1,
         /*case when an.if1 = 2 then d.act_nabor else 0 end sert_cnt,*/
         an.bonus_sum1,
         an.bonus_sum2,
         an.fn,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief_date,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief,
         fn_getname ( (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn
    FROM a1703be d,
         a1703be_action_nakl an,
         user_list st,
         a1703be_tp_select tp
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
                            WHERE master = DECODE ( :tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
         AND d.tp_kod = tp.tp_kod
         AND DECODE ( :eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND NVL (an.if1, 0) > 0
         AND (   ( :ok_bonus = 0)
              OR ( :ok_bonus = 1 AND bonus_dt1 is not null)
              OR ( :ok_bonus = 2 AND bonus_dt1 is null))
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl