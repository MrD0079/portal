/* Formatted on 24.02.2014 9:55:34 (QP5 v5.227.12220.39724) */
  SELECT a1502vk251.tab_num,
         st.fio fio_ts,
         a1502vk251.fio_eta,
         a1502vk251.tp_ur,
         a1502vk251.tp_addr,
         a1502vk251.tp_kod,
         DECODE (a1502vk251tps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1502vk251tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1502vk251.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1502vk251_tp_select a1502vk251tps, a1502vk251, user_list st
   WHERE     a1502vk251.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1502vk251.tp_kod = a1502vk251tps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a1502vk251.tab_num,
         st.fio,
         a1502vk251.fio_eta,
         a1502vk251.tp_ur,
         a1502vk251.tp_addr,
         a1502vk251.tp_kod,
         a1502vk251tps.contact_lpr,
         DECODE (a1502vk251tps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1502vk251.fio_eta, a1502vk251.tp_ur