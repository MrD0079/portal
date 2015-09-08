/* Formatted on 09/04/2015 13:14:18 (QP5 v5.227.12220.39724) */
SELECT fn_getname (prob_tn) prob_name,
       fn_getdolgn (prob_tn) prob_dolgn,
       fn_getname (inst_tn) inst_name,
       fn_getdolgn (inst_tn) inst_dolgn,
       fn_getname (chief_tn) chief_name,
       fn_getdolgn (chief_tn) chief_dolgn,
       fn_getname (dir_tn) dir_name,
       fn_getdolgn (dir_tn) dir_dolgn,
       TO_CHAR (p.data_start, 'dd.mm.yyyy') data_start_t,
       TO_CHAR (p.data_end, 'dd.mm.yyyy') data_end_t,
       p.*
  FROM p_prob_inst p
 WHERE prob_tn = :tn