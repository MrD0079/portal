/* Formatted on 08.11.2012 8:57:20 (QP5 v5.163.1008.3004) */
DECLARE
   subj   VARCHAR2 (255);
BEGIN
   SELECT '��������� ����� ������ - ' || name
     INTO subj
     FROM project
    WHERE id = :prj_id;

   FOR a
      IN (SELECT DISTINCT u.e_mail
            FROM project p1,
                 project p2,
                 project_grant pg,
                 user_list u
           WHERE     p1.id = p2.parent
                 AND p2.id = pg.prj_node_id
                 AND (pg.pos = u.pos_id OR pg.tn = u.tn)
                 AND u.dpt_id = p1.dpt_id
                 AND pg.otv = 1
                 AND u.datauvol IS NULL
                 AND u.e_mail IS NOT NULL
                 AND p1.id = :prj_id)
   LOOP
      PR_SENDMAIL (
         a.e_mail,
         subj,
         '��������� ������, � ������� �� ��������� � �������� ��������������.<br>�� ������ ����������� ������ � �������� �� ���������� �� ������� � ������� <a href="https://ps.avk.ua/?action=project_my">��� ������</a>');
   END LOOP;

   FOR a
      IN (SELECT DISTINCT u.e_mail
            FROM project p1,
                 project p2,
                 project_grant pg,
                 user_list u
           WHERE     p1.id = p2.parent
                 AND p2.id = pg.prj_node_id
                 AND (pg.pos = u.pos_id OR pg.tn = u.tn)
                 AND u.dpt_id = p1.dpt_id
                 AND pg.chk = 1
                 AND u.datauvol IS NULL
                 AND u.e_mail IS NOT NULL
                 AND p1.id = :prj_id)
   LOOP
      PR_SENDMAIL (
         a.e_mail,
         subj,
         '��������� ������, � ������� �� ��������� � �������� ��������������� �����.<br>������, ��� ������� �� ������ �������������� ��� ����� �� ������� � ������� <a href="https://ps.avk.ua/?action=project_report">������� ����� �� �������</a>');
   END LOOP;

   FOR a
      IN (SELECT DISTINCT u1.e_mail
            FROM project p1,
                 project p2,
                 project_grant pg,
                 user_list u,
                 full f,
                 user_list u1
           WHERE     p1.id = p2.parent
                 AND p2.id = pg.prj_node_id
                 AND (pg.pos = u.pos_id OR pg.tn = u.tn)
                 AND u.dpt_id = p1.dpt_id
                 AND pg.otv = 1
                 AND u.tn = f.slave
                 AND u1.dpt_id = p1.dpt_id
                 AND f.full = 1
                 AND u1.tn = f.master
                 AND u.datauvol IS NULL
                 AND u1.e_mail IS NOT NULL
                 AND u1.datauvol IS NULL
                 AND p1.id = :prj_id)
   LOOP
      PR_SENDMAIL (
         a.e_mail,
         subj,
         '��������� ������, � ������� ���� ������ ����������� ��������� � �������� �������������.<br>�� ������ ��������� � ����������� ���������� ����� �� ������� � ������� <a href="https://ps.avk.ua/?action=project_slaves">������ �����������</a>');
   END LOOP;
END;