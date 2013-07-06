/*
jQuery Forms component for beautyfying default browser checkbox and radio buttons

Copyright 2013 Fiveminutes ltd

Code samples
------------------
$("input[type=checkbox], input[type=radio]").checkBox(); // Replace all checkboxes and radio buttons on entire document

*/

(function($, window, document, undefined){
	// radio & checkbox
	$.fn.checkBox = function(customOptions) {
	
		var options = $.extend("", $.fn.checkBox.defaultOptions, customOptions);

		this.each(function(e){
			
			var $field = $(this),
				$label = $('label[for="'+$(this).attr('id')+'"]'),
				fieldType = $field.attr('type'),
				fieldId = $field.attr('id'),
				checkedClass = "field-" + fieldType + "-label-checked",
				$textInput = $label.children("input");
						
			if($field.is(':checked')) {
				$label.addClass(checkedClass);
			};
			
            $label.bind("click", function(event){
            	$field.triggerHandler("click");
            	
            	if($field.is(":checkbox")) {
            		$label.toggleClass(checkedClass);
            	}
            	else {
            		var fieldName = $field.attr("name");
            		
            		$("input[name='" + fieldName + "']").each(function(){
            			var $radio = $(this),
            				$radioLabel = $("label[for='" + $radio.attr("id") +"']");
            				
            			$radioLabel.removeClass(checkedClass);
            		});
            		
            		$label.addClass(checkedClass);
            	}
            });
            
            $textInput.on("click", function(event){
    			event.preventDefault();
    
                return false;
			});
			
		});
		
	};
	
	$.fn.checkBox.defaultOptions = {};
})(jQuery, this, document);
	