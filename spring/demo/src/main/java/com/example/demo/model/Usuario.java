package com.example.demo.model;

import jakarta.persistence.*;
import lombok.Data;
@Data
@Entity
@Table(name = "usuario")
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String cpf;

    public Usuario() {

    }

    public Usuario(Long id, String nome, String cpf) {
        this.id = id;
        this.nome = nome;
        this.cpf = cpf;
    }

}
