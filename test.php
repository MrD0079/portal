<?


send_mail('denis.yakovenko@avk.ua','test','test');


exit;




echo 30 * 5 . 7;
//var_dump(3*4);
exit;

$fn=array(
"new_staff_files/Foto Balasanyan.jpg",
"new_staff_files/foto Aver`yanov.JPG"
);

send_mail('denis.yakovenko@avk.ua','test','test',$fn);


exit;

$a=array(

array('key'=>19326375,'val'=>'!Prilozhenie 4.1. Adresnaya programma (1).xlsx'),
array('key'=>19326375,'val'=>'1opt.jpeg'),
array('key'=>19335212,'val'=>'Kopiya Fakt opt. Prilozhenie 4.1. Adresnaya programma opt (3)-1.xlsx'),
array('key'=>19335212,'val'=>'Scan-131211-0002.jpg'),
array('key'=>19566895,'val'=>'Prilozhenie 2.1. Raschet po zatratam na degustatsiyu po faktu provedeniya.xlsx'),
array('key'=>19566895,'val'=>'TN N9428.jpg'),
array('key'=>19568127,'val'=>'akt spisaniya.jpg'),
array('key'=>19568127,'val'=>'Prilozhenie 2.1. Raschet po zatratam na degustatsiyu po faktu provedeniya.xlsx'),
array('key'=>19584220,'val'=>'Prilozhenie 2.1. Raschet po zatratam na degustatsiyu po faktu provedeniya.xlsx'),
array('key'=>19584220,'val'=>'Prilozhenie 2.2. Otchet po degustatsii.xlsx'),
array('key'=>19584220,'val'=>'TN N2650.jpg'),
array('key'=>19584220,'val'=>'TN N2679.jpg'),
array('key'=>19584220,'val'=>'TN N9815.jpg'),
array('key'=>19608260,'val'=>'Revyakinskoe PO bonus.jpg'),
array('key'=>19608287,'val'=>'noyabr` opt skan.zip'),
array('key'=>19608389,'val'=>'IP Narbaeva.jpg'),
array('key'=>19608513,'val'=>'Prilozhenie 2.1. Raschet po zatratam na degustatsiyu po faktu provedeniya.xlsx'),
array('key'=>19608513,'val'=>'Spar degustatsiya np.jpg'),
array('key'=>19629365,'val'=>'Prilozhenie 2.1. Raschet po zatratam na degustatsiyu po faktu provedeniya.xlsx'),
array('key'=>19629365,'val'=>'Prilozhenie 2.2. Otchet po degustatsii.xlsx'),
array('key'=>19629365,'val'=>'TN N234399.jpeg'),
array('key'=>19631735,'val'=>'aktsiya opt.zip'),
array('key'=>19638648,'val'=>'noyabr`skiy bum LR.zip'),
array('key'=>19640676,'val'=>'vigruzka po aktsii noyabr`skiy bum.zip'),
array('key'=>19640676,'val'=>'vigruzka po aktsii noyabr`skiy bum.zip'),
array('key'=>19647192,'val'=>'degustatsiya noyabr` 2013 969.zip'),
array('key'=>19656762,'val'=>'otchet.zip'),
array('key'=>19679932,'val'=>'TMA_Lipetsk_polki za oktyabr`.rar'),
array('key'=>19715216,'val'=>'otchet kvartira.zip'),
array('key'=>19715216,'val'=>'otchet kvartira.zip'),
array('key'=>19825244,'val'=>'demyanskoe nakladnaya retro za oktyabr`.pdf'),
array('key'=>19828140,'val'=>'marevskoe raypo retro nakladnaya za oktyabr`.pdf'),
array('key'=>19828267,'val'=>'Rosinka nakladnaya za oktyabr`.pdf'),
array('key'=>19828342,'val'=>'starorusskoe raypo retro nakladnaya za oktyabr`.pdf'),
array('key'=>20599865,'val'=>'TMA_Lipetsk_polki za sentyabr`.rar'),
array('key'=>20663447,'val'=>'Adresnaya programma.xls'),
array('key'=>20787457,'val'=>'Akt na spisaniya 1.rar'),
array('key'=>20787457,'val'=>'Raspiska KBR.jpg'),
array('key'=>20787581,'val'=>'Akt spisaniya Kormilitsa.jpeg'),
array('key'=>20811636,'val'=>'Podtverzhdayushchie dokumenti.zip'),


);


foreach ($a as $k=>$v)
{

$pathold="bud_ru_zay_files/sup_doc";
$pathnew="bud_ru_zay_files/".$v["key"]."/sup_doc";
if (!file_exists($pathnew)) {mkdir($pathnew,0777,true);}
copy($pathold."/".$v["val"],$pathnew."/".$v["val"]);

echo $pathold."/".$v["val"]." =>  =>  => ".$pathnew."/".$v["val"]."<br>";

//move_uploaded_file($v1, $path."/".$fn);
}


