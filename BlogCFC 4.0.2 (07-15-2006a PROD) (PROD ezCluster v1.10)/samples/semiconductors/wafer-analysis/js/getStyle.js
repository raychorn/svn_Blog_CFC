function getStyle(el, style) {
    var value = '';
	if (!!el) {
		try { value = el.style[toCamelCase(style)]; } catch(e) { } finally { };
	   
	    if (!value) {
	        if (typeof document.defaultView == "object") {
	            value = document.defaultView.getComputedStyle(el, "").getPropertyValue(style);
			}
	        else if (el.currentStyle) {
	            value = el.currentStyle[toCamelCase(style)];
			}
		}
	}

	return value || "";
}

