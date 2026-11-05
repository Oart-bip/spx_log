# SPX Log — Diário de voo

Aplicativo Flutter que funciona como um diário de bordo das missões da SpaceX: mostra o último lançamento, a lista completa de missões (com filtro e busca), a frota de foguetes e dados da empresa. Todas as informações vêm da API em tempo de execução.

## Objetivo

Trabalho acadêmico para praticar requisições HTTP, leitura de JSON, `async`/`await`, tratamento de erros e apresentação de dados de uma API REST em uma interface mobile com identidade visual própria.

## Tecnologias

- Flutter e Dart (SDK >= 3.3)
- Pacote [`http`](https://pub.dev/packages/http) (única dependência além do Flutter)

## API utilizada

- **Nome:** SpaceX API (r/SpaceX), versão 4
- **Endereço:** https://api.spacexdata.com/v4
- **Documentação:** https://github.com/r-spacex/SpaceX-API/tree/master/docs
- **Autenticação:** não é necessária para leitura (GET)

Endpoints consumidos:

| Endpoint | Uso no app |
|---|---|
| `GET /launches` | lista de missões, filtros e busca |
| `GET /launches/latest` | destaque da tela inicial |
| `GET /rockets` | tela da frota e nome do foguete de cada missão |
| `GET /company` | indicadores e resumo da empresa |

## Funcionalidades

- Tela inicial com o último lançamento registrado e dados da empresa
- Lista de missões com filtro (todos, sucesso, falha, próximos) e busca por nome
- Tela de detalhe da missão (data, hora UTC, foguete, relatório, falhas e links)
- Tela da frota com foto, medidas e taxa de sucesso de cada foguete
- Estado de carregamento, mensagens de erro (sem internet, timeout, resposta inválida) com botão "tentar de novo" e mensagem para listas vazias
- Puxar para atualizar em todas as telas

## Identidade visual

Tema "controle de missão": fundo grafite, texto cor de osso e um único laranja de sinalização. Títulos grossos e apertados, dados e rótulos em fonte monoespaçada. Não usa AppBar, cards arredondados nem BottomNavigationBar padrão: a navegação é própria (itens numerados com barra deslizante), as listas são separadas por filetes e os indicadores ficam em linhas divididas. Algumas composições são deliberadamente assimétricas (número do voo à direita, imagens com recuo alternado).

## Como executar

1. Instale o [Flutter](https://docs.flutter.dev/get-started/install) e confira com `flutter doctor`.
2. Clone o repositório e entre na pasta.
3. Gere as pastas de plataforma (o repositório contém só o código do app):

   ```bash
   flutter create . --project-name spx_log
   ```

4. Para builds de release no Android, confirme que `android/app/src/main/AndroidManifest.xml` contém:

   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

5. Instale as dependências e execute:

   ```bash
   flutter pub get
   flutter run
   ```

O app precisa de conexão com a internet. O `flutter create` pode gerar `test/widget_test.dart` referenciando `MyApp`; apague esse arquivo se for rodar `flutter test`.

## Estrutura

```
lib/
  main.dart                 ponto de entrada
  models/                   Launch, Rocket, Company (fromJson)
  services/                 SpaceXService (requisições HTTP e erros)
  screens/                  AppShell, Home, Missões, Detalhe, Frota
  widgets/                  navegação, filtros, linhas, indicadores, estados
  theme/                    cores e estilos de texto
  utils/                    formatação de datas/números e transição de rota
```

## Observação sobre os dados

A SpaceX API é mantida pela comunidade e seus dados não são atualizados com frequência; por isso o "último lançamento" e os "próximos" refletem o que a API tem registrado, não necessariamente a data de hoje.
