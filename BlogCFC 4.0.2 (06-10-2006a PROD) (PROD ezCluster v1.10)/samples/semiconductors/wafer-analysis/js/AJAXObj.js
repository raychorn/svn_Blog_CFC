AJAXObj = function(id){
	this.id = id;				
};

AJAXObj.$ = [];

AJAXObj.get$ = function() {
	var instance = AJAXObj.$[AJAXObj.$.length];
	if (instance == null) {
		instance = AJAXObj.$[AJAXObj.$.length] = new AJAXObj(AJAXObj.$.length);
	}
	return instance;
};

AJAXObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < AJAXObj.$.length) ) {
		var instance = AJAXObj.$[id];
		if (!!instance) {
			AJAXObj.$[id] = object_destructor(instance);
			ret_val = (AJAXObj.$[id] == null);
		}
	}
	return ret_val;
};

AJAXObj.remove$s = function() {
	var ret_val = true;
	for (var i = 0; i < AJAXObj.$.length; i++) {
		AJAXObj.remove$(i);
	}
	return ret_val;
};

AJAXObj.prototype = {
	id : -1,
	data : [],
	names : [],
	toString : function() {
		function toStr(a, d) {
			var s = '[';
			var i = -1;
			var aName = '';

			try {
				var n = a.length;
				for (i = 0; i < n; i++) {
					aName = a[i];
					s += aName + " = \{" + d[aName].toString() + "\}" + '\n';
				}
			} catch(e) {
			} finally {
			}

			s += ']';
			return s;
		}
		var s = 'id = [' + this.id + '], ' + toStr(this.names, this.data);
		return s;
	},
	init : function() {
		this.names = [];
		this.data = [];
		return this;
	},
	push : function(aName, datum) {
		this.names.push(aName);
		this.data[aName] = datum;
	},
	pop : function() {
		var aName = this.names.pop();
		return this.data[aName];
	},
	named : function(aName) {
		return this.data[aName];
	},
	destructor : function() {
		return (this.id = AJAXObj.$[this.id] = this.data = this.names = null);
	}
};

