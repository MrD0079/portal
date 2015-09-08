/* Formatted on 21.02.2013 8:47:15 (QP5 v5.163.1008.3004) */
  SELECT tz.id, tz.addr, n.name
    FROM azl_tz tz, azl_nets n
   WHERE n.id = tz.nets
         AND tz.id IN (SELECT tz.id
                         FROM azl_tz tz,
                              azl_nets an,
                              nets n,
                              azl_contr_avk aca
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
                                       FROM azl_contr_avk
                                      WHERE inn = :tn) <> 0)
ORDER BY n.name, tz.addr