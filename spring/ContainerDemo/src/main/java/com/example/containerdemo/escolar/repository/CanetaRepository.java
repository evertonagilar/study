package com.example.containerdemo.escolar.repository;

import com.example.containerdemo.escolar.Caneta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CanetaRepository extends JpaRepository<Caneta, Long> {
    public Caneta findByNome(String nome);
}
