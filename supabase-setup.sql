-- Run this once in Supabase: SQL Editor > New query > paste > Run.
-- One row per person, holding their whole training log as JSON.
create table if not exists public.training_log (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Row-level security: each signed-in person can only see and change their own row.
alter table public.training_log enable row level security;

drop policy if exists "Read own log"   on public.training_log;
drop policy if exists "Insert own log" on public.training_log;
drop policy if exists "Update own log" on public.training_log;

create policy "Read own log"   on public.training_log for select to authenticated using (auth.uid() = user_id);
create policy "Insert own log" on public.training_log for insert to authenticated with check (auth.uid() = user_id);
create policy "Update own log" on public.training_log for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
