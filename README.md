# testAsinc - Dragon Ball Heroes App

## 🏷️ Descripción

testAsinc es una aplicación iOS que permite explorar el universo Dragon Ball, visualizando héroes y sus transformaciones. La aplicación implementa programación reactiva con Combine, arquitectura MVVM con async/await, y está completamente internacionalizada en español e inglés.

## 📱 Capturas de Pantalla

![Login Screen](Screenshots/login.jpg)


## ✨ Características Principales

* **Autenticación reactiva** - Sistema de login con Combine bindings
* **Catálogo de héroes** - Grid dinámico con carga asíncrona
* **Detalles del héroe** - Información completa y descripción
* **Transformaciones** - Visualización horizontal de las formas del héroe
* **Internacionalización** - Soporte completo para español e inglés
* **Programación reactiva** - Binding bidireccional con Combine

## 🏗️ Arquitectura

El proyecto implementa una arquitectura **MVVM** con programación reactiva:

### Data Layer
* **SecureDataService** - Gestión de tokens con KeychainSwift
* **ApiProvider** - Cliente HTTP con async/await
* **DTO Models** - Modelos de transferencia de datos

### Domain Layer
* **Models** - Entidades de dominio (Hero, Transformation)
* **UseCases** - Implícitos en los repositorios
* **Protocols** - Interfaces para inversión de dependencias

### Presentation Layer
* **ViewModels** - Estado reactivo con Combine
* **Views** - UI programática sin Storyboards
* **Controllers** - Gestión de ciclo de vida con bindings

### Repository Layer
* **AuthRepository** - Gestión de autenticación
* **HeroRepository** - Acceso a datos de héroes
* **Services** - Capa de servicios intermedios

## 📊 Patrones de Diseño

* **MVVM** - Con binding reactivo usando Combine
* **Repository Pattern** - Abstracción de fuentes de datos
* **Dependency Injection** - Para testing y flexibilidad
* **Observer Pattern** - Publishers y subscribers de Combine
* **Async/Await** - Manejo moderno de asincronía

## 🧪 Testing

### Suite de Pruebas Comprehensiva
El proyecto incluye tests unitarios con >60% de cobertura:

* **ViewModels** - Tests de lógica de presentación y estados
* **Services** - Tests de servicios de red y datos
* **Repositories** - Tests de capa de repositorio
* **Models** - Tests de entidades de dominio
* **UI Components** - Tests de celdas y vistas
* **ViewControllers** - Tests de ciclo de vida

### Implementaciones de Testing
- **MockServices** - Simulación de servicios de red
- **MockRepositories** - Repositorios de prueba
- **MockSecureDataService** - Almacenamiento simulado
- **APIProviderTests** - Tests de cliente HTTP
- **Combine Testing** - Pruebas de flujos reactivos

## 🛠️ Tecnologías Utilizadas

* **Swift 5** - Lenguaje de programación
* **UIKit** - Framework de interfaz (sin Storyboards)
* **Combine** - Programación reactiva
* **Async/Await** - Programación asíncrona moderna
* **KeychainSwift** - Almacenamiento seguro
* **Kingfisher** - Carga y cache de imágenes
* **XCTest** - Framework de testing

## 📋 Requisitos Técnicos

* iOS 15.0+
* Xcode 14.0+
* Swift 5.7+

## 🚀 Instalación y Uso

1. Clonar el repositorio
git clone https://github.com/tu-usuario/testAsinc.gitt

2. Abrir el proyecto en Xcode
4. Compilar y ejecutar la aplicación

## 🔒 Credenciales de Prueba

La API utiliza autenticación básica. Usa las credenciales proporcionadas por KeepCoding.

## 🔄 Flujo de la Aplicación

1. **Splash Screen** - Verifica token existente con animación
2. **Login** - Autenticación reactiva con validación en tiempo real
3. **Lista de Héroes** - Grid adaptativo con imágenes cacheadas
4. **Detalle del Héroe** - Información completa con scroll
5. **Transformaciones** - Colección horizontal con vista modal

## 🌍 Internacionalización

La aplicación soporta completamente:
* **Español** - Idioma por defecto
* **Inglés** - Traducción completa

Todos los literales están externalizados usando el catálogo de strings.

## 🚀 Programación Reactiva

### Implementación con Combine
- **TextField Binding** - Extensión custom para UITextField
- **Button Actions** - Publisher para eventos de tap
- **State Management** - ViewModels con @Published
- **Error Handling** - Manejo reactivo de errores

## 🧠 Aprendizajes del Proyecto

* Implementación avanzada de Combine
* Arquitectura MVVM con programación reactiva
* Async/await para operaciones de red
* Testing comprehensivo con mocks
* UI programática sin Storyboards
* Internacionalización completa

## 🚧 Posibles Mejoras Futuras

* Implementación de búsqueda reactiva
* Sistema de favoritos con persistencia
* Animaciones de transición personalizadas


---

*Este proyecto fue desarrollado como trabajo final del módulo de Programación Reactiva y Asincronismo, demostrando el uso de Combine, async/await y arquitectura MVVM.*
