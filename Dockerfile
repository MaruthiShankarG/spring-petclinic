# Use OpenJDK 11 based Alpine image
FROM openjdk:11-jdk

# Set the working directory inside the container
WORKDIR /usr/src/myapp

# Copy the local project files into the container
COPY . /usr/src/myapp

# Copy the Maven build output JAR into the container
# Assuming the JAR file is located in the target directory
# Make sure you have already built the project locally or you can run mvn install here
RUN ./mvnw clean install -DskipTests

# Specify the location of the JAR file after Maven builds it
ADD target/spring-petclinic-0.0.1-SNAPSHOT.jar /usr/src/myapp/spring-petclinic.jar

# Set the default command to run your Spring Boot application
ENTRYPOINT ["java", "-jar", "/usr/src/myapp/spring-petclinic.jar"]

