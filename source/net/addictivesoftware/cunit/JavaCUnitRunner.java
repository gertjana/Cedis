package net.addictivesoftware.cunit;

import java.lang.annotation.Annotation;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class JavaCUnitRunner {

	public String execute(String className) {
		Method beforeMethod = null;
		Method afterMethod = null;
		StringBuffer report = new StringBuffer();
		int ok = 0;
		int fail = 0;
		int error = 0;
		List<Method> testMethods = new ArrayList<Method>();
		
		report.append("CUnit Test report for ");
		report.append(className);
		report.append("\r\n");
		report.append("======================================================\r\n");
		try {
			Class<?> clazz = Class.forName(className);
			Map<Method, String> annotations = listAnnotations(clazz);
			for (Method method : annotations.keySet()) {
				String annotation = annotations.get(method);
				if (annotation.equals("before")) {
					beforeMethod = method;
				}
				if (annotation.equals("after")) {
					afterMethod = method;
				}
				if (annotation.equals("test")) {
					testMethods.add(method);
				}
			}
			Object instance = clazz.newInstance();
			
			if (null != beforeMethod) {
				beforeMethod.invoke(instance, new Object[] {});
			}
			
			for (Method testMethod : testMethods) {
				try {
					testMethod.invoke(instance, new Object[] {});
					report.append("[OK...] ");
					report.append(testMethod.getName());
					report.append("\r\n");
					ok++;
				} catch (Exception e) {
					if (e instanceof AssertionException) {
						report.append("[FAIL.] ");
						report.append(testMethod.getName());
						report.append("\r\n");
						report.append(e.getMessage());
						report.append("\r\n");
						fail++;
					} else {
						report.append("[ERROR] ");
						report.append(testMethod.getName());
						report.append("\r\n");
						report.append(e.getMessage());
						report.append("\r\n");
						error++;						
					}
				} finally {
				}
				
			}
			
			if (null != afterMethod) {
				afterMethod.invoke(instance, new Object[] {});
			}
		} catch (ClassNotFoundException e) {
			report.append(e.getMessage());
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		report.append("======================================================\r\n");
		report.append(String.format("Sucess: %d, Fail: %d, Error %d, of Total %d Tests", ok, fail, error, (ok+fail+error)));
		return report.toString();
	}

	private Map<Method, String> listAnnotations(Class<?> clazz) throws ClassNotFoundException {
		Map<Method, String> result = new HashMap<Method, String>();
		Method[] methods = clazz.getDeclaredMethods();
		for (Method method : methods) {
			Annotation[] annotations = method.getDeclaredAnnotations();
			for(Annotation annotation : annotations){
				if (annotation instanceof com.redhat.ceylon.compiler.java.metadata.Annotations) {
					Annotation[] childAnnotations = ((com.redhat.ceylon.compiler.java.metadata.Annotations)annotation).value();
					for (Annotation childAnnotation : childAnnotations) {
						String name = ((com.redhat.ceylon.compiler.java.metadata.Annotation)childAnnotation).value();
						if (!name.equals("shared")) {
							result.put(method, name);
						}
					}
				}
			}	
		}
		return result;
	}
}
