<?


require_once 'MDB2.php';
$dsn = 'oci8://persik:razvitie@ZAOIBM';
$db =& MDB2::connect($dsn);
$db->loadModule('Extended');

for ($i=1;$i<=5;$i++)
{
$sql = "
SELECT   SUM (DECODE (r.cmd_val, ".$i.", 1, 0)) cmd_val".$i."
    FROM golos_result r, golos_cmds c
   WHERE r.cmd_id(+) = c.ID AND c.NAME IS NOT NULL
GROUP BY c.NAME, c.ID
ORDER BY SUM (r.cmd_val) desc
";
$vals[$i] = array_values($db->getCol($sql));
//print_r($vals[$i]);
}

$sql = "
SELECT   c.NAME
    FROM golos_result r, golos_cmds c
   WHERE r.cmd_id(+) = c.ID AND c.NAME IS NOT NULL
GROUP BY c.NAME, c.ID
ORDER BY SUM (r.cmd_val) desc
";
$names = $db->getCol($sql);

//print_r($vals1);
//print_r(array_values($vals1));

require_once ("jpgraph/jpgraph.php");
require_once ("jpgraph/jpgraph_bar.php");
 
// We need some data
//$datay=array_values($vals);
 
$graph = new Graph(600,400);    
$graph->SetBox(false);
$graph->SetScale("textlin");
$graph->SetFrame(false);
$graph->img->SetMargin(30,30,120,50);
 
$graph->title->Set("Результаты голосования\nпо оценкам");
$graph->title->SetColor('#8C002F');
$graph->title->SetFont(FF_TIMES,FS_BOLD,24);
 
$graph->xaxis->SetFont(FF_TIMES,FS_BOLD,24);
$graph->xaxis->SetTickLabels(array_values($names));
$graph->xaxis->SetColor('#8C002F');

$graph->yaxis->SetFont(FF_TIMES,FS_BOLD,24);
$graph->yaxis->SetColor('#8C002F');
$graph->yaxis->Hide();


for ($i=5;$i>=1;$i--)
{
$bplot[$i] = new BarPlot($vals[$i]);
$bplot[$i]->SetFillGradient("navy","lightsteelblue",GRAD_MIDVER);
$bplot[$i]->SetColor("navy");
$bplot[$i]->value->Show();
$bplot[$i]->value->SetColor('#8C002F');
$bplot[$i]->value->SetFormat('%d');
$bplot[$i]->value->SetFont(FF_TIMES,FS_BOLD,12);
$bplot[$i]->SetLegend('Оценка '.$i);
}


$bplot[1]->value->SetColor('#8064A2');
$bplot[2]->value->SetColor('#C0504D');
$bplot[3]->value->SetColor('#9BBB59');
$bplot[4]->value->SetColor('#4BACC6');
$bplot[5]->value->SetColor('#F79646');

$bplot[1]->SetColor('#8064A2');
$bplot[2]->SetColor('#C0504D');
$bplot[3]->SetColor('#9BBB59');
$bplot[4]->SetColor('#4BACC6');
$bplot[5]->SetColor('#F79646');

//8064A2, C0504D, 9BBB59, 4BACC6, F79646

$bplot[1]->SetFillGradient("#8064A2","lightsteelblue",GRAD_MIDVER);
$bplot[2]->SetFillGradient("#C0504D","lightsteelblue",GRAD_MIDVER);
$bplot[3]->SetFillGradient("#9BBB59","lightsteelblue",GRAD_MIDVER);
$bplot[4]->SetFillGradient("#4BACC6","lightsteelblue",GRAD_MIDVER);
$bplot[5]->SetFillGradient("#F79646","lightsteelblue",GRAD_MIDVER);

$graph->legend->Pos(0.01,0.01,"right","top");
$graph->legend->SetFont(FF_TIMES,FS_BOLD,12);
$graph->legend->SetColor('#8C002F');
//$graph->legend->SetShadow('gray@0.4',5);


$gbplot = new GroupBarPlot(array_values($bplot));
$gbplot->SetWidth(0.8);

$graph->Add($gbplot);

$graph->Stroke();
?>