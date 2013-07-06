/*
jQuery CSS support inspecting

Copyright 2013 Fiveminutes ltd

Code sample
------------------
$.support.cssProperty("transition"); // Return true if browser support CSS transitions

*/

(function($, window, document, undefined){
	$.support.cssProperty = (function() {
        function cssProperty(p, rp) {
            var	v = ['Moz', 'Webkit', 'Khtml', 'O', 'ms', 'Icab'],
                b = document.body || document.documentElement,
                s = b.style,
                p = p.charAt(0).toUpperCase() + p.substr(1);
    
            // No css support detected
            if(typeof s == 'undefined') { return false; };
    
            // Tests for standard prop
            if(typeof s[p] == 'string') { return rp ? p : true; };
    
            // Tests for vendor specific prop
            for(var i=0; i < v.length; i++) {
                if(typeof s[v[i] + p] == 'string') { return rp ? (v[i] + p) : true; };
            }
        }
    
        return cssProperty;
    })();
})(jQuery, this, document);
	