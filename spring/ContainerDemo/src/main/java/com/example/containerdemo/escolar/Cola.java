package com.example.containerdemo.escolar;

import lombok.Data;

@Data
public class Cola implements IMaterial {
    private Long id;
    private String nome;
    private Marca marca;

    public Cola() {
    }

    public Cola(Long id, Marca marca) {
        this.id = id;
        this.marca = marca;
    }

}
