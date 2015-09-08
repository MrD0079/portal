/* Formatted on 17/12/2014 12:24:44 (QP5 v5.227.12220.39724) */
  SELECT m.*
    FROM dpnr_markets m
   WHERE m.id IN (SELECT m_id
                    FROM dpnr_market_tn
                   WHERE    tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                         OR (SELECT NVL (is_admin, 0)
                               FROM user_list
                              WHERE tn = :tn) = 1)
ORDER BY m.name