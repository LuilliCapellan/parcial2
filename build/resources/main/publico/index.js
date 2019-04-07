import "./geolocalizacion.js";

var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;

var database = indexedDB.open("formulario", 1);

database.onupgradeneeded = function (db) {
    let active = database.result;

    var formulario = active.createObjectStore("formulario", {keyPath:'codigo', autoIncrement: true});

    formulario.createIndex('por_codigo', 'codigo', {unique: true});
};

database.onsuccess = function (db) {

};

database.onerror = function (e) {
    console.error('Error en el proceso: '+e.target.errorCode);
};

export function agregarFormulario() {
    var dbActiva = database.result;

    var transaccion = dbActiva.transaction(["formulario"], "readwrite");

    transaccion.onerror = function (error) {
        var mensajeError = "Error: " + error.target.errorCode;
        console.error(mensajeError);
        alert(mensajeError);
    };

    transaccion.oncomplete = function (error) {
        document.querySelector("#nivelEscolar").value = 0;
        document.querySelector("#nombre").value = '';
        document.querySelector("#sector").value = '';

        alert("Objeto correctamente agregado");
    }

    var formulario = transaccion.objectStore("formulario");

    var request = formulario.put({
        nivelScolar: document.querySelector("#nivelEscolar").value,
        nombre: document.querySelector("#nombre").value,
        sector: document.querySelector("#sector").value,
        enviado_al_servidor: 0,
        latitud: obtenerCoordenadas().latitude,
        longitud: obtenerCoordenadas().longitude
    });

    request.onerror = function (e) {
        var mensaje = "Error: "+e.target.errorCode;
        console.error(mensaje);
        alert(mensaje)
    };
    request.onsuccess = function (success) {
        document.querySelector("#nivelEscolar").value = 0;
        document.querySelector("#nombre").value = '';
        document.querySelector("#sector").value = '';

        console.log("Objeto correctamente agregado");
    }
}