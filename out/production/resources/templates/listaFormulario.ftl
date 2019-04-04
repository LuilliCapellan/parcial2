<!doctype html>
<html lang="en">
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
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
            integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
            integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
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

        .offline-ui, .offline-ui *, .offline-ui:before, .offline-ui:after, .offline-ui *:before, .offline-ui *:after {
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
        }

        .offline-ui {
            display: none;
            position: fixed;
            background: black;
            z-index: 2000;
            display: inline-block;
        }


        .offline-ui {
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            -ms-border-radius: 4px;
            -o-border-radius: 4px;
            border-radius: 4px;
            font-family: "Helvetica Neue", sans-serif;
            padding: 1em;
            max-width: 100%;
            bottom: 1em;
            left: 1em;
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
                if (formularios[key].enviado_al_servidor == 0) {
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
        (function () {
            var a, b, c, d, e, f, g;
            d = function (a, b) {
                var c, d, e, f;
                e = [];
                for (d in b.prototype) try {
                    f = b.prototype[d], null == a[d] && "function" != typeof f ? e.push(a[d] = f) : e.push(void 0)
                } catch (g) {
                    c = g
                }
                return e
            }, a = {}, null == a.options && (a.options = {}), c = {
                checks: {
                    xhr: {
                        url: function () {
                            return "/favicon.ico?_=" + Math.floor(1e9 * Math.random())
                        }, timeout: 5e3
                    }, image: {
                        url: function () {
                            return "/favicon.ico?_=" + Math.floor(1e9 * Math.random())
                        }
                    }, active: "xhr"
                }, checkOnLoad: !1, interceptRequests: !0, reconnect: !0
            }, e = function (a, b) {
                var c, d, e, f, g, h;
                for (c = a, h = b.split("."), d = e = 0, f = h.length; f > e && (g = h[d], c = c[g], "object" == typeof c); d = ++e) ;
                return d === h.length - 1 ? c : void 0
            }, a.getOption = function (b) {
                var d, f;
                return f = null != (d = e(a.options, b)) ? d : e(c, b), "function" == typeof f ? f() : f
            }, "function" == typeof window.addEventListener && window.addEventListener("online", function () {
                return setTimeout(a.confirmUp, 100)
            }, !1), "function" == typeof window.addEventListener && window.addEventListener("offline", function () {
                return a.confirmDown()
            }, !1), a.state = "up", a.markUp = function () {
                return a.trigger("confirmed-up"), "up" !== a.state ? (a.state = "up", a.trigger("up")) : void 0
            }, a.markDown = function () {
                return a.trigger("confirmed-down"), "down" !== a.state ? (a.state = "down", a.trigger("down")) : void 0
            }, f = {}, a.on = function (b, c, d) {
                var e, g, h, i, j;
                if (g = b.split(" "), g.length > 1) {
                    for (j = [], h = 0, i = g.length; i > h; h++) e = g[h], j.push(a.on(e, c, d));
                    return j
                }
                return null == f[b] && (f[b] = []), f[b].push([d, c])
            }, a.off = function (a, b) {
                var c, d, e, g, h;
                if (null != f[a]) {
                    if (b) {
                        for (e = 0, h = []; e < f[a].length;) g = f[a][e], d = g[0], c = g[1], c === b ? h.push(f[a].splice(e, 1)) : h.push(e++);
                        return h
                    }
                    return f[a] = []
                }
            }, a.trigger = function (a) {
                var b, c, d, e, g, h, i;
                if (null != f[a]) {
                    for (g = f[a], i = [], d = 0, e = g.length; e > d; d++) h = g[d], b = h[0], c = h[1], i.push(c.call(b));
                    return i
                }
            }, b = function (a, b, c) {
                var d, e, f, g, h;
                return h = function () {
                    return a.status && a.status < 12e3 ? b() : c()
                }, null === a.onprogress ? (d = a.onerror, a.onerror = function () {
                    return c(), "function" == typeof d ? d.apply(null, arguments) : void 0
                }, g = a.ontimeout, a.ontimeout = function () {
                    return c(), "function" == typeof g ? g.apply(null, arguments) : void 0
                }, e = a.onload, a.onload = function () {
                    return h(), "function" == typeof e ? e.apply(null, arguments) : void 0
                }) : (f = a.onreadystatechange, a.onreadystatechange = function () {
                    return 4 === a.readyState ? h() : 0 === a.readyState && c(), "function" == typeof f ? f.apply(null, arguments) : void 0
                })
            }, a.checks = {}, a.checks.xhr = function () {
                var c, d;
                d = new XMLHttpRequest, d.offline = !1, d.open("HEAD", a.getOption("checks.xhr.url"), !0), null != d.timeout && (d.timeout = a.getOption("checks.xhr.timeout")), b(d, a.markUp, a.markDown);
                try {
                    d.send()
                } catch (e) {
                    c = e, a.markDown()
                }
                return d
            }, a.checks.image = function () {
                var b;
                return b = document.createElement("img"), b.onerror = a.markDown, b.onload = a.markUp, void (b.src = a.getOption("checks.image.url"))
            }, a.checks.down = a.markDown, a.checks.up = a.markUp, a.check = function () {
                return a.trigger("checking"), a.checks[a.getOption("checks.active")]()
            }, a.confirmUp = a.confirmDown = a.check, a.onXHR = function (a) {
                var b, c, e;
                return e = function (b, c) {
                    var d;
                    return d = b.open, b.open = function (e, f, g, h, i) {
                        return a({
                            type: e,
                            url: f,
                            async: g,
                            flags: c,
                            user: h,
                            password: i,
                            xhr: b
                        }), d.apply(b, arguments)
                    }
                }, c = window.XMLHttpRequest, window.XMLHttpRequest = function (a) {
                    var b, d, f;
                    return f = new c(a), e(f, a), d = f.setRequestHeader, f.headers = {}, f.setRequestHeader = function (a, b) {
                        return f.headers[a] = b, d.call(f, a, b)
                    }, b = f.overrideMimeType, f.overrideMimeType = function (a) {
                        return f.mimeType = a, b.call(f, a)
                    }, f
                }, d(window.XMLHttpRequest, c), null != window.XDomainRequest ? (b = window.XDomainRequest, window.XDomainRequest = function () {
                    var a;
                    return a = new b, e(a), a
                }, d(window.XDomainRequest, b)) : void 0
            }, g = function () {
                return a.getOption("interceptRequests") && a.onXHR(function (c) {
                    var d;
                    return d = c.xhr, d.offline !== !1 ? b(d, a.markUp, a.confirmDown) : void 0
                }), a.getOption("checkOnLoad") ? a.check() : void 0
            }, setTimeout(g, 0), window.Offline = a
        }).call(this), function () {
            var a, b, c, d, e, f, g, h, i;
            if (!window.Offline) throw new Error("Offline Reconnect brought in without offline.js");
            d = Offline.reconnect = {}, f = null, e = function () {
                var a;
                return null != d.state && "inactive" !== d.state && Offline.trigger("reconnect:stopped"), d.state = "inactive", d.remaining = d.delay = null != (a = Offline.getOption("reconnect.initialDelay")) ? a : 3
            }, b = function () {
                var a, b;
                return a = null != (b = Offline.getOption("reconnect.delay")) ? b : Math.min(Math.ceil(1.5 * d.delay), 3600), d.remaining = d.delay = a
            }, g = function () {
                return "connecting" !== d.state ? (d.remaining -= 1, Offline.trigger("reconnect:tick"), 0 === d.remaining ? h() : void 0) : void 0
            }, h = function () {
                return "waiting" === d.state ? (Offline.trigger("reconnect:connecting"), d.state = "connecting", Offline.check()) : void 0
            }, a = function () {
                return Offline.getOption("reconnect") ? (e(), d.state = "waiting", Offline.trigger("reconnect:started"), f = setInterval(g, 1e3)) : void 0
            }, i = function () {
                return null != f && clearInterval(f), e()
            }, c = function () {
                return Offline.getOption("reconnect") && "connecting" === d.state ? (Offline.trigger("reconnect:failure"), d.state = "waiting", b()) : void 0
            }, d.tryNow = h, e(), Offline.on("down", a), Offline.on("confirmed-down", c), Offline.on("up", i)
        }.call(this), function () {
            var a, b, c, d, e, f;
            if (!window.Offline) throw new Error("Requests module brought in without offline.js");
            c = [], f = !1, d = function (a) {
                return Offline.trigger("requests:capture"), "down" !== Offline.state && (f = !0), c.push(a)
            }, e = function (a) {
                var b, c, d, e, f, g, h, i, j;
                j = a.xhr, g = a.url, f = a.type, h = a.user, d = a.password, b = a.body, j.abort(), j.open(f, g, !0, h, d), e = j.headers;
                for (c in e) i = e[c], j.setRequestHeader(c, i);
                return j.mimeType && j.overrideMimeType(j.mimeType), j.send(b)
            }, a = function () {
                return c = []
            }, b = function () {
                var b, d, f, g, h, i;
                for (Offline.trigger("requests:flush"), h = {}, b = 0, f = c.length; f > b; b++) g = c[b], i = g.url.replace(/(\?|&)_=[0-9]+/, function (a, b) {
                    return "?" === b ? b : ""
                }), h[g.type.toUpperCase() + " - " + i] = g;
                for (d in h) g = h[d], e(g);
                return a()
            }, setTimeout(function () {
                return Offline.getOption("requests") !== !1 ? (Offline.on("confirmed-up", function () {
                    return f ? (f = !1, a()) : void 0
                }), Offline.on("up", b), Offline.on("down", function () {
                    return f = !1
                }), Offline.onXHR(function (a) {
                    var b, c, e, f, g;
                    return g = a.xhr, e = a.async, g.offline !== !1 && (f = function () {
                        return d(a)
                    }, c = g.send, g.send = function (b) {
                        return a.body = b, c.apply(g, arguments)
                    }, e) ? null === g.onprogress ? (g.addEventListener("error", f, !1), g.addEventListener("timeout", f, !1)) : (b = g.onreadystatechange, g.onreadystatechange = function () {
                        return 0 === g.readyState ? f() : 4 === g.readyState && (0 === g.status || g.status >= 12e3) && f(), "function" == typeof b ? b.apply(null, arguments) : void 0
                    }) : void 0
                }), Offline.requests = {flush: b, clear: a}) : void 0
            }, 0)
        }.call(this), function () {
            var a, b, c, d, e;
            if (!Offline) throw new Error("Offline simulate brought in without offline.js");
            for (d = ["up", "down"], b = 0, c = d.length; c > b; b++) e = d[b], (document.querySelector("script[data-simulate='" + e + "']") || localStorage.OFFLINE_SIMULATE === e) && (null == Offline.options && (Offline.options = {}), null == (a = Offline.options).checks && (a.checks = {}), Offline.options.checks.active = e)
        }.call(this), function () {
            var a, b, c, d, e, f, g, h, i, j, k, l, m;
            if (!window.Offline) throw new Error("Offline UI brought in without offline.js");
            b = '<div class="offline-ui" style="    color: rgb(217, 215, 211);\n' +
                '    background-color: rgb(23, 24, 28);"><div class="offline-ui-content" style="    color: rgb(217, 215, 211);\n' +
                '    background-color: rgb(23, 24, 28);"></div></div>', a = '<a href class="offline-ui-retry"></a>', f = function (a) {
                var b;
                return b = document.createElement("div"), b.innerHTML = a, b.children[0]
            }, g = e = null, d = function (a) {
                return k(a), g.className += " " + a
            }, k = function (a) {
                return g.className = g.className.replace(new RegExp("(^| )" + a.split(" ").join("|") + "( |$)", "gi"), " ")
            }, i = {}, h = function (a, b) {
                return d(a), null != i[a] && clearTimeout(i[a]), i[a] = setTimeout(function () {
                    return k(a), delete i[a]
                }, 1e3 * b)
            }, m = function (a) {
                var b, c, d, e;
                d = {day: 86400, hour: 3600, minute: 60, second: 1};
                for (c in d) if (b = d[c], a >= b) return e = Math.floor(a / b), [e, c];
                return ["now", ""]
            }, l = function () {
                var c, h;
                return g = f(b), document.body.appendChild(g), null != Offline.reconnect && Offline.getOption("reconnect") && (g.appendChild(f(a)), c = g.querySelector(".offline-ui-retry"), h = function (a) {
                    return a.preventDefault(), Offline.reconnect.tryNow()
                }, null != c.addEventListener ? c.addEventListener("click", h, !1) : c.attachEvent("click", h)), d("offline-ui-" + Offline.state), e = g.querySelector(".offline-ui-content")
            }, j = function () {
                return l(), Offline.on("up", function () {
                    return k("offline-ui-down"), d("offline-ui-up"), h("offline-ui-up-2s", 2), h("offline-ui-up-5s", 5)
                }), Offline.on("down", function () {
                    return k("offline-ui-up"), d("offline-ui-down"), h("offline-ui-down-2s", 2), h("offline-ui-down-5s", 5)
                }), Offline.on("reconnect:connecting", function () {
                    return d("offline-ui-connecting"), k("offline-ui-waiting")
                }), Offline.on("reconnect:tick", function () {
                    var a, b, c;
                    return d("offline-ui-waiting"), k("offline-ui-connecting"), a = m(Offline.reconnect.remaining), b = a[0], c = a[1], e.setAttribute("data-retry-in-value", b), e.setAttribute("data-retry-in-unit", c)
                }), Offline.on("reconnect:stopped", function () {
                    return k("offline-ui-connecting offline-ui-waiting"), e.setAttribute("data-retry-in-value", null), e.setAttribute("data-retry-in-unit", null)
                }), Offline.on("reconnect:failure", function () {
                    return h("offline-ui-reconnect-failed-2s", 2), h("offline-ui-reconnect-failed-5s", 5)
                }), Offline.on("reconnect:success", function () {
                    return h("offline-ui-reconnect-succeeded-2s", 2), h("offline-ui-reconnect-succeeded-5s", 5)
                })
            }, "complete" === document.readyState ? j() : null != document.addEventListener ? document.addEventListener("DOMContentLoaded", j, !1) : (c = document.onreadystatechange, document.onreadystatechange = function () {
                return "complete" === document.readyState && j(), "function" == typeof c ? c.apply(null, arguments) : void 0
            })
        }.call(this);
    </script>
    <script>
        $(document).ready(function (e) {
            Offline.check();
            let estado = Offline.state;
            console.log(estado);
            if (estado === "up") {
                document.getElementById("enviarServidor").hidden = false;
            } else {
                document.getElementById("enviarServidor").hidden = true;
            }
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
                        if (cursor.value.enviado_al_servidor === 0) {
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
                                            result.enviado_al_servidor = 1;
                                            let solicitudUpdate = formularioAux.put(result);
                                            solicitudUpdate.onsuccess = (e) => {
                                                console.log(e);
                                            };
                                            solicitudUpdate.onerror = (e) => {
                                                console.error("Error Datos Actualizados....");
                                            };
                                        }
                                    }
                                }
                            });
                            cursor.continue();
                        } else {
                            cursor.continue();
                        }
                    } else {
                        location.reload();
                        console.log("terminó el cursor");
                    }
                };
            };
        }
    </script>
    <title>Lista de formulario</title>
</head>
<body style="    color: rgb(217, 215, 211);
    background-color: rgb(23, 24, 28);">
<#include "/navBar.ftl">
<div id="dialog-form" title="Editar Formulario" style="color: rgb(217, 215, 211);
    background-color: rgb(23, 24, 28);">
    <form>
        <fieldset>
            <label for="nombre">Nombre</label>
            <input type="text" name="nombre" id="nombre" value=""
                   style="background-color: rgb(46, 55, 70) !important; -webkit-text-fill-color: white"
                   class="text ui-widget-content ui-corner-all">
            <label for="sector">Sector</label>
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
</body>
</html>