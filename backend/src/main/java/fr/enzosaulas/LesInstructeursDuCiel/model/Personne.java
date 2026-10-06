package fr.enzosaulas.LesInstructeursDuCiel.model;

import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Un personne est un utilisateur, soit Technicien, soit Instructeur, soit un Apprenti pilote.
 *
 *  <p> Il est défini par : </p>
 *  <ul>
 *      <li> un identifiant : idPers</li>
 *      <li> un nom : nomP</li>
 *      <li> un prenom : prenomP</li>
 *      <li> une date de naissance : dateDeNaissanceP</li>
 *      <li> une adresse mail : emailP</li>
 *      <li> un mot de passe : moDePasse</li>
 *  </ul>
 *  <p> Pour se connecter à l'application, son identifiant sera son email et son mot de passe</p>
 *
 * @author Enzo
 * @since 0.0.1
 */
@Entity
@Table(name = "PERSONNE")
@Getter @Setter
@NoArgsConstructor
public class Personne {

    @Id                                                   // PK
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idPers;

    @Column(nullable = false, length = 50)
    private String nomP;

    @Column(nullable = false, length = 50)
    private String prenomP;

    private LocalDate dateDeNaissanceP;

    @Column(nullable = false, unique = true, length = 150)
    private String emailP;

    @Column(nullable = false, length = 200)
    private String motDePasse;

    // PERSONNE (0,n) --- POSSEDER
    @OneToMany(mappedBy = "personne")
    private List<Posseder> formationsPossedees = new ArrayList<>();

    public Personne(String nomP, String prenomP, LocalDate dateDeNaissanceP,
                    String emailP, String motDePasse) {
        this.nomP = nomP;
        this.prenomP = prenomP;
        this.dateDeNaissanceP = dateDeNaissanceP;
        this.emailP = emailP;
        this.motDePasse = motDePasse;
    }
}

