FROM tomcat:lateast
ADD target/petclinic.war /usr/local/tomcat/webapps/petclinic.war
#ENV testvar=localhost
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "petclinic.war"]
