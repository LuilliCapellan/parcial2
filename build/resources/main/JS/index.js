var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;

var database = indexedDB.open("formulario", 1);

database.onupgradeneeded = function () {
    let active = database.result;

    var formulario = active.createObjectStore("formulario", {keyPath: 'codigo', autoIncrement: true});

    formulario.createIndex('por_codigo', 'codigo', {unique: true});
};

database.onsuccess = function (db) {

};

database.onerror = function (e) {
    console.error('Error en el proceso: ' + e.target.errorCode);
};
