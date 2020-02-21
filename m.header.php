<?php

if (isset($_REQUEST["excel"]))
{
	header("Content-type:application/vnd.ms-excel");
	header("Content-Disposition: attachment; filename=\"".$_REQUEST["filename"].".xls\"");
}
else
if (isset($_REQUEST["google"]))
{
}
else
{
    //header('X-Frame-Options: ALLOW-FROM bitrix.avk.ua');
    //header_remove("X-Frame-Options");
    header("Content-Type: text/html; charset=\"windows-1251\"");
    header("Cache-Control: no-store, no-cache,  must-revalidate"); 
    header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
}

if (!isset($_REQUEST["nohead"])&&!isset($_REQUEST["google"]))
{
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<?
}

if (!isset($_REQUEST["nohead"])&&!isset($_REQUEST["google"]))
//if (!isset($_REQUEST["nohead"]))
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
<link rel="stylesheet" href="js/chosen/chosen.min.css"> <!--chosen css-->
<link rel="stylesheet" href="css/select2/select2.min.css">
<link type="text/css" rel="stylesheet" href="css3menu/style.css">
<style type="text/css">._css3m{display:none}</style>
<link type="text/css" rel="stylesheet" href="css/portal.css?<?php echo filemtime( 'css/portal.css' )?>">
<link href="css/noty.css" rel="stylesheet" />
<!--[if IE]>
<style type="text/css">
#content-div {width: expression(eval(document.body.clientWidth-10) + "px");}
#bottom-div {width: expression(eval(document.body.clientWidth-10) + "px");}
</style>
<![endif]-->
<?
}

if (!isset($_REQUEST["nohead"])&&!isset($_REQUEST["google"]))
//if (!isset($_REQUEST["nohead"]))
{
?>
<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" href="css/smoothness/jquery-ui.css">
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/datepicker-ru-cp1251.js"></script>
<script type="text/javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.maskedinput.min.js"></script>
<script type="text/javascript" src="js/autoNumeric-1.9.27.js"></script>
<script type="text/javascript" src="js/bud_fil_passport.js"></script>
<script type="text/javascript" src="js/portal.js?<?php echo filemtime( 'js/portal.js' )?>"></script>
<script type="text/javascript" src="js/noty.min.js"></script>
<?
if (!isset($_REQUEST["print"]))
{
?>
<script type="text/javascript" src="js/tinymce/tinymce.min.js"></script>
<script type="text/javascript" src="js/jscolor/jscolor.js"></script>
<script type="text/javascript">
tinymce.init({
        selector: ".WYSIWYG",
        plugins: [
                "advlist autolink autosave link image lists charmap print preview hr anchor pagebreak spellchecker",
                "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
                "table contextmenu directionality emoticons template textcolor paste fullpage textcolor colorpicker textpattern",
                "save"
        ],
        //autosave_ask_before_unload: false,
        toolbar1: "newdocument fullpage | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | styleselect formatselect fontselect fontsizeselect",
        toolbar2: "cut copy paste | searchreplace | bullist numlist | outdent indent blockquote | undo redo | link unlink anchor image media code | insertdatetime preview | forecolor backcolor",
        toolbar3: "table | hr removeformat | subscript superscript | charmap emoticons | print fullscreen | ltr rtl | spellchecker | visualchars visualblocks nonbreaking template pagebreak restoredraft",
        //toolbar4: "save",
        menubar: false,
        toolbar_items_size: 'small',
	statusbar: false,
        //save_enablewhendirty: true,
	width: 1200,
	height: 500,
        /*save_onsavecallback: function() {console.log("Save");}*/
});
</script>
<?
}
?>
<?
}

if (!isset($_REQUEST["nohead"])&&!isset($_REQUEST["google"]))
//if (!isset($_REQUEST["nohead"]))
{
?><title>?????? ???????? ?? ???????? ???</title><?
?></head><body>
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