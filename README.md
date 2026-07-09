# Lista de Compras

Aplicativo Flutter para criar e acompanhar listas de compras com autenticação e dados em nuvem via Supabase. O projeto está organizado em módulos por funcionalidade e usa BLoC/Cubit para controle de estado.

## Visão geral

O app ajuda o usuário a substituir listas em papel por uma experiência mobile simples para planejar compras, consultar listas recentes, adicionar produtos por categoria e acompanhar o total estimado da lista.

## Funcionalidades implementadas

- **Autenticação com Supabase**
  - Login por e-mail e senha.
  - Cadastro de usuário com nome, e-mail e senha.
  - Recuperação de senha por e-mail.
  - Logout pelo menu de perfil.
- **Home de listas**
  - Busca as listas do usuário autenticado criadas no mês atual.
  - Exibe cards de resumo financeiro e a relação de listas.
  - Permite pesquisar listas pelo nome.
- **Criação de lista de compras**
  - Cria lista informando nome e local.
  - Suporta local `Casa` ou `Mercado`.
  - Solicita nome do supermercado quando o local escolhido é `Mercado`.
- **Detalhes da lista**
  - Exibe nome, data de criação e local da lista atual.
  - Lista os itens adicionados.
  - Calcula o total estimado com base em quantidade e preço dos itens.
- **Categorias e produtos**
  - Lista categorias cadastradas no Supabase.
  - Exibe produtos de uma categoria.
  - Permite pesquisar produtos dentro da categoria.
  - Permite selecionar itens quando a lista é do tipo `Casa`.
- **Internacionalização básica**
  - App configurado para localidade `pt_BR`.

## Stack técnica

- **Flutter** e **Dart**
- **Material Design 3**
- **flutter_bloc** para BLoC/Cubit
- **provider** para injeção/escopo de providers
- **supabase_flutter** para autenticação e banco de dados
- **intl** para formatação de datas e valores
- **flutter_localizations** para suporte a pt-BR

## Estrutura do projeto

```text
lib/
├── components/                 # Componentes reutilizáveis de UI
├── core/
│   ├── config/                 # Configuração do Supabase
│   ├── helpers/                # Validadores e enums
│   └── routes/                 # Rotas nomeadas do app
└── features/
    ├── auth/                   # Login, cadastro, recuperação e logout
    ├── categories/             # Listagem de categorias
    ├── categories_items/       # Produtos por categoria e adição de itens
    ├── home/                   # Tela inicial e busca de listas
    └── shopping/               # Criação e detalhe de listas de compras
```

Cada feature segue uma separação próxima de Clean Architecture:

```text
feature/
├── bloc/ ou cubit/             # Estados, eventos e regras de apresentação
├── data/                       # Repositórios que acessam o Supabase
├── domain/                     # Entidades e casos de uso
├── model/                      # Modelos para mapear dados externos
└── view/                       # Telas Flutter
```

## Rotas principais

| Rota | Tela | Descrição |
|---|---|---|
| `/` | Login | Tela inicial quando não há sessão ativa |
| `/home` | Home | Lista compras do usuário autenticado |
| `/add-shopping-list` | Criar lista | Formulário para criar uma nova lista |
| `/shopping-list-details` | Detalhes da lista | Exibe itens e total da lista |
| `/categories` | Categorias | Lista categorias de produtos |
| `/categories/{id}` | Itens da categoria | Lista produtos de uma categoria |

## Tabelas esperadas no Supabase

O código atual consulta e grava dados nas seguintes tabelas:

| Tabela | Uso no app |
|---|---|
| `users` | Dados complementares do usuário após autenticação |
| `shopping_lists` | Listas criadas pelo usuário |
| `shopping_list_items` | Itens adicionados às listas |
| `categories` | Categorias de produtos |
| `products` | Produtos vinculados às categorias |

Campos usados pelo app:

- `users`: `id`, `name`, `email`
- `shopping_lists`: `id`, `user_id`, `name`, `local`, `supermarket_name`, `created_at`
- `shopping_list_items`: `id`, `list_id`, `product_id`, `name`, `quantity`, `unit`, `checked`, `position`, `created_at`, `price`
- `categories`: `id`, `name`, `icon`, `position`
- `products`: `id`, `category_id`, `default_unit`, `name`, `position`

## Configuração do Supabase

A configuração fica em `lib/core/config/supabase_config.dart` e pode ser sobrescrita por variáveis de compilação do Dart:

- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY`

Exemplo:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://seu-projeto.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=sua-chave-publicavel
```

> Observação: o repositório contém valores fallback para desenvolvimento, mas em ambientes reais é recomendado informar os valores por `--dart-define`.

## Como executar

Pré-requisitos:

- Flutter instalado com SDK Dart compatível com `^3.11.4`.
- Projeto Supabase configurado com as tabelas acima.
- Emulador Android, simulador iOS ou dispositivo físico.

Passos:

```bash
flutter pub get
flutter run
```

Com variáveis de ambiente do Supabase:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://seu-projeto.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=sua-chave-publicavel
```

## Testes e qualidade

Comandos úteis:

```bash
flutter analyze
flutter test
```

Testes existentes:

- Smoke test do app principal.
- Teste de configuração fallback do Supabase.

## Status atual

O projeto já possui a base funcional de autenticação, navegação, criação e consulta de listas, categorias e produtos via Supabase. Alguns fluxos ainda parecem estar em evolução, como a ação final de adicionar itens selecionados na lista e interações específicas para listas em mercado.

## Documentação adicional

- `prd.md`: visão de produto, problema, objetivos e roadmap planejado.
- `docs/analise_sistema_bloc.md`: análise da arquitetura BLoC do sistema.