/* Formatted on 12.06.2014 9:57:47 (QP5 v5.227.12220.39724) */
  SELECT z.*, TO_CHAR (b, 'dd/mm/yyyy') bc
    FROM (SELECT s.*,
                 TO_DATE (
                       TO_CHAR (birthday, 'dd')
                    || '/'
                    || TO_CHAR (birthday, 'mm')
                    || '/'
                    || TO_CHAR (SYSDATE, 'yyyy'),
                    'dd/mm/yyyy')
                    b
            FROM user_list s
           WHERE     datauvol IS NULL
                 AND birthday IS NOT NULL
                 AND dpt_id = :dpt_id
                 AND TO_DATE (
                           TO_CHAR (birthday, 'dd')
                        || '/'
                        || TO_CHAR (birthday, 'mm')
                        || '/'
                        || TO_CHAR (SYSDATE, 'yyyy'),
                        'dd/mm/yyyy') BETWEEN TRUNC (SYSDATE)
                                          AND TRUNC (SYSDATE) + 5
                 AND is_spd = 1
          UNION
          SELECT s.*,
                 TO_DATE (
                       TO_CHAR (birthday, 'dd')
                    || '/'
                    || TO_CHAR (birthday, 'mm')
                    || '/'
                    || TO_CHAR (TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) + 1),
                    'dd/mm/yyyy')
                    b
            FROM user_list s
           WHERE     datauvol IS NULL
                 AND birthday IS NOT NULL
                 AND dpt_id = :dpt_id
                 AND TO_DATE (
                           TO_CHAR (birthday, 'dd')
                        || '/'
                        || TO_CHAR (birthday, 'mm')
                        || '/'
                        || TO_CHAR (TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) + 1),
                        'dd/mm/yyyy') BETWEEN TRUNC (SYSDATE)
                                          AND TRUNC (SYSDATE) + 5
                 AND is_spd = 1) z
ORDER BY b