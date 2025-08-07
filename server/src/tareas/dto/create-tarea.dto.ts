import { ApiProperty } from "@nestjs/swagger";
import { IsString, IsNotEmpty, IsOptional, IsBoolean,Matches, } from "class-validator";

export class CreateTareaDto {

  /**
   * Nombre de la tarea
   * - Debe ser una cadena de texto.
   * - No puede estar vacío ni contener solo espacios.
   */

  @ApiProperty({ required: true, description: "Nombre de la tarea" })
  @IsString({ message: 'El nombre de la tarea debe ser un texto válido' })
  @IsNotEmpty({ message: 'El nombre de la tarea es obligatorio' })
  @Matches(/\S/, { message: 'El nombre de la tarea no puede estar vacío o solo contener espacios' })
  nombre_tarea: string;

  /**
   * Descripción detallada de la tarea
   * - Debe ser una cadena de texto.
   * - No puede estar vacía ni contener solo espacios.
   */

  @ApiProperty({ required: true, description: "Descripción de la tarea" })
  @IsString({ message: 'La descripción debe ser un texto válido' })
  @IsNotEmpty({ message: 'La descripción es obligatoria' })
  @Matches(/\S/, { message: 'La descripción no puede estar vacía o solo contener espacios' })
  descripcion: string;

  /**
   * Estado de la tarea (opcional)
   * - Si se envía, debe ser un valor booleano (true o false).
   * - No puede ser una cadena vacía ni nulo.
   */

  @ApiProperty({ required: false, description: "Estado de la tarea" })
  @IsOptional()
  @IsBoolean({ message: 'El campo tarea_completada debe ser true o false ' })
  tarea_completada?: boolean;
}
