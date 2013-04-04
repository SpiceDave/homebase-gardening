jQuery('#pop-out').hide();

		jQuery(document).ready(function(){
			jQuery('#fb-mosaic').load('html/mozaic.html', function(e) {
				$(function() {
					$( document ).tooltip();
				});
				
			
				var mWidth = jQuery('#fb-mosaic').width();
				var mHeight = jQuery('#fb-mosaic').height();
				jQuery('.live-cell').on('mouseleave',function() {
					jQuery(document).clearQueue();
				});
				jQuery('.live-cell').on('mouseenter',function() {
					
					jQuery(this).attr('title', jQuery(this).attr('data-name'));

				});
				
				jQuery('.live-cell').on('click',function() {
					
											
					jQuery('#pop-out img').attr('src',jQuery(this).attr('data-image'));
					
				
					var cell = jQuery(this);
					var pos = cell.position();
					
					//normalise the pop-up box postion
					var top = pos.top;
					console.log(top);
					var left = pos.left;
					
					if(top > mHeight-200)
					{
						top = mHeight-200;
					}
					if(top < 28)
					{
						top = 28;
					}
					if(left > mWidth-458)
					{
						left = mWidth-458;
					}
					if(left < 28)
					{
						left = 28;
					}
					
					popUpBox(top, left);
					$( document ).tooltip( "close" );
				});
				jQuery('#search-box-txt').bind('keypress', function(event){
					if(event.which == 13)
					{
						search('search');
					}
				});

			});
		});
		
		
		function popUpBox(top, left){
			jQuery('#pop-out').clearQueue().hide(100, function(){
				jQuery('#pop-out').delay(500).css({'top':top + 'px', 'left':left}).show('fast');
				jQuery('.ui-tooltip').hide();
			});
		}
		
		function closeX(){
			jQuery('#pop-out').clearQueue().hide('fast');
		}
	
		//clear search field when user clicks in the box
		jQuery('#search-box-txt').on('click', function(){
			if(jQuery(this).val() == 'Search for tips...' || jQuery(this).val() == 'Sorry, no tips found...')
				jQuery(this).val('');
		});
		
		//search function
		function search(searchVal, tag){
			closeX();
			var resultsFound = false;
			jQuery('.live-cell').each(function(index){
				if(searchVal == 'search')
				{
					//get the string to be searched
					searchVal = jQuery('#search-box-txt').val().toLowerCase();
				}
				
				var thisAttrTag = jQuery(this).attr('data-tag').toLowerCase();
				var thisAttrName = jQuery(this).attr('data-name').toLowerCase();
				var thisAttrCopy = jQuery(this).attr('data-copy').toLowerCase();
				
				//clear the existing search highlighters
				jQuery(this).children('div').css('display','none');
				if(thisAttrName.search(searchVal) >= 0 || thisAttrCopy.search(searchVal) >= 0|| thisAttrTag.search(searchVal) >= 0)
				{
					
					jQuery(this).children('div').css('display','block');
					resultsFound = true;
					
				}
			});
			if(resultsFound == false)
			{
				jQuery('#search-box-txt').val('Sorry, no tips found...');
			}
		}