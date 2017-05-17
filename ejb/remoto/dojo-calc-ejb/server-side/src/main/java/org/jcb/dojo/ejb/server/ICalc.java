package org.jcb.dojo.ejb.server;

import javax.ejb.Remote;

@Remote
public interface ICalc {

	int som(int num1, int num2);

	int sub(int num1, int num2);

	int div(int num1, int num2);

	int mult(int num1, int num2);

}