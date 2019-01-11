package aula.io;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.ejb.PostActivate;
import javax.enterprise.context.RequestScoped;
import javax.inject.Named;
import java.io.Serializable;
import java.util.Objects;

@Named
@RequestScoped
public class Pessoa implements Serializable {
    private String nome;
    private String email;

    public Pessoa() {
    }

    public Pessoa(String nome, String email) {
        this.nome = nome;
        this.email = email;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @PostConstruct
    private void init(){
        System.out.println("Iniciando Pessoa...");
    }

    @PostActivate
    private void activate(){
        System.out.println("Ativando Pessoa...");
    }

    @PreDestroy
    private void destroy(){
        System.out.println("Destroy Pessoa...");
    }

    @Override
    public int hashCode() {
        return Objects.hash(nome, email);
    }

    @Override
    public String toString() {
        return "Pessoa{" +
                "nome='" + nome + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
