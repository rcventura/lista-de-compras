# Analise do Sistema - Lista de Compras

Data da analise: 2026-04-16

## Escopo

Esta analise foi feita a partir da leitura do codigo-fonte em `lib/`, com foco
na arquitetura por feature e no uso do padrao BLoC.

O projeto esta organizado em tres features principais:

- `auth`
- `home`
- `shopping`

Tambem existem camadas compartilhadas em `core/` e componentes reutilizaveis em
`components/`.

## Resumo Executivo

O sistema ja possui uma base funcional com BLoC nas jornadas principais:

- autenticacao
- exibicao da home
- criacao de lista de compras

Tambem existe uma feature para detalhes da lista e itens da lista, mas ela
ainda esta parcial e contem inconsistencias importantes na implementacao do
BLoC e no acoplamento com repository/usecase.

Em resumo:

- Feito e funcional com BLoC: login, cadastro, home, criacao de lista
- Feito, mas com risco/bug no fluxo BLoC: reset de senha
- Feito parcialmente com BLoC: detalhe da lista e itens da lista

## Arquitetura Observada

O projeto segue uma divisao parecida com Clean Architecture simplificada:

- `view`: telas e widgets da feature
- `bloc`: coordenacao de eventos e estados
- `data/repositories`: acesso ao Supabase
- `domain/entities`: estruturas do dominio
- `domain/usecases`: regras de negocio por acao
- `model`: adaptacao entre resposta do banco e entidade do dominio

Fluxo esperado:

1. A tela dispara um `Event`
2. O `Bloc` processa a acao
3. O `Bloc` chama um `UseCase`
4. O `UseCase` usa um `Repository`
5. O `Repository` conversa com Supabase
6. O resultado retorna ao `Bloc`
7. O `Bloc` emite um `State`
8. A tela reage ao novo estado

## Features Implementadas

### 1. Auth

Arquivos principais:

- `lib/features/auth/bloc/auth_bloc.dart`
- `lib/features/auth/view/login_screen.dart`
- `lib/features/auth/view/register_screen.dart`
- `lib/features/auth/view/forgot_password_screen.dart`
- `lib/features/auth/data/repositories/auth_repository.dart`

Capacidades encontradas:

- login com email e senha
- criacao de conta
- logout
- solicitacao de reset de senha

Uso de BLoC:

- `AuthBloc` recebe eventos de login, logout, cadastro e reset
- a UI usa `BlocConsumer` nas telas de login, cadastro e reset
- os estados `AuthLoading`, `AuthSuccess`, `RegisterSuccess`,
  `SendResetPasswordSuccess` e `AuthError` estao mapeados para a interface

Status:

- Login: implementado e funcional com BLoC
- Cadastro: implementado e funcional com BLoC
- Logout: implementado e funcional com BLoC
- Reset de senha: implementado na UI, mas com bug na regra de negocio

Observacao importante:

O use case `ForgotPasswordUsercase` chama `repository.logoutAccount()` em vez de
`repository.forgotPasswordAccount(...)`. Isso indica que a tela existe e o fluxo
de estados existe, mas a regra atual de reset esta incorreta e nao pode ser
considerada confiavel sem ajuste.

Conclusao da feature `auth`:

- funcional no nucleo de autenticacao
- parcialmente inconsistente no reset de senha

### 2. Home

Arquivos principais:

- `lib/features/home/view/home_screen.dart`
- `lib/features/home/bloc/home_bloc.dart`
- `lib/features/home/data/repositories/home_respository.dart`
- `lib/features/home/domain/usecases/fetch_shopping_list_usecase.dart`

Capacidades encontradas:

- carregar listas do usuario autenticado
- exibir estado vazio
- exibir loading
- navegar para criacao de lista
- navegar para detalhe da lista
- atualizar a home ao retornar da criacao

Uso de BLoC:

- `HomeBloc` recebe `FetchHomeShoppingListsRequest`
- a tela usa `BlocBuilder<HomeBloc, HomeState>`
- o estado de sucesso entrega a colecao de listas para renderizacao

Status:

- Home/listagem de listas: implementado e funcional com BLoC
- refresh apos retorno da criacao: implementado e funcional com BLoC
- detalhe via evento do `HomeBloc`: previsto, mas nao concluido

Observacao importante:

Existe handler para `ShoppingListDetailedRequested`, mas o `emit` de sucesso esta
comentado. Na pratica, o detalhe da lista nao esta sendo resolvido por este BLoC.

Conclusao da feature `home`:

- funcional para listagem e navegacao principal
- com parte de detalhe ainda incompleta

### 3. Shopping - Criacao de Lista

Arquivos principais:

- `lib/features/shopping/view/create_shopping_list_screen.dart`
- `lib/features/shopping/bloc/create_shoppinglist_bloc.dart`
- `lib/features/shopping/data/repositories/create_shopping_list_repository.dart`
- `lib/features/shopping/model/create_shopping_list_model.dart`

Capacidades encontradas:

- abrir tela de criacao
- informar nome da lista
- selecionar local
- informar nome do supermercado quando o local for mercado
- salvar no Supabase
- retornar para a home apos sucesso

Uso de BLoC:

- a tela usa `BlocConsumer<CreateShoppinglistBloc, CreateShoppingListState>`
- o evento `CreateShoppingListRequested` dispara a criacao
- o estado `ShoppingListCreationSuccess` fecha a tela

Status:

- Criacao de lista: implementado e funcional com BLoC
- Delecao de lista: implementada no BLoC, mas nao observada na UI atual
- Fetch de listas pelo `CreateShoppinglistBloc`: parcialmente implementado
- Fetch de detalhe pelo `CreateShoppinglistBloc`: parcialmente implementado

Observacoes importantes:

- O BLoC mistura responsabilidades de criacao, exclusao, fetch e detalhe
- Existem estados para fetch e detalhe, mas alguns `emit(...)` estao comentados
- A UI atual usa esse BLoC com sucesso para a criacao, mas nao para todas as
  outras responsabilidades previstas

Conclusao da feature `shopping` na parte de criacao:

- funcional para o fluxo principal de criar lista
- com excesso de responsabilidades no mesmo BLoC

### 4. Shopping - Detalhe da Lista e Itens

Arquivos principais:

- `lib/features/shopping/view/detail_shopping_list_screen.dart`
- `lib/features/shopping/bloc/shoppinglist_item_bloc.dart`
- `lib/features/shopping/data/repositories/fetch_detail_shopping_list_repository.dart`
- `lib/features/shopping/domain/usecases/fetch_detail_shopping_list_usecase.dart`

Capacidades encontradas:

- rota de detalhe com `shoppingListId`
- disparo de evento para carregar itens
- estruturas de eventos para adicionar, atualizar, excluir e marcar item
- estados para loading, sucesso e erro

Status:

- Tela de detalhe: implementada parcialmente
- Busca de itens: parcialmente implementada
- Adicao/edicao/exclusao/toggle de item: implementadas no BLoC, mas sem UI
  completa observada
- Fluxo completo de detalhe da lista: nao confiavel no estado atual

Observacoes importantes:

1. O `ShoppinglistItemBloc` inicializa o repository de forma inconsistente:
   usa `_detailShoppingListRepository.shoppingListId` antes de o proprio
   repository estar pronto.

2. O estado `ShoppingListItemFetchSuccess` existe, mas o `emit(...)` de sucesso
   no fetch esta comentado.

3. A tela de detalhe monta lista e total, mas ainda com placeholders estaticos.

4. A tela escuta `ShoppingListItemInitial` para navegar de volta para `/home`,
   o que sugere um fluxo de estado ainda pouco definido.

Conclusao da feature `shopping` na parte de itens:

- estrutura arquitetural iniciada com BLoC
- funcionalidade ainda incompleta
- nao deve ser considerada pronta de ponta a ponta

## Features Feitas X Funcionando com BLoC

### Feitas e Funcionando com BLoC

- Login
- Cadastro de usuario
- Logout
- Home com listagem das listas
- Criacao de nova lista de compras
- Retorno da criacao para a home com refresh

### Feitas, mas com inconsistencias de regra ou implementacao

- Reset de senha
- Busca de detalhe de lista no `HomeBloc`
- Fetch/listagem dentro do `CreateShoppinglistBloc`
- Detalhe de lista via `CreateShoppinglistBloc`

### Feitas parcialmente

- Detalhe da lista de compras
- Gestao de itens da lista
- Calculo de total exibido na tela de detalhe

## Avaliacao do Uso do BLoC no Sistema

Pontos positivos:

- o projeto adota BLoC de forma consistente nas features principais
- as telas principais reagem bem a loading, sucesso e erro
- a separacao em `view`, `bloc`, `repository`, `usecase`, `entity` e `model`
  ja existe e ajuda a evolucao do sistema

Pontos de atencao:

- alguns BLoCs concentram responsabilidades demais
- existem handlers com `emit(...)` comentados, o que deixa a feature "meio
  pronta"
- parte da regra ainda bypassa a camada de usecase/repository e consulta o
  Supabase diretamente no BLoC
- a feature de itens da lista ainda nao fecha o ciclo completo de BLoC

## Recomendacoes Prioritarias

1. Corrigir o fluxo de reset de senha em `ForgotPasswordUsercase`
2. Finalizar os `emit(...)` faltantes nas features de detalhe/fetch
3. Refatorar `CreateShoppinglistBloc` para reduzir responsabilidades
4. Reestruturar `ShoppinglistItemBloc` para receber o `shoppingListId` de forma
   segura
5. Completar a UI da tela de detalhe para adicionar, editar, excluir e marcar
   itens de fato
6. Adicionar testes de unidade para blocs e use cases principais

## Conclusao Final

O sistema ja possui uma base real e aproveitavel em BLoC. As features centrais
de autenticacao, home e criacao de lista ja mostram um fluxo funcional.

No entanto, a feature de detalhe da lista e gestao de itens ainda esta em fase
parcial. Hoje, o projeto pode ser considerado:

- funcional no fluxo principal de autenticacao
- funcional no fluxo principal de listar listas
- funcional no fluxo principal de criar lista
- parcialmente pronto no fluxo de detalhe e itens da lista

Essa conclusao foi baseada na leitura estatica do codigo e nos ajustes feitos no
fluxo recente de home/criacao. Ela nao substitui testes automatizados e testes
manuais completos em todos os cenarios.
