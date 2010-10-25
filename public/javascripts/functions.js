function getElement( id ) {
	if ( typeof( id ) == "string" )
		return document.getElementById( id );
	else
		return id;
}

function addElementClass(element, className) {
	var obj = getElement(element);
	var cls = obj.className;
	if (cls == undefined || cls.length == 0) {
		obj.className = className;
		return true;
	}
	if (cls == className)
		return false;

	var classes = cls.split(" ");
	for (var i = 0; i < classes.length; i++) {
		if (classes[i] == className)
			return false;
	}

	obj.className = cls + " " + className;
	return true;
}

function hasElementClass(element, className) {
	var obj = getElement(element);
	var cls = obj.className;
	if (!cls)
		return false;

	var classes = cls.split(" ");
	for (var i = 0; i < classes.length; i++) {
		if (classes[i] == className) {
			return true;
		}
	}
	return false;
}

function removeElementClass(element, className) {
	var obj = getElement(element);
	var cls = obj.className;
	if (cls == undefined || cls.length == 0)
		return false;

	if (cls == className) {
		obj.className = "";
		return true;
	}

	var classes = cls.split(" ");
	for (var i = 0; i < classes.length; i++) {
		if (classes[i] == className) {
			classes.splice(i, 1);
			obj.className = classes.join(" ");
			return true;
		}
	}
	return false;
}

function setVisible( element, isVisible ) {
	if ( isVisible )
		removeElementClass( element, "invisible" );
	else
		addElementClass( element, "invisible" );	
}

function getEvent(event) {
	var evt = null;
	if (event)
		evt = event;
	else
		evt = window.event;

	return evt;
}

function getEvtSrc(evt) {
	var e = getEvent(evt);
	return (e.target) ? e.target : e.srcElement;
}

function stopEvent(evt) {
	var e = getEvent(evt);
	e.cancelBubble = true;
	if ( e.stopPropagation ) e.stopPropagation();
	if ( e.preventDefault ) e.preventDefault();
}

function getWindowSize() {
	var width = 0;
	var height = 0;

	if ( typeof( window.innerWidth ) == "number" ) {
		width = window.innerWidth;
		height = window.innerHeight;
	} else if ( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight )) {
		width = document.documentElement.clientWidth;
		height = document.documentElement.clientHeight;
	} else if ( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
		width = document.body.clientWidth;
		height = document.body.clientHeight;
	}

	return {"width": width, "height": height};
}

function getScrollXY() {
	var scrOfX = 0, scrOfY = 0;
	if ( typeof( window.pageYOffset ) == 'number' ) {
		//Netscape compliant
		scrOfY = window.pageYOffset;
		scrOfX = window.pageXOffset;
	} else if ( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
		//DOM compliant
		scrOfY = document.body.scrollTop;
		scrOfX = document.body.scrollLeft;
	} else if ( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
		//IE6 standards compliant mode
		scrOfY = document.documentElement.scrollTop;
		scrOfX = document.documentElement.scrollLeft;
	}
	return {"x": scrOfX, "y": scrOfY};
}
function getElementPos(e) {
	var elem = getElement(e);


	if (!elem) {
		return {'x': -1, 'y': -1};
	}

	var left = 0;
	var top = 0;

	if (elem.offsetParent) {
		do {
			left += elem.offsetLeft;
			top += elem.offsetTop;
		} while ( ( elem = elem.offsetParent) != null );
	}

	return {'x': left, 'y': top};
}

function getElementDims(e) {
	var elem = getElement( e );

	if ( !elem ) {
		return {"x": -1, "y": -1};
	}

	var isHidden = hasElementClass( elem, "invisible" );
	var oldVisibility = elem.style.visibility;
	var oldPosition = elem.style.position;
	if ( isHidden ) {
		elem.style.visibility = "hidden";
		elem.style.position = "absolute";
		setVisible( elem, true );
	}

	var width = elem.offsetWidth;
	var height = elem.offsetHeight;

	if ( isHidden ) {
		setVisible( elem, false );
		elem.style.visibility = oldVisibility;
		elem.style.position = oldPosition;
	}

	return {"width": width, "height": height};
}

function scrollToElement( e ) {
	var elem = getElement( e );

	var windowSize = getWindowSize();
	var windowScroll = getScrollXY();

	var elemSize = getElementDims( elem );
	var elemPos = getElementPos( elem );

	if ( elemPos.x < windowScroll.x || elemPos.y < windowScroll.y )
		window.scrollTo( elemPos.x, elemPos.y );
	else if ( ( elemPos.x + elemSize.width ) > ( windowScroll.x + windowSize.width ) )
		window.scrollTo( elemPos.x, elemPos.y );
	else if ( ( elemPos.y + elemSize.height ) > ( windowScroll.y + windowSize.height ) )
		window.scrollTo( elemPos.x, elemPos.y );
}

function changeOpacity( elem, opacity ) {
	var e = getElement( elem );
	e.style.opacity = opacity / 100;
	e.style.MozOpacity = opacity / 100;
	e.style.KhtmlOpacity = opacity / 100;
	e.style.filter = "alpha(opacity=" + opacity + ")";
	//alert("filter: " + e.style.filter);
}

function setupHandler( obj, event, func, useCapture ) {
	if ( obj.addEventListener )
		obj.addEventListener( event, func, useCapture );
	else if ( obj.attachEvent )
		obj.attachEvent( "on" + event, func );
}

function openWindow(url, width, height, scrollbars, resizable, extras) {
	var opts = [];
	if (scrollbars != null && scrollbars == true)
		opts.push("scrollbars");
	if (resizable != null && resizable == true)
		opts.push("resizable");
	if (width != null)
		opts.push("width=" + width);
	if (height != null)
		opts.push("height=" + height);

	if ( extras != null ) {
		for ( var attr in extras ) {
			if ( extras[attr].length > 0 )
				opts.push( attr + "=" + extras[attr] );
			else
				opts.push( attr );
		}
	}
	return window.open(url, 'remote', opts.join(','))
}

function bindFunc( func, self ) {
	var newFunc = function () {
		var args = arguments;
		var me = arguments.callee;
		var self = me.im_self;
		return me.im_func.apply(self, args);
	};
	newFunc.im_self = self;
	newFunc.im_func = func;
	return newFunc;
}

function hbwindow( event ) {
	stopEvent( event );
	openWindow( this.href, 750, 550, true, true, {'top': 10, 'left': 10, 'status': "", 'resizable': ""} );
	return false;
}

function fixLinkTargets() {
	if (!document.getElementsByTagName) return;
	var anchors = document.getElementsByTagName( "a" );
	for ( var i = 0; i < anchors.length; i++ ) {
		var anchor = anchors[i];
		if ( anchor.getAttribute( "href" ) ) {
			if ( anchor.getAttribute( "rel" ) == "external" ) {
				anchor.target = "_blank";
			} else if ( anchor.getAttribute( "rel" ) == "hblogin" ) {
				setupHandler( anchor, "click", bindFunc( hbwindow, anchor ) );
			}
		}
	}
}

window.initFuncs = [fixLinkTargets];

function initPage() {
	for ( var i = 0; i < window.initFuncs.length; i++ ) {
		window.initFuncs[i]();
	}
}

if ( window.addEventListener ) {
	window.addEventListener( "load", initPage, false );
} else if ( window.attachEvent ) {
	window.attachEvent( "onload", initPage );
}