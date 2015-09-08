<?


require_once 'MDB2.php';
$dsn = 'oci8://persik:razvitie@ZAOIBM';
$db =& MDB2::connect($dsn);
$db->loadModule('Extended');


$sql = "
SELECT   SUM (NVL (r.cmd_val, 0))
    FROM golos_result r, golos_cmds c
   WHERE r.cmd_id(+) = c.ID AND c.NAME IS NOT NULL
GROUP BY c.NAME, c.ID
ORDER BY SUM (r.cmd_val) desc
";
$vals = $db->getCol($sql);


$sql = "
SELECT   c.NAME
    FROM golos_result r, golos_cmds c
   WHERE r.cmd_id(+) = c.ID AND c.NAME IS NOT NULL
GROUP BY c.NAME, c.ID
ORDER BY SUM (r.cmd_val) desc
";
$names = $db->getCol($sql);

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
$graph->img->SetMargin(30,30,80,50);
 
$graph->title->Set("Общие результаты голосования");
$graph->title->SetColor('#8C002F');
$graph->title->SetFont(FF_TIMES,FS_BOLD,24);
 
$graph->xaxis->SetFont(FF_TIMES,FS_BOLD,24);
$graph->xaxis->SetTickLabels(array_values($names),array('#8064A2','#C0504D','#9BBB59', '#4BACC6','#F79646'));
$graph->xaxis->SetColor('#8C002F');
$graph->yaxis->SetFont(FF_TIMES,FS_BOLD,24);
$graph->yaxis->SetColor('#8C002F');
$graph->yaxis->Hide();
 
//$bplot = new BarPlot($datay);
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
 
// Finally send the graph to the browser
$graph->Stroke();
?>