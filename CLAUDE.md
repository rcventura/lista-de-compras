# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter app ("lista_compras") for managing shopping lists, backed by Supabase (auth + Postgres). UI locale is fixed to `pt_BR`; user-facing strings, error messages, and route/file naming conventions are in Portuguese.

## Commands

```bash
flutter pub get                 # install dependencies
flutter run                     # run the app (needs an emulator/device)
flutter analyze                 # static analysis (flutter_lints)
flutter test                    # run all tests
flutter test test/widget_test.dart   # run a single test file
```

Supabase credentials default to values baked into `lib/core/config/supabase_config.dart`, but can be overridden:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=your-publishable-key
```

## Architecture

Each module under `lib/features/<name>/` follows the same layering (Clean-Architecture-ish):

```
feature/
├── bloc/ or cubit/   # flutter_bloc Bloc/Cubit — events, states, orchestration
├── data/              # repositories — talk to Supabase directly (client.from(...))
├── domain/
│   ├── entities/       # plain Dart entities used across bloc/domain
│   └── usecases/       # thin wrapper around a single repository method
└── model/              # fromMap/toMap mapping between Supabase rows and entities
```

Data flow: `View` dispatches a Bloc event → `Bloc` calls a `Usecase` → `Usecase` delegates to a `Repository` → `Repository` queries `Supabase.instance.client` and maps rows to `Entity` via a `Model.fromMap(...).toEntity()`. Blocs construct their own repository/usecase instances in their constructor (no DI container) — see `DetailShoppinglistBloc` in [detail_shoppinglist_bloc.dart](lib/features/shopping/bloc/detail_shoppinglist_bloc.dart) for the canonical pattern.

Features: `auth`, `home`, `categories`, `categories_items`, `shopping`. `shopping` also has a `cubit/` (`CurrentShoppingListCubit`) used to hold the in-progress shopping list across screens.

### Routing

All navigation is centralized in [routes.dart](lib/core/routes/routes.dart) via `Routes.generateRoute` (named routes, no external router package). Routes needing arguments use typed `*Args` classes (e.g. `ShoppingListDetailArgs`, `DetailItemArgs`, `CategoriesItemsArgs`) passed through `Navigator.pushNamed(context, Routes.x, arguments: ...)`; the generator does an `is!` check and renders an inline error Scaffold if the wrong argument type is supplied. Routes that need a Bloc wrap the screen in a `BlocProvider`/`MultiBlocProvider` right in `generateRoute` — Blocs are not provided globally except `AuthBloc` and `CurrentShoppingListCubit`, which are set up in `MultiProvider` in [main.dart](lib/main.dart).

### Supabase access

There is no repository abstraction/interface layer for most features — repositories hold a `SupabaseClient` and query tables directly (e.g. `client.from('shopping_list_items').select(...)`). `auth` is the exception: it has an abstract `domain/repositories/auth_repository.dart` implemented by `data/repositories/auth_repository.dart`. Table/column names used across the app are documented in [README.md](README.md) ("Tabelas esperadas no Supabase") — keep that table in sync when adding/renaming Supabase columns.

### Errors

`lib/core/error/failure.dart` defines a `Failure` hierarchy (`ServerFailure`, `AuthFailure`, `ValidationFailure`, etc.), but most blocs currently catch exceptions ad hoc and emit a hardcoded Portuguese error-state string rather than throwing/using `Failure` types — check the specific bloc before assuming `Failure` is wired through.

## Notes

- `lib/core/helpers/validators.dart` has shared form validators (`email`, `password`, `required`); reuse these instead of writing new inline validation.
- `lib/core/helpers/enum.dart` holds shared enums like `ShoppingListLocateEnum` (`casa` / `mercado`), which drives conditional UI (e.g. supermarket name field only shown for `mercado`).
- `docs/analise_sistema_bloc.md` documents the existing BLoC architecture in more depth if deeper background is needed.
- `prd.md` has product vision/roadmap context.
