function setFocusSafely(pObj) {
	if (!!pObj) {
		try { if (pObj.focus) { if ( (pObj.disabled == null) || (pObj.disabled == false) ) { pObj.focus(); } } } catch(e) { } finally { };
	}
}

