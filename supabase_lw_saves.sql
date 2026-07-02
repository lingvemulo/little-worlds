-- Little Worlds — family account cloud saves
-- Run once in the Supabase SQL editor (same project as Bridging21 Studio).
-- One row per family account; the whole save (settings + per-child worlds)
-- lives in a single jsonb column. RLS restricts every row to its owner.

create table if not exists lw_saves (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table lw_saves enable row level security;

drop policy if exists "lw_saves_select_own" on lw_saves;
create policy "lw_saves_select_own" on lw_saves
  for select using (auth.uid() = user_id);

drop policy if exists "lw_saves_insert_own" on lw_saves;
create policy "lw_saves_insert_own" on lw_saves
  for insert with check (auth.uid() = user_id);

drop policy if exists "lw_saves_update_own" on lw_saves;
create policy "lw_saves_update_own" on lw_saves
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
