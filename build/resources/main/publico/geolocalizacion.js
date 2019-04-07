let cantidad = 0;
let posicionId = 0;

let opcionesGPS = {
    enableHighAccuracy: true,
    timeout: 5000,
    maximumAge: 0
};
let coordenadas;
export function obtenerCoordenadas(){
   console.log('entrando geolocalización');

   navigator.geolocation.getCurrentPosition(function (position) {
       coordenadas = position.coords;
       console.log(position.coords);
   }, function (positionError) {
       console.log("no se pudo acceder a la posición: " + positionError);
   }, opcionesGPS);

   /*posicionId = navigator.geolocation.watchPosition(function (position) {
       coordenadas = position.coords;
       console.log(position.coords);
   }, function (positionError) {
       console.log(positionError);
   });*/
}

export function getCoodenadas() {
    return coordenadas;
}