-- Impulse Sport — migración para registrar días reales de uso de la cancha
-- (Trabajo de campo), además del día fijo semanal.
-- Ejecutar UNA SOLA VEZ en el SQL Editor de tu proyecto Supabase ACTUAL
-- (Project → SQL Editor → New query) ANTES de abrir la versión de la página
-- que agrega este apartado.

alter table campo_horarios
  add column if not exists fechas_uso jsonb not null default '[]'::jsonb;
