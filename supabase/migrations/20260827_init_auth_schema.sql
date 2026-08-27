-- ═══════════════════════════════════════════════════════════════════════════════
-- MagiCarré Auth Schema
-- Created: 2026-08-27
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- 1. USER PROFILES — extends auth.users with public profile data
-- ───────────────────────────────────────────────────────────────────────────────

create table if not exists public.user_profiles (
  id uuid primary key references auth.users(id) on delete cascade,

  -- Public profile
  username varchar(20) unique not null,
  bio text default null,
  avatar_url text default null,

  -- Game stats
  rating integer default 1000, -- Elo-like rating

  -- Onboarding
  onboarding_completed boolean default false,

  -- Metadata
  created_at timestamp default now(),
  updated_at timestamp default now()
);

comment on table public.user_profiles is 'User profile extension with public data, rating, and onboarding status';
comment on column public.user_profiles.id is 'References auth.users(id)';
comment on column public.user_profiles.username is 'Public username, auto-generated if not provided on signup';
comment on column public.user_profiles.rating is 'Elo-like rating, starts at 1000';

create index if not exists idx_user_profiles_username on public.user_profiles(username);
create index if not exists idx_user_profiles_rating on public.user_profiles(rating desc);
create index if not exists idx_user_profiles_created_at on public.user_profiles(created_at desc);

-- ───────────────────────────────────────────────────────────────────────────────
-- Row Level Security (RLS) for user_profiles
-- ───────────────────────────────────────────────────────────────────────────────

alter table public.user_profiles enable row level security;

-- Everyone can read all profiles (public data)
create policy "Profiles are readable by everyone"
  on public.user_profiles
  for select
  using (true);

-- Users can only update their own profile
create policy "Users can update their own profile"
  on public.user_profiles
  for update
  using (auth.uid() = id);

-- Users can only insert their own profile (via signup trigger)
create policy "Users can insert their own profile"
  on public.user_profiles
  for insert
  with check (auth.uid() = id);

-- ───────────────────────────────────────────────────────────────────────────────
-- 2. FRIENDSHIPS — bi-directional friend relationships
-- ───────────────────────────────────────────────────────────────────────────────

create table if not exists public.friendships (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null references public.user_profiles(id) on delete cascade,
  friend_id uuid not null references public.user_profiles(id) on delete cascade,

  created_at timestamp default now(),

  constraint no_self_friendship check (user_id != friend_id),
  constraint unique_friendship unique (user_id, friend_id)
);

comment on table public.friendships is 'Bi-directional friend relationships between users';

create index if not exists idx_friendships_user_id on public.friendships(user_id);
create index if not exists idx_friendships_friend_id on public.friendships(friend_id);

-- ───────────────────────────────────────────────────────────────────────────────
-- Row Level Security (RLS) for friendships
-- ───────────────────────────────────────────────────────────────────────────────

alter table public.friendships enable row level security;

-- Users can see friendships involving them
create policy "Users can see their friendships"
  on public.friendships
  for select
  using (auth.uid() = user_id or auth.uid() = friend_id);

-- Users can add friends
create policy "Users can add friends"
  on public.friendships
  for insert
  with check (auth.uid() = user_id);

-- Users can remove friendships they're part of
create policy "Users can remove friendships"
  on public.friendships
  for delete
  using (auth.uid() = user_id or auth.uid() = friend_id);

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF SCHEMA
-- ═══════════════════════════════════════════════════════════════════════════════
