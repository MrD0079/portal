/* Formatted on 27.08.2013 16:29:10 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         z.tn_chief,
         z.fio,
         z.pos,
         TO_CHAR (z.birthday, 'dd.mm.yyyy') birthday,
         uc.fio chief, z.photo
    FROM football_teams_members z, user_list uc
   WHERE z.team_id = :team_id AND z.tn_chief = uc.tn(+)
ORDER BY z.fio