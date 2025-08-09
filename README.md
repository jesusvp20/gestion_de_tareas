# gestion_de_tareas
App de gestión de tareas con NestJS (API REST con PostgreSQL y Prisma) y Flutter para frontend móvil. Incluye validaciones, manejo de errores y documentación Swagger. Permite crear, listar, actualizar, completar tareas, y desmarcasr tareas y eliminar tareas desde la app móvil.


Backend: NestJS, Prisma, PostgreSQL

Frontend: Flutter

Despliegue backend: Render

Documentación API: Swagger

## Instrucciones para ejecutarlo localmente ## 
**Nota:** Asegúrate de tener instalado prisma instalado en su equipo 
1- CLonar repositorio 

## Backend (NestJS + PostgreSQL + Prisma)
##acceder a la carpeta proyecto-tareas dentro de esta carpeta cd server 

#Instalar las dependencias

npm install
# Configurar variables de entorno
# Crear archivo .env con el siguiente contenido:
DATABASE_URL="postgresql://postgres:123456@localhost:5432/gestor_tareas"


# Ejecutar migraciones de la base de datos
npx prisma migrate dev --name init

# Levantar el servidor en desarrollo
npm run start:dev

#Api disponible  y documentada en swagger:
https://gestion-de-tareas-eg5t.onrender.com/api

##Frontend (Flutter)
## cd.. para salirnos de la carpeta server, 
cd mobile para acceder 

## aseguearse que en la carpeta service este esta url final String _url = 'https://gestion-de-tareas-eg5t.onrender.com/tareas';
# Ejecutar la app en un emulador o dispositivo físico
flutter run

##documetacion swagger local 
http://localhost:3000/api

##Uso de la IA
https://chatgpt.com/share/6897bcb1-37a4-800e-9ec1-c1064fb70166- tuve error con Flutter Gradle ya que formatee este computador de fabrica y se me presento ese error
https://chatgpt.com/share/6897be49-0f94-800e-aab6-8970d2323e87 tuve unos problemas con el deploy del backend

use tambien la IA en la ayuda para solucionar errores, solucioanr problemas que no entiendo y ayudarme en organizar el codigo 
