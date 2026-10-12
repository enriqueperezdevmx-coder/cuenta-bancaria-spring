# Cajero automático — Spring Core e inyección de dependencias

**Autor:** Enrique Pérez Sánchez

## Cómo correrlo

```bash
./correr.sh App final-app
./probar.sh final
```bash
| Bean | Clase | Cómo lo declara Spring (@Component o @Bean) | Singleton o prototype |
| :--- | :--- | :--- | :--- |
| `configuracionBanco` | `ConfiguracionBanco` | `@Configuration` | Singleton |
| `repositorioEnMemoria` | `RepositorioEnMemoria` | `@Component` | Singleton |
| `antifraudePorMonto` | `AntifraudePorMonto` | `@Component (@Primary)` | Singleton |
| `antifraudeEstricto` | `AntifraudeEstricto` | `@Component` | Singleton |
| `notificadorConsola` | `NotificadorConsola` | `@Component` | Singleton |
| `reloj` | `java.time.Clock` | `@Bean` | Singleton |
| `cajeroAutomatico` | `CajeroAutomatico` | `@Component` | Singleton |
| `sesionCajero` | `SesionCajero` | `@Component` | Prototype (`@Scope("prototype")`) |


## Boleto de salida

1. **¿Qué es la inyección de dependencias? Explícalo con el cajero, en tus palabras.**  
   Una clase (como el `CajeroAutomatico`) no instancia directamente sus piezas con `new`, sino que las solicita en su constructor. Quien las crea (en la MP-1 nosotros manualmente y a partir de la MP-2 el contenedor de Spring) se las inyecta desde el exterior ya armadas. Esto permite cambiar implementaciones sin tocar la lógica del cajero y facilita las pruebas unitarias desacoplando responsabilidades.

2. **En la MP-1, ¿quién decidía qué antifraude usaba el cajero? ¿Y desde la MP-2?**  
   En la MP-1 lo decidía el método `main` de `AppSinSpring` al hacer explícitamente `new AntifraudePorMonto()` y pasarlo al constructor. A partir de la MP-2 lo decide el contenedor IoC de Spring según la configuración declarada (`@Bean`, `@ComponentScan`, `@Primary` y `@Qualifier`).

3. **¿Cuándo usarías `@Bean` en vez de `@Component`? Da el ejemplo de hoy.**  
   Se usa `@Bean` en métodos dentro de una clase `@Configuration` cuando necesitamos registrar componentes de clases que no son nuestras (librerías externas o clases estándar del JDK de Java donde no podemos editar el código fuente para colocar `@Component`) o cuando la instanciación requiere configuración personalizada. El ejemplo de hoy fue `Clock` (`Clock.system(ZoneId.of("America/Mexico_City"))`), perteneciente a la biblioteca estándar de Java (`java.time.Clock`).

4. **¿Qué gana: `@Primary` o `@Qualifier`? ¿Por qué tiene sentido?**  
   Gana `@Qualifier`. Tiene sentido porque `@Primary` solo define una alternativa por defecto ante ambigüedades genéricas, mientras que `@Qualifier` solicita explícitamente un componente por su identificador/nombre; la regla de especificidad siempre prevalece sobre lo predeterminado.

5. **En tu proyecto de Empleados de la Semana 3 nunca escribiste `@ComponentScan`. ¿Quién lo hace?**  
   Lo hace automáticamente la anotación `@SpringBootApplication`, ya que es una meta-anotación que incluye por dentro `@ComponentScan` (junto con `@SpringBootConfiguration` y `@EnableAutoConfiguration`), escaneando el paquete raíz de la aplicación y todos sus subpaquetes.

   
