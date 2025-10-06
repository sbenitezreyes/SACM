# Sistema de Diseño - App Flutter Médica

## 🎨 Paleta de Colores

### Colores Principales
```dart
Primary Color:     #2196F3 (Azul Material)
Primary Light:     #64B5F6
Primary Dark:      #1976D2
Accent Color:      #FF4081 (Rosa/Fucsia)
```

### Degradados Aplicados
```dart
// Degradados para Cards
cards: Colors.white -> Primary Color (0.03 opacity)

// Degradados para Avatares/Íconos
iconos: Primary Color -> Primary Color (0.7 opacity)

// Degradados para Fondo de Login
login: Primary (0.1) -> Background -> Primary (0.05)

// Sombras con degradado
boxShadow: Color específico con 10-20% opacity, blur 8-15px
```

### Colores de Fondo
```dart
Background:        #FAFAFA (Gris muy claro)
Surface:           #FFFFFF (Blanco)
Card Background:   #FFFFFF con elevation
```

### Colores de Texto
```dart
Text Primary:      #212121 (Negro suave)
Text Secondary:    #757575 (Gris medio)
Text Hint:         #BDBDBD (Gris claro)
```

### Colores de Estado
```dart
Success:           #4CAF50 (Verde)
Warning:           #FF9800 (Naranja)
Error:             #F44336 (Rojo)
Info:              #2196F3 (Azul)
```

## 📝 Tipografía

### Fuentes
- **Primaria:** Roboto (por defecto en Material Design)
- **Tamaño base:** 16px

### Escala Tipográfica
```dart
Headline1:         32px, Bold
Headline2:         28px, Bold
Headline3:         24px, SemiBold
Title:             20px, Medium
Body Large:        16px, Regular
Body:              14px, Regular
Caption:           12px, Regular
Button:            14px, SemiBold (uppercase)
```

## 🎯 Espaciado

### Sistema de Espaciado (basado en 8px)
```dart
xs:  4px
sm:  8px
md:  16px
lg:  24px
xl:  32px
xxl: 48px
```

### Padding Estándar
- **Pantallas:** 16px horizontal, 16px vertical
- **Cards:** 16px en todos los lados
- **ListTiles:** 16px horizontal, 12px vertical

### Margin Entre Elementos
- **Cards:** 8px vertical
- **Secciones:** 24px vertical
- **Botones:** 16px entre ellos

## 🔲 Componentes

### AppBar
```dart
- Altura: 56px
- Elevation: 0 (minimalista)
- Background: Blanco
- Text Color: Negro
- Icon Color: Gris oscuro
```

### Cards
```dart
- Border Radius: 12px
- Elevation: 2
- Margin: 8px vertical
- Padding: 16px
```

### Botones

#### Primary Button (Elevated)
```dart
- Border Radius: 8px
- Height: 48px
- Padding: 16px horizontal
- Elevation: 2
- Text: Blanco, SemiBold
```

#### Secondary Button (Outlined)
```dart
- Border Radius: 8px
- Height: 48px
- Border Width: 1.5px
- Padding: 16px horizontal
```

#### Text Button
```dart
- Padding: 8px horizontal
- Text: Primary Color, SemiBold
```

### FloatingActionButton
```dart
- Size: 56x56px
- Elevation: 4
- Background: Primary Color
- Icon: Blanco
```

### Campos de Texto
```dart
- Border Radius: 8px
- Height: 56px
- Padding: 16px
- Border: OutlineInputBorder
- Focus Color: Primary
```

### ListTile
```dart
- Leading: CircleAvatar (40x40px)
- Title: Body Large, SemiBold
- Subtitle: Body, Gray
- Trailing: Icon 20px
- Content Padding: 16px horizontal
```

## 🎭 Iconografía

### Tamaños de Íconos
```dart
Small:   16px
Medium:  24px
Large:   32px
XLarge:  48px
```

### Íconos Principales
- **Pacientes:** person, people
- **Citas:** calendar_today, event
- **Médicos:** medical_services, local_hospital
- **Agregar:** add, add_circle
- **Editar:** edit, create
- **Eliminar:** delete, delete_outline
- **Buscar:** search
- **Menú:** menu
- **Volver:** arrow_back

## 🌊 Animaciones

### Duración
```dart
Fast:    150ms
Normal:  300ms
Slow:    500ms
```

### Curvas
```dart
Standard: Curves.easeInOut
Entrance: Curves.easeOut
Exit:     Curves.easeIn
```

### Transiciones
- **Navegación entre pantallas:** Slide + Fade (300ms)
- **Hover en cards:** Elevation 2 → 4 (150ms)
- **Botones:** Scale 1.0 → 0.95 al presionar

## 📐 Layouts

### Estructura de Pantallas
```
AppBar (56px)
├── Título
├── Botones de acción
└── [opcional] Search bar

Body
├── Padding: 16px
├── Contenido principal
└── Scroll si es necesario

FloatingActionButton (opcional)
└── Acción primaria
```

### Grid System
- **Mobile:** 1 columna
- **Tablet:** 2 columnas (> 600px)
- **Desktop:** 3-4 columnas (> 900px)

## ✅ Estados de UI

### Loading
- Circular Progress Indicator centrado
- Color: Primary
- Size: 40px

### Empty State
- Ícono grande (64px)
- Título descriptivo
- Texto de ayuda
- Botón de acción (opcional)

### Error State
- Ícono de error (64px, rojo)
- Mensaje de error
- Botón "Reintentar"

## 🎪 Ejemplos de Uso

### Card de Paciente
```dart
Card(
  margin: EdgeInsets.symmetric(vertical: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 2,
  child: ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.blue[100],
      child: Icon(Icons.person, color: Colors.blue),
    ),
    title: Text(
      'Nombre del Paciente',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: Text(
      'Información adicional',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: Colors.grey,
    ),
  ),
)
```

### Botón Primario
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 2,
  ),
  child: Text(
    'ACCIÓN',
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
    ),
  ),
)
```

## 📱 Responsive Design

### Breakpoints
```dart
Mobile:   < 600px
Tablet:   600px - 900px
Desktop:  > 900px
```

### Adaptaciones
- **Mobile:** Stack vertical, FAB visible
- **Tablet:** Grid de 2 columnas, FAB o botón en AppBar
- **Desktop:** Grid de 3-4 columnas, botones en AppBar

---

**Nota:** Este sistema de diseño debe aplicarse consistentemente en todas las pantallas para mantener una experiencia de usuario coherente y profesional.
