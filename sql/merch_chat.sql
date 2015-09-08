/* Formatted on 15.02.2014 20:35:00 (QP5 v5.227.12220.39724) */
  SELECT /*c.*,
         DECODE (u.is_spd, 1, u.fio, NVL (p.comm, c.login)) fio,
         DECODE (u.is_spd, 1, u.e_mail, p.email) email,*/
        '<font style="color:red">'
         || TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss')
         || '</font><br>'
         || '<font style="color:green">'
         || DECODE (u.is_spd, 1, u.fio, NVL (p.comm, c.login))
         || ':</font><br>'
         || '<font style="color:blue">'
         || c.text
         || '</font><br>'
            chat,
         TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         DECODE (u.is_spd, 1, u.fio, NVL (p.comm, c.login)) fio,
         c.text,
         c.id
    FROM merch_chat c, user_list u, routes_agents_pwd p
   WHERE     c.login = u.login
         AND c.login = p.login(+)
         AND c.dt = TO_DATE (:dt, 'dd.mm.yyyy')
         AND c.ag_id = :ag_id
         AND kod_tp = :kod_tp
ORDER BY c.lu