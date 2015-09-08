<?


require_once 'MDB2.php';
$dsn = 'oci8://persik:razvitie@ZAOIBM';
$db =& MDB2::connect($dsn);
$db->loadModule('Extended');


$sql = "
/* Formatted on 18.10.2011 13:49:19 (QP5 v5.163.1008.3004) */
SELECT
       SUM (DECODE (r.cmd_val, 5, 1, 0)) cmd_val5,
       SUM (DECODE (r.cmd_val, 4, 1, 0)) cmd_val4,
       SUM (DECODE (r.cmd_val, 3, 1, 0)) cmd_val3,
       SUM (DECODE (r.cmd_val, 2, 1, 0)) cmd_val2,
       SUM (DECODE (r.cmd_val, 1, 1, 0)) cmd_val1
  FROM golos_result r
 WHERE r.cmd_id = ".$_REQUEST["id"]."
";
$vals = $db->getRow($sql);



$sql = "select name from golos_cmds where id = ".$_REQUEST["id"]."";
$name = $db->getOne($sql);
//print_r($name);


//print_r($vals);
//print_r(array_values($vals));

require_once ("jpgraph/jpgraph.php");
require_once ("jpgraph/jpgraph_bar.php");
 
// We need some data
$datay=array_values($vals);
 
$graph = new Graph(600,400);    
$graph->SetBox(false);
$graph->SetScale("textlin");
$graph->SetFrame(false);
$graph->img->SetMargin(60,30,120,50);

/*
#8064A2
#C0504D
#9BBB59 
#4BACC6
#F79646
array('#8064A2','#C0504D','#9BBB59', '#4BACC6','#F79646')
*/

$graph->title->Set("Результаты голосования\nза команду \"".$name."\"");
$graph->title->SetColor('#8C002F');
$graph->title->SetFont(FF_TIMES,FS_BOLD,24);
 
$graph->xaxis->title->Set("Оценки");
$graph->xaxis->title->SetFont(FF_TIMES,FS_BOLD,24);
$graph->xaxis->title->SetColor('#8C002F');

$graph->xaxis->SetFont(FF_TIMES,FS_BOLD,24);
$graph->xaxis->SetTickLabels(array(5,4,3,2,1),array('#8064A2','#C0504D','#9BBB59', '#4BACC6','#F79646'));
$graph->xaxis->SetColor('#8C002F');

$graph->yaxis->SetFont(FF_TIMES,FS_BOLD,12);
$graph->yaxis->SetColor('#8C002F');
$graph->yaxis->Hide();

$graph->yaxis->title->Set("Кол-во оценок");
$graph->yaxis->title->SetFont(FF_TIMES,FS_BOLD,24);
$graph->yaxis->title->SetColor('#8C002F');
 
$bplot = new BarPlot($datay,null,null,array('#8064A2','#C0504D','#9BBB59', '#4BACC6','#F79646'));
$bplot->SetWidth(0.5);
 
$bplot->SetFillGradient("#8C002F","lightsteelblue",GRAD_MIDVER);
$bplot->SetColor(array('#8064A2','#C0504D','#9BBB59', '#4BACC6','#F79646'));
$bplot->value->Show();
$bplot->value->SetColor('#8C002F');
$bplot->value->SetFormat('%d');
$bplot->value->SetFont(FF_TIMES,FS_BOLD,24);
//$bplot->SetValuePos('max');
$graph->Add($bplot);
//$graph->SetTheme("earth");
 
// Finally send the graph to the browser
$graph->Stroke();
?>