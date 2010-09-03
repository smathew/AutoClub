function fixMenuIE( menuId ) {
	if ( document.attachEvent ) {
		var holder = $( menuId );
		if ( holder != null ) {
			var li = holder.firstChild;
			while ( li != null ) {
				setupHandler( li, "mouseover", bindFunc( function() {
					addElementClass( this, "sfhover" );
				}, li ) );
				setupHandler( li, "mouseout", bindFunc( function() {
					removeElementClass( this, "sfhover" );
				}, li ) );
				li = li.nextSibling;
			}
		}
	}
}