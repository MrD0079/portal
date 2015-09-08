/* Formatted on 10.12.2014 20:54:06 (QP5 v5.227.12220.39724) */
SELECT sb.id,
       sb.head_id,
       sb.kod_tp,
       sb.dt,
       sb.lu,
       sb.product,
       sb.qty,
       sb.comm,
       TO_CHAR (sb.srok_god, 'dd.mm.yyyy') srok_god,
       sbh.ok_ms,
       sbh.ok_kk,
       sbh.ok_ms_fio,
       TO_CHAR (sbh.ok_ms_lu, 'dd.mm.yyyy') ok_ms_lu,
       sbh.ok_kk_fio,
       TO_CHAR (sbh.ok_kk_lu, 'dd.mm.yyyy') ok_kk_lu,
       d.product_name_sw,
       comm.name comm_name
  FROM merch_report_sb sb,
       merch_report_sb_head sbh,
       merch_report_sb_comm comm,
       dimproduct d
 WHERE     sb.id = :id
       AND sb.head_id = sbh.head_id
       AND sb.kod_tp = sbh.kod_tp
       AND sb.dt = sbh.dt
       AND sb.comm = comm.id(+)
       AND sb.product = d.product_id(+)