<?

//echo basename(__FILE__);


//echo "<br>";


//$filename = basename($file,'.'.$info['extension']);

//$info = pathinfo(__FILE__);
//echo pathinfo(__FILE__)["dirname"];
echo pathinfo(__FILE__)["filename"];

//print_r($info);


//echo __LINE__;

/*
$scores = array (5,2,5,7,9);
$scores = array (9,9,5,5,2);
$n = count($scores);
$places = array_fill (0, $n, 0);
arsort($scores); //сортируем
echo "<pre>";
print_r($scores);
print_r($places);
echo "</pre>";
$place = 1; //счетчик
for ($i = 0; $i < $n; $i++)
{
   $places[$i] = $place;
   for ($j = $i+1; $j < $n; $j++)
   {
         if ($scores[$i] == $scores[$j]) {$places[$j]=$place; $i++;}
   }
   $place++;
}
echo "<hr>";
echo "<pre>";
print_r($scores);
print_r($places);
echo "</pre>";
*/
?>