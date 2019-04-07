package parcial2.pucmm.parcial2.main;

import com.google.gson.Gson;
import freemarker.template.Configuration;
import parcial2.pucmm.parcial2.entidades.Formulario;
import parcial2.pucmm.parcial2.servicios.DbService;
import parcial2.pucmm.parcial2.servicios.FormularioService;
import spark.template.freemarker.FreeMarkerEngine;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static spark.Spark.*;
import static spark.debug.DebugScreen.enableDebugScreen;

public class Main {
    public final static String ACCEPT_TYPE_JSON = "application/json";

    public static void main(String[] args) {
        DbService.getInstancia().iniciarDn();
        Configuration configuration = new Configuration(Configuration.getVersion());
        configuration.setClassForTemplateLoading(Main.class, "/templates");
        staticFiles.location("/MANIFEST");
        FreeMarkerEngine freeMarkerEngine = new FreeMarkerEngine(configuration);
        crearEntidades();
        enableDebugScreen();

        get("/", (request, response) -> modelAndView(null, "index.ftl"), freeMarkerEngine);

        get("/listaFormulario", (request, response) -> modelAndView(null, "listaFormulario.ftl"), freeMarkerEngine);

        get("/mapa", (request, response) -> {
            List<Formulario> formularios = FormularioService.getInstancia().findAll();
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("formularios", formularios);
            return modelAndView(attributes, "mapa.ftl");
        }, freeMarkerEngine);

        path("/api", () -> {
            post("/enviarFormularios", Main.ACCEPT_TYPE_JSON, (request, response) -> {
                Formulario formulario;
                formulario = new Gson().fromJson(request.body(), Formulario.class);
                System.out.println(formulario);
                FormularioService.getInstancia().crear(formulario);
                System.out.println(request.body());
                return formulario;
            }, JsonUtilidades.json());
            get("/formularios", Main.ACCEPT_TYPE_JSON, (request, response) -> FormularioService.getInstancia().findAll(), JsonUtilidades.json());
        });
    }

    public static void crearEntidades() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("UnidadPersistencia");
        EntityManager entityManager = emf.createEntityManager();
        entityManager.getTransaction().begin();
    }
}