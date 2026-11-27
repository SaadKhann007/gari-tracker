-- Supabase SQL Editor mein ye poora paste karo aur Run dabao
-- Pehle se tables bane hon to bhi chalta hai, kuch delete nahi hota.

create table if not exists vehicles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  type text not null default 'car',
  plate text,
  fuel_type text not null default 'petrol',
  created_at timestamptz not null default now()
);

-- purane table ke liye naye columns
alter table vehicles add column if not exists plate text;
-- fuel_type: 'petrol', 'diesel', 'gas', ya mila kar jaise 'petrol,gas' / 'diesel,gas'
alter table vehicles add column if not exists fuel_type text not null default 'petrol';

create table if not exists fuel_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  vehicle_id uuid not null references vehicles(id) on delete cascade,
  fuel_kind text not null default 'petrol',
  date date not null,
  odometer numeric not null,
  liters numeric not null,
  total_cost numeric not null,
  full_tank boolean not null default true,
  notes text,
  created_at timestamptz not null default now()
);

-- har fuel entry: 'petrol', 'diesel' ya 'gas'
alter table fuel_logs add column if not exists fuel_kind text not null default 'petrol';

create table if not exists maintenance_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  vehicle_id uuid not null references vehicles(id) on delete cascade,
  date date not null,
  odometer numeric,
  category text not null,
  description text,
  cost numeric not null default 0,
  next_due_odometer numeric,
  created_at timestamptz not null default now()
);

-- sirf meter reading ki entries (petrol / service ke bina)
create table if not exists meter_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  vehicle_id uuid not null references vehicles(id) on delete cascade,
  date date not null,
  odometer numeric not null,
  notes text,
  created_at timestamptz not null default now()
);

create index if not exists fuel_vehicle_idx on fuel_logs(vehicle_id, odometer);
create index if not exists maint_vehicle_idx on maintenance_logs(vehicle_id, date);
create index if not exists meter_vehicle_idx on meter_logs(vehicle_id, odometer);

alter table vehicles enable row level security;
alter table fuel_logs enable row level security;
alter table maintenance_logs enable row level security;
alter table meter_logs enable row level security;

drop policy if exists "own vehicles" on vehicles;
drop policy if exists "own fuel" on fuel_logs;
drop policy if exists "own maint" on maintenance_logs;
drop policy if exists "own meter" on meter_logs;

create policy "own vehicles" on vehicles for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own fuel" on fuel_logs for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own maint" on maintenance_logs for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own meter" on meter_logs for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.vehicles to authenticated;
grant select, insert, update, delete on public.fuel_logs to authenticated;
grant select, insert, update, delete on public.maintenance_logs to authenticated;
grant select, insert, update, delete on public.meter_logs to authenticated;
