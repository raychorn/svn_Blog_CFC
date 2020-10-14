//**************************************************************************/

function jsEventExplainer(e, newLine) {
	var _db = ''; 

	try {
		if (e.data) _db += "e.data is: " + e.data + newLine; 
	} catch(e) {
		_db += 'e.data is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.height) _db += "e.height is: " + e.height + newLine; 
	} catch(e) {
		_db += 'e.height is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.layerX) _db += "e.layerX is: " + e.layerX + newLine; 
	} catch(e) {
		_db += 'e.layerX is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.layerY) _db += "e.layerY is: " + e.layerY + newLine; 
	} catch(e) {
		_db += 'e.layerY is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.modifiers) _db += "e.modifiers is: " + e.modifiers + newLine; 
	} catch(e) {
		_db += 'e.modifiers is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.pageX) _db += "e.pageX is: " + e.pageX + newLine; 
	} catch(e) {
		_db += 'e.pageX is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.pageY) _db += "e.pageY is: " + e.pageY + newLine; 
	} catch(e) {
		_db += 'e.pageY is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.screenX) _db += "e.screenX is: " + e.screenX + newLine; 
	} catch(e) {
		_db += 'e.screenX is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.screenY) _db += "e.screenY is: " + e.screenY + newLine; 
	} catch(e) {
		_db += 'e.screenY is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.target) _db += "e.target is: " + e.target + newLine; 
	} catch(e) {
		_db += 'e.target is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.type) _db += "e.type is: " + e.type + newLine; 
	} catch(e) {
		_db += 'e.type is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.which) _db += "e.which is: " + e.which + newLine; 
	} catch(e) {
		_db += 'e.which is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.width) _db += "e.width is: " + e.width + newLine; 
	} catch(e) {
		_db += 'e.width is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.x) _db += "e.x is: " + e.x + newLine; 
	} catch(e) {
		_db += 'e.x is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.y) _db += "e.y is: " + e.y + newLine; 
	} catch(e) {
		_db += 'e.y is: -- UNKNOWN --' + newLine; 
	} finally {
	}
	return _db;
}

//**************************************************************************/
