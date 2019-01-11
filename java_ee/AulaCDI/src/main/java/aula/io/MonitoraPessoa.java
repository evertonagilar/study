package aula.io;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.ejb.PostActivate;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.enterprise.event.Observes;
import javax.inject.Inject;

@Startup
@Singleton
public class MonitoraPessoa {

    @Inject
    Pessoa pessoa2;

    public void onChangePessoa(@Observes PessoaEvent event){
        System.out.format("Evento onChangePessoa disparado para %s\n", event.getPessoa().getNome());
    }

    @PostConstruct
    private void init(){
        System.out.println("Iniciando MonitoraPessoa...");
    }

    @PostActivate
    private void activate(){
        System.out.println("Ativando MonitoraPessoa...");
    }

    @PreDestroy
    private void destroy(){
        System.out.println("Destroy MonitoraPessoa...");
    }

}
