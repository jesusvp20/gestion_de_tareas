import { Controller, Get, Post, Body, Patch, Param, Delete, ParseIntPipe } from '@nestjs/common';
import { TareasService } from 'src/tareas/tareas.service';
import { CreateTareaDto } from 'src/tareas/dto/create-tarea.dto';
import { UpdateTareaDto } from 'src/tareas/dto/update-tarea.dto';

@Controller('tareas') // Ruta base: /tareas
export class TareasController {
  constructor(private readonly tareasService: TareasService) {}

  /**
   * Crea una nueva tarea
   * Endpoint: POST /tareas
   */
  @Post()
  crearTarea(@Body() createTareaDto: CreateTareaDto) {
    return this.tareasService.crearTarea(createTareaDto);
  
  }

  /**
   * Listar las tareas creadas
   * Endpoint: GET /tareas
   */
  @Get()
  obtenerTodasLasTareas() {
    return this.tareasService.ListarTareas();
  }

  /**
   * Busca y retorna una tarea por su id
   * Endpoint: GET /tareas/:id
   */
 @Get('buscar/nombre')
obtenerTareaPorNombre(@Param('nombre') nombre: string) {
  return this.tareasService.buscarPorNombre(nombre);
}

  /**
   * Marca una tarea como completada, actualizando también la fecha
   * Endpoint: PATCH /tareas/:id/completar
   */
  @Patch(':id/completar')
  marcarTareaComoCompletada(@Param('id', ParseIntPipe) id: number) {
    return this.tareasService.marcarComoCompletada(id);
  }

  /**
   * Actualiza una tarea 
   * Endpoint: PATCH /tareas/:id
   */
  @Patch(':id')
  actualizarTarea(@Param('id', ParseIntPipe) id: number, @Body() updateTareaDto: UpdateTareaDto) {
    return this.tareasService.actualizarTarea(id, updateTareaDto);
  }

  /**
   * Elimina una tarea por su id
   * Endpoint: DELETE /tareas/:id
   */

  @Delete(':id')
  eliminarTarea(@Param('id', ParseIntPipe) id: number) {
    return this.tareasService.eliminar(id);
  }
}
