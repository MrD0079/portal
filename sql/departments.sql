/* Formatted on 25/08/2015 12:11:20 (QP5 v5.227.12220.39724) */
  SELECT z.*,
         fn_query2str ('select count(*) from zlkot@PERS_' || z.manufak, ',')
            store_vac
    FROM departments z
ORDER BY sort