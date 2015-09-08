/* Formatted on 23.01.2014 14:15:05 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.tn emp_svid,
                  u.fio emp_name,
                  u.pos_name emp_pos,
                  TO_CHAR (u.datauvol, 'dd.mm.yyyy') datauvol,
                  u.dpt_name
    FROM ol_staff f, user_list u
   WHERE u.tn = f.tn AND f.gruppa between 901 and 999
ORDER BY emp_name