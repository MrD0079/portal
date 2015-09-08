/* Formatted on 04/09/2015 14:51:32 (QP5 v5.227.12220.39724) */
  SELECT md5hash (a.name) h_name,
         a.name,
         f.full,
         COUNT (*) c
    FROM P_ACTIVITY a, user_list u, full f
   WHERE     u.tn = f.slave
         AND f.master = :tn
         AND a.tab_num = u.tab_num
         AND u.dpt_id = :dpt_id
         AND TRUNC (dt, 'mm') = TRUNC (SYSDATE, 'mm')
         AND a.name IN
                ('СР',
                 'ПО ЭТА',
                 'Полевое обучение ТС/ТМ',
                 'сторчек',
                 'Индивидуальная работа')
GROUP BY a.name, f.full