<?



($_REQUEST['field']=='status_lu')?$x=$db->getOne("select to_char(status_lu,'dd.mm.yyyy hh24:mi:ss') from distr_prot where id=".$_REQUEST['id']):null;
($_REQUEST['field']=='status_fio')?$x=$db->getOne('select status_fio from distr_prot where id='.$_REQUEST['id']):null;
($_REQUEST['field']=='ok_chief_lu')?$x=$db->getOne("select to_char(ok_chief_lu,'dd.mm.yyyy hh24:mi:ss') from distr_prot where id=".$_REQUEST['id']):null;
($_REQUEST['field']=='ok_chief_fio')?$x=$db->getOne('select ok_chief_fio from distr_prot where id='.$_REQUEST['id']):null;
($_REQUEST['field']=='ok_dpu_lu')?$x=$db->getOne("select to_char(ok_dpu_lu,'dd.mm.yyyy hh24:mi:ss') from distr_prot where id=".$_REQUEST['id']):null;
($_REQUEST['field']=='ok_dpu_fio')?$x=$db->getOne('select ok_dpu_fio from distr_prot where id='.$_REQUEST['id']):null;
($_REQUEST['field']=='ok_nm_lu')?$x=$db->getOne("select to_char(ok_nm_lu,'dd.mm.yyyy hh24:mi:ss') from distr_prot where id=".$_REQUEST['id']):null;
($_REQUEST['field']=='ok_nm_fio')?$x=$db->getOne('select ok_nm_fio from distr_prot where id='.$_REQUEST['id']):null;


echo $x;

?>