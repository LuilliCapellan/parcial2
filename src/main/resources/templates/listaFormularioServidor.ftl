<!doctype html>
<html lang="en" manifest="conexion.appcache">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" type="text/css" href="/cache-css/css/bootstrap.css">
    <script src="/cache-css/js/jquery-3.3.1.min.js"></script>
    <script src="/cache-css/js/bootstrap.js"></script>
    <script src="/cache-css/js/jquery-1.12.4.min.js"></script>
    <#--<script src="/cache-css/js/offline.min.js"></script>-->
    <script src="/cache-css/js/jquery-ui.js"></script>
    <script src="/cache-css/js/jquery-ui.css"></script>

    <#--<link rel="stylesheet" type="text/css" href="/cache-css/css/offline-theme-default.css">-->
    <#--<link rel="stylesheet" type="text/css" href="/cache-css/css/offline-language-spanish.min.css">-->
    <style>
        label, input {
            color: rgb(217, 215, 211);

            display: block;
        }

        input.text {
            color: rgb(217, 215, 211);
            margin-bottom: 12px;
            width: 95%;
            padding: .4em;
        }

        fieldset {
            padding: 0;
            border: 0;
            margin-top: 25px;
        }

        h1 {
            font-size: 1.2em;
            margin: .6em 0;
        }

        div#users-contain table {
            text-decoration-color: white;
            margin: 1em 0;
            border-collapse: collapse;
            width: 100%;
        }

        div#users-contain table td, div#users-contain table th {
            text-decoration-color: white;

            border: 1px solid #eee;
            padding: .6em 10px;
            text-align: left;
        }
    </style>
    <script>
        let indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
        let database = indexedDB.open("formulario", 1);
        let codigoFormulario = 0;
        let dialog, form,
            nombre = $("#nombre"),
            sector = $("#sector"),
            nivelEscolar = $("#nivelEscolar"),
            allFields = $([]).add(nombre).add(sector).add(nivelEscolar);
        $(document).ready(function (e) {
            database.onsuccess = function (e) {
                cargar(database);
                console.log('Base de datos leída correctamente');
            };

            database.onerror = function (e) {
                console.error('Error en el proceso: ' + e.target.errorCode);
            };

        });

        function cargar(database) {
            let dbActiva = database.result;
            let datos = dbActiva.transaction(["formulario"]);
            let formulario = datos.objectStore("formulario");
            let formularios = [];
            // let contador = 0;

            formulario.openCursor().onsuccess = (e) => {
                let cursor = e.target.result;
                if (cursor) {
                    formularios.push(cursor.value);
                    cursor.continue();
                } else {
                    console.log("terminó el cursor");
                }
            };

            datos.oncomplete = () => {
                insertarTable(formularios);
            };
        }

        function insertarTable(formularios) {
            let tabla = document.createElement("table");
            tabla.classList.add("table");
            let filaTabla = tabla.insertRow();
            tabla.insertRow().classList.add("col");
            filaTabla.insertCell().textContent = "Nombre";
            filaTabla.insertCell().textContent = "Sector";
            filaTabla.insertCell().textContent = "Nivel Escolar";
            for (let key in formularios) {
                if (formularios[key].cargado_online == 1) {
                    filaTabla = tabla.insertRow();
                    filaTabla.setAttribute("id", "" + formularios[key].codigo);
                    filaTabla.insertCell().textContent = "" + formularios[key].nombre;
                    filaTabla.insertCell().textContent = "" + formularios[key].sector;
                    if (formularios[key].nivelScolar === "0") {
                        filaTabla.insertCell().textContent = "Nivel Basico";
                    } else if (formularios[key].nivelScolar === "1") {
                        filaTabla.insertCell().textContent = "Nivel Medio";
                    } else if (formularios[key].nivelScolar === "2") {
                        filaTabla.insertCell().textContent = "Grado Universitario";
                    } else if (formularios[key].nivelScolar === "3") {
                        filaTabla.insertCell().textContent = "Postgrado";
                    } else if (formularios[key].nivelScolar === "4") {
                        filaTabla.insertCell().textContent = "Doctorado";
                    }
                }
            }
            document.getElementById("tablaFormulario").innerHTML = "";
            document.getElementById("tablaFormulario").appendChild(tabla);
        }
    </script>
    <title>Lista de formulario</title>
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
                <a class="nav-link" href="/listaFormularioServidor">Datos Servidor</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/mapa">Maps</a>
            </li>
        </ul>
    </div>
</nav>
<div id="tablaFormulario"
     style=" margin-top: 2vh;background-color: rgb(46, 55, 70) !important; -webkit-text-fill-color: white">

</div>
</body>
</html>