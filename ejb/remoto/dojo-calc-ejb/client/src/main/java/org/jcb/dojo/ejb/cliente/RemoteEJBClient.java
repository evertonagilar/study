package org.jcb.dojo.ejb.cliente;

import java.util.Hashtable;
import java.util.Scanner;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.jcb.dojo.ejb.server.HelloWorld;
import org.jcb.dojo.ejb.server.ICalc;
import org.jcb.dojo.ejb.server.StatefulHelloWorld;

public class RemoteEJBClient {

	public static void main(String[] args) throws Exception {
		System.out.println("###########################\nexecutando remoto");
		invokeCalc();
	}

	private static void invokeHelloWorld() throws NamingException {
		final HelloWorld hw = lookupRemoteHelloWorld();
		System.out.println("############## Executando HELLO !!!");
		System.out.println(hw.hello("jader"));
		System.out.println(hw.historico());
	}
	
	private static void invokeCalc() throws NamingException {
		final ICalc c = lookupRemoteCalc();
		System.out.println("############## Executando Calc !!!");
		int opcao = 5;
		int num1;
		int num2;
		Scanner input = new Scanner(System.in);
		System.out.println("-Escolha uma opção-");
		System.out.println("1. Soma");
		System.out.println("2. Subtracao");
		System.out.println("3. Multiplicacao");
		System.out.println("4. Divisao");
		System.out.println("0. Sair");
		System.out.println("Operação: ");
		opcao = input.nextInt();
		while (opcao != 0) {
			Scanner input1 = new Scanner(System.in);
			System.out.println("Qual o primeiro numero: ");
			num1 = input1.nextInt();
			System.out.println("Qual o segundo numero: ");
			num2 = input1.nextInt();
			if (opcao == 1) {
				int operacao = c.som(num1, num2);
				System.out.printf("\nO resultado da soma é: %d\n", operacao);
				break;
			} else if (opcao == 2) {
				int operacao = c.sub(num1, num2);
				System.out.printf("\nO resultado da subtração é: %d\n", operacao);
				break;
			} else if (opcao == 3) {
				int operacao = c.mult(num1, num2);
				System.out.printf("\nO resultado da multiplicação é: %d\n", operacao);
				break;
			} else if (opcao == 4) {
				int operacao = c.div(num1, num2);
				System.out.printf("\nO resultado da divisão é: %d\n", operacao);
				break;
			} else {
				System.out.println("????");
				break;
			}
		}		
		input.close();
	}

	private static void invokeStatefulHelloWorld() throws NamingException {
		final StatefulHelloWorld hw = lookupRemoteStatefulHelloWorld();
		System.out.println("############## Executando HELLO Stateful!!!");
		System.out.println(hw.hello("jader"));
		System.out.println(hw.historico());
	}

	private static ICalc lookupRemoteCalc() throws NamingException {
		final Hashtable<String, String> jndiProperties = new Hashtable<>();
		jndiProperties.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
		final Context context = new InitialContext(jndiProperties);
		return (ICalc) context.lookup("ejb:/wildfly-ejb-remote-server-side/CalcBean!" + ICalc.class.getName());
	}

	
	private static HelloWorld lookupRemoteHelloWorld() throws NamingException {
		final Hashtable<String, String> jndiProperties = new Hashtable<>();
		jndiProperties.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
		final Context context = new InitialContext(jndiProperties);

		// The JNDI lookup name for a stateless session bean has the syntax of:
		// ejb:<appName>/<moduleName>/<distinctName>/<beanName>!<viewClassName>
		//
		// <appName> The application name is the name of the EAR that the EJB is
		// deployed in
		// (without the .ear). If the EJB JAR is not deployed in an EAR then
		// this is
		// blank. The app name can also be specified in the EAR's
		// application.xml
		//
		// <moduleName> By the default the module name is the name of the EJB
		// JAR file (without the
		// .jar suffix). The module name might be overridden in the ejb-jar.xml
		//
		// <distinctName> : EAP allows each deployment to have an (optional)
		// distinct name.
		// This example does not use this so leave it blank.
		//
		// <beanName> : The name of the session been to be invoked.
		//
		// <viewClassName>: The fully qualified classname of the remote
		// interface. Must include
		// the whole package name.

		// let's do the lookup
		return (HelloWorld) context
				.lookup("ejb:/wildfly-ejb-remote-server-side/HelloWorldBean!" + HelloWorld.class.getName());
	}

	private static StatefulHelloWorld lookupRemoteStatefulHelloWorld() throws NamingException {
		final Hashtable<String, String> jndiProperties = new Hashtable<>();
		jndiProperties.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
		final Context context = new InitialContext(jndiProperties);

		// The JNDI lookup name for a stateless session bean has the syntax of:
		// ejb:<appName>/<moduleName>/<distinctName>/<beanName>!<viewClassName>
		//
		// <appName> The application name is the name of the EAR that the EJB is
		// deployed in
		// (without the .ear). If the EJB JAR is not deployed in an EAR then
		// this is
		// blank. The app name can also be specified in the EAR's
		// application.xml
		//
		// <moduleName> By the default the module name is the name of the EJB
		// JAR file (without the
		// .jar suffix). The module name might be overridden in the ejb-jar.xml
		//
		// <distinctName> : EAP allows each deployment to have an (optional)
		// distinct name.
		// This example does not use this so leave it blank.
		//
		// <beanName> : The name of the session been to be invoked.
		//
		// <viewClassName>: The fully qualified classname of the remote
		// interface. Must include
		// the whole package name.

		// let's do the lookup
		return (StatefulHelloWorld) context.lookup("ejb:/wildfly-ejb-remote-server-side/StatefulHelloWorldBean!"
				+ StatefulHelloWorld.class.getName() + "?stateful");
	}

}