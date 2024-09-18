
# Dragon Ball App

## Proyecto creado por Hernán Rodríguez

Este proyecto es una aplicación que consume una API de Dragon Ball creada por KeepCoding. La aplicación sigue el patrón de arquitectura **MVC (Model-View-Controller)** y está construida en **Swift** utilizando **UIKit**.

### Funcionalidades principales:
- Autenticación mediante login.
- Visualización de una lista de héroes de Dragon Ball.
- Detalle de cada héroe, mostrando información y transformaciones (si están disponibles).
- Navegación entre pantallas mediante `UINavigationController`.

### Capturas de pantalla:

#### Pantalla de Login:

<div style="display: flex; flex-direction: row;">
  <img src="https://live.staticflickr.com/65535/54004644084_b80717f34f_o.png" width="200" />
  <img src="https://live.staticflickr.com/65535/54004319226_1a94812cc6_o.png" width="200" />
  <img src="https://live.staticflickr.com/65535/54004644679_4eccab7088_o.png" width="200" />
  <img src="https://live.staticflickr.com/65535/54004319811_bbbb8419d6_o.png" width="200" />
  <img src="https://live.staticflickr.com/65535/54004644759_966521638f_o.png" width="200" />
</div>

### Estructura del proyecto:
- **Modelo**: Contiene las estructuras de datos de `Hero` y `Transformation`.
- **Vista**: Pantallas en **UIKit** con **XIBs** para las vistas personalizadas.
- **Controlador**: Controladores como `LoginViewController`, `HeroesTableViewController`, `HeroDetailsViewController` y `TransformationTableViewController` para gestionar la lógica de la aplicación y la navegación.

### Requisitos:
- **iOS 14+**
- **Xcode 12+**
- **Swift 5.0+**

### Configuración de la API:
La aplicación consume una API de KeepCoding para obtener la información de los héroes y transformaciones de Dragon Ball. Para realizar peticiones, es necesario autenticarte mediante un token que se genera al iniciar sesión.

### Contacto:
Si tienes alguna pregunta o sugerencia, no dudes en ponerte en contacto:

- **Correo**: hernanrg85@gmail.com
