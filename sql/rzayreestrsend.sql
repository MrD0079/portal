/* Formatted on 22/09/2016 15:27:31 (QP5 v5.252.13127.32867) */
DECLARE
   text     CLOB;
   subj     VARCHAR2 (255);
   attach   CLOB;
BEGIN
   FOR a
      IN (SELECT id,
                 return_mail,
                 ps,
                 pe,
                 CASE
                    WHEN ps = pe
                    THEN
                       cs.mt || ' ' || cs.y
                    ELSE
                       cs.mt || ' ' || cs.y || ' - ' || ce.mt || ' ' || ce.y
                 END
                    period
            FROM (  SELECT p.id,
                           p.return_mail,
                           MIN (r.dt) ps,
                           MAX (r.dt) pe
                      FROM rzay r,
                           nets n,
                           bud_fil p,
                           calendar c
                     WHERE     c.data = r.dt
                           AND n.id_net = r.id_net
                           AND r.payer = p.id
                           AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) =
                                  n.tn_rmkk
                           AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) =
                                  n.tn_mkk
                           AND DECODE ( :nets, 0, n.id_net, :nets) = n.id_net
                           AND r.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                        AND TO_DATE ( :ed, 'dd.mm.yyyy')
                           AND (   :sendstatus = 0
                                OR :sendstatus = r.sendstatus + 1)
                           AND (   :acceptstatus = 0
                                OR :acceptstatus = r.acceptstatus + 1)
                  GROUP BY p.id, p.return_mail) rz,
                 calendar cs,
                 calendar ce
           WHERE cs.data = rz.ps AND ce.data = rz.pe)
   LOOP
      subj :=
            'Возврат по сетевым клиентам за период '
         || a.period;
      text :=
            'Здравствуйте. Ниже представлена информация по "Ключевым клиентам",'
         || ' которые подлежат возврату на склад дистрибутора в период '
         || a.period;
      attach :=
            '<table style="font-size:8pt" border="1" cellpadding="2" cellspacing="0">'
         || '<tr style="font-weight:bold">'
         || '<td>Период</td><td>Сеть</td><td>Адрес ТЗ</td><td>Сканкопии накладных</td>'
         || '<td>Плановая сумма возврата, тыс.грн..</td>'
         || '</tr>';

      FOR b
         IN (  SELECT r.summa,
                      r.id,
                      r.dt,
                      c.mt || ' ' || c.y period,
                      n.net_name,
                      r.tp_name
                 FROM rzay r,
                      nets n,
                      bud_fil p,
                      calendar c
                WHERE     c.data = r.dt
                      AND n.id_net = r.id_net
                      AND r.payer = p.id
                      AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) =
                             n.tn_rmkk
                      AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                      AND DECODE ( :nets, 0, n.id_net, :nets) = n.id_net
                      AND r.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                      AND ( :sendstatus = 0 OR :sendstatus = r.sendstatus + 1)
                      AND (   :acceptstatus = 0
                           OR :acceptstatus = r.acceptstatus + 1)
                      AND r.payer = a.id
             ORDER BY r.dt, n.net_name, r.tp_name)
      LOOP
         UPDATE rzay
            SET sendstatus = 1
          WHERE id = b.id;

         COMMIT;

         attach :=
               attach
            || '<tr><td>'
            || b.period
            || '</td><td>'
            || b.net_name
            || '</td><td>'
            || b.tp_name
            || '</td><td>';

         FOR c IN (SELECT *
                     FROM rzayfiles
                    WHERE rzay = b.id)
         LOOP
            attach :=
                  attach
               || '<a href="https://ps.avk.ua/files/'
               || c.fn
               || '">'
               || c.fn
               || '</a><br>';
         END LOOP;

         attach := attach || '</td><td>' || TO_CHAR (b.summa) || '</td>';
         attach := attach || '</tr>';
      END LOOP;

      attach := attach || '</table>';

      pr_sendmail (a.return_mail,
                   subj,
                   text,
                   clob_to_blob (attach),
                   'attach.html');
   END LOOP;
END;