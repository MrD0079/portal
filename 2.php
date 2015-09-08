<?php
if( isset($_POST['submit']) ) {
      include('SimpleImage.php');
      $image = new SimpleImage();
      $image->load($_FILES['uploaded_image']['tmp_name']);
$fn=$_FILES['uploaded_image']['name'];
$h=$image->getHeight();
if ($image->getHeight()>800)
{
$image->resizeToHeight(800);
echo $fn.": ".$h."=>".$image->getHeight();
}
$image->save($_FILES['uploaded_image']['name']);
}
?>
   <form action="2.php" method="post" enctype="multipart/form-data">
      <input type="file" name="uploaded_image" />
      <input type="submit" name="submit" value="Upload" />
   </form>
<img src="<?echo $fn;?>">
<br>
<?echo $fn;?>