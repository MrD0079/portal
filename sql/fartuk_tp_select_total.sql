/* formatted on 18.02.2013 14:10:43 (qp5 v5.163.1008.3004) */
select sum (fartuktps.selected) selected
  from fartuk_tp_select fartuktps,
       (select distinct tstabnum,
                        merchname,
                        cust_code,
                        kod_tt,
                        jur_nazv,
                        addr,
                        h_custcode_kodtt
          from persik.fartuk) fartuk,
       user_list st
 where     fartuk.tstabnum = st.tab_num
                 AND (st.tn =:tn
            or (select nvl (is_traid, 0)
                  from user_list
                 where tn = :tn) = 1)
       and fartuk.h_custcode_kodtt = fartuktps.h_custcode_kodtt(+)
       and st.dpt_id = :dpt_id
       and fartuktps.selected = 1