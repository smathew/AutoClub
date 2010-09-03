/**
 * Javascript slideshow
 */
function jsslideshow( wrapper, imgArr ) {
	this.slidespeed = 3; // speed of the transition
	this.slidedelay = 5; // time to show a particular image
	this.currentIdx = 0;
	this.oldIdx = 0;
	this.newwindow = 0;

	//
	// Make sure the DOM is set up correctly
	//
	try {
	this.wrapper = $( wrapper );
	if ( this.wrapper == null )
		throw "Invalid wrapper object supplied.";

	//
	// Get a reference to the existing DOM elements
	//
	this.link = this.getAnchor();
	var img = this.getDefaultImage();

	//
	// Build the list of images, starting with the default image
	//
	img.id = "slideimage0";
	img.style.zIndex = 1;
	img.style.position = "absolute";
	var re;
	this.slideImages = [ { "img": img, "url": this.link.href } ];
	for ( var i = 0; i < imgArr.length; i++ ) {
		re = new RegExp( "^.*" + imgArr[i][0].replace( ".", "\\." ) + "$" );
		if ( !img.src.match( re ) )
			this.slideImages.push( this.createImage( imgArr[i][0], imgArr[i][1] ) );
	}

	this.oldIdx = this.slideImages.length - 1;
	this.currentIdx = 0;

	//
	// Find the dimensions of the largest image
	//
	var dims = null;
	var maxW = 0;
	var maxH = 0;
	for ( var i = 0; i < this.slideImages.length; i++ ) {
		dims = getElementDims( this.slideImages[i].img );
		if ( dims.width > maxW )
			maxW = dims.width;
		if ( dims.height > maxH )
			maxH = dims.height;
	}

	//
	// Fix the dimensions of the link and the images to this max size so 
	// there is no bleeding/jumping
	//
	this.link.style.width = maxW + "px";
	this.link.style.height = maxH + "px";
	for ( var i = 0; i < this.slideImages.length; i++ ) {
		this.slideImages[i].img.style.width = maxW + "px";
		this.slideImages[i].img.style.height = maxH + "px";
	}

	//
	// Schedule the first fade in
	//
	setTimeout( bindFunc( this.slideit, this ), this.slidedelay * 1000 );
	} catch (e) {
		console.error( e );
	}
}

jsslideshow.prototype = {
	getAnchor: function() {
		var links = this.wrapper.getElementsByTagName( "a" );
		if ( links.length <= 0 )
			throw "Unable to locate anchor.";
		else
			return links[0];
	},
	getDefaultImage: function() {
		var imgs = this.link.getElementsByTagName( "img" );
		if ( imgs.length <= 0 )
			throw "Unable to locate default image.";
		else
			return imgs[0];		
	},
	createImage: function( filename, url ) {
		var img = new Image();
		img.id = "slideimage" + this.slideImages.length;
		img.alt = "Slideshow Image";
		img.src = "images/" + filename;
		img.style.position = "absolute";
		changeOpacity( img, 0 );
		this.link.appendChild( img );
		return { "img": img, "url": url };
	},
	slideit: function() {
		//
		// Move the current image to z-index 1 and change the old opacity to 0
		//
		this.slideImages[this.currentIdx].img.style.zIndex = 1;
		changeOpacity( this.slideImages[this.oldIdx].img, 0 );

		//
		// Bump the indices
		//
		this.oldIdx = this.currentIdx;
		this.currentIdx = ( this.currentIdx + 1 ) % this.slideImages.length;

		//
		// Get the next image
		//
		var imgObj = this.slideImages[this.currentIdx];
		imgObj.img.style.zIndex = 2;

		//
		// Update the link URL to point to the URL for the new image
		//
		this.link.setAttribute( "href", imgObj.url );

		//
		// Fade the new image in
		//
		appear( imgObj.img, this.slidespeed );

		//
		// Schedule the next fade in.
		//
		setTimeout( bindFunc( this.slideit, this ), ( this.slidedelay + this.slidespeed ) * 1000 );
	}
};

function initSlideshow() {
	if ( window.slideShowImages != null )
		window.slideObj = new jsslideshow( window.slideShowWrapper, window.slideShowImages );
}

addInitFunc( initSlideshow );
