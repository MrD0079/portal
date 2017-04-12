/* Formatted on 12.04.2017 15:32:37 (QP5 v5.252.13127.32867) */
SELECT    'DisabledDates={"period":['
       || fn_query2str (
                '  SELECT    ''{ "from": "''
         || TO_CHAR (MIN, ''dd/mm/yyyy'')
         || ''", "to": "''
         || TO_CHAR (MAX, ''dd/mm/yyyy'')
         || ''" }''
    FROM (SELECT TRUNC (MAX (c.data), ''mm'') MIN, MAX (c.data) MAX
            FROM routes_head h,
                 routes_body1 b,
                 calendar c,
                 merch_report mr,
                 merch_report_ok o,
                 routes_agents a
           WHERE     h.id = b.head_id
                 AND h.data = TRUNC (c.data, ''mm'')
                 AND c.dm = b.day_num
                 AND b.id = mr.rb_id
                 AND c.data = mr.dt
                 AND h.id = o.head_id
                 AND c.data = o.dt
                 AND a.id = b.ag_id
                 AND h.id = '
             || :route
             || '
          UNION
          SELECT MIN (data) - 1, MAX (data)
            FROM calendar
           WHERE TRUNC (data, ''mm'') > (SELECT data
                                         FROM routes_head
                                        WHERE id = '
             || :route
             || ')
          UNION
          SELECT MIN (data), MAX (data) + 1
            FROM calendar
           WHERE TRUNC (data, ''mm'') < (SELECT data
                                         FROM routes_head
                                        WHERE id = '
             || :route
             || '))
ORDER BY MIN',
             ',')
       || ']};'
  FROM DUAL