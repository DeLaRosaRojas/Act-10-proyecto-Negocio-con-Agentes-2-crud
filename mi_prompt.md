# 🧵 Parisina CRUD (Flutter + Firebase)

Proyecto básico de aplicación web desarrollado en **Flutter** conectado a **Firebase (Cloud Firestore)**, que implementa un sistema CRUD completo para la gestión de usuarios y productos (telas).

---

## 📌 Descripción

**Parisina** es una aplicación inspirada en una tienda de telas y costura.
El sistema permite:

* Registro e inicio de sesión (usando Firestore, sin Firebase Auth)
* Gestión de usuarios
* Gestión de productos (telas)
* Navegación entre pantallas
* Diseño simple y moderno

---

## 🧩 Tecnologías utilizadas

* Flutter (Web)
* Firebase
* Cloud Firestore

---

## 🔥 Estructura del Proyecto

```plaintext
lib/
 ├── main.dart
 ├── login.dart
 ├── register.dart
 ├── home.dart
 ├── usuarios_page.dart
 ├── telas_page.dart
 ├── firebase_options.dart
```

---

## 🗂️ Base de Datos (Firestore)

### 📁 Colección: usuarios

| Campo      | Tipo   |
| ---------- | ------ |
| nombre     | string |
| correo     | string |
| contraseña | string |
| edad       | int    |
| telefono   | int    |

---

### 📁 Colección: telas

| Campo  | Tipo   |
| ------ | ------ |
| nombre | string |
| tipo   | string |
| color  | string |
| precio | int    |
| stock  | int    |

---

## 🚀 Instalación y Ejecución

### 1. Clonar repositorio

```bash
git clone https://github.com/TU_USUARIO/Proyect_crud.git
cd Proyect_crud
```

---

### 2. Instalar dependencias

```bash
flutter pub get
```

---

### 3. Configurar Firebase

Asegúrate de tener instalado:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

Luego ejecuta:

```bash
flutterfire configure
```

Selecciona:

* Proyecto: `parisinacrud`
* Plataforma: web

---

### 4. Ejecutar proyecto

```bash
flutter run -d chrome
```

---

## 🔐 Funcionalidades

### 👤 Usuarios

* Registro
* Inicio de sesión (validación manual con Firestore)
* Visualización
* Eliminación

---

### 🧵 Telas

* Crear productos
* Visualizar lista
* Eliminar productos

---

## 🎨 Diseño

* AppBar: Rojo fuerte
* Texto: Negro
* Fondo: Gris claro
* Footer: Negro con texto blanco
* Botones: Rojo y amarillo

---

## ⚠️ Consideraciones

* No se utiliza Firebase Authentication (intencionalmente simplificado)
* Validaciones básicas (se recomienda mejorar)
* Manejo de errores limitado (nivel principiante)

---

## 🛠️ Mejoras futuras

* Implementar UPDATE (editar registros)
* Agregar validaciones de formularios
* Mejorar diseño UI/UX
* Implementar Firebase Authentication
* Separar lógica en arquitectura (MVC o Provider)

---

## 👩‍💻 Autor

Proyecto desarrollado con fines educativos.

---

## 📄 Licencia

Uso libre para aprendizaje.
