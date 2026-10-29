-- Impulse Sport — migración para "Planes" (catálogo editable) y "Balance" (gastos)
-- Ejecutar UNA SOLA VEZ en el SQL Editor de tu proyecto Supabase ACTUAL
-- (Project → SQL Editor → New query) ANTES de abrir la versión de la página
-- que agrega esto.

create table if not exists planes (
  id bigint generated always as identity primary key,
  area text not null,
  nombre text not null,
  detalle text not null default '',
  monto numeric not null default 0,
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists gastos (
  id bigint generated always as identity primary key,
  concepto text not null default '',
  categoria text not null default 'Otro',
  monto numeric not null default 0,
  mes text not null,          -- 'YYYY-MM'
  notas text not null default '',
  created_at timestamptz not null default now()
);

alter table planes enable row level security;
alter table gastos enable row level security;

create policy "planes_anon_all" on planes
  for all
  to public
  using (true)
  with check (true);

create policy "gastos_anon_all" on gastos
  for all
  to public
  using (true)
  with check (true);

-- Carga los 12 planes que ya estaban en la página, para no arrancar con el
-- catálogo vacío. Después los podés renombrar, agregar, desactivar o
-- cambiarles el precio desde "💲 Tarifas" en la pestaña Pagos.
insert into planes (area, nombre, detalle, monto) values
  ('Fuerza', 'Fuerza Base', '2 sesiones semanales', 32000),
  ('Fuerza', 'Fuerza Premium', '3 o más sesiones semanales', 38000),
  ('Velocidad', 'Velocidad Base', '1 sesión semanal', 35000),
  ('Velocidad', 'Velocidad Premium', '2 sesiones semanales', 62000),
  ('Inteligencia de Juego', 'Grupal', '4 a 6 jugadores', 40000),
  ('Inteligencia de Juego', 'Dúo', '2 jugadores', 45000),
  ('Inteligencia de Juego', 'Dúo Plus', '2/3 jugadores · 2 sesiones semanales', 52000),
  ('Planes de Rendimiento', 'Plan Formación', '1 sesión de Fuerza + 1 de Inteligencia de Juego', 55000),
  ('Planes de Rendimiento', 'Plan Potencia', 'Fuerza Premium + Velocidad Base', 58000),
  ('Planes de Rendimiento', 'Plan Estrategia', 'Fuerza Premium + Inteligencia de Juego', 60000),
  ('Planes de Rendimiento', 'Plan Juego Rápido', 'Velocidad Base + Inteligencia de Juego', 62000),
  ('Planes de Rendimiento', 'Plan Integral', 'Fuerza Premium + Velocidad Base + Inteligencia de Juego', 65000);
