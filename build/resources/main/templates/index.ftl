<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script>
        var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;

        var database = indexedDB.open("formulario", 1);

        database.onupgradeneeded = function (db) {
            active = database.result;

            var formulario = active.createObjectStore("formulario", {keyPath:'codigo', autoIncrement: true});

            formulario.createIndex('por_codigo', 'codigo', {unique: true});
        };

        database.onsuccess = function (db) {

        };

        database.onerror = function (e) {
            console.error('Error en el proceso: '+e.target.errorCode);
        };

        let cantidad = 0;
        let posicionId = 0;

        let opcionesGPS = {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
        };
        let coordenadas;
        $(document).ready(function (){
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
            // return coordenadas;
        });
        function agregarFormulario() {
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
            request.onsuccess = function (success) {
                document.querySelector("#nivelEscolar").value = 0;
                document.querySelector("#nombre").value = '';
                document.querySelector("#sector").value = '';

                console.log("Objeto correctamente agregado");
            };
        }
    </script>
    <title>Formulario</title>
</head>
<body>
    <!--<script src="geolocalizacion.js" type="module"></script>-->
    <#include "/navBar.ftl">
    <!--<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <a class="navbar-brand" href="#">Cornelia Form</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/">Formulario<span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/listaFormulario">Formularios Hechos</a>
                </li>
            </ul>
            <form class="form-inline my-2 my-lg-0">
                <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </div>
    </nav>-->
    <div class="container" style="margin-top: 20px;">
        <form>
            <div class="row">
                <div class="col">
                    <input type="text" name="nombre" id="nombre" class="form-control" placeholder="Nombre">
                </div>
                <div class="col">
                    <input type="text" name="sector" id="sector" class="form-control" placeholder="Sector">
                </div>
            </div>
            <div class="form-group">
                <label for="nivelEscolar">Nivel Escolar</label>
                <select class="form-control" name="nivelEscolar" id="nivelEscolar">
                    <option value="0">Nivel Básico</option>
                    <option value="1">Nivel Medio</option>
                    <option value="2">Grado Universitario</option>
                    <option value="3">Postgrado</option>
                    <option value="4">Doctorado</option>
                </select>
            </div>
            <button onclick="agregarFormulario()" type="button" class="btn btn-primary">Agregar</button>
        </form>
    </div>
</body>
</html>