import { Module } from '@nestjs/common';
import { TareasController } from 'src/tareas/tareas.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { TareasService } from 'src/tareas/tareas.service'

@Module({
  controllers: [TareasController],
  providers: [TareasService],
  imports: [PrismaModule]
})
export class TareasModule {}
