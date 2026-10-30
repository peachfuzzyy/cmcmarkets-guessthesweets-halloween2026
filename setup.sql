-- Run this once in Supabase: SQL Editor -> New query -> paste -> Run.

create table public.guesses (
  id bigint generated always as identity primary key,
  name text not null check (char_length(trim(name)) between 1 and 40),
  guess integer not null check (guess between 1 and 100000),
  created_at timestamptz not null default now()
);

-- One entry per name (ignores capitals and extra spaces).
create unique index guesses_name_unique on public.guesses (lower(trim(name)));

alter table public.guesses enable row level security;

-- Visitors can add a guess and read the board. They cannot edit or delete anything.
create policy "anyone can enter" on public.guesses for insert to anon with check (true);
create policy "anyone can view"  on public.guesses for select to anon using (true);
