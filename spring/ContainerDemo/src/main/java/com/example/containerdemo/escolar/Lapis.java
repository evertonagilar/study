package com.example.containerdemo.escolar;

import lombok.Data;

import java.text.MessageFormat;

@Data
public class Lapis implements IMaterial {

    private Long id;
    private String nome;
    private Marca marca;

    @Override
    public void log() {
        System.out.println(MessageFormat.format("{0} -- {1} -- {2}", id, nome, marca.getDescricao()));
    }
}
