/*	VCO.MapMarker
	Creates a marker. Takes a data object and
	populates the marker with content.
================================================== */

VCO.MapMarker = VCO.Class.extend({
	
	includes: [VCO.Events],
	
	/*	Constructor
	================================================== */
	initialize: function(data, options) {
		
		// DOM Elements
		this._el = {
			container: {},
			content_container: {},
			content: {}
		};
	
		// Components
		this._marker 				= {};
		
		// Marker Number
		this.marker_number = 0;
	
		// Data
		this.data = {
			uniqueid: 				"",
			background: {			// OPTIONAL
				url: 				null,
				color: 				null,
				opacity: 			50
			},
			date: 					null,
			location: {
				lat: 				-9.143962,
				lon: 				38.731094,
				zoom: 				13,
				icon: 				"http://maps.gstatic.com/intl/en_us/mapfiles/ms/micons/blue-pushpin.png"
			},
			text: {
				headline: 			"Le portrait mystérieux",
				text: 				"Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
			},
			media: {
				url: 				"http://2.bp.blogspot.com/-dxJbW0CG8Zs/TmkoMA5-cPI/AAAAAAAAAqw/fQpsz9GpFdo/s1600/voyage-dans-la-lune-1902-02-g.jpg",
				credit:				"Georges Méliès",
				caption:			"Le portrait mystérieux"
			}
		
		};
	
		// Options
		this.options = {
			// animation
			duration: 			1000,
			ease: 				VCO.Ease.easeInSpline,
			width: 				600,
			height: 			600,
			map_popup: 			false
		};
		
		
		// Animation Object
		this.animator = null;
		
		// Merge Data and Options
		VCO.Util.mergeData(this.options, options);
		VCO.Util.mergeData(this.data, data);
		
		this._initLayout();
		
	},
	
	/*	Public
	================================================== */
	show: function() {
		
	},
	
	hide: function() {
		
	},
	
	addTo: function(m) {
		this._addTo(m);
	},
	
	removeFrom: function(m) {
		this._removeFrom(m)
	},
	
	updateDisplay: function(w, h, a) {
		this._updateDisplay(w, h, a);
	},
	
	createMarker: function(d, o) {
		this._createMarker(d, o);
	},
	
	createPopup: function(d, o) {
		this._createPopup(d, o);
	},
	
	active: function(a) {
		this._active(a);
	},
	
	/*	Marker Specific
		Specific to Map API
	================================================== */
		_createMarker: function(d, o) {
			
		},
		
		_addTo: function(m) {
			
		},
		
		_removeFrom: function(m) {
			
		},
		
		_createPopup: function(d, o) {
		
		},
		
		_active: function(a) {
			
		},
	
	/*	Events
	================================================== */
	_onMarkerClick: function(e) {
		trace("MARKER CLICK");
		this.fire("markerclick", {marker_number: this.marker_number});
	},
	
	/*	Private Methods
	================================================== */
	_initLayout: function () {
		this._createMarker(this.data, this.options);
	},
	
	// Update Display
	_updateDisplay: function(width, height, animate) {
		
	}
	
});
