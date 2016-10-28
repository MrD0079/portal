<?php
function placing($chars, $from=0, $to = 0){
    $cnt = count($chars);
    if(($from == 0) && ($to == 0)){
        $from = 1;
        $to = $cnt;
    }
    if($from == 0) $from = 1;
    if($to == 0) $to = $from;
    if($from < $to){
        $plac = [];
        for($num = $from; $num <= $to; $num++){
            $plac = array_merge($plac, placing(["A","B","C","D"], $num));
        }
    }else{
		print($from." ".$to);
        $plac = [""];   
        for($n = 0; $n < $from; $n++){
            $plac_old = $plac;
            $plac = [];
            foreach($plac_old as $item){
                $last = strlen($item);
                for($m = $n; $m < $cnt; $m++){
                    if($chars[$m] > $item[$last]){
                        $plac[] = $item.$chars[$m];
                    }
                }
            }
        }
    }
    return $plac;
}

$plac = placing(["A","B","C","D"]);
var_dump($plac);
$plac = placing(["A","B","C","D"],2);
var_dump($plac);
$plac = placing(["A","B","C","D"],2,3);
var_dump($plac);
?>