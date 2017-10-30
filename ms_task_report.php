<?
if (isset($_REQUEST["ms_tasks_list"])){
    $sql = "
/* Formatted on 22.10.2017 17:22:17 (QP5 v5.252.13127.32867) */
  SELECT z.*,
         CASE
            WHEN z.accepted_dt IS NOT NULL
            THEN
               (SELECT COUNT (*) - 1
                  FROM calendar
                 WHERE data BETWEEN z.created_dt AND z.accepted_dt AND is_wd = 1)
         END
            accepted_time, /*Время принятия в работу*/
         completed_dt - accepted_dt work_time, /*Время работы по задаче*/
         CASE WHEN completed_dt <= end_date THEN 1 END completed_in_srok, /*задача выполнена в срок*/
         CASE WHEN accepted - created < 1 THEN 1 END accepted_in_srok, /*своевременно принято в работу*/
         NULL
    FROM (SELECT m.id,
                 a.name ag_name,
                 NVL (us.fio, 'не определен') svms,
                 m.created, /*время создания задачи*/
                 TRUNC (m.created, 'dd') created_dt, /*дата создания задачи*/
                 (SELECT MIN (lu)
                    FROM ms_task_status_log
                   WHERE     status_id = (SELECT id
                                            FROM ms_task_status
                                           WHERE kod = 2)
                         AND task_id = m.id)
                    accepted, /*время принятия задачи СВ МС*/
                 (SELECT TRUNC (MIN (lu), 'dd')
                    FROM ms_task_status_log
                   WHERE     status_id = (SELECT id
                                            FROM ms_task_status
                                           WHERE kod = 2)
                         AND task_id = m.id)
                    accepted_dt, /*дата принятия задачи СВ МС*/
                 (SELECT TRUNC (MIN (lu), 'dd')
                    FROM ms_task_status_log
                   WHERE     status_id = (SELECT id
                                            FROM ms_task_status
                                           WHERE kod = 4)
                         AND task_id = m.id)
                    completed_dt, /*Дата последнего значения Выполнено*/
                 m.end_date,
                 DECODE (LENGTH (m.rfiles), NULL, 0, 1) rfiles_exists
            FROM ms_task m,
                 routes_agents a,
                 cpp,
                 user_list us,
                 ms_task_type t,
                 ms_task_status s
           WHERE     m.ag_id = a.id
                 AND m.kod_tp = cpp.kodtp(+)
                 AND m.svms_tn = us.tn(+)
                 AND m.ttype = t.id(+)
                 AND m.status = s.id(+) /*dt*/
                                       ) z
ORDER BY ag_name, svms, created
         ";
    $p = array("/*dt*/"=>"and trunc(m.created) between to_date('".$_REQUEST["sd"]."','dd.mm.yyyy') and to_date('".$_REQUEST["ed"]."','dd.mm.yyyy')");
    $sql=stritr($sql,$p);
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
    $sql = "select
            svms,
            count(*) c,
            sum(accepted_in_srok) accepted_in_srok,
            round(sum(accepted_in_srok)/count(*)*100,2) accepted_in_srok_perc,
            sum(DECODE (completed_dt, NULL, NULL, 1)) completed_dt,
            round(sum(DECODE (completed_dt, NULL, NULL, 1))/count(*)*100,2) completed_dt_perc,
            sum(completed_in_srok) completed_in_srok,
            round(sum(completed_in_srok)/count(*)*100,2) completed_in_srok_perc,
            null
            from (".$sql.") group by svms order by svms";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('xg', $r);
    $sql = "select
            count(*) c,
            sum(accepted_in_srok) accepted_in_srok,
            round(sum(accepted_in_srok)/count(*)*100,2) accepted_in_srok_perc,
            sum(completed_dt) completed_dt,
            round(sum(completed_dt)/count(*)*100,2) completed_dt_perc,
            sum(completed_in_srok) completed_in_srok,
            round(sum(completed_in_srok)/count(*)*100,2) completed_in_srok_perc,
            null
            from (".$sql.")";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('xgt', $r);
}
$smarty->display('ms_task_report.html');