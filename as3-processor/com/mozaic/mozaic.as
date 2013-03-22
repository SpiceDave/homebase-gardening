package com.mozaic
{
	import flash.system.JPEGLoaderContext;
	import flash.utils.ByteArray;
	import flash.filesystem.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.adobe.images.JPGEncoder;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class mozaic
	{
		

		/*stores the csv data as an object array */
		var submission:Array = new Array();
		
		const TILE_NO:int = 1998;//qty
		const TILE_SIZE:int = 15;//pixels
		const MOSAIC_WIDTH:int = 810;//pixels
		const ROW_WIDTH:int = MOSAIC_WIDTH / TILE_SIZE;//width of mosaic divided by width of cells
		const USER_IMG_SIZE:int = 172;//square
		var _html:String;
		var _htmlFile:String;
		var _targetImgDir:String;
		var _sourceImgDir:String;

		
		public function mozaic()
		{
			// constructor code
			trace('Processor loaded...');
		}
		
		/* Main function */
		public function process(csvFile:String, sourceImgDir:String, targetImgDir:String, mainImageFile:String, htmlFile:String ):void
		{
			_htmlFile = htmlFile;
			_sourceImgDir = sourceImgDir;
			_targetImgDir = targetImgDir;
			
			/*upload necessary files*/
			var mImage:File = new File(mainImageFile);
			var req:URLRequest = new URLRequest(mImage.url);
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			ldr.load(req);
			
						
			var csv:File = new File(csvFile);
			var fileContent:String = getFileContent(csv);
			
			//get the submissions
			submission = parseCSV(fileContent);
			//trace(submission[1500].image);
		}
		
		private function completeHandler(event:Event):void 
		{
			  var ldr:Loader = Loader(event.target.loader);
			  var b:Bitmap = Bitmap(ldr.content);
			  
			  var row:int = 1;
			  var j:int = 1;
			  var color:String;
			  var imgCellCode:String;
			  
			  _html = '<html><head><style>img{opacity:0.6;filter:alpha(opacity=6);}</style></head><body><div style="width:'+ MOSAIC_WIDTH +'px; position:relative">';
			  //add the colors metadata to the shuffled records
			  for(var i:int = 0; i<TILE_NO; i++)
			  {
				  
				  if((j)%(ROW_WIDTH + 1) == 0)
				  {
					  row++;
					  j = 0;
					  i--;
					  _html += '<div style="clear:both"></div>';
				  }
				  else
				  {
					  color = int(b.bitmapData.getPixel((j*TILE_SIZE) - (TILE_SIZE/2), (row*TILE_SIZE)-(TILE_SIZE-2))).toString(16);//hex
					  if(color.length == 5)
					  {
						  color = '0' + color;
					  }
					  submission[i].color = color;
					  
					//trace(i + ' ' + submission[i].color+ ' ' +j + ' ' + row);
					if(submission[i].image != 'empty')
					{
					  	var imgOutArray:Array =  ('img/target/'+ submission[i].image).split('.');
						imgCellCode = '<img src="'+imgOutArray[0]+'_c.jpg"/>';
					}
					else
						imgCellCode = '';
					
					  
					  _html += '<div class="mCell" id="' + i + '" style="width:'+TILE_SIZE+'px; height:'+TILE_SIZE+'px; background-color:#' + submission[i].color + '; float:left">'+ imgCellCode + '</div>';
				  }
				  j++;
				 
			  }
			  _html += '</div></body></html>';
			  writeHTML(_html);
			  createImages(); 
		}

		
		/* write the mosiac html code to file */
		private function writeHTML(code):void{
			var file:File = File.desktopDirectory.resolvePath(_htmlFile);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(code);
			stream.close();
		}
		
		/* write the small mosaic image html to file */
		private function writeImage(jpg:ByteArray, tpath:String):void{
			trace('Saving file: ' + tpath);
			var file:File = File.desktopDirectory.resolvePath(tpath);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes ( jpg, 0, jpg.length );
			stream.close();
		}
			
			

		/* Gets the handle to the csv file */
		private function getFileContent(_file:File):String
		{
			//open a fileStream to read the content of the file
			var fileStream:FileStream = new FileStream();
			fileStream.open(_file, FileMode.READ);
			var fileContent:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
			return fileContent;
		}

		/* Parses the csv file's content that is passsed to it, and returns an array of object */
		private function parseCSV(_content:String):Array
		{
			var csvContent:Array = new Array();
			var loadedData = _content.split(/\r\n|\n|\r/);
			
			//for each record as a mosaic tile
			for (var i:int=1; i<=TILE_NO; i++){
				//for tiles with data
				if(i < loadedData.length)
				{
					loadedData[i] = loadedData[i].split(",");
					csvContent.push({'name':loadedData[i][0], 
								'email':loadedData[i][1],
								'image':loadedData[i][2],
								'copy':loadedData[i][3],
								'tag':loadedData[i][4],
								'color':'empty'});
				}
				//else create empty record to facilitate shuffling with populated tiles
				else
				{
					csvContent.push({'name':'empty', 
									'email':'empty',
									'image':'empty',
									'copy':'empty',
									'tag':'empty',
									'color':'empty'});
				}
			}
			shuffle(csvContent)
			return csvContent;
		}
		
		/* create the images for the mosaic */
		private function createImages():void{
			 for(var i:int = 0; i<TILE_NO; i++)
			 {
				 var submittedImage:String = submission[i].image;
				 var colorTint:String = submission[i].color;
				 
				 if(submittedImage != 'empty')
				 {
					 trace('image to convert: ' + submittedImage + ' with a color tint of: ' + colorTint + ' belonging to: ' + submission[i].name);
					 //remove the file extension
					 var imgOutArray:Array =  (_targetImgDir+'/'+ submission[i].image).split('.');
					 generateImages(_sourceImgDir+'/'+ submission[i].image, imgOutArray[0], colorTint);
				}
			 }
			 
			 function generateImages(imgIn:String, imgOut:String, tint:String):void
			 {
				 /*upload necessary files*/
				var iImage:File = new File(imgIn);
				var ureq:URLRequest = new URLRequest(iImage.url);
				var ldr:Loader = new Loader();
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, smallImageUploadHandler);
				ldr.load(ureq); 
				
				function smallImageUploadHandler(event:Event):void 
				{
				  //encoder class instantiation
				  var jpgEncoder:JPGEncoder = new JPGEncoder(75);
				  var ldr:Loader = Loader(event.target.loader);
				  var bmp:Bitmap = Bitmap(ldr.content);
				  var mainSubmittedImage:Bitmap = new Bitmap();
				  
				  //set sizes for image crop
				  var imgWidth:int = bmp.width;
				  var imgHeight:int = bmp.height;
				  
				  trace('uploading image: ' + imgIn);
				  
				  /********* convert the main images first ********/
				  
				   //-->landscape or square
				  if(imgWidth >= imgHeight)
				  {
					  mainSubmittedImage = crop((imgWidth - imgHeight)/2, 0, imgHeight, imgHeight, bmp);
				  }
				  
				  //-->portrait
				  if(imgHeight >= imgWidth)
				  {
					  //do the crop
					  mainSubmittedImage = crop(0, (imgHeight - imgWidth)/2, imgWidth, imgWidth, bmp);
				  }
				  
				  //scale the image
				  mainSubmittedImage = drawScaled(mainSubmittedImage, Number(USER_IMG_SIZE), Number(USER_IMG_SIZE));
				  
				  var bmdMain:Bitmap = new Bitmap(mainSubmittedImage.bitmapData);


				  
				  var jpgByteArayMain:ByteArray = jpgEncoder.encode(bmdMain.bitmapData);
				  writeImage(jpgByteArayMain, imgOut + '_m.jpg');
				  
				  
				  /******** convert the small cell images ********/
				  
				  //convert to grayscale
				  const rc:Number = 1/3, gc:Number = 1/3, bc:Number = 1/3;
				  bmp.bitmapData.applyFilter(bmp.bitmapData, bmp.bitmapData.rect, new Point(), new ColorMatrixFilter([rc, gc, bc, 0, 0,rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]));
	  
				  
				  
				  
				  //-->landscape or square
				  if(imgWidth >= imgHeight)
				  {
					  bmp = crop((imgWidth - imgHeight)/2, 0, imgHeight, imgHeight, bmp);
				  }
				  
				  //-->portrait
				  if(imgHeight >= imgWidth)
				  {
					  //do the crop
					  bmp = crop(0, (imgHeight - imgWidth)/2, imgWidth, imgWidth, bmp);
				  }
				  
				  //scale the image
				  bmp = drawScaled(bmp, Number(TILE_SIZE), Number(TILE_SIZE));
				  
				  //color the image
				  var cTransform:ColorTransform = new ColorTransform();
				  cTransform.alphaMultiplier = 2;
				  var hex:Number = Number('0x' + tint);
				  cTransform.redMultiplier = 1 /(255 / Number((hex & 0xFF0000) >> 16));
				  cTransform.greenMultiplier = 1 /(255 /Number((hex & 0x00FF00) >> 8));
				  cTransform.blueMultiplier = 1 /(255 / Number((hex & 0x0000FF)));  
				  var rect:Rectangle = new Rectangle(0, 0, TILE_SIZE, TILE_SIZE);
				  bmp.bitmapData.colorTransform(rect, cTransform);
					
				  var bm:Bitmap = new Bitmap(bmp.bitmapData);


				  
				  var jpgByteAray:ByteArray = jpgEncoder.encode(bm.bitmapData);
				  writeImage(jpgByteAray, imgOut+ '_c.jpg');
				 				 
			 	}
			 }
		}
		
		
		/*crop the bitmap */
		function crop( _x:Number, _y:Number, _width:Number, _height:Number, displayObject:DisplayObject = null):Bitmap
		{
		   var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
		   var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
		   croppedBitmap.bitmapData.draw(displayObject, new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
		   return croppedBitmap;
		}
		
		/* rescale the image */
		function drawScaled(obj:DisplayObject, thumbWidth:Number, thumbHeight:Number):Bitmap {
			var m:Matrix = new Matrix();
			m.scale(thumbWidth / obj.width, thumbWidth / obj.height);
			var bmp:BitmapData = new BitmapData(thumbWidth, thumbHeight, false);
			bmp.draw(obj, m);
			return new Bitmap(bmp);
		}
		
		
		/* lovely function from http://bost.ocks.org/mike/shuffle/ used to shuffle the array of submissions */
		
		
		private function shuffle(array):Array 
		{
			
			var m = array.length, t, i;
			
			// While there remain elements to shuffle
			while (m) {
			
				// Pick a remaining element…
				i = Math.floor(Math.random() * m--);
				
				// And swap it with the current element.
				t = array[m];
				array[m] = array[i];
				array[i] = t;
			}
			return array;
		}

	}

}