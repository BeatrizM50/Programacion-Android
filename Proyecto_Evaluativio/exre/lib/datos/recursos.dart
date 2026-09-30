import 'package:exre/modelos/recurso.dart';

final List<Recurso> recursos = [
  Recurso(
    id: 1,
    titulo: 'Introducción a Widgets',
    categoria: 'Flutter',
    autor: 'Alejandro M.',
    duracion: 12,
    nivel: 'Basico',
    descripcion: 'Aprende los fundamentos de los widgets en Flutter y como se utilizan para construir interfaces.',
    tipo: 'Video',
    color: '#0553B1',
  ),

  Recurso(
    id: 2,
    titulo: 'StatelessWidget y StatefulWidget',
    categoria: 'Flutter',
    autor: 'Ana Perez',
    duracion: 18,
    nivel: 'Basico',
    descripcion: 'Conoce las diferencias entre StatelessWidget y StatefulWidget y cuándo utilizar cada uno.',
    tipo: 'Lectura',
    color: '#0553B1',
  ),

  Recurso(
    id: 3,
    titulo: 'Primer proyecto Flutter',
    categoria: 'Flutter',
    autor: 'Carlos Diaz',
    duracion: 25,
    nivel: 'Basico',
    descripcion:
        'Aprende a crear y ejecutar un proyecto básico utilizando Flutter.',
    tipo: 'Practica',
    color: '#0553B1',
  ),

  Recurso(
    id: 4,
    titulo: 'Componentes de una aplicación',
    categoria: 'Flutter',
    autor: 'Laura Gomez',
    duracion: 20,
    nivel: 'Intermedio',
    descripcion: 'Estudia cómo organizar los principales componentes de una aplicación Flutter.',
    tipo: 'Documento',
    color: '#0553B1',
  ),

  Recurso(
    id: 5,
    titulo: 'Introducción a Android',
    categoria: 'Android',
    autor: 'Miguel Torres',
    duracion: 15,
    nivel: 'Basico',
    descripcion:
        'Introducción al desarrollo de aplicaciones para dispositivos Android.',
    tipo: 'Video',
    color: '#1DA260',
  ),

  Recurso(
    id: 6,
    titulo: 'Actividad del ciclo de vida',
    categoria: 'Android',
    autor: 'Pedro Ruiz',
    duracion: 22,
    nivel: 'Intermedio',
    descripcion:
        'Aprende los principales estados del ciclo de vida de una aplicación.',
    tipo: 'Lectura',
    color: '#1DA260',
  ),

  Recurso(
    id: 7,
    titulo: 'Componentes Android',
    categoria: 'Android',
    autor: 'Maria Lopez',
    duracion: 17,
    nivel: 'Basico',
    descripcion:
        'Conoce algunos de los componentes utilizados en aplicaciones Android.',
    tipo: 'Video',
    color: '#1DA260',
  ),

  Recurso(
    id: 8,
    titulo: 'Eventos en Android',
    categoria: 'Android',
    autor: 'Jose Martin',
    duracion: 30,
    nivel: 'Avanzado',
    descripcion: 'Estudia el manejo de eventos dentro de una aplicación móvil.',
    tipo: 'Practica',
    color: '#1DA260',
  ),

  Recurso(
    id: 9,
    titulo: 'Columnas y filas',
    categoria: 'Layouts',
    autor: 'Ana Perez',
    duracion: 14,
    nivel: 'Basico',
    descripcion: 'Aprende a organizar elementos utilizando Row y Column.',
    tipo: 'Video',
    color: '#F59E0B',
  ),

  Recurso(
    id: 10,
    titulo: 'Container y Padding',
    categoria: 'Layouts',
    autor: 'Roilan R.',
    duracion: 16,
    nivel: 'Basico',
    descripcion: 'Aprende a controlar espacios y tamaños utilizando Container y Padding.',
    tipo: 'Lectura',
    color: '#F59E0B',
  ),

  Recurso(
    id: 11,
    titulo: 'Diseños adaptables',
    categoria: 'Layouts',
    autor: 'Carlos Diaz',
    duracion: 24,
    nivel: 'Intermedio',
    descripcion: 'Construye interfaces que puedan adaptarse a diferentes tamaños de pantalla.',
    tipo: 'Practica',
    color: '#F59E0B',
  ),

  Recurso(
    id: 12,
    titulo: 'ListView en Flutter',
    categoria: 'Scrollables',
    autor: 'Laura Gomez',
    duracion: 19,
    nivel: 'Intermedio',
    descripcion: 'Aprende a crear listas desplazables utilizando ListView.',
    tipo: 'Video',
    color: '#DB2777',
  ),

  Recurso(
    id: 13,
    titulo: 'ListView.builder',
    categoria: 'Scrollables',
    autor: 'Miguel Torres',
    duracion: 21,
    nivel: 'Intermedio',
    descripcion: 'Aprende a utilizar ListView.builder para construir listas de tamaño variable.',
    tipo: 'Practica',
    color: '#DB2777',
  ),

  Recurso(
    id: 14,
    titulo: 'ListView.separated',
    categoria: 'Scrollables',
    autor: 'Pedro Ruiz',
    duracion: 13,
    nivel: 'Intermedio',
    descripcion: 'Aprende a construir listas utilizando separadores visuales.',
    tipo: 'Documento',
    color: '#DB2777',
  ),

  Recurso(
    id: 15,
    titulo: 'Introducción a Slivers',
    categoria: 'Slivers',
    autor: 'Jose Martin',
    duracion: 26,
    nivel: 'Avanzado',
    descripcion: 'Introducción al concepto de Slivers y su utilización en interfaces desplazables.',
    tipo: 'Video',
    color: '#7C3AED',
  ),

  Recurso(
    id: 16,
    titulo: 'CustomScrollView',
    categoria: 'Slivers',
    autor: 'Maria Lopez',
    duracion: 28,
    nivel: 'Avanzado',
    descripcion:
        'Aprende a combinar diferentes Slivers dentro de una interfaz.',
    tipo: 'Practica',
    color: '#7C3AED',
  ),

  Recurso(
    id: 17,
    titulo: 'Navegación entre pantallas',
    categoria: 'Navegacion',
    autor: 'Roilan R.',
    duracion: 20,
    nivel: 'Intermedio',
    descripcion:
        'Aprende a navegar entre diferentes pantallas utilizando Navigator.',
    tipo: 'Video',
    color: '#DC2626',
  ),

  Recurso(
    id: 18,
    titulo: 'Navigator.push',
    categoria: 'Navegacion',
    autor: 'Ana Perez',
    duracion: 15,
    nivel: 'Intermedio',
    descripcion:
        'Aprende a utilizar Navigator.push para abrir nuevas pantallas.',
    tipo: 'Lectura',
    color: '#DC2626',
  ),

  Recurso(
    id: 19,
    titulo: 'BottomNavigationBar',
    categoria: 'Navegacion',
    autor: 'Carlos Diaz',
    duracion: 23,
    nivel: 'Intermedio',
    descripcion:
        'Aprende a crear una navegación inferior para cambiar entre secciones.',
    tipo: 'Practica',
    color: '#DC2626',
  ),

  Recurso(
    id: 20,
    titulo: 'Proyecto final de navegación',
    categoria: 'Navegacion',
    autor: 'Laura Gomez',
    duracion: 35,
    nivel: 'Avanzado',
    descripcion: 'Practica la navegación entre varias pantallas en una aplicación Flutter.',
    tipo: 'Documento',
    color: '#DC2626',
  ),
];
