AJaxContextObj = function(id){
	this.id = id;	
	this.queryString = '';
	this.parmsDict = -1;
	this.argsDict = -1;
};

AJaxContextObj.$ = [];

AJaxContextObj.get$ = function() {
	var instance = AJaxContextObj.$[AJaxContextObj.$.length];
	if (instance == null) {
		instance = AJaxContextObj.$[AJaxContextObj.$.length] = new AJaxContextObj(AJaxContextObj.$.length);
	}
	return instance;
};

AJaxContextObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < AJaxContextObj.$.length) ) {
		var instance = AJaxContextObj.$[id];
		if (!!instance) {
			AJaxContextObj.$[id] = object_destructor(instance);
			ret_val = (AJaxContextObj.$[id] == null);
		}
	}
	return ret_val;
};

AJaxContextObj.remove$s = function() {
	var ret_val = true;
	for (var i = 0; i < AJaxContextObj.$.length; i++) {
		AJaxContextObj.remove$(i);
	}
	return ret_val;
};

AJaxContextObj.prototype = {
	id : -1,
	queryString : '',
	parmsDict : -1,
	argsDict : -1,
	toString : function() {
		var aKey = -1;
		var s = '\nAJaxContextObj(' + this.id + ') :: (\n';
		s += 'queryString = [' + this.queryString + ']' + '\n';
		s += 'parmsDict = [' + this.parmsDict + ']' + '\n';
		s += 'argsDict = [' + this.argsDict + ']' + '\n';
		s += ')';
		return s;
	},
	init : function() {
		this.queryString = '';
		try { this.parmsDict.destructor(); } catch(e) { } finally {	};
		this.parmsDict = -1;
		try { this.argsDict.destructor(); } catch(e) { } finally { };
		this.argsDict = -1;
		return this;
	},
	destructor : function() {
		try { this.parmsDict.destructor(); } catch(e) {	} finally {	};
		this.parmsDict = -1;
		try { this.argsDict.destructor(); } catch(e) { } finally { };
		return (this.id = AJaxContextObj.$[this.id] = this.queryString = this.parmsDict = this.argsDict = null);
	}
};

