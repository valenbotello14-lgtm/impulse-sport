-- Impulse Sport — esquema completo para un proyecto Supabase NUEVO
-- Ejecutar UNA SOLA VEZ en el SQL Editor del proyecto nuevo (Project → SQL Editor → New query)
-- Crea las cinco tablas que usa la app ("alumnos", "tarifas", "horarios", "planes"
-- y "gastos") con las mismas columnas y el mismo tipo de policy (acceso total con
-- la clave "anon") que el proyecto viejo.

create table if not exists alumnos (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  nombre text not null default '',
  apellido text not null default '',
  tel text not null default '',
  email text not null default '',
  medico text not null default '',
  plan text not null default 'Fuerza Base',
  tipo text not null default 'Mensual',
  monto text not null default '',
  venc text not null default '',
  fechaplan text not null default '',
  lesion integer not null default 0,
  notasplan text not null default '',
  manual text not null default '📝 Sin definir',
  asistencia jsonb not null default '{}'::jsonb,
  calsynced text,
  caleventids text,
  ultimopago text not null default '',
  pagado boolean not null default false,
  pagosmensuales jsonb not null default '{}'::jsonb,
  baja boolean not null default false,
  fecha_baja text not null default '',
  motivo_baja text not null default ''
);

create table if not exists tarifas (
  id bigint generated always as identity primary key,
  plan text not null,
  mes text not null,          -- 'YYYY-MM': mes desde el cual rige este monto
  monto numeric not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists horarios (
  id bigint generated always as identity primary key,
  dia text not null,            -- 'Lunes'..'Domingo'
  hora text not null,           -- 'HH:MM'
  nombre text not null default '',
  cupo integer,                 -- null = sin límite
  inscriptos jsonb not null default '[]'::jsonb,  -- array de ids de alumnos
  created_at timestamptz not null default now()
);

create table if not exists campo_horarios (
  id bigint generated always as identity primary key,
  area text not null,           -- 'Inteligencia de Juego' | 'Velocidad'
  dia text not null,            -- 'Lunes'..'Domingo'
  hora text not null,           -- 'HH:MM'
  nota text not null default '',
  created_at timestamptz not null default now()
);

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

alter table alumnos enable row level security;
alter table tarifas enable row level security;
alter table horarios enable row level security;
alter table campo_horarios enable row level security;
alter table planes enable row level security;
alter table gastos enable row level security;

-- La app usa la clave "anon" para leer/escribir todo (no hay login de usuarios).
create policy "alumnos_anon_all" on alumnos
  for all
  to public
  using (true)
  with check (true);

create policy "tarifas_anon_all" on tarifas
  for all
  to public
  using (true)
  with check (true);

create policy "horarios_anon_all" on horarios
  for all
  to public
  using (true)
  with check (true);

create policy "campo_horarios_anon_all" on campo_horarios
  for all
  to public
  using (true)
  with check (true);

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

-- Carga los 12 planes de ejemplo para no arrancar con el catálogo vacío.
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
