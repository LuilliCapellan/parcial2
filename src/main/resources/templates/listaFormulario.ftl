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
            filaTabla.insertCell().textContent = "Acciones";
            for (let key in formularios) {
                if (formularios[key].cargado_online == 0) {
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
                    filaTabla.insertCell().innerHTML = '<button class="btn btn-primary" id="' + formularios[key].codigo + '" onclick="editandoFormulario(' + formularios[key].codigo + ')" style="margin-right: 15px; background-color: rgb(46, 55, 70) !important;">Editar</button><button class="btn btn-primary" style="background-color: rgb(46, 55, 70) !important;" onclick="eliminarFormulario(' + formularios[key].codigo + ')">Eliminar</button>';
                }
            }
            document.getElementById("tablaFormulario").innerHTML = "";
            document.getElementById("tablaFormulario").appendChild(tabla);
        }

        function eliminarFormulario(codigo) {
            let dbEdicion = database.result;
            let edicionArchivo = dbEdicion.transaction(["formulario"], "readwrite");
            let formulario = edicionArchivo.objectStore("formulario");
            formulario.delete(codigo).onsuccess = (e) => {
                console.log("eliminado correctamente");
                location.reload();
            }
        }

        function editandoFormulario(codigo) {
            console.log(codigo);
            let dbEdicion = database.result;
            let edicionArchivo = dbEdicion.transaction(["formulario"], "readwrite");
            let formulario = edicionArchivo.objectStore("formulario");
            codigoFormulario = codigo;
            dialog = $("#dialog-form").dialog({
                autoOpen: false,
                height: 400,
                width: 350,
                modal: true,
                buttons: {
                    "Editar": editar,
                    Cancel: function () {
                        dialog.dialog("close");
                    }
                },
                close: function () {
                    form[0].reset();
                    allFields.removeClass("ui-state-error");
                }
            });
            form = dialog.find("form").on("submit", function (event) {
                event.preventDefault();
            });
            $("#" + codigo).button().on("click", function () {
                dialog.dialog("open");
            });
            formulario.get(codigo).onsuccess = (e) => {
                let result = e.target.result;
                console.log(result);
                if (result !== undefined) {
                    document.getElementById("nombre").value = "" + result.nombre;
                    document.getElementById("sector").value = "" + result.sector;
                    document.getElementById("nivelEscolar").value = "" + result.nivelScolar;
                }
            };
        }

        function editar() {
            let dbEdicion = database.result;
            let edicionArchivo = dbEdicion.transaction(["formulario"], "readwrite");
            let formulario = edicionArchivo.objectStore("formulario");
            formulario.get(codigoFormulario).onsuccess = (e) => {
                let result = e.target.result;
                if (result !== undefined) {
                    result.nombre = document.getElementById("nombre").value;
                    result.sector = document.getElementById("sector").value;
                    result.nivelScolar = document.getElementById("nivelEscolar").value;
                    let solicitudUpdate = formulario.put(result);
                    solicitudUpdate.onsuccess = (e) => {
                        console.log("terminó todo");
                        dialog.dialog("close");
                        location.reload();
                    };
                    solicitudUpdate.onerror = (e) => {
                        console.error("Error Datos Actualizados....");
                    };
                }
            }
        }
    </script>
    <script>
        $(function () {
            var dialog, form,

                emailRegex = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/,
                nombre = $("#nombre"),
                sector = $("#sector"),
                nivelEscolar = $("#nivelEscolar"),
                allFields = $([]).add(nombre).add(sector).add(nivelEscolar),
                tips = $(".validateTips");

            function updateTips(t) {
                tips
                    .text(t)
                    .addClass("ui-state-highlight");
                setTimeout(function () {
                    tips.removeClass("ui-state-highlight", 1500);
                }, 500);
            }

            function checkLength(o, n, min, max) {
                if (o.val().length > max || o.val().length < min) {
                    o.addClass("ui-state-error");
                    updateTips("Length of " + n + " must be between " +
                        min + " and " + max + ".");
                    return false;
                } else {
                    return true;
                }
            }

            function checkRegexp(o, regexp, n) {
                if (!(regexp.test(o.val()))) {
                    o.addClass("ui-state-error");
                    updateTips(n);
                    return false;
                } else {
                    return true;
                }
            }

            function addUser() {
                var valid = true;
                allFields.removeClass("ui-state-error");

                valid = valid && checkLength(name, "username", 3, 16);
                valid = valid && checkLength(email, "email", 6, 80);
                valid = valid && checkLength(password, "password", 5, 16);

                valid = valid && checkRegexp(name, /^[a-z]([0-9a-z_\s])+$/i, "Username may consist of a-z, 0-9, underscores, spaces and must begin with a letter.");
                valid = valid && checkRegexp(email, emailRegex, "eg. ui@jquery.com");
                valid = valid && checkRegexp(password, /^([0-9a-zA-Z])+$/, "Password field only allow : a-z 0-9");

                if (valid) {
                    $("#users tbody").append("<tr>" +
                        "<td>" + name.val() + "</td>" +
                        "<td>" + email.val() + "</td>" +
                        "<td>" + password.val() + "</td>" +
                        "</tr>");
                    dialog.dialog("close");
                }
                return valid;
            }

            dialog = $("#dialog-form").dialog({
                autoOpen: false,
                height: 400,
                width: 350,
                modal: true,
                buttons: {
                    "Create an account": addUser,
                    Cancel: function () {
                        dialog.dialog("close");
                    }
                },
                close: function () {
                    form[0].reset();
                    allFields.removeClass("ui-state-error");
                }
            });

            form = dialog.find("form").on("submit", function (event) {
                event.preventDefault();
                addUser();
            });

            $("#create-user").button().on("click", function () {
                dialog.dialog("open");
            });
        });
    </script>
    <script>
        function enviarFormulario() {
            let indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
            let database = indexedDB.open("formulario", 1);
            database.onsuccess = (e) => {
                let dbActiva = database.result;
                let datos = dbActiva.transaction(["formulario"], "readwrite");
                let formulario = datos.objectStore("formulario");
                formulario.openCursor().onsuccess = (e) => {
                    let cursor = e.target.result;
                    console.log(cursor);
                    if (cursor) {
                        if (cursor.value.cargado_online === 0) {
                            console.log(cursor);
                            let objetoFormulario = {
                                codigo: cursor.value.codigo,
                                nombre: cursor.value.nombre,
                                sector: cursor.value.sector,
                                latitud: cursor.value.latitud,
                                longitud: cursor.value.longitud,
                                nivelEscolar: cursor.value.nivelScolar
                            };
                            $.ajax({
                                method: 'POST',
                                data: JSON.stringify(objetoFormulario),
                                url: '/api/enviarFormularios',
                                success: function (data) {
                                    console.log(data);
                                    let datosAux = dbActiva.transaction(["formulario"], "readwrite");
                                    let formularioAux = datosAux.objectStore("formulario");
                                    formularioAux.get(objetoFormulario.codigo).onsuccess = (e) => {
                                        let result = e.target.result;
                                        if (result !== undefined) {
                                            result.cargado_online = 1;
                                            let solicitudUpdate = formularioAux.put(result);
                                            solicitudUpdate.onsuccess = (e) => {
                                                console.log(e);
                                               location.reload();
                                            };
                                            solicitudUpdate.onerror = (e) => {
                                                console.error("Error al actualizar datos....");
                                                location.reload();
                                            };
                                        }
                                    }
                                }
                            });
                        } else {
                            cursor.continue();
                        }
                    } else {
                        console.log("el cursor a acabado");
                        location.reload();
                    }
                };
            };
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
<div id="dialog-form" title="Editar Formulario" style="color: rgb(217, 215, 211);
    background-color: rgb(23, 24, 28);">
    <form>
        <fieldset>
            <input type="text" name="nombre" id="nombre" value=""
                   style="background-color: rgb(46, 55, 70) !important; -webkit-text-fill-color: white"
                   class="text ui-widget-content ui-corner-all">
            <input type="text" name="sector" id="sector" value=""
                   style="background-color: rgb(46, 55, 70) !important; -webkit-text-fill-color: white"
                   class="text ui-widget-content ui-corner-all">
            <div class="form-group">
                <select class="form-control" name="nivelEscolar"
                        style="background-color: rgb(46, 55, 70) !important; -webkit-text-fill-color: white"
                        id="nivelEscolar"
                        class="text ui-widget-content ui-corner-all">
                    <option value="0">Nivel Básico</option>
                    <option value="1">Nivel Medio</option>
                    <option value="2">Grado Universitario</option>
                    <option value="3">Postgrado</option>
                    <option value="4">Doctorado</option>
                </select>
            </div>
            <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
        </fieldset>
    </form>
</div>
<div id="tablaFormulario"
     style=" margin-top: 2vh;background-color: rgb(46, 55, 70) !important; -webkit-text-fill-color: white">

</div>
<button type="submit" onclick="enviarFormulario()" id="enviarServidor" class="btn btn-primary"
        style="width: 100%; background-color: rgb(46, 55, 70) !important;">
    Subir Datos
</button>
<div id="no_internet" title="Basic dialog" hidden="true">
    <p> Fallo el envio de datos! No existe conexion a internet!</p>
</div>
<div id="si_internet" title="Basic dialog" hidden="true">
    <p> Ha subido los datos con exito!</p>
</div>
</body>
</html>