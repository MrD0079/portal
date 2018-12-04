/* Formatted on 17.09.2012 15:35:39 (QP5 v5.163.1008.3004) */
/*SELECT ROWNUM - 1 num, tn
  FROM (  SELECT tn
            FROM bud_ru_zay_accept
           WHERE z_id = :id
             and child=0
        ORDER BY accept_order)
		*/

/*SELECT ROWNUM - 1 num, tn
  FROM (
    select distinct tn from
      ( SELECT tn, accept_order
            FROM bud_ru_zay_accept
           WHERE z_id = :id
             and child=0
           UNION select 2923402273 , 9999999 as accept_order  FROM Dual
        ORDER BY accept_order))
	*/

SELECT ROWNUM - 1 num, tn
  FROM (
    select tn, MAX(accept_order) accept_order  from
      ( SELECT tn, accept_order
            FROM PERSIK.bud_ru_zay_accept
           WHERE z_id = :id
             and child=0
           UNION select 2923402273 , 9999999 as accept_order  FROM Dual
      )
    GROUP BY tn
   ORDER BY accept_order
  )