-- Impulse Sport — migración para agregar cupo e inscriptos a "Trabajo de campo"
-- Ejecutar UNA SOLA VEZ en el SQL Editor de tu proyecto Supabase ACTUAL
-- (Project → SQL Editor → New query) ANTES de abrir la versión de la página
-- que permite anotar alumnos en los turnos de Inteligencia de Juego / Velocidad.

alter table campo_horarios
  add column if not exists cupo integer,
  add column if not exists inscriptos jsonb not null default '[]'::jsonb;
