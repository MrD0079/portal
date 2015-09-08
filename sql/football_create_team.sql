/* Formatted on 27.08.2013 15:38:59 (QP5 v5.227.12220.39724) */
  SELECT ft.*, d.dpt_name, s.color
    FROM football_teams ft, departments d, football_team_status s
   WHERE     ft.dpt_id = d.dpt_id(+)
         AND :tn IN (tn_responsible, tn_checking)
         AND ft.status = s.id(+)
ORDER BY d.dpt_name, ft.gruppa, ft.region