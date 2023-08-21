package com.example.containerdemo.escolar;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.io.Serializable;

@Data
@Entity
public class Marca implements Serializable {

    private static final long serialVersionUID = -6342416213437615582L;
    @Id
    private String descricao;

    public Marca() {
        this.descricao = "Sem marca";
    }
}
