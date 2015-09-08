/* Formatted on 25/06/2015 17:25:44 (QP5 v5.227.12220.39724) */
SELECT    'var DisabledDates={"period":['
       || fn_query2str (
                '
SELECT    ''{ "from": "''
         || TO_CHAR (MIN (c.data), ''dd/mm/yyyy'')
         || ''", "to": "''
         || TO_CHAR (MAX (c.data), ''dd/mm/yyyy'')
         || ''" }''
    FROM bud_svod_taf t,
         bud_tn_fil f,
         user_list u,
         calendar c
   WHERE     t.fil = F.BUD_ID
         AND f.tn = '
             || :tn
             || '
         AND f.bud_id = '
             || :fil
             || '
         AND f.tn = u.tn
         AND TRUNC (c.data, ''mm'') = t.dt
         AND t.ok_db_tn IS NOT NULL
GROUP BY t.dt
ORDER BY t.dt
',
             ',')
       || ']};'
  FROM DUAL