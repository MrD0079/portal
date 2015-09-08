<?
$goods[0]=30; $goods[1]=50; $goods[2]=100; $goods[3]=70;

$sum=0; foreach($goods as $a) {$sum=$sum+$a;} $count=count($goods)-1; for($i=0;$i<=$count;$i++) {$part[$i]=round($goods[$i]/$sum*500,0);}

$max=max($goods); for($j=0;$j<=$count;$j++) {$column[$j]=round($goods[$j]/$max*100,0);}

header("Content-type: image/png");
$img=ImageCreate(500,200);

$white=ImageColorAllocate($img,255,255,255);
$red=ImageColorAllocate($img,255,0,0);
$green=ImageColorAllocate($img,0,255,0);
$blue=ImageColorAllocate($img,0,0,255);
$gray=ImageColorAllocate($img,128,128,128);
$color=array($red,$green,$blue,$gray);

$x1=0;$x2=0; for($i=0;$i<=$count;$i++) { $x2=$x1+$part[$i]; ImageFilledRectangle($img,$x1,20,$x2,80,$color[$i]); $x1=$x2; }

$x=0; $y=0; $width=50; for($j=0;$j<=$count;$j++) { $y=199-$column[$j]; ImageFilledRectangle($img,$x,$y,$x+$width,199,$color[$j]); $x=$x+$width; }

ImagePNG($img);
?>