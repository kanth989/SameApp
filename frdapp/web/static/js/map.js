
	function getlocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    return initMapView(position);
                }, function (error) {
                    console.warn('Please allow us to access your Geolocation');
                });
            }else {
                console.log('Geolocation not supported on your browser');
            }
		}
	function initMapView (position) {
            var lat = position.coords.latitude, lng = position.coords.longitude;
            console.log('Your Location : ',  lat, ' ,',  lng);
            window._position = position;
            // Pan to Geo location
            // map.panTo([lat, lng]);
            //  Add marker to the Geo location
            // addMarker(lat, lng);
            // Add Circle
            // var circle = L.circle([lat, lng], 4000).addTo(map);
            return position;
        }

  /* function addMarker(position, popupContent) {
            var marker = L.marker([position.coords.latitude, position.coords.longitude]).addTo(map);
            if (popupContent){
                marker.bindPopup(popupContent).openPopup();
            }
            return marker;
        }*/