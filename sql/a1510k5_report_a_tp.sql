/* Formatted on 21/09/2015 17:44:25 (QP5 v5.227.12220.39724) */
  SELECT a.tab_num,
         st.fio fio_ts,
         a.fio_eta,
         a.tp_ur,
         a.tp_addr,
         a.tp_kod,
         tp.contact_lpr
    FROM a1510k5_tp_select tp,
         a1510k5 a,
         user_list st,
         a1510k5_flag f
   WHERE     a.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a.tp_kod = tp.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a.h_fio_eta, :eta_list) = a.h_fio_eta
         AND a.tp_kod = f.tp_kod(+) and f.tp_kod is null
         AND TO_NUMBER (TO_CHAR (a.data, 'mm')) = :month
GROUP BY a.tab_num,
         st.fio,
         a.fio_eta,
         a.tp_ur,
         a.tp_addr,
         a.tp_kod,
         tp.contact_lpr
ORDER BY st.fio,
         a.fio_eta,
         a.tp_ur,
         a.tp_addr