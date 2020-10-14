function insertArrayItem(a,newValue,position) {
	if (position && position > -1) {
		a.splice(position,0,newValue);
	}
	else {
		a.unshift(newValue);
	}
}

