SELECT p.param_name, p.val_number,
       CASE
          WHEN p.param_name = 'day_for_MAreport'
          THEN
            CASE
              WHEN TRUNC (TO_DATE(:dt,'dd.mm.yyyy'), 'mm') - ADD_MONTHS(TRUNC (sysdate, 'mm'),-1) = 0 AND TO_NUMBER (TO_CHAR (sysdate, 'dd')) <= p.val_number
              THEN 1

              WHEN TRUNC (TO_DATE(:dt,'dd.mm.yyyy'), 'mm') - TRUNC (sysdate, 'mm') >= 0
              THEN 1

              ELSE 0
            END

          WHEN p.param_name = 'access_for_MAreport' AND p.val_number = 1
          THEN 1

          ELSE 0
        END access_edit
  FROM PARAMETERS p
  where dpt_id=1 and p.param_name = 'day_for_MAreport' OR p.param_name = 'access_for_MAreport'
order by p.param_name