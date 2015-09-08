/* Formatted on 27.08.2013 14:50:52 (QP5 v5.227.12220.39724) */
  SELECT ft.*, d.dpt_name
    FROM football_teams ft, departments d
   WHERE ft.dpt_id = d.dpt_id(+)
ORDER BY d.dpt_name, ft.gruppa, ft.region