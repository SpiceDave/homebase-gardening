<?php
	$x = $_GET['X_COORD'];
	$x = $_GET['X_COORD'];
 
	$im = imagecreatefromjpeg("main.jpg");
	$rgb = imagecolorat($im, $x, $y);
	$r = ($rgb >> 16) & 0xFF;
	$g = ($rgb >> 8) & 0xFF;
	$b = $rgb & 0xFF;

	//var_dump($r, $g, $b);
	$color = array($r, $g, $b);
	echo $color;

?>