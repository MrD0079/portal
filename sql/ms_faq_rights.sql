/* Formatted on 28.02.2018 15:13:30 (QP5 v5.252.13127.32867) */
SELECT p.id, p.name, f.ID fid
  FROM routes_pos p,
       (SELECT *
          FROM ms_faq_rights
         WHERE file_id = :id) f
 WHERE     p.id = f.pos_id(+)
       AND p.id IN (SELECT pos_id
                      FROM spr_users_ms
                     WHERE datauvol IS NULL)