/* Formatted on 28.08.2013 17:01:37 (QP5 v5.227.12220.39724) */
  SELECT ft.*, d.dpt_name, s.color
    FROM football_teams ft, departments d, football_team_status s
   WHERE     ft.dpt_id = d.dpt_id(+)
         AND ft.status = s.id(+)
         AND ft.status = 15597783
ORDER BY d.dpt_name, ft.gruppa, ft.region