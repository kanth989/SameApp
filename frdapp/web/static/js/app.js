// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".


import {Socket} from "deps/phoenix/web/static/js/phoenix"

class App {

	static init() {
	  var username = $("#username")
	  var msgBody  = $("#message")
	  

	function getlocation() {
		
            if (navigator.geolocation) {
            	
                navigator.geolocation.getCurrentPosition(function(position) {
                    initMapView(position);
                   
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
            // window._position = position;
            // Pan to Geo location
            map.panTo([lat, lng]);
            //  Add marker to the Geo location
            // addMarker(lat, lng, user.val());
            // Add Circle
            // var circle = L.circle([lat, lng], 4000).addTo(map);
           // return pos;
           channel.push("new:message", {
		      	
		        user: username.val(),
		        body: msgBody.val(),
		        // console.log( this.getlocation());
		        "lat": lat,
		        "lng": lng
		      })
        }



	  let socket = new Socket("/socket")
	  socket.connect()
	  socket.onClose( e => console.log("Closed connection") )

	  var channel = socket.channel("rooms:lobby", {})
	  channel.join()
	  .receive( "error", () => console.log("Failed to connect") )
	  .receive( "ok",    () => console.log("Connected") )

	setInterval(function(){

  			if( msgBody.val().length > 0 ) {
  				getlocation();
  				
  				//console.log(pos +"   @@@@@@@@@@@@@@@@");
		      
		      
		    } 

	}, 2000);


  	channel.on( "new:message", msg => this.renderMessage(msg) )

	}

	static addMarker(lat, lng, popupContent) {
       var marker = L.marker([lat, lng]).addTo(map);

        if (popupContent){
            marker.bindPopup(popupContent).openPopup();
        }
        return marker;
    }

	static renderMessage(msg) {

	  var messages = $("#messages")
	  var adding_map = this.addMarker(msg.lat, msg.lng, msg.user)
	  messages.append(`<p><b>[${msg.user}]</b>: ${msg.body}</p>`)
	}
	static sanitize(str) { return $("<div/>").text(str).html() }

  
}


$( () => App.init() )

export default App