-- Impulse Sport — esquema completo para un proyecto Supabase NUEVO
-- Ejecutar UNA SOLA VEZ en el SQL Editor del proyecto nuevo (Project → SQL Editor → New query)
-- Crea las tres tablas que usa la app ("alumnos", "tarifas" y "horarios") con las
-- mismas columnas y el mismo tipo de policy (acceso total con la clave "anon") que
-- el proyecto viejo.

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
  pagosmensuales jsonb not null default '{}'::jsonb
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

alter table alumnos enable row level security;
alter table tarifas enable row level security;
alter table horarios enable row level security;

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
