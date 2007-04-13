//always call this script after the SWF object script has called the flamingo viewer.
var flamingo;
function init() {
   if (document.getElementById) {
      flamingo = document.getElementById("flamingo");
   }
}
window.onload = init;
function flamingo_onInit() {
   //at this moment the flamingo.swf is up and running, so initialize the global flamingo var.
   flamingo =getMovie("flamingo");
}
function getMovie(movieName) {
   if (navigator.appName.indexOf("Microsoft") != -1) {
            return window[movieName];
   }else {
      return document[movieName];
   }
}
