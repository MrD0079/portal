<?


//echo phpinfo();


echo $_SERVER["REMOTE_ADDR"]."<br>";
var_dump(filter_input(INPUT_SERVER, "REMOTE_ADDR"));
echo $_SERVER["HTTP_COOKIE"]."<br>";
echo $_COOKIE["PHPSESSID"]."<br>";
echo $_COOKIE["authchallenge"]."<br>";

exit;

//$arr = array('a' => 1, 'b' => 2, 'c' => 3, 'd' => 4, 'e' => 5);
////$arr['a']=$arr;

//echo json_encode($arr);


    $sql=rtrim(file_get_contents('sql/ms_vac_list_ms.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],':rm_tn' => 0,':svms_tn' => 0);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

echo mb_convert_encoding (json_encode(recursive_iconv('Windows-1251','UTF-8',$data), /*JSON_PRETTY_PRINT | */JSON_UNESCAPED_UNICODE),'Windows-1251','UTF-8');

//print_r($data);

//$data = recursive_iconv('Windows-1251','UTF-8',$data);

//$a = ["A",["A","B","C","D"],"C",["A","B","C","D"]];
//echo json_encode($data);
/*
  switch (json_last_error()) {
        case JSON_ERROR_NONE:
            echo ' - No errors';
        break;
        case JSON_ERROR_DEPTH:
            echo ' - Maximum stack depth exceeded';
        break;
        case JSON_ERROR_STATE_MISMATCH:
            echo ' - Underflow or the modes mismatch';
        break;
        case JSON_ERROR_CTRL_CHAR:
            echo ' - Unexpected control character found';
        break;
        case JSON_ERROR_SYNTAX:
            echo ' - Syntax error, malformed JSON';
        break;
        case JSON_ERROR_UTF8:
            echo ' - Malformed UTF-8 characters, possibly incorrectly encoded';
        break;
        default:
            echo ' - Unknown error';
        break;
    }

    echo PHP_EOL;
*/

//echo json_decode($data);
//exit;




/*

$v1=1.1;
$v2=2.2;
$v3=0;
$formula='$v1+$v2+$v2/$v3';
@eval('$x='.$formula.';');
echo $x;
*/

//$x=$v1+$v2+$v2/$v3;

//@$x=1/0;

//echo $x;

?>