package com.spring.sts;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

public class MySQLConnectionTest {

	private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
	//MySQL Driver 6.0 "com.mysql.cj.jdbc.Driver";
	private static final String URL = "jdbc:mysql://localhost:3306/book_ex?useSSL=false&serverTimezone=Asia/Seoul";
	//MySQL 6.1 "jdbc:mysql://localhost:3306/book_ex?useSSL=false&serverTimezone=Asia/Seoul";
	private static final String USER = "root";
	private static final String PW = "qlrxhfl72";
	
	@Test
	public void testConnection() throws Exception{
		
		Class.forName(DRIVER);
		
		try(Connection con = DriverManager.getConnection(URL, USER, PW)){
			System.out.println(con);
		}catch(Exception e) {
			e.printStackTrace();
		}//try_
	}//testConnection_
}//MySQLConnectionTest_