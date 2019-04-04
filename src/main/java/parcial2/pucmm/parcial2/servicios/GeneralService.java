package parcial2.pucmm.parcial2.servicios;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Id;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaQuery;
import java.lang.reflect.Field;
import java.util.List;

public class GeneralService<T> {

    private static EntityManagerFactory emf;
    private Class<T> claseEntidadGeneral;


    public GeneralService(Class<T> claseEntidad) {
        if (emf == null) {
            emf = Persistence.createEntityManagerFactory("UnidadPersistencia");
        }
        this.claseEntidadGeneral = claseEntidad;

    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    /**
     * @param entidad
     * @return
     */
    private Object getValorCampo(T entidad) {
        if (entidad == null) {
            return null;
        }
        for (Field f : entidad.getClass().getDeclaredFields()) {
            if (f.isAnnotationPresent(Id.class)) {
                try {
                    f.setAccessible(true);
                    Object valorCampo = f.get(entidad);

                    return valorCampo;
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
        }

        return null;
    }

    /**
     * @param entidad
     */
    public void crear(T entidad) {
        EntityManager em = getEntityManager();

        try {
            if (em.find(claseEntidadGeneral, getValorCampo(entidad)) != null) {
                System.out.println("La entidad a guardar existe, no creada.");
                return;
            }
        } catch (IllegalArgumentException ie) {
            //
            System.out.println("Parametro aceptado. No agregado");
        }

        em.getTransaction().begin();
        try {
            em.persist(entidad);
            em.getTransaction().commit();

        } catch (Exception ex) {
            em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    /**
     * @return
     */
    public List<T> findAll() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<T> criteriaQuery = em.getCriteriaBuilder().createQuery(claseEntidadGeneral);
            criteriaQuery.select(criteriaQuery.from(claseEntidadGeneral));
            return em.createQuery(criteriaQuery).getResultList();
        } catch (Exception ex) {
            throw ex;
        } finally {
            em.close();
        }
    }

}
