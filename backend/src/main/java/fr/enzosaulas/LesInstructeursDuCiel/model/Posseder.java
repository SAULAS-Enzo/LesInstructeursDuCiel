package fr.enzosaulas.LesInstructeursDuCiel.model;

import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.Date;

/**
 * Un posseder associe une persersonne à plusieurs formations qu'elle possède.
 * Elle relie une formation à une liste de personnes qui l'a possède
 *
 * <p>Elle est défini par : </p>
 * <ul>
 *     <li> l'identifiant de la pseronne : idPers</li>
 *     <li> le nom de la formation : nomF</li>
 *     <li> la date d'obtention de la formation : dateObtention</li>
 * </ul>
 *
 * @author Enzo
 * @since 0.0.1
 */
@Entity
@Table(name = "POSSEDER")
@Getter @Setter
@NoArgsConstructor
public class Posseder {

    @EmbeddedId                                           // PK composite (idPers, nomF)
    private PossederId id = new PossederId();

    @ManyToOne
    @MapsId("idPers")                                     // FK -> PERSONNE.idPers
    @JoinColumn(name = "idPers")
    private Personne personne;

    @ManyToOne
    @MapsId("nomF")                                       // FK -> FORMATION.nomF
    @JoinColumn(name = "nomF")
    private Formation formation;

    @Column(nullable = false)
    private LocalDate dateObtention;

    public Posseder(Personne personne, Formation formation, LocalDate dateObtention) {
        this.id = new PossederId(personne.getIdPers(), formation.getNomF());
        this.personne = personne;
        this.formation = formation;
        this.dateObtention = dateObtention;
    }
}