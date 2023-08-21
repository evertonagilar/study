package com.example.containerdemo.escolar;


import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

@Entity
@Data
@Table(name = "canetas")
public class Caneta implements IMaterial {

    private static final long serialVersionUID = 5868366871451523133L;
    @Id
    private Long id;
    private String nome;
    private Marca marca;

    @Autowired
    public void setId(Long id) {
        this.id = id;
    }

    @Autowired
    public void setMarca(@Qualifier("comum") Marca marca) {
        this.marca = marca;
    }
}
