<?php
$im = imagecreatefromjpeg('images/showcase_viv_west-300x181.jpg');

if($im && imagefilter($im, IMG_FILTER_COLORIZE,100, 50, 25))
{
    echo 'Image converted to grayscale.';

    imagejpeg($im, 'images/showcase_viv_west-300x181.jpg');
}
else
{
    echo 'Conversion to grayscale failed.';
}

imagedestroy($im);
?>