-- CreateTable
CREATE TABLE "public"."tareas" (
    "id" SERIAL NOT NULL,
    "nombre_tarea" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "tarea_completada" BOOLEAN NOT NULL DEFAULT false,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tarea_completada_fecha" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tareas_pkey" PRIMARY KEY ("id")
);
