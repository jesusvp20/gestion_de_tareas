import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { ValidationPipe, BadRequestException } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Habilitar CORS para consumir el API con Flutter
  app.enableCors();
  
  // Habilita validaciones automáticas globales para todos los DTOs
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,

    /**
     *Muestra un solo mensaje si todos los campos requeridos están vacíos.
     */
    exceptionFactory: (errors) => {
      const camposInvalidos = errors.map(err => err.property);
      const camposObligatorios = ['nombre_tarea', 'descripcion'];

      const todosVacios = camposObligatorios.every(campo => camposInvalidos.includes(campo));

      if (todosVacios) {
        return new BadRequestException(['Los campos no pueden estar vacíos']);
      }

      const mensajes = errors.flatMap(error =>
        Object.values(error.constraints || {})
      );

      return new BadRequestException(mensajes);
    }
  }));

  // Configuración de Swagger para documentar la API
  const configuracion = new DocumentBuilder()
    .setTitle('Gestor de tareas')
    .setDescription('Aplicación para la gestión de tareas')
    .setVersion('1.0')
    .build();

  const document = SwaggerModule.createDocument(app, configuracion);
  SwaggerModule.setup('api', app, document);

  await app.listen(process.env.PORT ?? 3000);
}

bootstrap();
