package fr.enzosaulas.LesInstructeursDuCiel.model;

import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;

/**
 * Représenta la clé primaire de l'entité POSSERDER
 */
@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class PossederId implements Serializable {

    private Long idPers;
    private String nomF;
}
