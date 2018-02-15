<?

require("class.phpmailer.php");

if(!function_exists("stritr")){
    function stritr($string, $one = NULL, $two = NULL){
        if(  is_string( $one )  ){
		return str_ireplace($one,$two,$string);
        }
        else if(  is_array( $one )  ){
		return str_ireplace(array_keys($one),array_values($one),$string);
        }
        else{
            return $string;
        }
    }
}

function get_new_id(){global $db;return($db->getOne(file_get_contents('sql/get_new_id.sql')));}
function get_new_file_id(){global $db;return($db->getOne(file_get_contents('sql/get_new_file_id.sql')));}
function init_data($v){$v=='' ? $r=null : $r=OraDate2MDBDate($v);return($r);}
function get_month_name($m){global $db;return($db->getOne('SELECT DISTINCT mt FROM calendar WHERE my = '.$m));}

function send_mail($email,$subj,$text,$fn=null,$ok_output_enable = true)
{
        if ($email==null) return;
	$mail = new PHPMailer();
	try
	{
		$mail->IsSMTP();
		$mail->isHTML(true);
		$mail->Host = "mailhub.avk.company";
		$mail->SMTPAuth = false;
		$mail->SetLanguage("ru");
		$mail->ClearAllRecipients();
		$mail->ClearAttachments();
		$mail->From = "robot@avk.ua";
		$mail->FromName = "Портал дирекции по продажам АВК";
		$adrs= explode(",", $email); 
		foreach ($adrs as $adr)
		{
			$mail->AddAddress($adr);
		}
		$mail->Subject = $subj;
		$mail->Body = $text;
		if (is_array($fn))
		{
		foreach ($fn as $file_name)
		{
			if ($file_name!=null)
			{
				if
				(
					file_exists($file_name)
					&&
					is_file($file_name)
					&&
					(filesize($file_name)!=0)
				)
				{
					$mail->AddAttachment($file_name);
				}
			}
		}
		}
		if (!$mail->Send())
		{
			echo "<p><font style=\"color: red;\">".$mail->ErrorInfo."</font></p>";
                        audit_mail(
                                                $mail->ErrorInfo
                                              . "\n"
                                              . 'recipients => '
                                              . join(' ', $adrs)
                                              . "\n"
                                              . 'subject => '
                                              . $subj
                                              . "\n"
                                              . 'MESSAGE => '
                                              . $text);
		}
		else
		{
			if ($ok_output_enable)
			{
				echo "<p><font style=\"color: red;\">письмо отправлено по следующим адресам: \"".$email."\"</font></p>"; 
			}
                                        audit_mail(
                                                'recipients => '
                                              . join(' ', $adrs)
                                              . "\n"
                                              . 'subject => '
                                              . $subj
                                              . "\n"
                                              . 'MESSAGE => '
                                              . $text);
		}
	}
	catch (Exception $e)
	{
		audit('Ошибка отправки почтового письма: '.  $e->getMessage(),'error');
	}
	finally
	{
		$mail->ClearAllRecipients();
		$mail->ClearAttachments();
		unset($mail);
	}
}

function InitRequestVar($Name, $Default = null, $storeSessionVarInDB = false)
{
    global $db,$tn,$login;
    if ($storeSessionVarInDB) {
        $db_session_var = $db->getOne("select val from session_vars where login='$login' and name='$Name'");
        $_SESSION[$Name]=unserialize($db_session_var);
    }
    if (isset($_POST[$Name]))
    {
            $_SESSION[$Name]=$_POST[$Name];
    }
    else
    {
        if (isset($_GET[$Name]))
        {
                $_SESSION[$Name]=$_GET[$Name];
        }
        else
        {
            if (isset($_SESSION[$Name]))
            {
                    $_REQUEST[$Name]=$_SESSION[$Name];
            }
            else
            {
                $_SESSION[$Name]=$Default;
                $_REQUEST[$Name]=$Default;
            }
        }
    }
    if ($storeSessionVarInDB) {
        $keys = array('name'=>$Name,'login'=>$login);
        $vals = array('val'=>serialize($_REQUEST[$Name]));
        Table_Update('session_vars', $keys,$vals);
    }
}

/*
function Field_Update ($table, $field, $value, $where)
{
    global $db;
    // echo $field."=>".$value."<br>";
    $v = stripslashes($value);
    $sql = "select $field from $table where $where";
    $res = $db->GetOne($sql);
    // echo $field."=>".$res."<br>";
    if ($res != $v) {
        // update value
        $sql = "update $table set $field = ? where $where";
        $params = array($v);
        $res = $db->query($sql, $params);
    }
}
*/

function OraDate2MDBDate($v,$format='%Y-%m-%d %H:%M:%S')
{
	if (mb_strlen($v)==0)
	{return("");}
	$sep='/';
	if (count(explode('/', $v))==1)
	{
		$sep='.';
	}
	list($d, $m, $y) = explode($sep, $v);
	$mk=mktime(0, 0, 0, $m, $d, $y);
	return(strftime($format,$mk));
}

/*
function MDBDate2OraDate($v)
{
	if (mb_strlen($v)==0)
	$sep='/';
	if (count(explode('/', $v))==1)
	{
		$sep='.';
	}
	list($d, $m, $y) = explode($sep, $v);
	$mk=mktime(0, 0, 0, $m, $d, $y);
	return(strftime('%Y/%m/%d',$mk));
}
*/

function cube($n)
{
    return(trim(stripslashes($n)));
}

function array_diff_my($a1, $a2)
{
    reset($a1);
    reset($a2);
    $arr_size = count($a1);
    for($i = 0;$i < $arr_size;$i++) {
        $v1 = current($a1);
        $v2 = current($a2);
        if ($v1 != $v2) {
            return false;
        }
        next($a1);
        next($a2);
    }
    return true;
}

function Table_Update ($table/* string */ , $keys/* array(field1=>value1,...)*/ , $values/* array(field1=>value1,...) if $values is empty then only delete */)
{
	global $db,$smarty;
	$k = array();
	$k1 = array();
	$v1 = array();
	foreach ($keys as $key => $val)
	{
		$k[] = $key . "='" . $val."'";
		$k1[] = $key . "=?";
		$v1[] = $val;
	}
	if (count($values) != 0)
	{
		$values = array_map("cube", $values);
		$sql = "select " . implode(", ", array_keys($values)) . " from $table where " . implode(" and ", $k1);
		$res = $db->getRow($sql, null, $v1, null, MDB2_FETCHMODE_ASSOC);
		if ($res)
		{ ////////////////////////////////////////// record exist, updating...
			if (!array_diff_my($res, $values))
			{
				$affectedRows = $db->extended->autoExecute($table, $values, MDB2_AUTOQUERY_UPDATE, implode(" and ", $k));
                                //if ($table=="merch_report"||$table=="merch_report_ok") 
                                    audit("TABLE=".$table."\nKEYS: ".serialize($keys)."\nVALS: ".serialize($values),$table);
			}
		}
		else
		{ ////////////////////////////////////////// record not exist, inserting...
			if (implode("",$values)!="")
			{
				$affectedRows = $db->extended->autoExecute($table, array_merge($keys, $values), MDB2_AUTOQUERY_INSERT);
                                //if ($table=="merch_report"||$table=="merch_report_ok") 
                                    audit("TABLE=".$table."\nKEYS: ".serialize($keys)."\nVALS: ".serialize($values),$table);
			}
		}
	}
	else
	{
			$affectedRows = $db->extended->autoExecute($table, null, MDB2_AUTOQUERY_DELETE, implode(" and ", $k));
                        //if ($table=="merch_report"||$table=="merch_report_ok") 
                            audit("TABLE=".$table."\nKEYS: ".serialize($keys)."\nVALS: ".serialize($values),$table);
	}
	if (isset($affectedRows))
	{
		if (PEAR::isError($affectedRows))
		{
			audit
			(
				"TABLE=".$table.
				"\nKEYS: ".serialize($keys).
				"\nVALS: ".serialize($values).
				"\nERROR: ".$affectedRows->getMessage() . " " . $affectedRows->getDebugInfo()
				,'error'
			);
			$smarty->assign('error', $affectedRows->getMessage() . " " . $affectedRows->getDebugInfo());
			$smarty->display('error.html');
			return false;
		}
	}
	return true;
}

function Bool2Int ($value,$v=0)
{
	if ($v==1)
	{
		$value == "true" ? $Bool2Int = "1" : $Bool2Int = "0" ;
	}
	else
	{
		$value == "on" ? $Bool2Int = "1" : $Bool2Int = "0" ;
	}
	return $Bool2Int;
}

function Int2Text ($value)
{
	$value == 1 ? $Int2Text = "да" : $Int2Text = "нет" ;
	return $Int2Text;
}


function IfEmpty($arg1, $arg2)
{
	if (strlen($arg1) == 0) return $arg2;
	return $arg1;
}



function audit($info = "",$prg = "admin")
{
	global $db,$tn,$login;
	$fields_values = array(
            'login'=>$login,
            'tn'=>$tn,
            'text'=>$info,
            'prg'=>$prg,
            'ip'=>filter_input(INPUT_SERVER, "REMOTE_ADDR")
	);
	$affectedRows = $db->extended->autoExecute('full_log', $fields_values, MDB2_AUTOQUERY_INSERT, null);
}

function audit_mail($info = "")
{
	global $db,$tn,$login;
	$fields_values = array(
            'login'=>$login,
            'tn'=>$tn,
            'text'=>$info,
            'ip'=>filter_input(INPUT_SERVER, "REMOTE_ADDR")
	);
	$affectedRows = $db->extended->autoExecute('full_log_mail', $fields_values, MDB2_AUTOQUERY_INSERT, null);
}

function translit($str)
{
	$t_from = file('translit_from.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
	$t_to = file('translit_to.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
	$a = array_combine($t_from,$t_to);
	$s1 = strtr(mb_convert_encoding($str,"UTF-8","Windows-1251"),$a);
	$s1 = str_replace(" ","_",$s1);
	return str_replace("/","_",$s1);
}

function translit_cgi($str)
{
	$t_from = file('translit_from.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
	$t_to = file('translit_to.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
	$a = array_combine($t_from,$t_to);
	$s1 = strtr($str,$a);
	return $s1;
}

function array_iconv(&$val, $key, $userdata)
{
	//$val = iconv($userdata[0], $userdata[1], $val);
	$val = mb_convert_encoding($val,$userdata[1],$userdata[0]);
	//audit(serialize($userdata),'error');
}

function recursive_iconv($in_charset, $out_charset, $arr)
{
	//$in_charset = $in_charset.'//IGNORE//TRANSLIT';
	//$out_charset = $out_charset."//IGNORE";
	if (!is_array($arr))
	{
		//return iconv($in_charset, $out_charset, $arr);
		return mb_convert_encoding($arr,$out_charset,$in_charset);
	}
	$ret = $arr;
	array_walk_recursive($ret, "array_iconv", array($in_charset, $out_charset));
	return $ret;
}

function getZaySum($zid,$fid){
	global $db;
	return $db->getOne("SELECT getZaySum (".$zid.",".$fid.") FROM DUAL");
}

function getTPType($zid,$fid){
	global $db;
	return $db->getOne("SELECT getTPType (".$zid.",".$fid.") FROM DUAL");
}

?>