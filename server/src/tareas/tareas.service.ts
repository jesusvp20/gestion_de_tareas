import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { UpdateTareaDto } from 'src/tareas/dto/update-tarea.dto';
import { CreateTareaDto } from 'src/tareas/dto/create-tarea.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class TareasService {
  constructor(private prisma: PrismaService) {}

  /**
   * Crea una nueva tarea en la base de datos
   * @param createTareaDto - Datos necesarios para crear la tarea
   * @returns La tarea creada
   */
  crearTarea(createTareaDto: CreateTareaDto) {
    try {
      return this.prisma.tareas.create({ data: createTareaDto });
    } catch (error) {
      throw new BadRequestException('Error al crear la tarea');
    }
  }

  /**
   * Obtiene todas las tareas de la base de datos
   * @returns Lista de tareas
   */

async ListarTareas() {
  const tareas = await this.prisma.tareas.findMany();

  if (!tareas || tareas.length === 0) {
    throw new NotFoundException('No hay tareas registradas');
  }

  return tareas;
}
  /**
   * Busca una tarea por su nombre
   * @param nombre - nombre de la tarea a buscar
   * @returns La tarea si existe, o lanza una excepción si no existe
   */
async buscarPorNombre(nombre: string) {
  const tarea = await this.prisma.tareas.findFirst({
    where: { nombre_tarea: nombre },
  });

  if (!tarea) {
    throw new NotFoundException(`No se encontró una tarea con nombre "${nombre}"`);
  }

  return tarea;
}

  /**
   * Actualiza una tarea existente con nuevos datos
   * @param id - id de la tarea a actualizar
   * @param updateTareaDto - Datos a actualizar
   * @returns La tarea actualizada, o excepción si no existe
   */
  async actualizarTarea(id: number, updateTareaDto: UpdateTareaDto) {
    const existe = await this.prisma.tareas.findUnique({ where: { id } });

    if (!existe) {
      throw new NotFoundException(`No se puede actualizar. La tarea con ID ${id} no existe`);
    }

    return this.prisma.tareas.update({
      where: { id },
      data: updateTareaDto,
    });
  }

  /**
   * Marca una tarea como completada y registra la fecha de finalización
   * @param id - id de la tarea a marcar
   * @returns La tarea actualizada con estado completado, o excepción si no existe
   */
  async marcarComoCompletada(id: number) {
    const existe = await this.prisma.tareas.findUnique({ where: { id } });

    if (!existe) {
      throw new NotFoundException(`No se encontró la tarea con ID ${id} para marcar como completada`);
    }

    return this.prisma.tareas.update({
      where: { id },
      data: {
        tarea_completada: true,
        tarea_completada_fecha: new Date(),
      },
    });
  }

  /**
   * Elimina una tarea de la base de datos por su ID
   * @param id - id de la tarea a eliminar
   * @returns La tarea eliminada, o excepción si no existe
   */
  async eliminar(id: number) {
    const existe = await this.prisma.tareas.findUnique({ where: { id } });

    if (!existe) {
      throw new NotFoundException(`No se encontró la tarea con ID ${id} para eliminar`);
    }

    return this.prisma.tareas.delete({
      where: { id },
    });
  }
}