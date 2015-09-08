/* Formatted on 18.02.2013 14:11:45 (QP5 v5.163.1008.3004) */
SELECT *
  FROM (  SELECT fartuk.tstabnum,
                 st.fio fio_ts,
                 fartuk.merchname,
                 fartuk.jur_nazv,
                 fartuk.addr,
                 fartuk.kod_tt,
                 fartuktps.selected,
                 fartuktps.contact_lpr,
                 fartuk.h_custcode_kodtt
            FROM fartuk_tp_select fartuktps,
                 (SELECT DISTINCT TSTABNUM,
                                  MERCHNAME,
                                  CUST_CODE,
                                  KOD_TT,
                                  JUR_NAZV,
                                  ADDR,
                                  H_CUSTCODE_KODTT
                    FROM PERSIK.FARTUK) fartuk,
                 user_list st
           WHERE     fartuk.tstabnum = st.tab_num
                 AND (st.tn =:tn
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND fartuk.h_custcode_kodtt = fartuktps.h_custcode_kodtt(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY fartuk.tstabnum,
                 st.fio,
                 fartuk.merchname,
                 fartuk.jur_nazv,
                 fartuk.addr,
                 fartuk.kod_tt,
                 fartuktps.selected,
                 fartuktps.contact_lpr,
                 fartuk.h_custcode_kodtt
        ORDER BY st.fio, fartuk.merchname, fartuk.jur_nazv)