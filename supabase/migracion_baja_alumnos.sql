-- Impulse Sport — migración para marcar alumnos como "Baja" (inactivos)
-- Ejecutar UNA SOLA VEZ en el SQL Editor de tu proyecto Supabase ACTUAL
-- (Project → SQL Editor → New query) ANTES de abrir la versión de la página
-- que agrega el apartado de clientes activos/baja.

alter table alumnos
  add column if not exists baja boolean not null default false,
  add column if not exists fecha_baja text not null default '',
  add column if not exists motivo_baja text not null default '';
