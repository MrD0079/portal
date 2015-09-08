/* Formatted on 05/12/2014 13:03:37 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT r.cpp1_tz_address
    FROM ms_rep_routes1 r,
         merch_report_sb sb,
         merch_report_sb_comm comm,
         dimproduct d
   WHERE     r.rh_id = sb.head_id
         AND r.rb_kodtp = sb.kod_tp
         AND r.rh_data = TRUNC (sb.dt, 'mm')
         AND sb.comm = comm.id
         AND sb.product = d.product_id
         AND (   r.rh_tn IN (SELECT slave
                               FROM full
                              WHERE master = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1

              OR (SELECT is_kk
                    FROM user_list
                   WHERE tn = :tn) = 1

)
ORDER BY cpp1_tz_address