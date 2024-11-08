FROM openjdk:11-jdk-alpine
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac spring-petclinic.java
CMD ["java", "sprint-petclinic"]
ADD target/sprint-petclinic.jar sprint-petclinic.jar
ENTRYPOINT ["java","-jar","sprint-petclinic.jar"]
