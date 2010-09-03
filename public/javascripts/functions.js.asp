
if ( !Array.indexOf ) {
	Array.prototype.indexOf = function( obj ){
		for ( var i = 0; i < this.length; i++ ) {
			if ( this[i] == obj ) return i;
		}
		return -1;
	}
}

String.prototype.trim = function () {
    return this.replace( /^\s*/, "" ).replace( /\s*$/, "" );
}

/* Adds object oriented inheritance to Javascript!  Yay! */
function extend(descendant, base_class, extension_dict) {
	function wrap(func, base_class_func) {
		return function() {
			var prev = this.$base_class_func;
			this.$base_class_func = base_class_func;
			try { return func.apply(this, arguments); }
			finally { this.$base_class_func = prev; }
		}
	}
	function wrap_ctor(ctor, old_ctor) {
		return function() {
			var prev = this.$base_ctor;
			this.$base_ctor = old_ctor;
			try { return ctor.apply(this, arguments); }
			finally { this.$base_ctor = prev; }
		}
	}

	/*
	 * Copy over all of base_class's methods
	 */
	for (var m in base_class.prototype) {
		descendant.prototype[m] = base_class.prototype[m];
	}

	/*
	 * Wrap the base constructor
	 */
	var old_base_ctor = base_class.prototype['$base_ctor'];
	if (old_base_ctor) {
		descendant.prototype['$base_ctor'] = wrap_ctor(base_class, old_base_ctor);
	} else {
		descendant.prototype['$base_ctor'] = base_class;
	}

	/*
	 * Now add all of the child methods, wrapping if necessary
	 */
	for (var m in extension_dict) {
		var val = extension_dict[m];
		/*
		 * Make sure we're actually overriding a function, and that the overridden
		 * function is referenced with $base_class_func().
		 */
		if (base_class.prototype[m] && val.toString().indexOf("$base_class_func") != -1) {
			descendant.prototype[m] = wrap(val, base_class.prototype[m]);
		} else {
			descendant.prototype[m] = val;
		}
	}
}

function clone( obj ) {
	var newObj = ( obj instanceof Array ) ? [] : {};
	for ( i in obj ) {
		if ( obj[i] && typeof( obj[i] ) == "object" ) {
			newObj[i] = clone( obj[i] );
		} else {
			newObj[i] = obj[i];
		}
	}
	return newObj;
};

function setAttrs( obj, attrs ) {
	for ( k in attrs ) {
		obj.setAttribute( k, attrs[k] );
	}
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

function getEnv( ) {
	if ( typeof( window ) == "undefined" )
		return "SERVER";
	else
		return "CLIENT";
}

function checkEmail( email ) {
	var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	if ( !filter.test( email ) )
		return false;
	else
		return true;
}

function stripQuotes( str ) {									
	var strWork  = "" + str;
	var rtnString = "";
	var tmpChar = "";
	for ( i = 0; i < strWork.length; i++ ) {
		tmpChar = strWork.charAt(i);
		if ( tmpChar != "'" )
			rtnString += tmpChar;
	}
	return rtnString;
}

function pad( field, chr, len ) {
	var strField = "";
	if ( field != null && typeof( field ) != "undefined" )
		strField = field.toString();

	while ( strField.length < len )
		strField = strField + chr;

	return strField;
}

function padLeft( field, chr, len ) {
	var strField = "";
	if ( field != null && typeof( field ) != "undefined" )
		strField = field.toString();

	while ( strField.length < len )
		strField = chr + strField;
	return strField;
}

function padRight( field, chr, len ) {
	var strField = "";
	if ( field != null && typeof( field ) != "undefined" )
		strField = field.toString();

	while ( strField.length < len )
		strField = strField + chr;
	return strField;
}

function sprintf() {
	function _format( match, sign ) {
		if ( sign )
			match.sign = match.negative ? '-' : match.sign;
		else
			match.sign = '';

		var l = match.min - match.argument.length + 1 - match.sign.length;
		var pad = new Array( l < 0 ? 0 : l ).join( match.pad );

		return pad + match.sign + match.argument;
	}

	if ( typeof( arguments ) == "undefined" ) return null;
	if ( arguments.length < 1 ) return null;
	if ( typeof( arguments[0] ) != "string" ) return null;
	if ( typeof( RegExp ) == "undefined" ) return null;

	//var exp = new RegExp( /(%([%]|(\-)?(\+|\x20)?(0)?(\d+)?(\.(\d)?)?([bcdfosxX])))/g );

	var string		= arguments[0];
	var exp			= new RegExp( /(%([%]|(0)?(\d+)?(\.(\d)?)?([sdf])))/g );
	var matches 	= [];
	var strings 	= [];
	var match		= null;
	var argIdx		= 0;
	var strPosBeg	= 0;
	var strPosEnd	= 0;
	var matchPosEnd	= 0;
	var newstring	= "";

	while ( ( match = exp.exec( string ) ) != null ) {
		if ( match[7] ) argIdx += 1;

		strPosBeg = matchPosEnd;
		strPosEnd = exp.lastIndex - match[0].length;
		strings.push( string.substring( strPosBeg, strPosEnd ) );
		matchPosEnd = exp.lastIndex;

		matches.push( {
			match: match[0],
			pad: match[3] || ' ',
			min : match[4] || 0,
			precision: match[6],
			code: match[7] || "%",
			sign: '',
			negative: parseInt( arguments[argIdx] ) < 0 ? true : false,
			argument: String( arguments[argIdx] )
		} );
	}

	strings.push( string.substring( matchPosEnd ) );

	var subst = "";
	for ( var i = 0; i < matches.length; i++ ) {
		switch ( matches[i].code ) {
			case "%":
				subst = "%";
				break;
			case "d":
				matches[i].argument = String( Math.abs( parseInt( matches[i].argument ) ) );
				subst = _format( matches[i], true );
				break;
			case "f":
				matches[i].argument = String( Math.abs( parseFloat( matches[i].argument ) ).toFixed( matches[i].precision ? matches[i].precision : 6 ) );
				subst = _format( matches[i], true );
				break;
			case "s":
				subst = _format( matches[i], false );
				break;
			default:
				subst = matches[i].match;
		}
		newstring += strings[i];
		newstring += subst;
	}
	newstring += strings[i];

	return newstring;
}

function fmtDate( dateObj, fmt ) {
	if ( dateObj == null || typeof( dateObj ) == "undefined" || dateObj == "" )
		return "";

	// Poor man's strftime()
	var dt = new Date( dateObj );
	
	/* We'll do this once we have a need for multi-language support
	if ( fmt == "%D" && typeof( vbFmtDate ) != "undefined" ) {
		dt = fmtDate( dt, "%d/%m/%Y" );  // VB wants things moved around for FormatDateTime.
		return vbFmtDate( dt, false );
	}
	*/

	var m = String( dt.getMonth() + 1 );
	var d = String( dt.getDate() );
	var y = String( dt.getYear() );
	var y = dt.getFullYear();
	if ( y < 2000 )
		y = String( y % 1900 );
	else
		y = String ( y % 2000 );
	var Y = String( dt.getFullYear() );
	var H = String( dt.getHours() );
	var M = String( dt.getMinutes() );
	var S = String( dt.getSeconds() );

	// %D  == %m/%d/%Y
	// %0D == %0m/%0d/%Y
	// %-D == %-m/%-d/%Y
	// %T  == %H:%0M:%0S

	var str = fmt.replace( /%D/,	"%m/%d/%Y" );
		str = str.replace( /%0D/,	"%0m/%0d/%Y" );
		str = str.replace( /%-D/,	"%-m/%-d/%Y" );
		str = str.replace( /%-m/g,	padLeft( m, " ", 2 ) );
		str = str.replace( /%0m/g,	padLeft( m, "0", 2 ) );
		str = str.replace( /%m/g,	m );
		str = str.replace( /%-d/g,	padLeft( d, " ", 2 ) );
		str = str.replace( /%0d/g,	padLeft( d, "0", 2 ) );
		str = str.replace( /%d/g,	d );
		str = str.replace( /%y/g,	padLeft( y, "0", 2 ) );
		str = str.replace( /%Y/g,	Y);
		str = str.replace( /%T/g,	"%H:%0M:%0S" );
		str = str.replace( /%0T/g,	"%0H:%0M:%0S" );
		str = str.replace( /%-T/g,	"%-H:%-M:%-S" );
		str = str.replace( /%-H/g,	padLeft( H, " ", 2 ) );
		str = str.replace( /%0H/g,	padLeft( H, "0", 2 ) );
		str = str.replace( /%H/g,	H );
		str = str.replace( /%-M/g,	padLeft( M, " ", 2 ) );
		str = str.replace( /%0M/g,	padLeft( M, "0", 2 ) );
		str = str.replace( /%M/g,	M );
		str = str.replace( /%-S/g,	padLeft( S, " ", 2 ) );
		str = str.replace( /%0S/g,	padLeft( S, "0", 2 ) );
		str = str.replace( /%S/g,	S );

	return str;
}

function fmtCurrency( field, addComma ) {
	var num = "0";
	if ( field != null && typeof( field ) != "undefined" && field != "" )
		num = field.toString().replace(/\$|\,/g, "");

	if ( isNaN( num ) )
		num = "0";

	var val = parseFloat(num).toFixed(2);
	var str = val.toString();
	var x = str.split(".");
	var dollars = x[0];
	var cents = pad( ( x.length > 1 ? x[1] : "" ), "0", 2 );

	if ( addComma != false ) {
		var re = /(\d+)(\d{3})/;
		while ( re.test( dollars ) )
			dollars = dollars.replace( re, "$1" + "," + "$2" );
	}

	return dollars + "." + cents;
}

function fmtPostalCode( field ) {
	var fld = "";
	if ( typeof( field ) == "undefined" || String( field ) == "" )
		return "";

	fld = String( field );

	if ( fld.length > 5 && fld.indexOf( "-" ) == -1 )
		fld = fld.substring( 0, 5 ) + "-" + fld.substring( 5 );

	return fld;
}

function fmtPhone( field ) {
	var fld = "";
	if ( typeof( field ) == "undefined" || String( field ) == "" )
		return "";

	fld = String( field );

	fld = fld.replace( /[^0-9]/g, "" );

	if ( fld.length == 7 )
		return fld.substring( 0, 3 ) + "-" + fld.substring( 3 );
	else if ( fld.length == 10 )
		return "(" + fld.substring( 0, 3 ) + ") " + fld.substring( 3, 6 ) + "-" + fld.substring( 6 );
	else
		return fld;
}

function fmtTaxID( field ) {
	var fld = "";
	if ( typeof( field ) == "undefined" || String( field ) == "" )
		return "";

	fld = String( field ).replace( /[^0-9]/g, "" ).trim();
	fld = padLeft( fld, "0", 9 );

	fld = fld.replace( /^([0-9]{3})([0-9]{2})([0-9]{4})$/, "$1-$2-$3" );
	return fld;
}

function insertAfter( elem, newElem ) {
	var e = $( elem );
	if ( e.nextSibling == null ) {
		e.parentNode.appendChild( newElem );
	} else {
		elem.parentNode.insertBefore( newElem, e.nextSibling );
	}
}

/*******************************/
/*        DATE ROUTINES        */
/*******************************/
function compareDates( date1, date2 ) {
	var dt = new Date( date1 );
	var dt1 = new Date( dt.getFullYear(), dt.getMonth(), dt.getDate() );

	dt = new Date( date2 );
	var dt2 = new Date( dt.getFullYear(), dt.getMonth(), dt.getDate() );
	if ( dt1 > dt2 )
		return 1;
	else if ( dt2 > dt1 )
		return -1;
	else
		return 0;
}

function getDaysofYear( year )  {
	var feb = 28;
    if ( leapYear( year ) )
        feb = 29;
    return [31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
}

function leapYear ( year ) {
	return ( ( year % 4 == 0 ) && ( year % 100 != 0 ) ) || ( year % 400 == 0 );
}

function customEndDate( dateObj, fmt ) {
	var dt = new Date( dateObj );
	dt.setDate( getDaysofYear( dt.getFullYear() )[dt.getMonth()] );
	return fmtDate( dt, fmt );
}

function currentDate( fmt ) {
	return fmtDate( new Date(), fmt );
}

function moveDate( days, dt, fmt ) {
	var dateObj = new Date( dt );
	dateObj.setDate( dateObj.getDate() + days );
	return fmtDate( dateObj, fmt );
}

function daysPrior( daysBack, fmt ) {
	return moveDate( -daysBack, new Date(), fmt );
}

function daysAhead( daysAhead, fmt ) {
	return moveDate( daysAhead, new Date(), fmt );
}

function thirtyDaysPrior( dateObj , fmt ) {
	var dt = new Date( dateObj );
	var year = dt.getFullYear();
	var month = dt.getMonth() - 1;
	if ( month == -1 ) {
		year--;
		month = 11;
	}
	var days = getDaysofYear( year )[month];
	var day = Math.abs( dt.getDate() - days );
	day = days - day;

	dt.setFullYear( year, month, day );

	return fmtDate( dt, fmt );
}
