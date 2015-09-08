<?php

header("Content-Type: text/html; charset=\"windows-1251\"");
putenv("NLS_LANG=RUSSIAN_CIS.CL8MSWIN1251");


define('ZAOAVK','(DESCRIPTION =    (ADDRESS_LIST =      (ADDRESS = (PROTOCOL = TCP)(PORT = 1521)(HOST = oracle1.avk.company))    )    (CONNECT_DATA =      (SERVICE_NAME = ZAOAVK)      (SERVER = DEDICATED)    )  )');
define('ZAOIBM','(DESCRIPTION =    (ADDRESS_LIST =      (ADDRESS = (PROTOCOL = TCP)(PORT = 1521)(HOST = oracle2.avk.company))    )    (CONNECT_DATA =      (SERVICE_NAME = ZAOAVK)      (SERVER = DEDICATED)    )  )');

//define('ZAOAVK','(DESCRIPTION =    (ADDRESS_LIST =      (ADDRESS = (PROTOCOL = TCP)(PORT = 1521)(HOST = 192.168.4.253))    )    (CONNECT_DATA =      (SERVICE_NAME = ZAOAVK)      (SERVER = DEDICATED)    )  )');
//define('ZAOWH','(DESCRIPTION =    (ADDRESS_LIST =      (ADDRESS = (PROTOCOL = TCP)(PORT = 1521)(HOST = 192.168.4.242))    )    (CONNECT_DATA =      (SERVICE_NAME = ZAOWH)      (SERVER = DEDICATED)    )  )');
//define('ZAOIBM','(DESCRIPTION =    (ADDRESS_LIST =      (ADDRESS = (PROTOCOL = TCP)(PORT = 1521)(HOST = 10.2.10.242))    )    (CONNECT_DATA =      (SERVICE_NAME = ZAOWH)      (SERVER = DEDICATED)    )  )');

require('smarty_init.php');

function print_array($val, $level = 0)
{
	foreach ($val as $key=>$value)
	{
		if (is_array($value))
		{
			echo str_pad("",$level*3)."[".$key."] => ARRAY\n";
			print_array($value,$level+1);
		}
		else
		{
			echo str_pad("",$level*3)."[".$key."] => ".$value."\n";
		}
	}
}

function ses_req()
{
?>
<div ondblclick="
$(this).width(500-$(this).width());
$(this).height(500-$(this).height());
"
name="debug_div"
id="debug_div"
align=left
style="
	z-index:999;
	background: white;
	padding: 0px;
	border:1px dotted gray;
	color: rgb(255, 0, 0);
	position:fixed;
	right:0px;
	bottom:0px;
	width:20px;
	height:20px;
	overflow:auto;
"
>
<pre style="font-size:9;">
******* REQUEST *******
<?print_array($_REQUEST);?>
<br>
******* FILES *******
<?print_array($_FILES);?>
<br>
******* SESSION *******
<?print_array($_SESSION);?>
</pre>
</div>
<?
}

function recursive_remove_directory($directory, $empty=FALSE)
{
	if(substr($directory,-1) == '/')
	{
		$directory = substr($directory,0,-1);
	}
	if(!file_exists($directory) || !is_dir($directory))
	{
		return FALSE;
	}elseif(is_readable($directory))
	{
		$handle = opendir($directory);
		while (FALSE !== ($item = readdir($handle)))
		{
			if($item != '.' && $item != '..')
			{
				$path = $directory.'/'.$item;
				if(is_dir($path)) 
				{
					recursive_remove_directory($path);
				}else{
					unlink($path);
				}
			}
		}
		closedir($handle);
		if($empty == FALSE)
		{
			if(!rmdir($directory))
			{
				return FALSE;
			}
		}
	}
	return TRUE;
}


?>