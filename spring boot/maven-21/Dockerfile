#FROM maven:3.9.4-eclipse-temurin-21-alpine
#
#WORKDIR /app
#
#COPY pom.xml .
#RUN mvn dependency:go-offline -B
#
#COPY . .
#
#EXPOSE 8080
#
#CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.fork=false", "-Dspring-boot.run.profiles=dev"]


FROM maven:3.9.4-eclipse-temurin-21-alpine

WORKDIR /app

COPY pom.xml ./
RUN mvn dependency:go-offline -B

EXPOSE 8080
CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.fork=false"]
