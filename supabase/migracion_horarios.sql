-- Impulse Sport — migración para la grilla de "Horarios"
-- Ejecutar UNA SOLA VEZ en el SQL Editor de Supabase (Project → SQL Editor → New query)
-- ANTES de publicar la versión de index.html que agrega la pestaña Horarios.
-- (Si estás armando un proyecto Supabase nuevo desde cero, no hace falta este archivo
-- aparte: ya está incluido en esquema_nuevo_proyecto.sql)

create table if not exists horarios (
  id bigint generated always as identity primary key,
  dia text not null,            -- 'Lunes'..'Domingo'
  hora text not null,           -- 'HH:MM'
  nombre text not null default '',
  cupo integer,                 -- null = sin límite
  inscriptos jsonb not null default '[]'::jsonb,  -- array de ids de alumnos
  created_at timestamptz not null default now()
);

alter table horarios enable row level security;

-- La app usa la clave "anon" para leer/escribir todo (igual que ya hace con "alumnos" y "tarifas").
create policy "horarios_anon_all" on horarios
  for all
  to public
  using (true)
  with check (true);
