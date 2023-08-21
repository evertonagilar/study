package com.example.containerdemo;

import com.example.containerdemo.escolar.Caneta;
import com.example.containerdemo.escolar.Cola;
import com.example.containerdemo.escolar.Lapis;
import com.example.containerdemo.escolar.Marca;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
public class MaterialEscolaConfig {

    @Bean("madeira")
    public Cola getColaMadeira(Long id, @Qualifier("premium") Marca marca){
        Cola cola = new Cola();
        cola.setId(id);
        cola.setMarca(marca);
        cola.setNome("Cola Super bonder");
        return cola;
    }


    @Bean
    public Caneta getCaneta(){
       Caneta caneta = new Caneta();
       caneta.setNome("caneta Bic");
       return caneta;
    }

    @Qualifier("premium")
    @Bean
    public Marca getMarcaPremium(){
        Marca marca = new Marca();
        marca.setDescricao("premium");
        return marca;
    }

    @Qualifier("lowcard")
    @Bean
    public Marca getMarcaLowcard(){
        Marca marca = new Marca();
        marca.setDescricao("lowcard");
        return marca;
    }

    @Qualifier("comum")
    @Bean
    public Marca getMarcaComum(){
        Marca marca = new Marca();
        marca.setDescricao("comum");
        return marca;
    }

    @Autowired
    @Primary
    @Bean
    public Lapis getLapis(Long id, @Qualifier("premium") Marca marca){
        Lapis lapis = new Lapis();
        lapis.setId(id);
        lapis.setMarca(marca);
        lapis.setNome("lapis preto");
        return lapis;
    }

}
