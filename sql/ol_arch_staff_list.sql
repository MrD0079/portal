/* Formatted on 10.01.2014 16:50:49 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.tn emp_svid,
                  u.fio emp_name,
                  u.pos_name emp_pos,
                  to_char(u.datauvol,'dd.mm.yyyy') datauvol,
                  u.dpt_name
    FROM free_staff f, user_list u
   WHERE u.tn = f.tn
ORDER BY emp_name