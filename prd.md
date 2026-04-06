# PRD — Lista de Compras

## Visão Geral

Aplicativo mobile Flutter que substitui o papel e caneta no supermercado. O usuário monta sua lista antes de sair de casa, marca os itens conforme os coloca no carrinho e acompanha o valor total em tempo real.

---

## Problema

Pessoas que vão ao supermercado ainda usam papel e caneta (ou anotações de texto simples) para gerenciar suas compras. Isso tem limitações claras:

- Difícil riscar e reorganizar itens
- Não há controle de valor total
- Sem categorização por corredor/setor
- Listas se perdem ou ficam ilegíveis
- Não dá para reaproveitar listas de compras recorrentes

---

## Objetivo do Produto

Criar um app simples, rápido e intuitivo que qualquer pessoa consiga usar dentro do supermercado, mesmo sem experiência com tecnologia.

---

## Público-Alvo

- Pessoas que fazem compras semanais/mensais no supermercado
- Faixa etária ampla (18–65 anos)
- Usuários com pouca ou muita experiência com smartphones
- Uso principal: momentos de compra e planejamento doméstico

---

## Funcionalidades

### MVP (v1.0)

| # | Funcionalidade | Descrição |
|---|---|---|
| 1 | Criar lista | Usuário cria uma nova lista com nome (ex: "Compras da semana") |
| 2 | Adicionar item | Nome do item + quantidade + unidade (kg, un, L, etc.) |
| 3 | Marcar item como comprado | Tap no item riscado/marcado com check |
| 4 | Remover item | Deslizar ou botão de deletar |
| 5 | Valor estimado por item | Campo de preço opcional por item |
| 6 | Total da lista | Soma automática dos itens com preço informado |
| 7 | Persistência local | Dados salvos no dispositivo (sem necessidade de login) |
| 8 | Múltiplas listas | Criar e alternar entre listas diferentes |

### v1.1

| # | Funcionalidade | Descrição |
|---|---|---|
| 9 | Categorias de item | Hortifruti, Laticínios, Limpeza, etc. |
| 10 | Ordenar por categoria | Agrupar itens por corredor para agilizar a compra |
| 11 | Reutilizar lista | Duplicar uma lista anterior como base |
| 12 | Histórico de preços | Mostrar o último preço registrado para o item |

### v2.0 (Futuro)

| # | Funcionalidade | Descrição |
|---|---|---|
| 13 | Compartilhar lista | Enviar lista para outra pessoa via link/WhatsApp |
| 14 | Lista colaborativa | Edição em tempo real entre múltiplos usuários |
| 15 | Sincronização em nuvem | Backup e acesso em múltiplos dispositivos |
| 16 | Reconhecimento de voz | Adicionar itens falando |

---

## Fluxo Principal

```
Tela Inicial (Minhas Listas)
    └── [+ Nova Lista] → Nomear lista → Tela da Lista
    └── [Lista existente] → Tela da Lista

Tela da Lista
    └── [+ Adicionar item] → Nome + qtd + preço → Salva na lista
    └── [Tap no item] → Marca como comprado (risca o item)
    └── [Total] → Atualiza em tempo real conforme marca/desmarca
```

---

## Requisitos Não-Funcionais

- **Offline-first**: funciona 100% sem internet
- **Performance**: abertura do app em menos de 2 segundos
- **Simplicidade**: fluxo principal em no máximo 2 taps
- **Acessibilidade**: texto legível em luz solar, botões grandes
- **Plataformas**: Android (prioritário) e iOS

---

## Stack Técnica

| Camada | Escolha |
|---|---|
| Framework | Flutter |
| Linguagem | Dart |
| Estado | Provider ou Riverpod |
| Persistência local | Hive ou SQLite (drift) |
| UI | Material Design 3 |

---

## Métricas de Sucesso

- Usuário consegue criar uma lista e adicionar 5 itens em menos de 1 minuto
- Taxa de retenção: usuário volta a abrir o app na próxima compra
- Zero crashes na jornada principal (criar lista → adicionar item → marcar como comprado)

---

## Fora de Escopo (MVP)

- Login / conta de usuário
- Integração com supermercados ou preços em tempo real
- Scanner de código de barras
- Receitas e sugestões automáticas
