-- ===========================================================
-- Mapa de Processos & Automação — schema Supabase
-- Cole tudo isto no Supabase → SQL Editor → Run
-- ===========================================================

-- Tabela única que guarda o estado do mapa (um documento compartilhado).
create table if not exists public.mapa_estado (
  id          text primary key,
  data        jsonb not null,
  updated_by  text,
  updated_at  timestamptz default now()
);

-- Sincronização em tempo real (quando um edita, os outros recebem).
alter publication supabase_realtime add table public.mapa_estado;

-- ===========================================================
-- Segurança (RLS)
-- Versão simples para uso INTERNO: qualquer pessoa com o link do
-- site + a chave anônima consegue ler e escrever.
-- (Para restringir ao time, veja a observação no README.)
-- ===========================================================
alter table public.mapa_estado enable row level security;

create policy "leitura publica"
  on public.mapa_estado for select using (true);

create policy "insercao publica"
  on public.mapa_estado for insert with check (true);

create policy "atualizacao publica"
  on public.mapa_estado for update using (true) with check (true);
