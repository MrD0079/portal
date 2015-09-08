<?php

if (!isset($_REQUEST["excel"]))
{
	header("Content-Type: text/html; charset=\"windows-1251\"");
	header("Cache-Control: no-store, no-cache,  must-revalidate"); 
	header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
}
else
{
	header("Content-type:application/vnd.ms-excel");
	header("Content-Disposition: attachment; filename=\"".$_REQUEST["filename"].".xls\"");
}

if (!isset($_REQUEST["nohead"])&&!isset($_REQUEST["google"]))
{
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<?
}

if (!isset($_REQUEST["nohead"]))
{
?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=windows-1251"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="-1"/>
<?
}

if (!isset($_REQUEST["print"])&&!isset($_REQUEST["nohead"]))
{
?>
<link type="text/css" rel="stylesheet" href="css3menu/style.css">
<style type="text/css">._css3m{display:none}</style>
<link type="text/css" rel="stylesheet" href="css/portal.css">
<!--[if IE]>
<style type="text/css">
#content-div {width: expression(eval(document.body.clientWidth-10) + "px");}
#bottom-div {width: expression(eval(document.body.clientWidth-10) + "px");}
</style>
<![endif]-->
<?
}

if (!isset($_REQUEST["nohead"]))
{
?>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.maskedinput.min.js"></script>
<script type="text/javascript" src="js/autoNumeric-1.9.27.js"></script>
<script type="text/javascript" src="js/bud_fil_passport.js"></script>
<script type="text/javascript" src="js/portal.js"></script>
<?
}

if (!isset($_REQUEST["nohead"]))
{
?><title>Портал дирекции по продажам АВК</title></head><body>
<link rel="icon" href="design/favicon.ico" type="image/x-icon">
<a id="toTop" href="javascript:void(0);" title="Up"></a>
<?
}

if (!isset($_REQUEST["print"])&&!isset($_REQUEST["nohead"]))
{
	?><div id="head-back-div"></div><?
	?><div id="left-div"><?
	?><!--<img src="design/april1.gif" height="70px">--><?
	if (isset($is_don))
	{
	if ($is_don=='0')
	{
		?><img src="design/logo.png" border="0"/><?
	}
	}
	?></div><?
}

?>