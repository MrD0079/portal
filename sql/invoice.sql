/* Formatted on 2012/02/22 09:01 (Formatter Plus v4.8.8) */
SELECT i.*,
       n.net_name,
       fn_getname ( n.tn_mkk) mkk,
       fn_getname ( n.tn_rmkk) rmkk,
       TO_CHAR(i.DATA, 'dd.mm.yyyy') data_t,
       TO_CHAR(i.lu, 'dd.mm.yyyy hh24:mi:ss') lu_t
  FROM invoice i,
       nets n
 WHERE n.id_net = i.id_net
   AND i.ID = :invoice