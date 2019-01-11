package aula.io;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.ejb.PostActivate;
import javax.enterprise.context.RequestScoped;
import javax.enterprise.event.Event;
import javax.inject.Inject;
import javax.inject.Named;

@Named
@RequestScoped
public class PessoaController {

    @Inject
    private Pessoa pessoa;

    @Inject
    private Event<PessoaEvent> event;

    public String salvar(){
        System.out.println("salvando...");
        System.out.format("Pessoa 1 - %s (%s)\n", pessoa.getNome(), pessoa.getEmail());

        PessoaEvent pessoaEvent = new PessoaEvent(new Pessoa(pessoa.getNome(), pessoa.getEmail()));
        event.fire(pessoaEvent);


        return "confirma.xhtml";
    }

    public Pessoa getPessoa() {
        return pessoa;
    }


    @PostConstruct
    private void init(){
        System.out.println("Iniciando PessoaController...");
    }

    @PostActivate
    private void activate(){
        System.out.println("Ativando PessoaController...");
    }

    @PreDestroy
    private void destroy(){
        System.out.println("Destroy PessoaController...");
    }

}
