<!doctype html>
<html lang="en" >
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
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
            integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v5.3.0/css/ol.css"
          type="text/css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
            integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
            crossorigin="anonymous"></script>
    <style>
        .map {
            background: black;
            height: 93vh;
            width: 100%;
        }

    </style>
    <script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v5.3.0/build/ol.js"></script>

    <title>Mapa</title>
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
<div id="map" class="map"></div>
<script type="text/javascript">
    let formularios = [];
    $(document).ready(function () {
        $.ajax({
            type: "GET",
            url: "/api/formularios",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (result) {
                formularios = result;
                console.log(result)
                let markers = [];
                let i = 0;
                formularios.forEach(formularioElement => {
                    var marker = new ol.Feature({
                        geometry: new ol.geom.Point(
                            ol.proj.fromLonLat([formularioElement.longitud, formularioElement.latitud])
                        ),
                    });
                    i++;
                    markers.push(marker);
                    if (formularios.length === i) {
                        var vectorSource = new ol.source.Vector({
                            features: markers
                        });
                        var markerVectorLayer = new ol.layer.Vector({
                            source: vectorSource,
                        });
                        map.addLayer(markerVectorLayer);
                    }
                });
            },
            error: function () {
                debugger;
                alert('error');
            }
        });
    });
    var baseMapLayer = new ol.layer.Tile({
        source: new ol.source.OSM()
    });
    var map = new ol.Map({
        target: 'map',
        layers: [baseMapLayer],
        view: new ol.View({
            center: ol.proj.fromLonLat([-70.6752018, 19.4487403]),
            zoom: 13
        })
    });
</script>
</body>
</html>