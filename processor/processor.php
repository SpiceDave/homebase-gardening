<?php
	//constants
	
	$CSV_PATH = ''; //path to the csv file
	$OLD_IMG_DIR = ''; //path to existing user images
	$PROCESSED_IMG_DIR = ''; //directory of processed images
	$MASTER_IMAGE = ''; //path to overlay image
	$ROW_SIZE = 60; //row size (number of cells making up a row [might be different for each format])
	$CELL_SIZE = 10; //cell size (width in pixels)
	$HTML_OUTPUT; //the name of the html output file (and path)
	
	//variables
	
	$count = 0; //current csv row
	$rows; //size of the array
	$current_row = 0; //number of current row - cells not records
	$csv_data; //array of all user data
	$html; //html variable (stores the formatted html)
	
	
	//process html
		//read in file
		//for each line of CSV (http://php.net/manual/en/function.fgetcsv.php, or http://de.php.net/manual/en/splfileobject.fgetcsv.php, http://www.nawrik.com/programming/php/create-a-php-array-from-a-csv-file/)
		
			//add the required user info (except for the image to the array $csv_data)
			
			//get the image (http://www.php.net/manual/en/function.imagecreatefromjpeg.php) see function imageCreateFromAny() below - bear in mind JPEG jpg jpeg etc...
			
			//now that we have the image resource...
			
			//create two resized images and copy and copy to processed images folder, rename the files to equal the $current_row, and also add this value to $csv_data for this row.
			
				//easy to create the first of the image as this is full color and it doesn't matter where it ends up
				
					//see the second example at http://php.net/manual/en/function.imagecopyresampled.php - we can use that to create our small files
				
				//second small image isn't as easy as we either need to colorize this, or convert to alpha and apply a tint if the client doesn't go for duplication of records, and wants the pixels randomised
				//effectively whatever we do we need to work out where this image is going to sit and find the color on the main image, and then color this one... to randomise we really need to do it here in php we might loop through to the number of cells,
				//add them all to the array and http://php.net/manual/en/function.shuffle.php. 
				
				
			//now we create the HTML for the grid, one at a time through the loop. this code will be just that required to make up the matrix, we might load it using ajax later on
			
				//Create the html for all the small grid and store the required rollover data within it use data-attributes and add the data from the csv e.g. http://html5doctor.com/html5-custom-data-attributes/ for example
					//$html += '<div class="gridCell" id="smallGrid"'.$count.' ><img src="'.$count.'-small.jpg" /><div>'; etc...
				
				//if we get up to the end of the row
					//add a <div style="clear:both"></div> to begin the next line
					
			
				//write the value of $html to a file $HTML_OUTPUT; so that it can be used automatically after git push				
	
	
?>

<?php 
function imageCreateFromAny($filepath) { 
    $type = exif_imagetype($filepath); // [] if you don't have exif you could use getImageSize() 
    $allowedTypes = array( 
        1,  // [] gif 
        2,  // [] jpg 
        3,  // [] png 
        6   // [] bmp 
    ); 
    if (!in_array($type, $allowedTypes)) { 
        return false; 
    } 
    switch ($type) { 
        case 1 : 
            $im = imageCreateFromGif($filepath); 
        break; 
        case 2 : 
            $im = imageCreateFromJpeg($filepath); 
        break; 
        case 3 : 
            $im = imageCreateFromPng($filepath); 
        break; 
        case 6 : 
            $im = imageCreateFromBmp($filepath); 
        break; 
    }    
    return $im;  
} 
?>