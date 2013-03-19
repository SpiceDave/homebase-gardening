﻿package com.mozaic{	public class mozaic	{		import flash.filesystem.*;		import flash.display.*;		import flash.events.Event;		import flash.net.URLRequest;				/*stores the csv data as an object array */		var submission:Array = new Array();		const TILE_NO:int = 2000;		const TILE_SIZE:int = 16;		const ROW_WIDTH:int = 50;//width of mosaic divided by width of cells				public function mozaic()		{			// constructor code			trace('Processor loaded...');		}				/* Main function */		public function process(csvFile:String, sourceImgDir:String, targetImgDir:String, mainImageFile:String, htmlFile:String )		{			/*upload necessary files*/			var mImage:File = new File(mainImageFile);			var req:URLRequest = new URLRequest(mImage.url);			var ldr:Loader = new Loader();			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);			ldr.load(req);												var csv:File = new File(csvFile);			var fileContent:String = getFileContent(csv);						//get the submissions			submission = parseCSV(fileContent);			trace(submission[1500].image);		}				private function completeHandler(event:Event):void 		{			  var ldr:Loader = Loader(event.target.loader);			  var b:Bitmap = Bitmap(ldr.content);			  			  var row:int = 1;			  var j:int = 1;			  			  //add the colors metadata to the shuffled records			  for(var i:int = 0; i<=TILE_NO; i++)			  {				  j++;				  if(j%50 == 1)				  {					  row++;					  j -= 50;				  }				  submission[i].color = b.bitmapData.getPixel((j*16) -8, (row*16)-8);				  trace(submission[i].color);			  }			  		}					/* Gets the handle to the csv file */		private function getFileContent(_file:File):String		{			//open a fileStream to read the content of the file			var fileStream:FileStream = new FileStream();			fileStream.open(_file, FileMode.READ);			var fileContent:String = fileStream.readUTFBytes(fileStream.bytesAvailable);			fileStream.close();			return fileContent;		}		/* Parses the csv file's content that is passsed to it, and returns an array of object */		private function parseCSV(_content:String):Array		{			var csvContent:Array = new Array();			var loadedData = _content.split(/\r\n|\n|\r/);						//for each record as a mosaic tile			for (var i:int=0; i<TILE_NO; i++){				//for tiles with data				if(i < loadedData.length)				{					loadedData[i] = loadedData[i].split(",");					csvContent.push({'name':loadedData[i][0], 								'email':loadedData[i][1],								'image':loadedData[i][2],								'copy':loadedData[i][3],								'tag':loadedData[i][4],								'color':'empty'});				}				//else create empty record to facilitate shuffling with populated tiles				else				{					csvContent.push({'name':'empty', 									'email':'empty',									'image':'empty',									'copy':'empty',									'tag':'empty',									'color':'empty'});				}			}			shuffle(csvContent)			return csvContent;		}				/* lovely function from http://bost.ocks.org/mike/shuffle/ used to shuffle the array of submissions */		private function shuffle(array):Array 		{						var m = array.length, t, i;						// While there remain elements to shuffle			while (m) {							// Pick a remaining element…				i = Math.floor(Math.random() * m--);								// And swap it with the current element.				t = array[m];				array[m] = array[i];				array[i] = t;			}			return array;		}	}}