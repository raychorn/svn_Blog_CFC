/**************************************************************************/

window.onscroll = function () {
	var dObj = $('div_sysMessages');
	if (!!dObj) {
		dObj.style.position = 'absolute';
		dObj.style.top = document.body.scrollTop + 50 + 'px';
		dObj.style.width = (clientWid$() - 10) + 'px';
		dObj.style.height = (clientHt$() - 10) + 'px';
	}
}
