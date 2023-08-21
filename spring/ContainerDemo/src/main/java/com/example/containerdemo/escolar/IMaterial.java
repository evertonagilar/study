package com.example.containerdemo.escolar;

import java.io.Serializable;

public interface IMaterial extends Serializable {

    public Long getId();
    public String getNome();
    public Marca getMarca();

    default public void log(){
        System.out.println(this.getId() + "  -- " + this.getNome() + " -- " + this.getMarca().getDescricao());
    }
}
