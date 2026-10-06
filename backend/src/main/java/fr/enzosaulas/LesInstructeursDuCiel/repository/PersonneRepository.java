package fr.enzosaulas.LesInstructeursDuCiel.repository;

import fr.enzosaulas.LesInstructeursDuCiel.model.Personne;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PersonneRepository extends JpaRepository<Personne, Long> { }
