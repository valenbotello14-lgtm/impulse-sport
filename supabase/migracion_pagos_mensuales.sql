-- Impulse Sport — migración para "Pagos y Membresías" mes a mes
-- Ejecutar UNA SOLA VEZ en el SQL Editor de Supabase (Project → SQL Editor → New query)
-- ANTES de publicar la nueva versión de index.html.

-- 1) Nueva columna en "alumnos": historial de pagos por mes.
--    Clave "YYYY-MM" -> { monto, pagado, fechaPago, notas }
alter table alumnos
  add column if not exists pagosmensuales jsonb not null default '{}'::jsonb;

-- 2) Nueva tabla "tarifas": precio de cada plan, vigente desde un mes en adelante.
--    Un aumento se carga como una fila nueva; los meses anteriores a su vigencia
--    siguen usando el monto que tenían.
create table if not exists tarifas (
  id bigint generated always as identity primary key,
  plan text not null,
  mes text not null,          -- 'YYYY-MM': mes desde el cual rige este monto
  monto numeric not null default 0,
  created_at timestamptz not null default now()
);

alter table tarifas enable row level security;

-- La app usa la clave "anon" para leer/escribir todo (igual que ya hace con "alumnos").
-- Si en tu proyecto la policy de "alumnos" es distinta/más restrictiva, replicá esa
-- misma policy acá en lugar de esta.
create policy "tarifas_anon_all" on tarifas
  for all
  to public
  using (true)
  with check (true);
