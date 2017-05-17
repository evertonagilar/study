package org.jcb.dojo.ejb.server;

import java.util.List;

import javax.ejb.Remote;

@Remote
public interface StatefulHelloWorld {

	public String hello(String nome);

	public List<String> historico();
}
