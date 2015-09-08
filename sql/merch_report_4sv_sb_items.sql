/* Formatted on 10.12.2014 19:50:44 (QP5 v5.227.12220.39724) */
  SELECT d.product_name_sw,
         sb.qty,
         comm.name comm_name,
         TO_CHAR (sb.srok_god, 'dd.mm.yyyy') srok_god
    FROM merch_report_sb sb, merch_report_sb_comm comm, dimproduct d
   WHERE     sb.head_id = :head_id
         AND sb.kod_tp = :kod_tp
         AND sb.dt = TO_DATE (:dt, 'dd.mm.yyyy')
         AND sb.comm = comm.id
         AND sb.product = d.product_id
         AND DECODE (:vp, 0, 0, sb.product) = DECODE (:vp, 0, 0, :vp)
ORDER BY d.product_name_sw