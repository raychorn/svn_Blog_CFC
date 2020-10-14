// waferPoint.js

waferPoint = function(id){
	this.id = id;				
};

waferPoint.$ = [];

waferPoint.get$ = function() {
	var instance = waferPoint.$[waferPoint.$.length];
	if (instance == null) {
		instance = waferPoint.$[waferPoint.$.length] = new waferPoint(waferPoint.$.length);
	}
	return instance;
};

waferPoint.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < waferPoint.$.length) ) {
		var instance = waferPoint.$[id];
		if (!!instance) {
			waferPoint.$[id] = object_destructor(instance);
			ret_val = (waferPoint.$[id] == null);
		}
	}
	return ret_val;
};

waferPoint.remove$s = function() {
	var ret_val = true;
	for (var i = 0; i < waferPoint.$.length; i++) {
		waferPoint.remove$(i);
	}
	return ret_val;
};

waferPoint.prototype = {
	id : -1,
	DieX : -1,
	DieY : -1,
	ImageX : -1,
	ImageY : -1,
	OriginX : -1,
	OriginY : -1,
	value : -1,
	scaleFactor : -1,
	toString : function() {
		var s = 'waferPoint(' + this.id + ') :: \n';
		s += 'DieX/DieY = [' + this.DieX + ',' + this.DieY + ']' + '\n';
		s += 'OriginX/OriginY = [' + this.OriginX + ',' + this.OriginY + ']' + ((this.scaleFactor != -1) ? ', OriginX/OriginY = [' + Math.ceil(this.OriginX * this.scaleFactor) + ',' + Math.ceil(this.OriginY * this.scaleFactor) + ']' : '') + '\n';
		s += 'ImageX/ImageY = [' + this.ImageX + ',' + this.ImageY + ']' + ((this.scaleFactor != -1) ? ', ImageX/ImageY = [' + Math.ceil(this.ImageX * this.scaleFactor) + ',' + Math.ceil(this.ImageY * this.scaleFactor) + ']' : '') + '\n';
		s += 'value = [' + this.value + ']\n';
		s += 'scaleFactor = [' + this.scaleFactor + ']\n\n';
		return s;
	},
	destructor : function() {
		return (this.id = waferPoint.$[this.id] = this.DieX = this.DieY = this.ImageX = this.ImageY = this.OriginX = this.OriginY = this.value = this.scaleFactor = null);
	}
};

