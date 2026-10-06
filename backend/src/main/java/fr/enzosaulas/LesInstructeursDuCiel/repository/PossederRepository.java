package fr.enzosaulas.LesInstructeursDuCiel.repository;

import fr.enzosaulas.LesInstructeursDuCiel.model.Posseder;
import fr.enzosaulas.LesInstructeursDuCiel.model.PossederId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PossederRepository extends JpaRepository<Posseder, PossederId> { }
