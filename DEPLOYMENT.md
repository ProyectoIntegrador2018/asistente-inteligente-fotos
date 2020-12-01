# Instalación de aplicación asistente inteligente de fotografía

Por el momento el cliente no nos ha dado algún tipo de accesso ni guía para subir la aplicación a su tienda de 
App Store para que los usuarios puedan utilizar la aplicación. Por ahora sólo existen dos métodos similares para poder utilizar la aplicación
ya sea en un dispositivo real o en un simulador (lo cual no es tan recomendable por posibles problemas con la cámara)

## Requisitos
* Tener una computadora de la marca Apple (Mac)
* iPhone o iPad con versión iOS 12 o mayor
* Tener descargada la aplicación Xcode en una versión 11 o 12

## Uso de aplicación en un simulador
1. Clonar el repositorio.
```
$ git clone https://github.com/ProyectoIntegrador2018/asistente-inteligente-fotos.git
```
2. Abrir el folder 'STORYBOARD'.
3. Abrir el folder 'AIT'.
4. Abrir el archivo con nombre AIT.xcodeproj.
5. En el menú superior de Xcode, seleccionar un simulador y dar clic al botón de 'Run' y se estará creando la aplicación en el simulador seleccionado.

## Uso de aplicación en un dispositivo real
1. Clonar el repositorio.
```
$ git clone https://github.com/ProyectoIntegrador2018/asistente-inteligente-fotos.git
```
2. Abrir el folder 'STORYBOARD'.
3. Abrir el folder 'AIT'.
4. Abrir el archivo con nombre AIT.xcodeproj.
5. Descargar OpenCV v3.4.11

Jalar el bundle de opencv2.framework dentro del proyecto de Xcode, debajo del proyecto.

Nota:

- `Copy items if needed` está activo
- `Create folder references` está activo
- `Add to targets: AIT` está activo

6. Conectar por medio de USB su iPhone o iPad a la computadora
7. En caso de ser la primera vez se tendrá que dar confianza por parte del dispositivo a la computadora (Usualmente aparece un pop up para esto)
8. En el menú superior de Xcode, seleccionar el dispositivo y dar clic al botón de 'Run' y se estará creando la aplicación en el dispositivo.
