/* Formatted on 21.02.2013 8:50:34 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT p.*
    FROM atd_contr_avk p, atd_tz tz
   WHERE tz.contr_avk = p.id
         AND tz.id IN (SELECT tz.id
                         FROM atd_tz tz,
                              atd_nets an,
                              nets n,
                              atd_contr_avk aca
                        WHERE     tz.nets = an.id
                              AND an.kod = n.sw_kod(+)
                              AND tz.contr_avk = aca.id(+)
                              AND   DECODE ( (SELECT DECODE (NVL (is_mkk, 0) + NVL (is_rmkk, 0), 0, 0, 1)
                                                FROM user_list
                                               WHERE tn = :tn)
                                            + DECODE (DECODE (n.tn_mkk, :tn, 1, 0) + DECODE (n.tn_rmkk, :tn, 1, 0), 0, 0, 1),
                                            2, 1,
                                            0)
                                  + DECODE (aca.inn, :tn, 1, 0)
                                  + (SELECT is_super
                                       FROM atd_contr_avk
                                      WHERE inn = :tn) <> 0)
ORDER BY fio