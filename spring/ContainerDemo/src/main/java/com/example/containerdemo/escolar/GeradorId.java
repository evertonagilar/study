package com.example.containerdemo.escolar;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.concurrent.atomic.AtomicLong;

@Component
public class GeradorId {
    private static AtomicLong gerador = new AtomicLong(1);

    @Bean
    @Scope("prototype")
    public Long getId(){
        Long novoId = gerador.getAndIncrement();
        System.out.println("Gerando id "+ novoId);
        return novoId;
    }

}
