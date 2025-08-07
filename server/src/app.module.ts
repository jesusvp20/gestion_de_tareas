import { Module } from '@nestjs/common';

import { TareasModule } from './tareas/tareas.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [TareasModule, PrismaModule],

})
export class AppModule {}

