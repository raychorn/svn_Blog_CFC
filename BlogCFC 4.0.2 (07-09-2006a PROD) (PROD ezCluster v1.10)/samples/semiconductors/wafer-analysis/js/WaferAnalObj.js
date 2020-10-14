// WaferAnalObj.js

WaferAnalObj = function(id, _waferName, _waferID){
	this.id = id;				
	this.waferName = _waferName;
	this.waferID = _waferID;
	this.waferStats = waferStats.get$();
	this.title = [];
	this.titleImagePts = [];
	this._data = [];
	this.qData = [];
};

WaferAnalObj.$ = [];

WaferAnalObj.get$ = function(waferName, waferID) {
	var instance = WaferAnalObj.$[WaferAnalObj.$.length];
	if (instance == null) {
		instance = WaferAnalObj.$[WaferAnalObj.$.length] = new WaferAnalObj(WaferAnalObj.$.length, waferName, waferID);
	}
	return instance;
};

WaferAnalObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < WaferAnalObj.$.length) ) {
		var instance = WaferAnalObj.$[id];
		if (!!instance) {
			WaferAnalObj.$[id] = object_destructor(instance);
			ret_val = (WaferAnalObj.$[id] == null);
		}
	}
	return ret_val;
};

WaferAnalObj.remove$s = function() {
	var ret_val = true;
	for (var i = 0; i < WaferAnalObj.$.length; i++) {
		WaferAnalObj.remove$(i);
	}
	return ret_val;
};

WaferAnalObj.prototype = {
	id : -1,
	waferName : -1,
	waferID : -1,
	waferStats : -1,
	title : [],
	titleImagePts : [],
	_data : [],
	qData : [],
	toString : function() {
		var s = 'id = (' + this.id + ') :: ';
		s += 'waferName = (' + this.waferName + ')';
		s += ', waferID = (' + this.waferID + ')';
		s += ', waferStats = (' + this.waferStats + ')';
		s += ', title.length = (' + this.title.length + ')';
		s += ', title = (' + this.title + ')';
		s += ', titleImagePts = (' + this.titleImagePts + ')';
		s += ', _data.length = (' + this._data.length + ')';
		s += ', _data = (' + this._data + ')';
		s += ', qData.length = (' + this.qData.length + ')';
		s += ', qData = (' + this.qData + ')';
		s += '\n';
		return s;
	},
	add_qData : function(qD) {
		if (typeof this.qData != const_object_symbol) {
			this.qData = [];
		}
		this.qData.push(qD); 
	},
	init : function() {
		return this;
	},
	destructor : function() {
		return (this.id = WaferAnalObj.$[this.id] = this.waferName = this.waferID = this.waferStats = this.title = this.titleImagePts = this._data = this.qData = null);
	}
};
