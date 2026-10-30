-- Impulse Sport — migración para "Trabajo de campo" (turnos de referencia
-- de Inteligencia de Juego / Velocidad, sin cupo ni inscriptos)
-- Ejecutar UNA SOLA VEZ en el SQL Editor de tu proyecto Supabase ACTUAL
-- (Project → SQL Editor → New query) ANTES de abrir la versión de la página
-- que agrega este apartado dentro de la pestaña Horarios.

create table if not exists campo_horarios (
  id bigint generated always as identity primary key,
  area text not null,           -- 'Inteligencia de Juego' | 'Velocidad'
  dia text not null,            -- 'Lunes'..'Domingo'
  hora text not null,           -- 'HH:MM'
  nota text not null default '',
  created_at timestamptz not null default now()
);

alter table campo_horarios enable row level security;

create policy "campo_horarios_anon_all" on campo_horarios
  for all
  to public
  using (true)
  with check (true);
