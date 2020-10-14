/** BEGIN: events.js ************************************************************************/

const_events_list = 'Abort,AfterUpdate,BeforeUnload,BeforeUpdate,Blur,Bounce,Click,Change,DataAvailable,DataSetChanged,DataSetComplete,DblClick,DragDrop,Error,ErrorUpdate,FilterChange,Focus,Help,KeyDown,KeyPress,KeyUp,Load,MouseDown,MouseMove,MouseOut,MouseOver,MouseUp,MouseWheel,Move,ReadyStateChange,Reset,Resize,RowEnter,RowExit,Scroll,Select,SelectStart,Start,Submit,Unload';

function events_unHookAllEventHandlers(anObj) {
	function recursive_delete( object) {
		if (!object || object.delete_in_progress) {
			return;
		}
		try {
			object.delete_in_progress = true;
			var a = const_events_list.split(',');
			for (var i = 0; i < a.length; i++) {
				var selector = 'on' + a[i];
				if (Eval('object.selector')) {
					Eval('object.selector = null')
				}
			}
			for (var name in object) {
				if (name != 'delete_in_progress') {
					recursive_delete( object[name]);
					object[name] = null;
				}
			}
		}
		catch (e) {
			//alert (e.message);
		}
	}
}

/** END! events.js ************************************************************************/

