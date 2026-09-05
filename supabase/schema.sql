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
-- ═══════════════════════════════════════════════════════════════════════════════
-- MagiCarré — Game History & Online Play Schema
-- Created: 2026-09-04
-- Adds: game_history, matches, matchmaking_queue tables, and every RPC used
-- for AI/local rating, online matchmaking, invitations, and turn-based sync.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- 1. GAME_HISTORY — one row per completed game (AI, local 2P, or online)
-- ───────────────────────────────────────────────────────────────────────────────

create table if not exists public.game_history (
  id uuid primary key default gen_random_uuid(),

  player_id uuid not null references public.user_profiles(id),
  opponent_type text not null check (opponent_type in ('ai', 'local_2p', 'online')),
  opponent_id uuid references public.user_profiles(id),
  ai_difficulty text check (ai_difficulty in ('easy', 'medium', 'hard')),

  result text not null check (result in ('win', 'loss', 'draw')),
  player_rating_before integer not null,
  player_rating_after integer not null,
  rating_delta integer generated always as (player_rating_after - player_rating_before) stored,

  move_count integer not null default 0,
  board_size integer not null default 5,
  played_at timestamptz not null default now()
);

alter table public.game_history enable row level security;

create policy "Players can view own game history"
  on public.game_history
  for select
  using (auth.uid() = player_id);

-- Aucune policy INSERT directe : toutes les écritures passent par la RPC
-- SECURITY DEFINER record_game_result() ci-dessous.

-- ───────────────────────────────────────────────────────────────────────────────
-- 2. MATCHES & MATCHMAKING_QUEUE — parties en ligne
-- ───────────────────────────────────────────────────────────────────────────────

create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  status text not null default 'waiting' check (status in ('waiting', 'active', 'finished')),
  invite_code text unique,
  rated boolean not null default true,

  creator_id uuid not null references public.user_profiles(id),
  white_player_id uuid references public.user_profiles(id),
  black_player_id uuid references public.user_profiles(id),

  -- État de jeu sérialisé par le moteur carre_magic_logic (codec JSON) —
  -- null tant que la partie n'est pas activée.
  game_state jsonb,
  current_player text check (current_player in ('white', 'black')),

  timer_base_seconds integer not null default 0,
  timer_increment_seconds integer not null default 0,
  white_time_remaining_ms bigint,
  black_time_remaining_ms bigint,
  turn_started_at timestamptz,

  result text check (result in ('white_wins', 'black_wins', 'draw')),
  end_reason text check (end_reason in ('normal', 'resignation', 'timeout')),

  -- Garde d'idempotence : empêche un client de ré-appeler
  -- record_game_result() deux fois pour la même partie.
  white_recorded boolean not null default false,
  black_recorded boolean not null default false,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.matches is 'Online match — one row per game, game_state is the carre_magic_logic GameState codec JSON';

create index if not exists matches_white_player_id_idx on public.matches(white_player_id);
create index if not exists matches_black_player_id_idx on public.matches(black_player_id);
create index if not exists matches_invite_code_idx on public.matches(invite_code) where invite_code is not null;

alter table public.matches enable row level security;

create policy "Participants can view their matches"
  on public.matches
  for select
  using (
    auth.uid() = white_player_id
    or auth.uid() = black_player_id
    or (status = 'waiting' and invite_code is not null)
  );

-- Aucune policy UPDATE/INSERT directe : tout passe par les RPC ci-dessous.

create table if not exists public.matchmaking_queue (
  id uuid primary key default gen_random_uuid(),
  player_id uuid not null unique references public.user_profiles(id),
  timer_base_seconds integer not null,
  timer_increment_seconds integer not null,
  queued_at timestamptz not null default now()
);

comment on table public.matchmaking_queue is 'FIFO matchmaking queue, one active entry per player, paired by identical time control';

create index if not exists matchmaking_queue_timer_idx
  on public.matchmaking_queue(timer_base_seconds, timer_increment_seconds, queued_at);

alter table public.matchmaking_queue enable row level security;

create policy "Players can view their own queue entry"
  on public.matchmaking_queue
  for select
  using (auth.uid() = player_id);

create policy "Players can delete their own queue entry"
  on public.matchmaking_queue
  for delete
  using (auth.uid() = player_id);

-- Realtime : nécessaire pour la synchro des parties en ligne via
-- postgres_changes.
alter publication supabase_realtime add table public.matches;

-- ───────────────────────────────────────────────────────────────────────────────
-- 3. RPC — record_game_result : enregistre une partie (IA / local / online) et
--    met à jour l'ELO. Chaque joueur s'auto-reporte (auth.uid() = p_player_id) ;
--    pour une partie en ligne, les deux clients appellent cette fonction
--    indépendamment, chacun ne pouvant écrire que son propre rating.
-- ───────────────────────────────────────────────────────────────────────────────

create or replace function public.record_game_result(
  p_player_id uuid,
  p_opponent_type text,
  p_opponent_id uuid default null,
  p_ai_difficulty text default null,
  p_result text default 'loss',
  p_move_count integer default 0,
  p_board_size integer default 5,
  p_rated boolean default true
)
returns jsonb
language plpgsql
security definer
set search_path = 'public'
as $$
declare
  v_player_rating   integer;
  v_opponent_rating integer;
  v_expected        float;
  v_score           float;
  v_k               integer := 32;
  v_new_rating      integer;
  v_delta           integer;
begin
  if auth.uid() != p_player_id then
    raise exception 'Unauthorized';
  end if;

  select rating into strict v_player_rating
  from public.user_profiles
  where id = p_player_id;

  -- Local 2P, or an explicitly unrated online game: record the game, no ELO change.
  if p_opponent_type = 'local_2p' or not p_rated then
    v_new_rating := v_player_rating;
    v_delta      := 0;

  -- AI or rated online: compute ELO
  else
    if p_opponent_type = 'ai' then
      v_opponent_rating := case p_ai_difficulty
        when 'easy'   then 800
        when 'medium' then 1100
        when 'hard'   then 1400
        else 1100
      end;
    else
      select rating into v_opponent_rating
      from public.user_profiles
      where id = p_opponent_id;
    end if;

    v_expected   := 1.0 / (1.0 + power(10.0,
                     (v_opponent_rating::float - v_player_rating::float) / 400.0));
    v_score      := case p_result
                      when 'win'  then 1.0
                      when 'draw' then 0.5
                      else 0.0
                    end;
    v_new_rating := greatest(100,
                     v_player_rating + round(v_k * (v_score - v_expected))::integer);
    v_delta      := v_new_rating - v_player_rating;
  end if;

  update public.user_profiles set
    rating     = v_new_rating,
    wins       = wins   + case when p_result = 'win'  then 1 else 0 end,
    losses     = losses + case when p_result = 'loss' then 1 else 0 end,
    draws      = draws  + case when p_result = 'draw' then 1 else 0 end,
    updated_at = now()
  where id = p_player_id;

  insert into public.game_history (
    player_id, opponent_type, opponent_id, ai_difficulty,
    result, player_rating_before, player_rating_after,
    move_count, board_size
  ) values (
    p_player_id, p_opponent_type, p_opponent_id, p_ai_difficulty,
    p_result, v_player_rating, v_new_rating,
    p_move_count, p_board_size
  );

  return jsonb_build_object(
    'rating_before', v_player_rating,
    'rating_after',  v_new_rating,
    'delta',         v_delta
  );
end;
$$;

-- ───────────────────────────────────────────────────────────────────────────────
-- 4. RPC — matchmaking & invitations
-- ───────────────────────────────────────────────────────────────────────────────

-- Rejoint la file d'attente ; apparie atomiquement (SELECT ... FOR UPDATE
-- SKIP LOCKED) avec un adversaire compatible s'il y en a un déjà en attente.
create or replace function public.queue_join(p_timer_base integer, p_timer_increment integer)
returns uuid
language plpgsql
security definer
set search_path = 'public'
as $$
declare
  v_opponent_id uuid;
  v_match_id uuid;
  v_white_id uuid;
  v_black_id uuid;
  v_remaining_ms bigint;
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  select player_id into v_opponent_id
  from public.matchmaking_queue
  where player_id != auth.uid()
    and timer_base_seconds = p_timer_base
    and timer_increment_seconds = p_timer_increment
  order by queued_at
  for update skip locked
  limit 1;

  if v_opponent_id is not null then
    delete from public.matchmaking_queue where player_id = v_opponent_id;
    delete from public.matchmaking_queue where player_id = auth.uid();

    if random() < 0.5 then
      v_white_id := auth.uid();
      v_black_id := v_opponent_id;
    else
      v_white_id := v_opponent_id;
      v_black_id := auth.uid();
    end if;

    v_remaining_ms := case when p_timer_base = 0 then null else p_timer_base * 1000 end;

    insert into public.matches (
      status, rated, creator_id, white_player_id, black_player_id,
      current_player, timer_base_seconds, timer_increment_seconds,
      white_time_remaining_ms, black_time_remaining_ms, turn_started_at
    ) values (
      'active', true, auth.uid(), v_white_id, v_black_id,
      'white', p_timer_base, p_timer_increment,
      v_remaining_ms, v_remaining_ms, now()
    ) returning id into v_match_id;

    return v_match_id;
  end if;

  insert into public.matchmaking_queue (player_id, timer_base_seconds, timer_increment_seconds)
  values (auth.uid(), p_timer_base, p_timer_increment)
  on conflict (player_id) do update
    set timer_base_seconds = excluded.timer_base_seconds,
        timer_increment_seconds = excluded.timer_increment_seconds,
        queued_at = now();

  return null;
end;
$$;

create or replace function public.queue_leave()
returns void
language plpgsql
security definer
set search_path = 'public'
as $$
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  delete from public.matchmaking_queue where player_id = auth.uid();
end;
$$;

create or replace function public.create_invite_match(
  p_timer_base integer,
  p_timer_increment integer,
  p_rated boolean
)
returns text
language plpgsql
security definer
set search_path = 'public'
as $$
declare
  v_code text;
  v_attempts integer := 0;
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  loop
    v_code := upper(substr(md5(random()::text), 1, 6));
    exit when not exists (select 1 from public.matches where invite_code = v_code);
    v_attempts := v_attempts + 1;
    if v_attempts > 10 then
      raise exception 'Could not generate a unique invite code';
    end if;
  end loop;

  insert into public.matches (
    status, invite_code, rated, creator_id,
    timer_base_seconds, timer_increment_seconds
  ) values (
    'waiting', v_code, p_rated, auth.uid(),
    p_timer_base, p_timer_increment
  );

  return v_code;
end;
$$;

create or replace function public.join_invite_match(p_invite_code text)
returns uuid
language plpgsql
security definer
set search_path = 'public'
as $$
declare
  v_match record;
  v_white_id uuid;
  v_black_id uuid;
  v_remaining_ms bigint;
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  select * into v_match
  from public.matches
  where invite_code = p_invite_code
  for update;

  if not found then
    raise exception 'Invite not found';
  end if;

  if v_match.status != 'waiting' then
    raise exception 'Invite no longer available';
  end if;

  if v_match.creator_id = auth.uid() then
    raise exception 'Cannot join your own invite';
  end if;

  if random() < 0.5 then
    v_white_id := v_match.creator_id;
    v_black_id := auth.uid();
  else
    v_white_id := auth.uid();
    v_black_id := v_match.creator_id;
  end if;

  v_remaining_ms := case when v_match.timer_base_seconds = 0 then null else v_match.timer_base_seconds * 1000 end;

  update public.matches set
    status = 'active',
    white_player_id = v_white_id,
    black_player_id = v_black_id,
    current_player = 'white',
    white_time_remaining_ms = v_remaining_ms,
    black_time_remaining_ms = v_remaining_ms,
    turn_started_at = now(),
    updated_at = now()
  where id = v_match.id;

  return v_match.id;
end;
$$;

-- Initialise game_state sur une partie tout juste activée. Compare-and-set
-- atomique : un second appel racing (l'autre client) devient un no-op
-- puisque la clause WHERE ne matche plus après le premier write.
create or replace function public.initialize_match_state(
  p_match_id uuid,
  p_game_state jsonb
)
returns void
language plpgsql
security definer
set search_path = 'public'
as $$
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  update public.matches
  set game_state = p_game_state
  where id = p_match_id
    and status = 'active'
    and game_state is null
    and (auth.uid() = white_player_id or auth.uid() = black_player_id);
end;
$$;

-- ───────────────────────────────────────────────────────────────────────────────
-- 5. RPC — déroulement de la partie
-- ───────────────────────────────────────────────────────────────────────────────

-- Vérifie que l'appelant est bien le joueur dont c'est le tour, recalcule
-- son temps restant côté serveur (jamais fait confiance au client), écrit
-- le nouvel état ou clôture la partie si p_new_status != 'playing'.
create or replace function public.submit_move(
  p_match_id uuid,
  p_new_game_state jsonb,
  p_next_player text,
  p_new_status text
)
returns void
language plpgsql
security definer
set search_path = 'public'
as $$
declare
  v_match record;
  v_mover_color text;
  v_elapsed_ms bigint;
  v_new_remaining bigint;
  v_result text;
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  select * into v_match from public.matches where id = p_match_id for update;

  if not found or v_match.status != 'active' then
    raise exception 'Match not active';
  end if;

  if auth.uid() = v_match.white_player_id then
    v_mover_color := 'white';
  elsif auth.uid() = v_match.black_player_id then
    v_mover_color := 'black';
  else
    raise exception 'Not a participant';
  end if;

  if v_mover_color != v_match.current_player then
    raise exception 'Not your turn';
  end if;

  v_elapsed_ms := round(extract(epoch from (now() - v_match.turn_started_at)) * 1000)::bigint;

  if v_mover_color = 'white' and v_match.white_time_remaining_ms is not null then
    v_new_remaining := greatest(0, v_match.white_time_remaining_ms - v_elapsed_ms + v_match.timer_increment_seconds * 1000);
  elsif v_mover_color = 'black' and v_match.black_time_remaining_ms is not null then
    v_new_remaining := greatest(0, v_match.black_time_remaining_ms - v_elapsed_ms + v_match.timer_increment_seconds * 1000);
  else
    v_new_remaining := null;
  end if;

  if p_new_status = 'playing' then
    update public.matches set
      game_state = p_new_game_state,
      current_player = p_next_player,
      turn_started_at = now(),
      white_time_remaining_ms = case when v_mover_color = 'white' then v_new_remaining else white_time_remaining_ms end,
      black_time_remaining_ms = case when v_mover_color = 'black' then v_new_remaining else black_time_remaining_ms end,
      updated_at = now()
    where id = p_match_id;
  elsif p_new_status in ('whiteWins', 'blackWins', 'draw') then
    v_result := case p_new_status
      when 'whiteWins' then 'white_wins'
      when 'blackWins' then 'black_wins'
      else 'draw'
    end;

    update public.matches set
      game_state = p_new_game_state,
      status = 'finished',
      result = v_result,
      end_reason = 'normal',
      white_time_remaining_ms = case when v_mover_color = 'white' then v_new_remaining else white_time_remaining_ms end,
      black_time_remaining_ms = case when v_mover_color = 'black' then v_new_remaining else black_time_remaining_ms end,
      updated_at = now()
    where id = p_match_id;
  else
    raise exception 'Unknown status %', p_new_status;
  end if;
end;
$$;

create or replace function public.resign_match(p_match_id uuid)
returns void
language plpgsql
security definer
set search_path = 'public'
as $$
declare
  v_match record;
  v_color text;
  v_result text;
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  select * into v_match from public.matches where id = p_match_id for update;

  if not found or v_match.status != 'active' then
    raise exception 'Match not active';
  end if;

  if auth.uid() = v_match.white_player_id then
    v_color := 'white';
  elsif auth.uid() = v_match.black_player_id then
    v_color := 'black';
  else
    raise exception 'Not a participant';
  end if;

  v_result := case when v_color = 'white' then 'black_wins' else 'white_wins' end;

  update public.matches set
    status = 'finished',
    result = v_result,
    end_reason = 'resignation',
    updated_at = now()
  where id = p_match_id;
end;
$$;

-- Callable par n'importe quel participant. Si la partie a une pendule,
-- clôture au temps si le joueur dont c'est le tour est réellement épuisé
-- (recalculé côté serveur). Sans pendule, sert de filet anti-abandon
-- (7 jours d'inactivité).
create or replace function public.claim_timeout(p_match_id uuid)
returns void
language plpgsql
security definer
set search_path = 'public'
as $$
declare
  v_match record;
  v_mover_color text;
  v_elapsed_ms bigint;
  v_remaining bigint;
  v_result text;
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  select * into v_match from public.matches where id = p_match_id for update;

  if not found or v_match.status != 'active' then
    return;
  end if;

  if auth.uid() != v_match.white_player_id and auth.uid() != v_match.black_player_id then
    raise exception 'Not a participant';
  end if;

  v_mover_color := v_match.current_player;
  v_elapsed_ms := round(extract(epoch from (now() - v_match.turn_started_at)) * 1000)::bigint;

  if v_mover_color = 'white' then
    v_remaining := v_match.white_time_remaining_ms;
  else
    v_remaining := v_match.black_time_remaining_ms;
  end if;

  if v_remaining is not null then
    if v_elapsed_ms < v_remaining then
      return;
    end if;
  else
    if v_elapsed_ms < 7 * 24 * 60 * 60 * 1000 then
      return;
    end if;
  end if;

  v_result := case when v_mover_color = 'white' then 'black_wins' else 'white_wins' end;

  update public.matches set
    status = 'finished',
    result = v_result,
    end_reason = 'timeout',
    updated_at = now()
  where id = p_match_id;
end;
$$;

-- Garde d'idempotence : pose le flag white_recorded/black_recorded selon la
-- couleur de l'appelant, appelée juste après un record_game_result() réussi.
create or replace function public.mark_match_recorded(p_match_id uuid)
returns void
language plpgsql
security definer
set search_path = 'public'
as $$
declare
  v_match record;
begin
  if auth.uid() is null then
    raise exception 'Unauthorized';
  end if;

  select * into v_match from public.matches where id = p_match_id;

  if not found then
    raise exception 'Match not found';
  end if;

  if auth.uid() = v_match.white_player_id then
    update public.matches set white_recorded = true where id = p_match_id;
  elsif auth.uid() = v_match.black_player_id then
    update public.matches set black_recorded = true where id = p_match_id;
  else
    raise exception 'Not a participant';
  end if;
end;
$$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF MIGRATION
-- ═══════════════════════════════════════════════════════════════════════════════
