function svgvml3d() {
	var oDiagramFrame = $('iframe_diagram1');
	var oDiagram3D = $('iframe_diagram3D');
	var oForm = $('form_diagram1');
	var oSelection = $('selection_graphType');
	if (!!oSelection) {
		oSelection.selectedIndex = 0;
	}
	if (!!oForm) {
		oForm.style.display = const_none_style;
	}
	if (!!oDiagramFrame) {
		oDiagramFrame.style.display = const_none_style;
	}
	if (!!oDiagram3D) {
		oDiagram3D.style.display = const_inline_style;
		oDiagram3D.style.width = '900px';
		oDiagram3D.style.height = '500px';
		oDiagram3D.src = window.location.href + 'svgvml3d/index.html';
	}
}

