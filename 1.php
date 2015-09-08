<?
$file_list=array();


include('SimpleImage.php');
$image = new SimpleImage();


function isEmptyDir($dir){
     return (($files = @scandir($dir)) && count($files) <= 2);
} 

function rg($z)
{

global $image;

	foreach (glob($z."/*") as $k=>$v)
	{
		if (is_dir($v))
		{
			if (!isEmptyDir($v))
			rg($v);
		}
		else
		{


		$image->load($v);
		$h=$image->getHeight();
		if ($image->getHeight()>600)
		{
		$image->resizeToHeight(600);
		echo $v.": ".$h."=>".$image->getHeight()."\n";
		}
		$image->save($v);

		}
	}
}



//rg('/home/httpd/server2/merch_spec_report_files/01.06.2013');
rg('/home/httpd/server2/merch_spec_report_files/02.06.2013');


/*

if ($handle = opendir("merch_spec_report_files")) {
	while (false !== ($file = readdir($handle)))
	{
		if ($file != "." && $file != "..")
		{
			if ($handle1 = opendir("merch_spec_report_files/".$file))
			{
				while (false !== ($file1 = readdir($handle1)))
				{
					if ($file1 != "." && $file1 != "..")
					{
						if ($handle2 = opendir("merch_spec_report_files/".$file."/".$file1))
						{
							while (false !== ($file2 = readdir($handle2)))
							{
								if ($file2 != "." && $file2 != "..")
								{
									if ($handle3 = opendir("merch_spec_report_files/".$file."/".$file1."/".$file2))
									{
										while (false !== ($file3 = readdir($handle3)))
										{
											if ($file3 != "." && $file3 != "..")
											{
												//$file_list[$file][$file1][$file2][] = $file3;
												//$a=pathinfo($file3);
												//$fn="msrf".$db->getOne("select SEQ_FILES.nextval from dual").".".$a["extension"];
												//echo $file3."=>".$fn."<br>";
												//rename("merch_spec_report_files/".$file."/".$file1."/".$file2."/".$file3,"merch_spec_report_files/".$file."/".$file1."/".$file2."/".$fn);
												//$keys = array("dt"=>OraDate2MDBDate($file),"ag_id"=>$file1,"kod_tp"=>$file2,"fn"=>$fn);
												//Table_Update ("merch_spec_report_files", $keys, $keys);



		//echo "merch_spec_report_files/".$file."/".$file1."/".$file2."/".$file3."<br>";
		$fn="merch_spec_report_files/".$file."/".$file1."/".$file2."/".$file3;
		$image->load($fn);
		$h=$image->getHeight();
		if ($image->getHeight()>600)
		{
		$image->resizeToHeight(600);
		echo $fn.": ".$h."=>".$image->getHeight()."\n";
		}
		$image->save($fn);




											}
										}
										closedir($handle3);
									}
								}
							}
							closedir($handle2);
						}
					}
				}
				closedir($handle1);
			}
		}
	}
	closedir($handle);
}
*/

?><pre><?

//print_r($file_list);

?></pre><?

?>