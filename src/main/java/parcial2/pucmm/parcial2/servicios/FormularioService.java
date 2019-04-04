package parcial2.pucmm.parcial2.servicios;

import parcial2.pucmm.parcial2.entidades.Formulario;

public class FormularioService extends GeneralService<Formulario> {
    private static FormularioService formularioServiceIntance;

    public FormularioService() {
        super(Formulario.class);
    }

    public static FormularioService getInstancia() {
        if (formularioServiceIntance == null) {
            formularioServiceIntance = new FormularioService();
        }
        return formularioServiceIntance;
    }
}
