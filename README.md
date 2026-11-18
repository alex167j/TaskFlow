# TaskFlow

Aplicación Android de gestión de tareas desarrollada con Flutter en el curso
**De interfaces Flutter a una app que conversa con una API**. Permite consultar,
crear, editar y eliminar tareas usando una API REST, con arquitectura
**MVVM + Repository**.

---

## 1. Problema

Los estudiantes de quinto nivel organizan sus pendientes académicos en notas
sueltas, capturas de pantalla y mensajes de chat. Esa información se pierde
fácilmente, no se puede priorizar y no está disponible cuando cambian de
dispositivo.

TaskFlow resuelve el problema con un lugar único para registrar tareas,
marcar su prioridad y estado, y consultarlas desde cualquier momento mediante
un servicio REST.

## 2. Usuario objetivo

| Aspecto | Descripción |
|---|---|
| Perfil | Estudiante universitario de quinto nivel |
| Edad | 18 a 25 años |
| Dispositivo | Smartphone Android de gama media |
| Contexto | Organiza trabajos, talleres y exámenes de varias materias |
| Necesidad | Saber qué debe hacer, con qué prioridad y qué ya completó |

## 3. Alcance

**Incluye**

- Listado de tareas con estados de carga, vacío y error.
- Detalle de una tarea.
- Creación, edición y eliminación con validaciones y confirmación.
- Búsqueda y filtros por texto, prioridad y estado.
- Preferencias locales (tema y último filtro).

**No incluye (en esta versión del curso)**

- Autenticación con cuentas reales y tokens de sesión.
- Notificaciones push y sincronización en tiempo real.
- Versión para iOS o escritorio como entrega final.

## 4. Historias de usuario

1. **Consultar el listado**
   Como estudiante quiero ver todas mis tareas para saber qué tengo pendiente.
   - Criterios de aceptación: al abrir la app se muestra un indicador de carga;
     luego la lista o un mensaje de vacío; si falla la red, un mensaje de error
     con acción **Reintentar**. Cada tarjeta muestra título, descripción corta,
     prioridad y estado.

2. **Ver el detalle**
   Como estudiante quiero abrir una tarea para revisar su información completa.
   - Criterios de aceptación: tocar una tarjeta navega a `/task/:id`; el detalle
     muestra todos los campos; al regresar, el listado se conserva tal como
     estaba.

3. **Crear una tarea**
   Como estudiante quiero registrar una tarea con título, descripción y
   prioridad para no olvidarla.
   - Criterios de aceptación: el título es obligatorio y se valida antes de
     enviar; el botón **Guardar** se deshabilita mientras la solicitud está en
     curso; al guardar se muestra una confirmación y la tarea aparece en el
     listado.

4. **Editar una tarea**
   Como estudiante quiero modificar una tarea existente para corregir datos o
   actualizar su estado.
   - Criterios de aceptación: el formulario se precarga con los datos actuales;
     si la actualización falla, los datos escritos no se pierden; el listado
     refleja los cambios sin reiniciar la app.

5. **Eliminar una tarea**
   Como estudiante quiero eliminar tareas con confirmación previa para evitar
   borrar información por accidente.
   - Criterios de aceptación: se muestra un diálogo de confirmación; cancelar no
     elimina nada; tras eliminar, la tarea desaparece del listado; un error de
     red muestra un mensaje recuperable.

## 5. Modelo principal: `Task`

Representa una tarea del dominio (no un elemento de interfaz). Implementado en
`lib/models/task.dart`.

| Campo | Tipo Dart | Tipo JSON | Descripción |
|---|---|---|---|
| `id` | `int` | número | Identificador único asignado por la API |
| `title` | `String` | texto | Título breve de la tarea |
| `description` | `String` | texto | Detalle de lo que se debe hacer |
| `priority` | `TaskPriority` | texto | `high`, `medium` o `low` |
| `status` | `TaskStatus` | texto | `pending` o `completed` |
| `userId` | `int` | número | Usuario propietario de la tarea |

Ejemplo de respuesta JSON:

```json
{
  "id": 12,
  "title": "Entregar informe del taller",
  "description": "Redactar el informe con los avances de la semana",
  "priority": "high",
  "status": "pending",
  "userId": 1
}
```

## 6. Boceto de las tres pantallas principales

### 6.1 Listado (`/`)

```text
┌─────────────────────────────┐
│  TaskFlow            [≡]    │  AppBar
├─────────────────────────────┤
│  ¡Hola, Alex!               │
│  Tienes 3 tareas pendientes │
│                             │
│ ┌─────────────────────────┐ │
│ │ Título de la tarea  ... │ │
│ │ Descripción corta       │ │
│ │ 🔥 Prioridad: Alta   ›  │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ Título de la tarea  ... │ │
│ │ Descripción corta       │ │
│ │ ↓ Prioridad: Baja    ›  │ │
│ └─────────────────────────┘ │
│              ( + )          │  Botón flotante: nueva tarea
└─────────────────────────────┘
```

Estados previstos: **carga** (indicador centrado), **vacío** (mensaje y botón
para crear) y **error** (mensaje y botón **Reintentar**).

### 6.2 Detalle (`/task/:id`)

```text
┌─────────────────────────────┐
│  <  Detalle de tarea        │
├─────────────────────────────┤
│  Título de la tarea         │
│  ✅ Completada              │
│  🔥 Prioridad: Alta         │
│                             │
│  Descripción                │
│  Texto completo de la tarea │
│                             │
│  [ Editar ]   [ Eliminar ]  │
└─────────────────────────────┘
```

### 6.3 Formulario (`/new` y `/task/:id/edit`)

```text
┌─────────────────────────────┐
│  <  Nueva tarea             │
├─────────────────────────────┤
│  Título *                   │
│  [________________________] │
│  Descripción                │
│  [________________________] │
│  Prioridad                  │
│  (Alta) (Media) (Baja)      │
│  Estado                     │
│  (Pendiente) (Completada)   │
│                             │
│          [ Guardar ]        │
└─────────────────────────────┘
```

## 7. Endpoints requeridos por el CRUD

Todos los endpoints operan sobre el recurso `tasks`. La URL base se define en
el servicio de API (`TaskApiService`).

| Operación | Método | Endpoint | Cuerpo enviado | Respuesta esperada |
|---|---|---|---|---|
| Listar | `GET` | `/tasks` | — | `200` con arreglo de tareas |
| Detalle | `GET` | `/tasks/{id}` | — | `200` con una tarea · `404` si no existe |
| Crear | `POST` | `/tasks` | Tarea sin `id` | `201` con la tarea creada |
| Actualizar | `PATCH` | `/tasks/{id}` | Campos a modificar | `200` con la tarea actualizada |
| Eliminar | `DELETE` | `/tasks/{id}` | — | `204` sin cuerpo |

Códigos de error contemplados: `400` datos inválidos, `404` recurso no
encontrado, `500` error del servidor y errores de red/timeout.

## 8. Arquitectura prevista

```text
View (pantallas y widgets)
   ↕
ViewModel (estado de interfaz: carga, datos, error)
   ↕
Repository (fuente de verdad de las tareas)
   ↕
API Service (HTTP, JSON, encabezados)
```

- **View**: no hace peticiones HTTP; solo muestra datos y captura acciones.
- **ViewModel**: expone `isLoading`, `tasks` y `errorMessage`; se escucha con
  `provider` + `ChangeNotifier` (Semana 3, sesión 6).
- **Repository**: decide cómo obtener y transformar los datos.
- **API Service**: concentra URL base, métodos, encabezados y conversión de
  respuestas (Semana 4).

## 9. Estructura actual del proyecto

```text
lib/
├── main.dart                     # App, tema y router (go_router)
├── models/
│   └── task.dart                 # Modelo Task, prioridad y estado
├── screens/
│   ├── tasks_screen.dart         # Listado (datos estáticos por ahora)
│   └── task_detail_screen.dart   # Detalle por id de ruta
└── widgets/
    └── task_card.dart            # Tarjeta reutilizable del listado

test/
└── widget_test.dart              # Pruebas de listado, detalle y regreso
```

## 10. Avance por sesiones

| Semana | Sesiones | Estado |
|---|---|---|
| 1 | 1–2 | ✅ Bienvenida con estado y paleta propia |
| 2 | 3–4 | ✅ Listado estático con `TaskCard` y navegación `go_router` |
| 3 | 5 | ✅ Especificación, modelo con usuario y README |
| 3 | 6 | ⏳ Arquitectura MVVM y estructura por funcionalidades |
| 4–7 | 7–14 | ⏳ API REST, CRUD, pruebas, persistencia y entrega |

## 11. Cómo ejecutar

Requisitos: Flutter 3.47 o superior, Android SDK y un dispositivo o emulador.

```bash
flutter pub get
flutter devices
flutter run -d <id-del-dispositivo>
```

Calidad:

```bash
dart format .
flutter analyze
flutter test
```

---

Curso Flutter · Proyecto integrador TaskFlow · 2026
