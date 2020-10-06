# Integrate GXServer with Jenkins

## Pre-requisitos
  - 1 o mas instancias de GeneXus instaladas.
  - 1 GXServer, por ahora local, la idea es que no.
  - Windows Managment Framwork 5.1

## Configuración inicial
Luego de hacer un checkout de este repo, se debe completar el archivo ubicado en ``.\config\Jconfig.json`` con los datos solicitados:
  - LocalKBPath: ruta local de las KBs que va a manejar Jenkins.
  - Jenkins: si existe un jenkins hay que colocar la ubicacion y modificar la flag=exists a true, de lo contrario colocando la flag en false, se puede especificar una ruta local donde instalar el Jenkins o dejando todo vacio se instala en su ubicacion por defecto.
  - GitHub user and password para mantenimiento a este repositorio. (to deprecate)
  - url de un GXServer con ContinuousIntegration y sus credenciales de acceso (indicar local o gxtechnical prefijo)
  - Indicar las instalaciones de GeneXus locales ya existentes, el nombre se usa como id y ademas si se va a utilizar el deploy to cloud, agregar las credenciales.

## Ejecucion
El usuario ejecuta ``.\JenkinsSetup.ps1``

Si es la primer ejecución, el script se detiene y pide seguir los pasos.
(Se va abrir la url localhost/8080 y un documento de texto con las instrucciones, de no abrirse se puede encontrar el documento en . )
Luego de completados estos pasos se requiere ejecutar nuevamente ``./JenkinsSetup.ps1``

## Errores comunes
***
``1.`` ***.\Irun.ps1 : File .\Irun.ps1 cannot be loaded. The file***<br>
***.\Irun.ps1 is not digitally signed. You cannot run this script on the current system.***<br>

Este error se soluciona cambiando la Execution-policy de powershell, simplemente puede ejecutar:<br>  
**Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass**<br>
***
``2.``***ConvertFrom-Json : Unrecognized escape sequence. (64): {***<br>
    ***"LocalKBPath":  {***<br>
                        ***"path":  "C:\knowledgebases"***<br>
Este error es porque en el Jconfig.json se estan colocando "\" en lugar de "\\", por ejemplo el LocalKBPath deberia ser de la forma:
**"LocalKBPath": { "path":___"C:\\knowledgebases"___ }**
***
``3.``
## Opciones avanzadas

Ejecutar ``.\JenkinsSetup.ps1 /h`` para ver una lista de opciones que brinda el setup para instalaciones/actualizaciones particulares, entre las que se destacan:
  - updategxinstances
  - setprovider