/* Formatted on 03/03/2015 10:28:40 (QP5 v5.227.12220.39724) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         d.vk_weight,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         d.nakl_summnds,
         CASE
            WHEN d.chanel_type = 1 AND d.vk_weight >= 20 THEN 1
            WHEN d.chanel_type = 2 AND d.vk_weight >= 50 THEN 1
            WHEN d.chanel_type = 3 AND d.vk_weight >= 100 THEN 1
         END
            if1,
         NVL (an.if1, 0) selected_if1,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE tn = (SELECT parent
                         FROM parents
                        WHERE tn = st.tn)
                 AND m = :month and act=:act)
            ok_chief,
         an.bonus_sum1,
         d.H_TP_KOD_DATA_NAKL,
         d.chanel_type,
         d.chanel_type_name
    FROM a1502vk251 d, a1502vk251_action_nakl an, user_list st
   WHERE     d.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, d.H_TP_KOD_DATA_NAKL, 0) =
                DECODE (:tp, 0, an.H_TP_KOD_DATA_NAKL, 0)
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:tp, 0, DECODE (NVL (an.if1, 0), 0, 0, 1), 0) =
                DECODE (:tp, 0, 1, 0)
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl