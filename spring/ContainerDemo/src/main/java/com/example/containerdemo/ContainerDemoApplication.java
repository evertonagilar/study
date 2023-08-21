package com.example.containerdemo;

import com.example.containerdemo.escolar.Caneta;
import com.example.containerdemo.escolar.Cola;
import com.example.containerdemo.escolar.IMaterial;
import com.example.containerdemo.escolar.Lapis;
import com.example.containerdemo.escolar.repository.CanetaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
public class ContainerDemoApplication {

    public static void main(String[] args) {
        ApplicationContext context = SpringApplication.run(ContainerDemoApplication.class, args);
        ApplicationContext xmlContext = new ClassPathXmlApplicationContext(new String[]{"classpath:spring.xml"}, context);

        Caneta caneta = context.getBean(Caneta.class);
        caneta.log();

        CanetaRepository canetaRepository = context.getBean(CanetaRepository.class);
        if (canetaRepository.findByNome("caneta Bic") != null){
            System.out.println("Já existe bic cadastrado!");
        }

        canetaRepository.save(caneta);
        canetaRepository.flush();

        IMaterial lapis = context.getBean(Lapis.class);
        lapis.log();

        Cola cola = context.getBean("madeira", Cola.class);
        cola.log();

        Cola cola2 = (Cola) xmlContext.getBean("tenaz");
        cola2.log();

        Caneta outra = canetaRepository.findById(caneta.getId()).orElseThrow(IllegalArgumentException::new);
        outra.log();


    }

}
