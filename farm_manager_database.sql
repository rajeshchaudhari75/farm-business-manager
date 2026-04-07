Project URL: https://vsdeyesozflecpswiban.supabase.co
Publishable Key: sb_publishable_CYKfRt-3xgPfr0uqEht0Qw_IzBLyJAE
Direct Connection String: postgresql://postgres:[YOUR-PASSWORD]@db.vsdeyesozflecpswiban.supabase.co:5432/postgres
CLI Setup Commands: 
supabase login
supabase init
supabase link --project-ref vsdeyesozflecpswiban



create table entries (
  id bigint primary key generated always as identity,
  type text not null,
  date text not null,
  description text not null,
  month text,
  week text,
  category text,
  source text,
  amount numeric not null,
  notes text,
  created_at timestamptz default now()
);

alter table entries enable row level security;

create policy "Allow all" on entries for all using (true) with check (true);

-- Run this in your Supabase SQL Editor
-- https://supabase.com/dashboard → your project → SQL Editor

CREATE TABLE IF NOT EXISTS app_users (
  id           BIGSERIAL PRIMARY KEY,
  username     TEXT NOT NULL UNIQUE,
  name         TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role         TEXT NOT NULL DEFAULT 'readonly' CHECK (role IN ('admin', 'readonly')),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Allow anonymous reads and writes (the app uses the anon key)
ALTER TABLE app_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON app_users
  FOR ALL USING (true) WITH CHECK (true);

-- Optional: index for fast username lookups
CREATE INDEX IF NOT EXISTS app_users_username_idx ON app_users (username);


select * from app_users
select * from entries
select type, count (*) from entries group by type
select * from labour_names
create table labour_names (
  id bigint primary key generated always as identity,
  name text not null unique,
  created_at timestamptz default now()
);

alter table labour_names enable row level security;
create policy "Allow all" on labour_names for all using (true) with check (true);

create table categories (
  id bigint primary key generated always as identity,
  name text not null unique,
  color text default '#888888',
  created_at timestamptz default now()
);

create table sub_items (
  id bigint primary key generated always as identity,
  category_id bigint references categories(id) on delete cascade,
  name text not null,
  created_at timestamptz default now()
);

alter table categories enable row level security;
alter table sub_items enable row level security;
create policy "Allow all" on categories for all using (true) with check (true);
create policy "Allow all" on sub_items for all using (true) with check (true);

select * from categories
select * from sub_items
select * from entries where month like '%Feb%'
delete from entries where month like '%July%'
select count (*) from entries where description like '%Dhoifode kaka%'

select * from entries where description like '%Dhoifode kaka%'
select * from entries where source like '%Dhoifode kaka%'
select * from entries where source = 'Prakash + Priti Salary'
select distinct source from entries where category = 'LABOUR' and month like '%Feb%'

update entries set source =  'Dhoiphode Kaka' where source = 'Raju Bhosale / Dhoifode kaka'

-- Run this in your Supabase SQL Editor
-- Creates the farmstay_entries table for the Farmstay page

create table if not exists farmstay_entries (
  id           bigserial primary key,
  date         date not null,
  description  text,
  month        text,
  fs_type      text not null default 'income' check (fs_type in ('income','expense')),
  category     text,
  amount       numeric(12,2) not null default 0,
  notes        text,
  created_at   timestamptz default now()
);

-- Enable Row Level Security (open policy for your API key)
alter table farmstay_entries enable row level security;

create policy "Allow all for anon" on farmstay_entries
  for all using (true) with check (true);

-- Run this in your Supabase SQL Editor
-- Creates the ledger_entries table for the Ledger page

create table if not exists ledger_entries (
  id           bigserial primary key,
  date         date not null,
  description  text,
  month        text,
  ld_type      text not null default 'credit' check (ld_type in ('credit','debit')),
  category     text,
  amount       numeric(12,2) not null default 0,
  reference    text,
  notes        text,
  created_at   timestamptz default now()
);

-- Enable Row Level Security (open policy for your API key)
alter table ledger_entries enable row level security;

create policy "Allow all for anon" on ledger_entries
  for all using (true) with check (true);
