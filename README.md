# ENLACES
- **[Informe preliminar tf-idf](https://docs.google.com/document/d/1avMTT4l-7INxERRrsYDPO3VbDboIgxTv0d9YCRScpAY/edit?tab=t.0)**

# TIF_DIPLO-UNSAM
Trabajo Integrador Final del Diploma Universitario en Ciencias Sociales Computacionales y Humanidades Digitales IDAES-UNSAM
#### Integrantes
Alejandra Fauquié - Eugenia Peiretti - Martín Tapia Serrano
### Consigna Trabajo FInal
### Opción 2 (Módulo 5)

#### Introducción
El trabajo final del módulo 5 se basará en utilizar el corpus provisto (cuyas características se describen a continuación) y recorrer todo el flujo de trabajo visto en clase: preprocesamiento, generación de distribuciones de frecuencias de palabras y modelado de tópicos. Prestaremos especial atención en la corrección a la explicación y justificación de las decisiones tomadas, en tanto muestren manejo de los tópicos vistos en clase.

#### Dataset
El archivo que se adjunta consiste en un corpus de unas 7.000 noticias scrapeadas entre julio y septiembre de 2019 de los siguientes medios de circulación nacional:
Télam
La Nación 
Clarín 
Perfil
Infobae
MinutoUno
Página 12

Constituye una muestra aleatoria del corpus construido por Florencia Piñeyrúa para su tesina de grado “Procesamiento del lenguaje natural aplicado al estudio de tópicos de noticias de seguridad en Argentina: julio a septiembre 2019”. Una exposición más concentrada de sus resultados puede encontrarse en el siguiente artículo.

El corpus contiene, las siguientes variables:
id : identificador de cada documento
url : link a la noticia original
fecha : fecha de publicación
anio : año de publicación
mes : mes de publicación
dia : dia de publicación
medio : medio en el que fue publicado
orientacion: clasificación -provisoria- de los medios según su línea editorial predominante (más conservador, más progresista, neutral)
titulo
texto
Pueden descargar el dataset desde este link.

#### Consignas
A partir del corpus deberán:
Cargar los datos
Preprocesarlos (normalizar texto, eliminar stopwords)
Generar una matriz token-por-fila para cada documento

A continuación deberán responder las siguientes consignas:

- [x] ¿Cuáles son las palabras más utilizadas en cada uno de los medios? ¿Pueden verse diferencias? (Tener en cuenta las diferentes métricas trabajadas en el curso: tf, tf-idf, etc.) Generar las visualizaciones que considere más pertinentes para responder la pregunta.

- [x] ¿Cuáles son los tópicos principales en el corpus? ¿Pueden evidenciar diferencias en cada uno de los medios? Explicar qué método se utilizó para responder la pregunta, cuáles son los supuestos del mismo. Generar las visualizaciones más adecuadas para responder a las preguntas.

- [x] A continuación, seleccionar las noticias vinculadas a algún **tópico relevante** (por ejemplo, “Elecciones”) y construir un clasificador para predecir la orientación del diario. Utilizar alguno de los modelos de clasificación vistos a lo largo de al Diplomatura (regresión logística, random forest, etc.). Utilizar como features el “Spanish Billion Word Corpus and Embeddings”, analizado en clase (pueden descargar el embedding en formato .bin del link). ¿Qué resultados arroja el modelo? ¿Es posible mediante el texto de las noticias conocer la línea editorial del diario? Generar las visualizaciones y tablas correspondientes para una correcta evaluación del modelo.

- [x] Diseñar un prompt para que Gemini (el LLM que usamos en clase) para realizar la tarea del punto anterior. Extraer una muestra de unos 800 articulos usados en el punto anterior y clasificarlos mediante Gemini. Comparar los resultados de ambos modelos. ¿Cuál funciona mejor? Generar las métricas y visualizaciones para comparar ambos modelos. ¿Cuáles podrían ser las causas de ambos comportamientos?

#### Entregables
Se esperan dos entregables:
- [ ] Un documento en formato word, google doc (no pdf) en el que se desarrollan las respuestas a las consignas, se presentan los principales resultados (tablas, visualizaciones) y las interpretaciones.
- [ ] Un notebook/script en el que se realiza el procesamiento del texto y se generan los modelos y visualizaciones correspondientes.

La entrega se hará mediante el sistema Google Classroom

#### Modalidad de trabajo
El trabajo deberá hacerse en grupos de hasta 3 personas. El trabajo deberá ser subido a Google Classroom por solamente uno de los integrantes del grupo. Deberá constar en el trabajo el nombre de ambos.  

#### Fecha de entrega
La fecha última de entrega será el ~~10/03/2025~~ **17/03/2025** a las 23:59. No se concederán prórrogas. 
