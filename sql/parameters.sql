/* Formatted on 2011/12/22 08:48 (Formatter Plus v4.8.8) */
SELECT p.param_name,
       p.val_number,
       p.val_string,
       TO_CHAR(p.val_date, 'dd.mm.yyyy') val_date,
       p.ID,
       p.lu
  FROM PARAMETERS p
  where dpt_id=:dpt_id
order by p.param_name