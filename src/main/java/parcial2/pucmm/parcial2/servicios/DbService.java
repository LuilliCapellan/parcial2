package parcial2.pucmm.parcial2.servicios;

import org.h2.tools.Server;

import java.sql.SQLException;

public class DbService {
    private static DbService instancia;

    public static DbService getInstancia() {
        if (instancia == null) {
            instancia = new DbService();
        }
        return instancia;
    }

    public void iniciarDn() {
        try {
            Server.createTcpServer("-tcpPort", "9092", "-tcpAllowOthers", "-tcpDaemon").start();

        } catch (SQLException ex) {
            System.out.println("Error en la base de datos: " + ex.getMessage());
        }
    }

    public void init() {
        iniciarDn();
    }
}
