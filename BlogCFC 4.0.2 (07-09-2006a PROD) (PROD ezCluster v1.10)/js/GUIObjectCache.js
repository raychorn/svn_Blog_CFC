_cache_gui_objects = [];

function initGUIObjectCache() {
	_cache_gui_objects = [];
}

function flushCache$(obj) {
	if (obj != null) {
		var sfEls = obj.getElementsByTagName("*");
		for (var i = 0; i < sfEls.length; i++) {
			events_unHookAllEventHandlers(sfEls[i]);
			if (sfEls[i].id) {
				_cache_gui_objects[sfEls[i].id] = null;
			}
		}
	}
}

function _$(id) {
	var obj = -1;
	obj = ((document.getElementById) ? document.getElementById(id) : ((document.all) ? document.all[id] : ((document.layers) ? document.layers[id] : null)));
	return obj;
}

function $(id) {
	var obj = -1;
	if (_cache_gui_objects[id] == null) {
		obj = _$(id);
		_cache_gui_objects[id] = obj;
	} else {
		obj = _cache_gui_objects[id];
	}
	return obj;
}
