// QObj.js

QObj = function(id, _colNames){
	this.id = id;				
	this.colNames = _colNames;
	this.dataRec = [];
	var a = _colNames.URLDecode().trim().split(',');
	this.dataRec.push(a);
};

QObj.$ = [];

QObj.get$ = function(_colNames) {
	var instance = QObj.$[QObj.$.length];
	if (instance == null) {
		instance = QObj.$[QObj.$.length] = new QObj(QObj.$.length, _colNames);
	}
	return instance;
};

QObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < QObj.$.length) ) {
		var instance = QObj.$[id];
		if (!!instance) {
			QObj.$[id] = object_destructor(instance);
			ret_val = (QObj.$[id] == null);
		}
	}
	return ret_val;
};

QObj.remove$s = function() {
	var ret_val = true;
	for (var i = 0; i < QObj.$.length; i++) {
		QObj.remove$(i);
	}
	return ret_val;
};

QObj.prototype = {
	id : -1,
	s_toString : '',
	colNames : '',
	dataRec : [],
	rowCntName : 'rowCnt',
	_toString : function(_aRec, _ri, _cols) {
		s_toString += ((_ri > 1) ? '\n' : '') + '[' + _ri + '] :: ';
		for (var i = 0; i < _aRec.length; i++) {
			if (_aRec[i].trim().length > 0) {
				s_toString += '{' + _cols[i] + '}=<' + _aRec[i] + '>';
				if (i < (_aRec.length - 1)) {
					s_toString += ', ';
				}
			}
		}
		return s_toString += '';
	},
	toString : function() {
		s_toString = 'QObj(' + this.id + ') :: \ncolumnList = (' + this.columnList() + '), recordCount = ' + this.recordCount() + '\n' + 'dataRec = (' + this.dataRec.toString() + ')\n\n';
		this.iterate(this._toString);
		return s_toString;
	},
	recordCount : function() {
		return (this.dataRec.length - 1); 
	},
	columnList : function() {
		return ((this.dataRec.length > 0) ? this.dataRec[0] : []);
	},
	data : function() {
		return (this.dataRec.slice(1,this.dataRec.length));
	},
	iterate : function(func) {
		var _cols = this.columnList();
		if ( (!!func) && (typeof func == const_function_symbol) ) {
			for (var ri = 1; ri < this.dataRec.length; ri++) {
				func(this.dataRec[ri], ri, _cols);
			}
		}
	},
	iterateRecObjs : function(func) {
		var i = -1;
		var _f = -1;
		var rN = this.dataRec.length;
		var rowArray = [];
		var oDict = DictObj.get$();
		var _cols = this.columnList();
		
		if ( (!!func) && (typeof func == const_function_symbol) ) {
			for (var ri = 1; ri < rN; ri++) {
				rowArray = this.dataRec[ri];
				for (i = 0; i < _cols.length; i++) {
					oDict.push(_cols[i], rowArray[i]);
				}
				oDict.push(this.rowCntName, rN - 1);
				_f = func(ri, oDict, this.rowCntName, this);
				_f = ((!!_f) ? _f : -1);
				if (_f != -1) {
					break;
				}
				oDict.init();
			}
		}
		DictObj.remove$(oDict.id);
	},
	QueryAddRow : function() {
		var d = [];
		this.dataRec.push(d);
	},
	getColNumFromColName : function(colName) {
		var colNum = -1;
		for (var i = 0; i < this.dataRec[0].length; i++) { 
			if (colName.trim().toUpperCase() == this.dataRec[0][i].trim().toUpperCase()) {
				colNum = i;
				break;
			}
		}
		return colNum;
	},
	QuerySetCell : function(cName, vVal, rowNum) {
		var d = [];
		var ci = -1;
		var colNum = this.getColNumFromColName(cName);
		if (colNum != -1) {
			if (rowNum <= this.recordCount()) {
				d = this.dataRec[rowNum];
				for (ci = 0; ci < this.dataRec[0].length; ci++) {
					if (ci == colNum) {
						d[ci] = vVal.URLDecode();
						break;
					}
				}
				this.dataRec[rowNum] = d;
			}
		}
		return false;
	},
	getValueFromName : function(cName, colName, valName) {
		var row = [];
		var ri = -1;
		var colNum = this.getColNumFromColName(colName);
		var valNum = this.getColNumFromColName(valName);
		if ( (colNum != -1) && (valNum != -1) ) {
			for (ri = 1; ri < this.dataRec.length; ri++) {
				row = this.dataRec[ri];
				if (row[colNum].trim().toUpperCase() == cName.trim().toUpperCase()) {
					return row[valNum];
				}
			}
		}
		return '';
	},
	getValueFromNameAtRow : function(cName, colName, valName, iRow) {
		var row = [];
		var ri = -1;
		var colNum = this.getColNumFromColName(colName);
		var valNum = this.getColNumFromColName(valName);
		if ( (colNum != -1) && (valNum != -1) ) {
			if ( (iRow > 0) && (iRow < this.dataRec.length) ) {
				row = this.dataRec[iRow];
				if (row[colNum].trim().toUpperCase() == cName.trim().toUpperCase()) {
					return row[valNum];
				}
			}
		}
		return '';
	},
	as_JS_array_source : function(cName) {
		var _parms = URLDecode(this.getValueFromName(cName, 'name', 'val'));
		var _pa = _parms.split(',');
		var _pb = [];
		var _pc = [];
		var aa = '[[]]';
		if (_pa.length > 1) {
			aa = '[';
			for (var i = 0; i < _pa.length; i++) {
				_pb = _pa[i].split('=');
				if (_pb.length == 2) {
					_pc = [];
					_pc.push(_pb[0]);
					_pc.push(_pb[1]);
					aa += '[' + _pc.cfString() + ']';
					if (i < (_pa.length - 1)) {
						aa += ', ';
					}
				}
			}
			aa += ']';
		}
		return aa;
	},
	destructor : function() {
		return (this.id = QObj.$[this.id] = this.s_toString = this.colNames = this.dataRec = null);
	}
};

