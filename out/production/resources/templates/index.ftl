<!doctype html>
<html lang="en" manifest="conexion.appcache">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
            integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
            integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
            crossorigin="anonymous"></script>
    <script>
        var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;

        var database = indexedDB.open("formulario", 1);

        database.onupgradeneeded = function () {
            active = database.result;

            var formulario = active.createObjectStore("formulario", {keyPath: 'codigo', autoIncrement: true});

            formulario.createIndex('por_codigo', 'codigo', {unique: true});
        };

        database.onsuccess = function (db) {

        };

        database.onerror = function (e) {
            console.error('Error en el proceso: ' + e.target.errorCode);
        };
        let opcionesGPS = {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
        };
        let coordenadas;
        $(document).ready(function () {
            console.log('entrando geolocalización');

            navigator.geolocation.getCurrentPosition(function (position) {
                coordenadas = position.coords;
                console.log(position.coords);
            }, function (positionError) {
                console.log("no se pudo acceder a la posición: " + positionError);
            }, opcionesGPS);

        });

        function agregarFormulario() {
            var dbActiva = database.result;

            var transaccion = dbActiva.transaction(["formulario"], "readwrite");

            transaccion.onerror = function (error) {
                var mensajeError = "Error: " + error.target.errorCode;
                console.error(mensajeError);
                alert(mensajeError);
            };

            transaccion.oncomplete = function () {
                document.querySelector("#nivelEscolar").value = 0;
                document.querySelector("#nombre").value = '';
                document.querySelector("#sector").value = '';

                alert("Objeto correctamente agregado");
            };

            var formulario = transaccion.objectStore("formulario");

            var request = formulario.put({
                nivelScolar: document.querySelector("#nivelEscolar").value,
                nombre: document.querySelector("#nombre").value,
                sector: document.querySelector("#sector").value,
                enviado_al_servidor: 0,
                latitud: coordenadas.latitude,
                longitud: coordenadas.longitude
            });

            request.onerror = function (e) {
                var mensaje = "Error: " + e.target.errorCode;
                console.error(mensaje);
                alert(mensaje)
            };
            request.onsuccess = function () {
                document.querySelector("#nivelEscolar").value = 0;
                document.querySelector("#nombre").value = '';
                document.querySelector("#sector").value = '';

                console.log("Objeto correctamente agregado");
            };
        }
    </script>
    <title>Formulario</title>
</head>
<body style="    color: rgb(217, 215, 211);
    background-color: rgb(23, 24, 28);">
<nav class="navbar navbar-expand-lg navbar-dark bg-primary" style="background-color: rgb(46, 55, 70) !important; ">
    <a class="navbar-brand" href="#">Parcial 2</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent"
         style="background-color: rgb(46, 55, 70) !important;">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="/">Ingresar Datos</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/listaFormulario">Ver Datos</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/mapa">Maps</a>
            </li>
        </ul>
    </div>
</nav>
<div class="container" style="color: rgb(217, 215, 211);
    background-color: rgb(23, 24, 28);
height: 93vh">
    <form>
        <div class="form-group">
            <input type="text" name="nombre" id="nombre" class="form-control" placeholder="Nombre" style="
    color: rgb(201, 197, 191);
    background-color: rgb(23, 24, 28);
    border-top-color: rgb(54, 63, 72);
    border-right-color: rgb(54, 63, 72);
    border-bottom-color: rgb(54, 63, 72);
    border-left-color: rgb(54, 63, 72);
                    margin-bottom: 2vh;
                    margin-top: 2vh">
            <input type=" text" name="sector" id="sector" class="form-control" placeholder="Sector"
                   style="margin-bottom: 2vh;
                       color: rgb(201, 197, 191);
    background-color: rgb(23, 24, 28);
    border-top-color: rgb(54, 63, 72);
    border-right-color: rgb(54, 63, 72);
    border-bottom-color: rgb(54, 63, 72);
    border-left-color: rgb(54, 63, 72);
                 ">
            <select class="form-control" name="nivelEscolar" id="nivelEscolar" style="
    color: rgb(201, 197, 191);
    background-color: rgb(23, 24, 28);
    border-top-color: rgb(54, 63, 72);
    border-right-color: rgb(54, 63, 72);
    border-bottom-color: rgb(54, 63, 72);
    border-left-color: rgb(54, 63, 72);
                    margin-bottom: 2vh; ">
                <option value="0">Nivel Básico</option>
                <option value="1">Nivel Medio</option>
                <option value="2">Grado Universitario</option>
                <option value="3">Postgrado</option>
                <option value="4">Doctorado</option>
            </select>
        </div>
        <button style="width: 100%; background-color: rgb(46, 55, 70) !important;" onclick="agregarFormulario()"
                type="button" class="btn btn-primary">Añadir
        </button>
    </form>
</div>
</body>
</html>

