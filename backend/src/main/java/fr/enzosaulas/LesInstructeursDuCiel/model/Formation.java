package fr.enzosaulas.LesInstructeursDuCiel.model;

import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 *  Une formation est un cursus d'un diplôme parmit la liste définie suivante :
 *  BIA, ABL, LAPL, PPL, CPl, ATPL, MPL, CAEA, IR, QT, MCC
 *
 *  <p>Pour passer à une formation supérieure il faut impérativement celle de du niveau précédent</p>
 *  <p>Elle est définie par :</p>
 *  <ul>
 *      <li> le nom de la formation parmit la liste : nomF</li>
 *      <li> la description : descriptionF</li>
 *      <li> la formation du niveau précédent si besoin : formationNecessaire </li>
 *  </ul>
 */
@Entity
@Table(name = "FORMATION")
@Getter @Setter
@NoArgsConstructor
public class Formation {

    @Id // clé primaire
    @Column(length = 10)
    private String nomF;

    @Column(nullable = false, length = 500)
    private String descriptionF;

    @ManyToOne // REQUIRE : FORMATION (0,1) --- (0,n) FORMATION
    @JoinColumn(name = "nomFNecessaire")  // clé étrangère
    private Formation formationNecessaire;

    // FORMATION (0,n) --- POSSEDER
    @OneToMany(mappedBy = "formation")
    private List<Posseder> possesseurs = new ArrayList<>();

    public Formation(String nomF, String descriptionF, Formation formationNecessaire) {
        this.nomF = nomF;
        this.descriptionF = descriptionF;
        this.formationNecessaire = formationNecessaire;
    }
}